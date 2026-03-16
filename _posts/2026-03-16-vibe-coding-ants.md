---
layout: post
title:  "Vibe-coding ants"
slug: vibe-coding-ants
date:   2026-03-16
published: true
---

# Vibe-coding ants

*Ants, assembly, and local optima.*

[Moment](https://moment.com/) recently held a wonderfully fun programming challenge:
> You write a program in a custom assembly-like (we call it ant-ssembly) instruction set that controls 200 ants. Each ant can sense nearby cells (food, pheromones, home, other ants) but has no global view. The only coordination mechanism is pheromone trails, which ants can emit and sense them, but that's it. Your program runs identically on every ant.
>
> The goal is to collect the highest percentage of food across a set of maps. Different map layouts (clustered food, scattered, obstacles) reward very different strategies. The leaderboard is live.

As a non-technical product manager, I was curious how far pure vibes could get me. I ended up with a final score of 599 (out of 1000), placing 52nd out of ~27k submissions (note that players could submit multiple times, so the actual number of entrants was probably much lower). For context, first place achieved 856 points, and the top 10 was rounded out at 770.

**Conclusion**: the vibes were great at bootstrapping a program even when the user (me) had farcically little idea about what was going on. They were also good (too good) at optimizing the program into a corner that we later couldn't get out of.

**Contents:** [Methods](#methods) · [Strategy](#strategy-some-things-that-worked-some-things-that-failed) · [Genetic simulator](#other-fun-stuff-genetic-simulator)

## Methods
I[^1] immediately realized that I did not want to use the (very beautiful) web editor that Moment provided, as the transfer of code in and out of the browser would add overhead to the agent dev loop. So I (read: Claude) downloaded the HAR file from my browser, extracted the simulator engine, wrote a local Node.js simulator for the end-to-end process, and put some reference docs around it. Combined with a testing script so Claude didn't have to continually rediscover how our harness worked, this meant that we could conduct small 12-map tests and larger 120-map evaluations locally as part of the dev/test iteration loop.

Then I let Claude loose. Despite having a 20x Max subscription, I became slightly worried about how many tokens it was burning, and so throughout the project I took major detours to develop some tooling/scripting for Claude to use, including a static ops budget analyzer, ant and map diagnosis tools, and automated parameter sweepers. Creating tooling for these sorts of repetitive analyses saved a considerable amount of time (and tokens) - **if I caught Claude doing something repeatedly that could be automated, I had it automate it.**

The iteration loop:
1. Pull hypotheses from our running roadmap and lessons documents
2. Generate list of suggested code enhancements
3. Snapshot baseline scores
4. Launch subagents to build out enhancements in parallel, isolated worktrees
5. Run 12-map tests on a static seed to smoke-test for significant regressions
6. If passed, run 120-map random-seed evals for a more statistically-sound signal
7. Decide whether to incorporate or reject the changes
8. Update roadmap/lessons document and return to step 1

In addition to this core iteration loop, I had some Claude agents conducting research into prior art around pathfinding algorithms, ant colony behavior in nature, other ant simulation contests, etc. Several breakthroughs came from this research. Why reinvent the wheel?

While the project started around the ref docs, roadmap, and lessons, documentation quickly grew, to the point where we started some meta-documentation such as system maps so that Claude could efficiently find what it needed. By the end the lessons log had 200+ entries, and we'd search it before starting any experiment. **Not repeating past mistakes sounds obvious, but dev agents love to repeatedly make the same mistakes unless specifically instructed not to**, and lessons doc + hooks are good (though not perfect) ways to implement enforcement.

## Strategy: some things that worked, some things that failed

### The final brain

The final brain I submitted used two general states - one to explore the map and find food (exploring), the other to take food back to the nest (homing).

The main homing signal was a Dijkstra gradient-driven green pheromone field built from the nest outwards. Each ant would sniff nearby cells and find the strongest green signal and mark its own cell slightly weaker. Ants trying to get home would follow the gradient uphill back to the nest.

Theoretically, this method could've led to trails that were 255 cells long due to pheromone strength caps and decay. In practice, however, trails were less than half that length because our outward-bound ants intentionally weakened the trail by an extra 1/cell. Combined with imperfect outward-bound pathfinding, the green nest gradient frequently peaked at 80-100 cells long.

Inversely, I used red as the food signal. Ants would pick up food, follow green home, and mark red along the way so exploring ants could climb the red gradient upwards towards the food.

For around 80% of the challenge, I used dead reckoning. However, this was quite costly, both in terms of ops budget as the ants had to spend a significant portion of each tick recording its movements, and memory register use since the ants had to store its location vis a vis the nest. In my final submission, I had dropped dead reckoning in favor of a reworked pheromone system.

### Challenges and missed opportunities

My final submission had **one unused register and two unused pheromone channels** (blue and yellow). Since a major challenge I faced was trying to extend the green pheromone trails, these channels were obvious avenues of exploration. Despite hours of brainstorming and trying out several designs with Claude on how best to incorporate these, we were never able to find a design that worked.

As I'm sure other competitors experienced, wall-following was a major challenge, especially for the gauntlet and fortress maps. While we eventually landed on a manageable wall-following solution, I'm sure it wasn't ideal and some additional points could have been achieved with a better solution.

I spent a significant amount of time working with Claude on clean-room rewrite attempts. None of these led anywhere, perhaps because they were too ambitious in scope and didn't have a clear architectural thesis that we were betting on. As a result, when the rewrites inevitably ran into hiccups like significant score regressions, they were quickly abandoned.

### Mistakes & lessons

#### It's hard to reliably identify small enhancements when there's an element of randomness.
The contest was technically deterministic, in that the same code would result in the same scores. However, due to the pseudo-random number generator used internally, code that was logically identical could lead to different results if instructions shifted the RNG sequence in critical paths, even with the same seed and maps.

PRNG noise caused up to +-30 point divergences on the 12-map eval, which meant that it was very difficult to reliably identify incremental enhancements. I spent a non-trivial amount of time trying to figure out how to separate signal from noise on the 12-map tests, eventually just falling back to 120-map tests in an effort to smooth out the noise.

#### Early design choices can lead to lock-in on local optima.
In the first version we developed, Claude included features such as dead reckoning which became load-bearing. The rest of the brain was so optimized around it that any incremental change would lead to significant score regressions, which led to us concluding that dead reckoning was an essential part of the system.

After stalling, we eventually explored a ground-up rework, removing dead reckoning and using the additional ops to rework our pheromone system, which both freed up ops and led to small score gains itself. The AI iteration loop was excellent at local optimization, but it wasn't able to chain together these experiments into a more cohesive rework without explicit prompting.

#### Smart architecture beats incremental enhancements.

A core tenet of my AI iteration loop was making small, isolated, and testable changes. This approach works well for tuning parameters, but it quickly led to ceilings on architectural exploration. Most of the major score leaps we had were driven by patient diagnosis and brainstorming to see what enhancements were interdependent and needed to be tested together. This is probably the hardest thing to operationalize in my loop, because it was structured around incremental and reversible changes by design.

#### Kill (and resurrect) your darling hypotheses.
Many times while iterating, we marked hypotheses as invalidated, but never revisited those hypotheses later on, when the architecture and relevant conditions (such as register availability or ops budget) had changed.

After changing our process to regularly revisit stale hypotheses and to proactively brainstorm conditions under which hypotheses should be retested, we discovered several enhancements which led to incremental score gains.

## Other fun stuff (genetic simulator)
Around 24 hours before the contest ended, I accepted that no major breakthrough was foreseeable within the context of the LLM-driven iterative development cycle, so I decided to have a bit of fun and spun up a genetic simulator and a couple cloud machines to run it overnight. Despite being run for a dozen hours on two of the finest machines a new account limited by quota could get, this approach did not surface any improvements over the hand-tuned brain (hypotheses as to why below), but it was way more fun than it had any right to be.

The first attempt was rather dismal. The genetic simulator operated at the instruction level and was unable to reliably create viable programs in the enormous search space presented therein. Despite adding several funnel steps (including a static analyzer to ensure mutated code was valid), these programs struggled to even make it to the base 45 score achieved by the contest-provided sample brain.

Seeing the instruction-level mutations fail, I pivoted to evolving state machines. Basically, this meant pulling out specific states or routines from my hand-crafted brain and using those as the building blocks for the genetic simulator. Unfortunately, this method effectively gates the potential ceiling of the genetic sim at my (lack of) ingenuity in creating the base states. Even starting from scratch, the evolved brains were never able to break past the local optima that my hand-tuned brain had found itself in.

While the genetic simulator was ultimately not successful at producing a better brain in the ~24 hours I ran it, I found it was an excellent way to grok certain genetic/evolutionary concepts, effectively re-discovering concepts from high school biology.

For example, early attempts quickly converged on the locally-optimized brain we already had, because it had the highest score and score was our only fitness signal. By identifying additional signals and implementing a multi-objective fitness function, we were able to encourage greater diversity in the "gene pool" which led to more interesting mutations and certain brains which populated specific map-type niches.

Mutation granularity was also a major dilemma. The initial instruction-level mutations were ideal in the sense that the simulator could (and did) come up with anything, theoretically allowing for breakthroughs that neither I nor Claude may have thought of. In practice, 99.999....% of "anything" was broken programs. The state-machine mutations were better but perhaps went too far in the other direction. When the smallest unit of change was an entire state/routine, it was too coarse for the simulator to make gradual improvements, and the simulator converged repeatedly on the program we had already built. If working on this for more time, digging in on the right level of mutation granularity would be at the top of my list.

As a bonus, because the simulator relied on running large batches of programs through the maps, I found the original JS engine lacking in terms of performance, so Claude rewrote it in C / WASM which improved throughput tremendously. This was also a fun little detour into the performance of genetic simulators and how optimizations that can improve performance (such as creating more gates and steeper dropoffs between funnel steps) must trade off against genetic diversity that might only become beneficial later on.

[^1]: Throughout this post, I use "I" and "Claude" interchangeably, because "Claude" requires 5 more letters to type than "I". It is reasonable to read that any step which required coding was done exclusively by Claude, and 90% of the ideas were generated by Claude as well.
