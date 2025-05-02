---
date: "2024-11-25T23:13:00+01:00"
draft: false
title: "Introducing LiteLookup: Your Terminal Assistant"
author: "Abdulmumin"
---

Quick question: How many browser tabs do you have open right now? How many of them are due to needing concise information about some random concept?

As a software engineer who practically lives on the command line, I’ve always been frustrated by the idea of switching to a web browser for quick references and simple explanations. Whether it’s a syntax issue, programming concept, or system command, I want to be able to access information directly from the terminal—without the hassles of window-switching and tab-juggling. That is why I created [LiteLookup](https://github.com/Lanrey-waju/lite-lookup)

## Who Is This Tool For?

LiteLookup was created for anybody whose workflow revolves around the terminal. Whether you are a system administrator, DevOps professional, or backend engineer like myself, LiteLookup can save you valuable time that would have been spent switching windows and managing browser tabs just to find some quick information.

## Key Offerings

LiteLookup is a simple command-line interface (CLI) tool that lets you access concise, on-demand information about a concept without leaving the terminal. Here is why LiteLookup is special:

- **Fast lookups:** Get the information you need in seconds
- **Avoid distraction:** Stay focused and don’t enter a rabbit hole you don’t need to.
- **Digestible explanation:** Get beginner-friendly information on your queries
- **Conversational mode:** You can go back and forth on an idea you want to brainstorm about right from the terminal.

## LiteLookup In Action

At the most basic level, you can fetch quick, one-time information about any concept with the following command:
`lookup “concept”`

The tool returns a short, quick reference on the topic within seconds.

Let's play out a scenario quickly:
Imagine you’re deep in a coding project trying to manage your local git repository, and suddenly, while working in the terminal, you come across an unfamiliar git command: ”git stash.” Expectedly, you’re lost and need a quick reference on the novel command. Instead of leaving the terminal and opening another browser tab to search through various articles and potentially get distracted, you can simply type the following on the command line:

\>\> `lookup "git stash"`

Within seconds, you should get something like:

![Image showing basic usage of the lookup command](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/q3orsz5jpe4tqeqgimlu.png)

Just like that, you have gone from clueless to informed—all without leaving the comfort of your text-based haven!

## Getting Started

LiteLookup is easy to set up and use:

### Prerequisites

- Redis server installed and running  
  Redis is a lightweight, open-source key-value store used for caching. Learn how to install Redis [here](https://redis.io/docs/latest/operate/oss_and_stack/install/install-redis/).
- Python 3.11 or higher
- Groq LLM API access (get your free API key [here](https://console.groq.com/keys))

### Setup

1. Ensure Redis is running:

- `redis-cli ping`
  You should get PONG which indicates Redis is up and running.

2. Install LiteLookup via pip or pipx:

- `pip install litelookup`

3. Check Installation

- Enter `lookup —-version` to check if the tool is correctly installed

4. Configure your API key

- To use the tool for the first time, you should see a prompt
  asking you to input your API key:  
  `>>Enter API KEY here:`
  Simply paste the API key you got from [Groq](https://console.groq.com/keys) to use the tool.

## Usage

### Basic Lookup

To fetch quick concise information about a concept, type:
`lookup "concept"`

### Get Help

To get a description of the tool and a list of available commands, use the \-h or –help flag with lookup as so: `lookup -h` or `lookup –help`

### Programming Mode

If you care for a more verbose, programming-centric response, you may include the \-p flag in your query.

`lookup "programming concept" -p`

For example, `lookup "print() in python" -p`

### Direct Mode

For even more concise, direct answers to command-related queries, use the \-d flag in your query.

`lookup -d "command to ..."` or `lookup --direct "how to ..."`

For example, lookup \-d "command to delete a file in Linux" or lookup \-d "how to rollback a commit in Git"

![Image showing the usage of litelookup in direct mode](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/toalmrflux1y2kx5uz1u.png)

This mode provides brief, actionable responses without additional explanations. For best results, start your query with "command to" or "how to".

### Interactive Shell Mode

Enter an interactive mode for faster, continuous lookups because the tool does not have to establish new TCP connections whenever you have follow-up queries.:

- `Lookup -id` for interactive direct mode
- `Lookup -ip` for interactive programming mode (more verbose)

To exit the interactive mode, type:

- “quit” or “q”

### Conversational or Chat Mode

For a conversational interactive experience, LiteLookup offers a chat feature that allows you to go back and forth with the tool:

`lookup -ic`

![Image showing usage of litelookup in conversational mode](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/jsqq3h07w9l25pwpido2.png)

As you can see, this mode lets you engage in a conversational exchange and could serve as a nifty terminal brainstorming buddy.

## What’s Coming to LiteLookup?

LiteLookup is intended to be an indeed light tool that does what it’s meant for extremely well. It is currently in its early development stage but promises a lot of intuitive features that align with the original purpose of quick referencing.
It will also continue to be optimized to fix bugs that arise and improve user experience.

## Try It Out\!

Give [LiteLookup](https://pypi.org/project/litelookup/) a try today and share your thoughts! Your feedback is invaluable in making this tool better. Reach out to me on [X](https://x.com/lanrey_waju) or [LinkedIn](https://www.linkedin.com/in/abdulmumin-akinde/) with your experience and suggestions. Thank you\!
