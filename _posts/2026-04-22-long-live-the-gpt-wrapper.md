---
layout: post
title: "The GPT wrapper is dead. Long live the GPT wrapper."
slug: long-live-the-gpt-wrapper
date: 2026-04-22
published: true
---

# The GPT wrapper is dead. Long live the GPT wrapper.

*Agentic harnesses didn't just fall out of a coconut tree.*

![](/assets/images/wrapper-harness-same-picture.jpg)

The death of the GPT wrapper has been greatly exaggerated. Modern harnesses are just GPT wrappers rebranded.

Before you go looking for your pitchfork, consider this. Claude Code, Codex, and Cursor are all GPT wrappers in the most meaningful sense: programs that decide what to put into a model and what to do with the output. These are also among the most useful AI products I've used.

Those statements may seem contradictory, but they're actually the same. Harnesses are the only source of context application developers can control. Context dominates every other lever combined. Ergo, harnesses become the only real way to differentiate.

## The model exists only in the context that the harness provides.

When claiming that something is the most important thing ever, it is prudent to define the thing. Context, loosely, is everything the model reads. Less loosely, it's the token sequence that is handed to the function. That sentence is intentionally in the passive voice, because coming up with increasingly creative and useful sources of input token sequences is by far the most interesting area in AI research right now.

At its most basic - think of a chatbot - context consists of a prompt. A marginally more sophisticated setup prepends a system prompt to the user-provided message. Early LLM applications - so-called GPT-wrappers - were basically just prompt engineering, tweaking system and application prompts.

There are two problems with that. First, if your moat is a block of text you prepend to an LLM call, you don't have a moat. Hence, GPT wrapper (derogatory).

But also, and perhaps more importantly, having a real live human decide what goes into the context window is so uninspired. Plus humans rather infamously don't scale as well as computers.

The real fun comes when the system itself decides. All of the fun work to be done in AI lies here, and that is barely hyperbole. A system that can parse a user's request, decide what's relevant, analyze, fetch, format, wrap, and so on, effectively provides a cheat sheet to the model. It can take the model's response and decide what to do next, including invoking additional programs.

That system is the harness.

The vocabulary of AI over the last two years provides prima facie evidence. Agents. RAG. Context engineering. Memory. MCP. Tool use. Chain of thought.

These are all labels for different ways of providing context and interpreting outputs.

And these are moves that are only made possible through a harness. Harnesses can be as simple as loops that force an LLM to keep going beyond its natural stopping point. They can be as complex as agentic coding tools, and that complexity grows release-by-release.

It might be a case of everything looking like a nail when I've just picked up a hammer, but it's an idea I can't get off my mind. The last two years of AI progress, rather than being a parade of new ideas, is actually one idea being explored and dissected from every angle.

If you're building an application on top of an LLM, you can effectively treat the weights as frozen and the hyperparameters as nuisances.

The only dimension your product can change is the context.

## Context engineering, née GPT wrapper, reborn as the agentic harness.

Broke: the [bitter lesson](http://www.incompleteideas.net/IncIdeas/BitterLesson.html) means harnesses will be obsoleted as base model capabilities improve.

Woke: harnesses can still be useful despite the improving capabilities of base models.

Bespoke: harnesses will become increasingly important *because of* the improving capabilities of base models.

If the base model is the durable moat, you'd expect the labs to act like it. Selling API access, guarding the training data, obsessively scaling the base model. Letting the ecosystem figure out what to do with the outputs. This was the dominant sentiment from 2023-2024.

Everything changed when Claude Code attacked. Anthropic's harness bets drove them to close the gap with - and arguably overtake - OpenAI. In January, Anthropic formally [announced](https://www.anthropic.com/news/introducing-anthropic-labs) their Labs team doubling down on harness-based capabilities like Skills, Cowork, and browser usage. In response, OpenAI has poured resources into Codex, Operator, and Projects. Everyone is racing to ship improved tool use, memory features, and multi-step workflows. These are not side projects, as OpenAI's [public pivot](https://www.theverge.com/ai-artificial-intelligence/911118/openai-memo-cro-ai-competition-anthropic) makes clear. Harnesses are now a main bet.

This shift coincided with the weights gap closing faster than expected. Open and semi-open models - DeepSeek, Qwen, Llama, Mistral, etc. - are narrowing the gap to the frontier from years to months. The distance between the best model and a good-enough model is rapidly shrinking across a rapidly-increasing portion of use cases. The labs are responding by moving up the stack.

Examine the revealed preference. Even while labs swear oaths on model superiority as their defining edge, their product roadmaps and strategy reveal their bets on the context layer and domain-specific harnesses. They're betting that being better at calling the function captures more value and does so more durably than producing the function itself.

## Can we break the wrapper reincarnation cycle? Sources say no.

This could change. A sufficiently large frontier jump could reopen the gap (as every lab reiterates in the weeks leading up to a new model).

But it's difficult to reconcile the belief that AGI-ish capabilities are just a few years out and will be worth orders of magnitude more than current applications with increasing investment in product, applications, and harnesses. The diversion only makes sense if capabilities are plateauing or applications will continue to deliver durable value.

Right now, every major lab is investing in a harness hedge. That hedge itself is informative.
