---
layout: post
title:  "Making and meeting Moloch"
slug: making-and-meeting-moloch
date:   2026-03-31
published: true
---

# Making and meeting Moloch

*Game design, tradeoffs, and the pressure to make the numbers go up.*

This is a reflection on the makings of [Project Basilisk](https://projectbasilisk.com), a short-ish game-ish experience about creating safe AGI in a world where being first is all that matters.

There's a moment that any creator or founder can recognize - the moment when their carefully-crafted idea makes contact with reality. Who budges? Certainly not reality, not unless your creation is large enough to change it. Most aren't.

My moment came when I released the alpha version of a game I'd been chipping away at for months. It wasn't in a great state - I'd taken to heart the saying "if you're not embarrassed by the first version of your product, you've released too late"[^1]. I knew I'd get some flack. I didn't know how much I'd get.

Some of the comments were easy to receive. They raised items I'd already had on my backlog, things that were consistent with my vision that I'd just needed a nudge to get to. Those comments were the nudge I needed to make my vision coalesce a little further.

Others were more difficult. They questioned whether this was a game at all. The numbers reflected this - the drop-off looked existential. My idea came into contact with reality and was found wanting.

What do you do when you have a vision and the world wants something else?
## Origins

But I'm getting ahead of myself. Project Basilisk[^2] was originally conceived as a sermon. Inspired by Universal Paperclips[^3], I'd wanted to create an expectation-subverting narrative about the difficulties of creating safe AGI amidst the incentive systems and market structures that pressure labs to go faster, no matter the cost. The core idea of an incremental game is that the numbers go up. More numbers go up more faster = more dopamine. The core idea of my game was, "hey, maybe we should stop and think about the speed at which the numbers go up, and whether in fact we want the numbers to go up at all, before the numbers become sentient and slip out of our control". (The numbers being a ham-fisted allegory for AI research, naturally.)

As a person of limited technical proficiency[^4], I turned towards the latest and greatest version of Claude Code. I'd used it before for limited projects, but this would be my first real foray into creating something from the ground up with a coding agent.

One of the interesting (and fun, debatably?) things about working with LLMs is their limited context window. Because LLMs are an excellent opportunity for one to speedrun the history of effective management and software development practices, this meant I got to do one of my favorite things: create documentation, which meant [writing a lot](https://knowingken.com/write-bad.html) about my ideas. I started with a north star vision document, which gradually morphed into a constellation of 30+ design documents covering the main principles of each major system in the game, from the economy to research to alignment. And because this wasn't meant to be 'just a game', pages upon pages of narrative background, arcs, and character backstories.

I really enjoy writing because it forces me to confront what a hypocrite I am. My original design document had twelve "core" values. That was way [too many values to be useful](https://knowingken.com/values.html). I could have gone forwards and created something that did a lot of things in a mediocre fashion. Instead, I killed my darlings, until I was left with one core principle:
1. The mechanics are the message: players should realize the morals of the game through the actions they take.
About half-way through development, I realized I had neither the time nor the aptitude to simulate the world entire, so I wrote down a fallback principle:
2. Meaning > education > balance > fun.

(It turns out that these principles would become increasingly difficult to follow. That's when I knew I'd chosen useful ones.)

Having written down my vision and values, it was a simple matter to do the thing and make the game.

If you haven't played the game - spoiler alert:

You play as the CEO of an AI lab competing to build AGI. There are strong economic and competitive pressures. It's difficult to do everything by the book and still make it to AGI first - and making it there first is the only thing that matters.

What trade-offs are you willing to make, and what risks are you willing to take, in your pursuit of greatness? Will you cut safety work to accelerate timelines, look past data provenance in a crunch, or ignore warning signals to maintain investor confidence? And how will your decisions affect the shape of the AI you create?

## Contact

This is barely a game.

The gameplay is oddly cruel.

There's no replayability.[^5]

The first rounds of feedback were brutal. Bounce rates were sky-high: nearly two-thirds of players who started the game bounced after less than five minutes. The funnel after that was barely any brighter. After the first twenty-four hours, less than 1% of players who had started the game had finished it. I didn't know if that was good or bad in the grand scheme of gaming analytics (and I still don't), but it felt bad for a game I had designed to take around 80 minutes to play through.

The initial ratings were no better. A deluge of one-stars pummeled the listings. The message was inescapable: it felt like an unequivocal failure.

I'd intentionally released the game in a half-finished state. Out of two planned story arcs, only the first - which I rather considered a prolonged tutorial or demo - was part of the initial launch. The feedback made me question whether it even made sense to work on the second half.

But despite the headwinds, I discovered some powerful forces at my back.

First, a few positive comments began slipping through. Though few and far between, each one was a lifeline providing the approval and vindication that became motivation.

Second, the ratings began to split. I'd assumed that the ratings would come in a normal distribution - that the slew of initial one-stars meant it'd never climb higher. But over the next several days, as players came back to the game and completion rates slowly rose, a bimodal distribution emerged. Yes, a lot of people hated it. But if they didn't hate it, it looked like they loved it. Four- and five-star ratings began to bump up the averages. The distribution of ratings wasn't something I'd given much thought to before, but I came to appreciate the bimodal, love-it-or-hate-it verdict far more than had the ratings been a mediocre slew of twos and threes.[^6]

Third, stubbornness runs deep in my blood, whether by nature or nurture. There was no way I was giving up on something I thought could be great, not if my big bull head had anything to say about it.

If years of product management had taught me one thing, it was to go to the numbers. So I pulled up Posthog and started looking through the conversion funnel in detail. Perhaps a large part of the bounce rate was due to the audience - so I broke down the funnel by referrer. It turned out that certain domains had much higher conversion. Audiences that were willing to give weirder, genre-bending games a shot made it a lot further than audiences who were expecting a Cookie Clicker clone[^7].

I knew that 100% conversion was a pipe dream, but maybe I was leaving some low-hanging fruit unpicked. I crunched the numbers - nearly half of the drop-offs were with players who spent time clicking around the UI and were confused about what to do, eventually giving up. There were signals of intent; these players didn't immediately see the game and bounce, they gave it a shot. Building a real tutorial for them became my top priority.[^8]

The tutorial worked. Most players went through it, and those who did completed the game at 4x the rate of those who didn't.

But the tutorial was not a panacea. There was a very large segment of players who bounced before even reading the first guiding message. The game was very narrative-heavy. These players would never be part of my target audience. Despite this, I felt a deep urge to change my creation to appeal to them.

What if I just simplified the mechanics a little, so a player didn't really have to understand the game to play it? Reduced the tension between being safe and being fast, so losing stops being an option? Turned uncomfortable tradeoffs into win-wins, so players didn't have to make hard choices? Smoothed out the abstractions and gutted the concepts, so as to avoid the confusing contradictions of reality?

What if I hyper-optimized for the metrics that were legible, the metrics I had chosen to measure in large part because they were the "standard" in product / gaming analytics? If I chased conversion, retention, playtime, users, while silently trading off against the metrics that were harder to measure - the educational value in the tension, the intentional anxiety, the realism of the concepts?

There is a moment that every creator and founder recognizes, when their vision meets reality and is found wanting. There will be an unbearably intense, seductive, coercive urge to compromise their vision, the ethos that defines their creation, in service of making the numbers go up.

This was mine.
## I'm So Meta Even This Allegory

Project Basilisk was originally intended as a commentary on how structural incentives and competitive pressures can test even the most principled founders.

I did not expect to find it testing myself.

I'd wanted to create an educational experience, a genre-bending hybrid interactive fiction / simulation / incremental / strategy / game / sermon. The market I entered wanted fun and features, a predictable experience where the numbers go up without too much thought involved. I was competing for player attention against every other game out there.

The metrics for my vision were bleak. The hypothetical metrics for a twisted version - with a shorter game loop, faster feedback, a stripped-down narrative, all optimized for retention and fun - were much better.

I found myself facing the same tradeoff I had designed for my players.

It would be so easy to abandon the original vision. So satisfying to watch my own numbers - players, completions, ratings - go up.

But then I thought back to my original reasons for building this at all. I hadn't gone into it wanting the approval of every player. I hadn't wanted to create the next Cookie Clicker or Angry Birds or Candy Crush.

I had wanted to make something that meant something. And compromising here would subtract from the meaning I wanted to convey.

"The mechanics are the message. Prefer education over balance. Prefer balance over fun."

And so the anguished decision became simple. The seduction became banal. Having accepted that I could not reach everyone, I chose to make the experience the best it could be for those I could reach.
## In which we all face Moloch together

Scott Alexander called it [Moloch](https://slatestarcodex.com/2014/07/30/meditations-on-moloch/): the way competition forces individually-rational actors to sacrifice the things they value most, not out of malice or incompetence, but because the structures they operate in won't let them do otherwise.

I met a baby Moloch in the corners of the internet where I'd shared my game. The stakes were low, despite how high they felt in the moment. My Moloch was relatively easy to overcome.

The leading AI labs of our time face a much larger Moloch. Resisting Moloch doesn't just mean driving forward stubbornly against a few mean words on the internet. It may mean defying your national security apparatus and potentially being blacklisted across the country. It means holding fast to care, when carelessness is so often easier, more profitable, more convenient. And the consequences are far more severe. Giving into my Moloch would've meant the world losing a single weird indie game and gaining a gacha game (or a gambling app, or a short-form video platform).

Giving into our shared Moloch may mean a world that has lost all that makes it recognizable.

And even if we do resist Moloch - if we somehow build something "safe" and "aligned" - we'll find another Moloch with a tougher question yet: safe for whom? Aligned to what values?

---

This essay can be differently experienced as a game-thing [here](https://projectbasilisk.com).


[^1]: Reid Hoffman, if the internet is to be believed.

[^2]: Originally "AGI Incremental", until I spent 3 hours trying to solve the hardest problem in development - naming things.

[^3]: Among other games too numerous to list. A feeble and very incomprehensive attempt: Papers, Please; Frostpunk; The Roottrees are Dead; Type Help; A Dark Room; Biotomata; Skynet Simulator; The McDonald's Video Game.

[^4]: Some of my friends say that this is wildly inaccurate, but they disagree about the direction, so I have yet to find a better label.

[^5]: Although I suppose this commenter played it through at least once, which I count as a win.

[^6]: I'm still not sure to what extent game ratings are driven by sampling bias and whether such starkly bimodal distributions are simply the norm. If you have data on this, I'd love to chat!

[^7]: No offense to Cookie Clicker, grandfather of the genre that it is.

[^8]: Building tutorials when afflicted with the curse of knowledge is much more difficult than I had imagined.
