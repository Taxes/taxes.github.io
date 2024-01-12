# Postgres performance - a deep-dive on how poor statistics affect join strategies.

**Summary:**
* The Postgres query planner can produce query plans with much longer runtimes than optimal due to poor choice of join methods.
* One reason the planner chooses non-optimal join methods is by underestimating the results of previous joins, an error that compounds in more complex queries with multiple joins.

The Postgres query planner is pretty neat. For a given SQL query, there can be multiple plans that return the same results, but not all plans are created equal. The planner analyzes information related to the datasets and joins in the query, and tries to find the optimal (fastest) way to execute the query.

Like most underlying tools, when the planner does its job well, nobody notices it. It's when when the planner fails horrifically that it draws attention, and if you're like me - a relative newcomer to query optimization - you might not even know that the query planner exists, much less the effect it has on your query latencies. This post attempts to explain how a gap in the query planner could lead to slower performance by several orders of magnitude, as chronicled from the perspective of a product manager turned ad-hoc-database-administrator-for-a-day.

## Choosing the right query plan has significant effects on query performance.
As noted earlier, a key function of the query planner is to determine the fastest way to execute a given query. One major variable between execution plans is the join methods used to combine data from various tables. Each join method carries a set of trade-offs, and depending on the characteristics of the underlying tables, performance between join methods can vary by multiple orders of magnitude.

A refresher on join terminology: a join is a process that merges data from two tables, referenced as the left and right(-side) table for clarity. The tables are joined using a shared column or set of columns called join attributes. For example, if you have a table with product information and a table with order information, you might join the two on product ID, which would be the join attribute.

The three join methods that Postgres uses are:
* Nested loop join: As the name suggests, for each row on the left table, we loop over every row in the right table. This has the advantage of low overhead, with no sorting or other work needs, but processing costs increase dramatically as the table sizes scale. In a naive implementation, if we have M rows in the left table and N rows in the right table, we'll need to scan M x N rows in total.
* Merge join: Both tables are sorted on the join attribute and then scanned from the top down. This way, we only have to run through each row once on each side - scanning a total of M + N rows. The trade-off is the computation involved in the sort process - without diving into the time and space complexities of sorting algorithms, we can assume that this adds some overhead to the process.
* Hash join: The right table is loaded into a hash table, which is a process that makes it very easy to look up a specific row based on its join attribute (which become hash keys). Then we run through each row of the left table and look up the matching right-side rows using the hash table. The trade-off here is in the overhead of building and storing the hash table.

A thorough exploration of all the trade-offs involved in choosing the optimal join methods is outside the scope of this post (and my expertise). Suffice it to say that - and this is a highly simplified take missing a lot of nuance - nested loop joins are better if both tables are small, merge joins are better for tables that are already sorted, and hash joins are better for large tables. (TODO: Placeholder for deep-dive on join strategy trade-offs.)

## The query planner uses statistics, including row estimates, to inform crucial query planning decisions.
So, how does the planner choose which join method to use? Let's assume a join selection algorithm that runs as follows, leveraging the comparative advantages of each join method (again, highly simplified):
1. If both the left and right table are already sorted, use a merge join.
2. Else, if the total number of rows M x N is larger than 100, use a hash join.
3. Else, use a nested loop join.
This means that there are some pieces of information which are crucial for the planner to make a well-informed optimal join method choice:
1. The sort status of both tables
2. The size of both tables
As we'll come to see, inaccurate information at this stage can have a significant effect on performance. For example, if the query planner believes that the input tables each only have 1 row, then the product of rows is just 1 - an ideal case for the nested loop join. If instead, both input tables have 1,000 rows, the nested loop will need to process a total of 1,000,000 rows. Such as mismatch would lead the query planner to wildly underestimate the computation costs involved and select an inefficient nested loop over a hash join.

## Postgres assumes columns are uncorrelated when calculating row estimates.
How could such large misestimates arise? One culprit is correlation. By default, the planner assumes that columns values are not correlated. This can lead to incorrect row estimates if columns used in a filter, for example, are correlated.

For example, take a table that contains the hair color and state of residence of everyone living in the U.S. To make this concrete, let's say the total population is 300 million, of which 150 million have brown hair and 20 million live in New York. 

Postgres collects basic table and column statistics when you analyze the table. This information includes the number of rows in the table (cardinality), as well as statistics around the values that appear in each column, including the relative incidence of the most common values (selectivity). In this example, the cardinality of the table is 300 million, the selectivity of brown hair is 150m/300m = 50%, and the selectivity of New York is 20m/300m = 6.67%.

Let's say you want to find the number of brown-haired New Yorkers. If these values are uncorrelated, as the query planner assumes, then you can get a pretty good estimate by multiplying the cardinality (300m - the total number of records) by the selectivity of each factor (50% for brown hair and 6.67% for New York). This gives you around ~10 million, and unless you have special information about New York being especially attractive (or repulsive!) to brunettes, this seems like a reasonable guess.

## Correlated columns can lead to wildly inaccurate row estimates.
That's all well and good when the variables are uncorrelated, but what if they're not? 

For example, let's say that the table also contains the zip code of each person. Assume that 25,000 people live in zip code 10001, which (known is us, but unbeknownst to Postgres) is located entirely within the state of New York. By definition, the number of New Yorkers in zip code 10001 is the same as the number of residents in zip code 10001 - that is, 25,000.

However, by default, Postgres doesn't know that these two attributes are correlated. Using the same naive methodology as before, the planner will multiple the cardinality of the table (300m) against the selectivity of each factor (6.67% New York, 0.0083% zip code 10001) and estimate that only ~1,670 people meet both conditions. This would be a underestimating the actual number by a factor of 15.

## Bad row estimates lead to bad query plans.
Imagine if we added further conditions on similarly correlated attributes such as city of residence or area code - these correlation errors would compound and lead to even larger misestimates. Given what we know about how critical accurate row estimates are to inform query planning and join strategies, it's evident that the planner's underestimations could have significant effects on query performance.

So we have a bit of a problem. In the following post, I'll discuss how Postgres uses extended statistics to deal with correlation within a table, the limitations on correlations between tables, and other strategies for generating more accurate estimates and better query plans when faced with this situation.