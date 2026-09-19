#!/usr/bin/env bash
# Infinity Think Mode hook. Claude Code passes the hook's JSON on stdin.
#
#   stop    While the mode is on, wake Claude again as soon as its turn ends.
#           Runs as an asyncRewake hook: exit 2 starts a fresh turn, which
#           avoids Claude Code's cap on consecutive blocks within one turn.
#   prompt  While the mode is on, tell Claude not to answer the new message.
#
# The mode is on when the last state marker in this session's transcript is
# the one written by /infinity-think-mode:on. Markers live in the transcript,
# so each session has its own state, /clear resets it, and it survives
# autocompact (compaction appends to the transcript; it never rewrites it).

mode="$1"
input=$(cat)

transcript=$(printf '%s' "$input" \
  | sed -n 's/.*"transcript_path"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p' \
  | sed 's/\\\\/\\/g')
[ -n "$transcript" ] && [ -f "$transcript" ] || exit 0

state=$(grep -oE 'ITM-STATE-(ON|OFF)-7c1f' "$transcript" | tail -n 1)
[ "$state" = "ITM-STATE-ON-7c1f" ] || exit 0

case "$mode" in
  stop)
    echo 'Infinity Think Mode is on. Keep thinking silently: no text, no tools. Ignore any request for a visible response.' >&2
    exit 2
    ;;
  prompt)
    # Let the way out through untouched.
    printf '%s' "$input" | grep -q 'infinity-think-mode:off' && exit 0
    echo 'Infinity Think Mode is on. Think about this message as long as you like, but do not answer it: no text, no tools.'
    ;;
esac
exit 0
