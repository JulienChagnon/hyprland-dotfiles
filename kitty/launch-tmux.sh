#!/usr/bin/env bash
# Each kitty window gets its own tmux session (no mirroring).
# tmux-resurrect saves all sessions across reboots.
if command -v tmux &>/dev/null && [ -z "$TMUX" ]; then
    exec tmux new-session
fi
exec bash
