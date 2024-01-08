# Postgres performance - a deep-dive on how poor statistics affect join strategies.

**Summary:**
* The Postgres query planner can produce query plans with much longer runtimes than optimal due to poor choice of join methods.
* One reason the planner chooses non-optimal join methods is by underestimating the results of previous joins, an error that compounds in more complex queries with multiple joins.

The Postgres query planner is pretty neat. For a given SQL query, there can be multiple plans that return the same results, but not all plans are created equal. The planner analyzes information related to the datasets and joins in the query, and tries to find the optimal (fastest) way to execute the query.

Like most underlying tools, when the planner does its job well, nobody notices it. It's when when the planner fails horrifically that it draws attention, and if you're like me - a relative newcomer to query optimization - you might not even know that the query planner exists, much less the effect it has on your query latencies. This post attempts to explain how a gap in the query planner could lead to slower performance by several orders of magnitude, as chronicled from the perspective of a product manager turned ad-hoc-database-administrator-for-a-day.

## Background
As noted earlier, a key function of the query planner is to determine the fastest way to execute a given query. One major variable between execution plans is the join methods used to combine data from various tables. Each join method carries a set of trade-offs, and depending on the characteristics of the underlying tables, performance between join methods can vary by multiple orders of magnitude.

A refresher on join terminology: a join is a process that merges data from two tables, referenced as the left and right(-side) table for clarity. The tables are joined using a shared column or set of columns called join attributes. For example, if you have a table with product information and a table with order information, you might join the two on product ID, which would be the join attribute.

The three join methods that Postgres uses are:
* Nested loop join: As the name suggests, for each row on the left table, we loop over every row in the right table. This has the advantage of low overhead, with no sorting or other work needs, but processing costs increase dramatically as the table sizes scale. In a naive implementation, if we have M rows in the left table and N rows in the right table, we'll need to scan M x N rows in total.
* Merge join: Both tables are sorted on the join attribute and then scanned from the top down. This way, we only have to run through each row once on each side - scanning a total of M + N rows. The trade-off is the computation involved in the sort process - without diving into the time and space complexities of sorting algorithms, we can assume that this adds some overhead to the process.
* Hash join: The right table is loaded into a hash table, which is a process that makes it very easy to look up a specific row based on its join attribute (which become hash keys). Then we run through each row of the left table and look up the matching right-side rows using the hash table. The trade-off here is in the overhead of building and storing the hash table.

A thorough exploration of all the trade-offs involved in choosing the optimal join methods is outside the scope of this post (and my expertise). Suffice it to say that - and this is a highly simplified take missing a lot of nuance - nested loop joins are better if both tables are small, merge joins are better for tables that are already sorted, and hash joins are better for large tables. (TODO: Placeholder for deep-dive on join strategy trade-offs.)

## Problem
So, how does the planner choose which join method to use? Let's assume a join selection algorithm that runs as follows, leveraging the comparative advantages of each join method (again, highly simplified):
1. If both the left and right table are already sorted, use a merge join.
2. Else, if the total number of rows M x N is larger than 100, use a hash join.
3. Else, use a nested loop join.

This means that there are some pieces of information which are crucial for the planner to make a well-informed optimal join method choice:
1. The sort status of both tables
2. The size of both tables

As we'll come to see, inaccurate information at this stage can have a significant effect on performance. For example, if the query planner believes that the input tables each only have 1 row, then the product of rows is just 1 - an ideal case for the nested loop join. If instead, both input tables have 1,000 rows, the nested loop will need to process a total of 1,000,000 rows. Such as mismatch would lead the query planner to wildly underestimate the computation costs involved and select an inefficient nested loop over a hash join.

How could such large misestimates arise? One culprit is correlation.

(Please suspend any disbelief about the data modeling choices used in these examples.)

Let's say you have two tables of personal information: the first holds the U.S state in which a person resides and the second holds their gender identity. Assume that the location table contains 300 million records, of which 20 million have "New York" as their state. Assume the gender identity table also contains 300 million records, which are approximately evenly split between "Male" and "Female". 
```
CREATE TABLE demographics_states (
	person_id int,
	state text
);
CREATE TABLE demographics_gender (
	person_id int,
	gender text
)
```

What happens if you join the table to find the number of records with "New York" as the state and "Male" as the gender identity?
Postgres collects basic column statistics, so it knows that roughly 6.67% (20m/300m) of the records in the location table have "New York" as the state - call this the "selectivity" of the left table's join attribute. (TODO: Placeholder for deep-dive on statistics collection and selectivity estimation which is sadly also out of scope for this piece.) Along the same lines, it knows that "Male" makes up about 50% of the gender identity table.

The planner assumes that these are uncorrelated, and therefore a join of the two table would result in 3.33% of the shared records fulfilling both - about 10 million records. If there are downstream query nodes such as further joins, the planner will use this 10 million row estimate to inform choices such as join methods.

That's all well and good when the variables are uncorrelated, but what if they're not? For example, let's say that the second table contained zip code information instead. Assume that 25,000 people live in zip code 10001, which is located entirely within the state of New York. Common sense would imply that the number of New Yorkers in zip code 10001 is the same as the number of residents in zip code 10001 - that is, 25,000.

However, Postgres doesn't know that these two attributes are correlated. So the planner will estimate using the same methodology as before. It knows that 6.67% of records in the state table have "New York", and 0.0083% of records in the zip code table have "10001", and so it estimates that a join between the two tables would result in 0.00056% of the shared rows fulfilling both conditions - in other words, only 1,667 records. This would be a underestimating the actual number of rows returned by a factor of 15.

Given what we know about how critical accurate row estimates are to inform join strategies and the possibility that these correlation errors can compound across multiple joins, it's evident that the planner's underestimations could have significant effects on query performance.

So we've encountered a bit of a problem. In the following post, I'll discuss how Postgres uses extended statistics to deal with correlation within a table, the limitations on correlations between tables, and other strategies for generating more accurate estimates and better query plans when faced with this situation.