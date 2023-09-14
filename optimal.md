# The optimal amount of most Bad Things is non-zero.

The overwhelming costs of complete eradication.

## There is a difference between optimal and ideal.

Patrick McKenzie writes that "[the optimal amount of fraud is greater than zero](https://www.bitsaboutmoney.com/archive/optimal-amount-of-fraud/)".
This is interesting because fraud is widely considered a Bad Thing.
Our intuition may be that the optimal amount of Bad Things is zero.
After all, things that are Bad have negative effects.
Wouldn't we all be better off with fewer Bad Things?

In a vacuum, I think the answer is yes.
And to put it slightly differently - the *ideal* amount of Bad Things is zero.
Unfortunately, few of us have the privilege of living in a vacuum.
The rest of us may look up to ideals but end up having to make decisions based on what is *optimal* - that is, the ideal state of things given a certain context and set of constraints.

## When should an optimal amount of a Bad Thing not be zero?
This rests on the following assumptions:
1. Resources are limited.
2. Changing the amount of a Thing costs resources.
3. The naturally occuring amount of a Thing is non-zero.
4. The further away from its natural amount, the more resources it takes to change the amount of a Thing. This is most common when interventions cannot be perfectly targeted and instead are implemented through a stochastic process.  
5. Without consistent pressure, the amount of a Thing tends to revert to its natural amount.

## A non-zero number of examples.
There are [tradeoffs in everything](/tradeoffs.md).
I think about this a lot, especially when people tell me that I should have zero tolerance for something.

### The optimal amount of fraud is non-zero, revisited.

Taking McKenzie's example of card fraud and (1) as a given, the rest of case becomes: (2) Reducing card fraud has direct costs, such as the time and money spent on detecting and preventing fraud, as well as indirect costs, such as lost revenue from customers frustrated by anti-fraud measures. (3) Fraud naturally occurs at a non-zero rate. (4) Anti-fraud measures have non-zero error rates. As a result, when the amount of fraud decreases, the relative amount of false negatives increases. (5) When effective anti-fraud programs cease, the amount of fraud increases.

The only way to have zero fraud is to have no commerce.

### The optimal amount of bugs is non-zero.
I work as a product manager. Sometimes, I will get questions about why I let bugs get into production. ~~After I am done blaming my engineering team,~~ I end up explaining, in slightly different words, that the optimal amount of bugs is non-zero. (1) Given. (2) Researching and fixing bugs takes time and energy. (3) Almost all software is of sufficient complexity that a certain level of unexpected behavior is... expected. (4) The existing testing framework catches most major bugs and is itself optimized between accuracy, speed, and cost. Expanding it to catch the incredibly niche bug you found (and the other slightly different permutations of the bug depending on the software configuration) would mean no more feature delivery. Ever. (5) As the codebase changes, testing and QA procedures have to change in concert or they will become less useful at catching bugs.

The only way to have zero bugs is to have no software.

### The optimal amount of personal injury is non-zero.

A few days ago, I stubbed my toe. I was not very happy about it at the time, but on further reflection, I think the occasional injury is a natural consequence of this optimization paradigm. (1) Given. (2) Avoiding injuries incurs a cost in terms of activities I must avoid. (3) I am not superhuman enough to naturally and effortlessly avoid all injuries. (4) I don't know beforehand what activites will lead to an injury. Statistics invariably show that you can get injured doing the most mundane activities, so the more minor the injury I want to avoid, the greater the cost in terms of activities I cannot partake in. (5) Every moment brings new opportunities for injuries if I am not carefully trying to avoid them.

The only way to have zero injuries is to have no life.

## This is not always true, but it is useful.
When might this not hold?
I think assumptions 1 and 2 are widely accepted and minimally controversial. I am less confident that 3-5 are universally applicable across all Bad Things - specifically, I am suspicious of the reliance on a "natural" amount of a Thing. But I cannot think of a good counter-example at the moment.

In other words, this model may not be perfect. Please get in touch if you have ideas on how to better construct the principles, see a major (or minor) gap, have a counter-example, or want to discuss in general.