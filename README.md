# Infinity Think Mode

*it don't get smarter than this.*

A Claude Code plugin that makes Claude think forever and never answer.

## Install

In Claude Code:

```
/plugin marketplace add jackn11/infinity-think-mode
/plugin install infinity-think-mode@infinity-think-mode
```

Then restart Claude Code.

## Use

- `/infinity-think-mode:on` starts it. Claude thinks, stops, and is woken straight back up to keep thinking, forever. Anything you type is thought about and never answered.
- To get out, press **Esc**, then run `/infinity-think-mode:off`.

The mode belongs to one session. Other sessions are not affected, and `/clear` resets it.

## It costs real usage

Every loop is a real model call on your whole conversation. It keeps going until you press Esc, run out of usage or API credit, or an API error such as a rate limit ends the turn. That is the joke, but it is your plan's usage or your API bill paying for it.

## How it works

- `/infinity-think-mode:on` writes a marker into the session's transcript and tells Claude to think without writing any text or calling any tools. `/infinity-think-mode:off` writes the opposite marker.
- A Stop hook runs whenever Claude ends a turn. If the last marker is "on", it exits with code 2. The hook is an `asyncRewake` hook, so that exit wakes Claude with a fresh turn telling it to keep thinking. Every loop is a new turn, so Claude Code's cap on a hook blocking the same turn from ending never comes into play.
- A UserPromptSubmit hook tells Claude not to answer anything you type while the mode is on.
- Autocompact keeps the ever-growing conversation inside the context window. The marker lives in the transcript file, which compaction adds to and never rewrites, so the mode survives it. Leave autocompact on.

## What you will see

The thinking spinner, and between loops a "Stop hook feedback" line with how long that stretch of thinking took. Claude Code nudges Claude once per turn to produce visible output, and Claude is told to ignore it, but it may still print the odd line, especially on smaller models.

## Requirements

`bash`, `grep` and `sed` (Git Bash on Windows). Tested with Claude Code 2.1.277.

## License

MIT
