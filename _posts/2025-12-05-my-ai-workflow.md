---
layout: post
title: My Workflow with AI Agents
excerpt: >
  A workspace with simple tools that leverages multiple parallel AI agents.
---

# My AI Workflow

## System Prompt – History

In Februray 2025, I went on parental leave. At the time, Copilot, ChatGPT, Cursor, & custom built AI workflows using
your own `TOKEN` were the main ways to use generative AI for work. As a neovim user these tools weren't compelling
enough. Copilot was a fancy autocomplete, ChatGPT was a more interesting Google Search. Cursor looked nice but wasn't a
significant productivity upgrade from my current workflow, not enough to justify the switch anyway.

Building my own workflow seemed like a good idea but would be a huge lift. I also knew that there was a lot of eyes on
AI and a lot people working to make it easier to leverage. Building my own thing on the side felt like a waste, I either
had to dedicate a lot of thought & energy to compete with other's or else wait for something better to come along. I
also thought that Cursor might improve enough to make the switch worth it.

I came back from leave in September 2025. I followed along what was happening with AI while I was off but didn't put
time into playing with it. The development of new AI tools & advancements has been rapid over the past 2 years but
stepping out of the loop & re-entering 7 months into the future. That's a _stark_ transition. Agents were the tool I
didn't know I needed. It fit near perfectly into my workflow.

## Tools

Prior to agents my workspace setup relied on a a minimal set of tools that I could easily remember & port to other
workspaces easily.

* `tmux` – + a custom `mux` tool to simplify my common commands
* `neovim` – + glue code to send commands to other `tmux` panes.

With agents I've augmented it with a few more tools but the total set is still quite small.

* `claude` – + a custom `c` tool to control MCP's on startup with `fzf`
* `git worktree` - + a custom `wt` tool to navigate with `fzf`

## Prompt – The Workflow

When I want to start on a new piece of work this is what I do

```sh-session
$ mux new feature-name  # creates a new tmux window with the name `feature-name`
$ wt new                # pulls worktree name from tmux window i.e. `feature-name`
$ mux split             # create 3 tmux panes Left Half for `nvim`, Right Bottom for `claude` & another for a shell 
```

Next, I open `claude` (with `c`) & `nvim`. I use a custom leader command `<leader><leader> np` – `np` for **n**otes
**p**rompts. This opens a new file under `$NOTES/claude/prompts/feature-name.md` where `feature-name` is the `git
branch` or the current directory name if it's not a `git` project.

At this point I'm ready to go, I have a prompt file and I can send the contents directly to claude with
`<leader><leader> c`.

## Reference

These are other commands that I use day to day to when resuming past work.

```
mux new [NAME]          # omitting NAME will open `fzf` with existing worktrees
wt swtich               # select an existing worktree with `fzf`, this is the default command when run as `wt`
```

Neovim has a few lua functions that help work with claude & tmux

```
<leader><leader> c      # send full buffer or highlighted region to claude pane
<leader><leader> f      # send filepath + line numbers to claude (uses @/file/path syntax) to force claude to read it
<leader><leader> fn     # find notes – open fuzzy finder scoped to `$NOTES/` with my claude prompts, commands & agents
```
