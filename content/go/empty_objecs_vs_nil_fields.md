---
date: "2025-05-07T15:01:09+01:00"
draft: true
title: "Empty Objects vs. Nil Fields When Marshalling in Go"
author: "Abdulmumin"
---

## A little backstory...

I recently contributed to an open source tool called [autocommit](https://github.com/christian-gama/autocommit). It is a tool that solves an issue I have and I thought to implement myself. Autocommit generates conventional commit messages based on the input `git diff`. Pretty neat and handy for those times when you struggle to come up with concise but descriptive commit messages for code changes you made.

Instead of jumping straigt to possibly reinventing the wheel, I decided to see if autocommit could just work out of the box. And it would have, if it didn't attempt to force me to take money out of my wallet.

The library only worked with OpenAI's models which you have to pay for. So, I thought to make it more flexible, fix the vendor lock-in and allow the use of models that are absolutely free (albeit less-refined) compared to OpenAI's top models.

I implemented a feature to use [Groq](https://console.groq.com), a free AI inference tool that lets you use models like llama, gemma, deepseek, etc., in your applications. To use Groq, you only need the free API key which is also remarkably easy to get.

So, I needed to interact with Groq's API, and looking back, I probably should’ve just jumped in and done it myself. But at the time, my first thought was to check if someone else had already built a module for it. That way, I’d get two big wins:

- Faster development
- Better reliability as I expect a dedicated module to handle all the edge cases better than I would have.

I dedided to use a fairly recent library called [groq-go](https://github.com/hasitpbhatt/groq-go) which is a wrapper around the Groq API. With that, I could offer users of the autocommit tool access to Groq's fast, free and powerful language models.

Everything was working fine, until it didn't.

## The Problem
