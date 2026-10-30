#!/usr/bin/env bash
PROJ="${REASON_PROJ:-$HOME/reaper_projects}"; REAPER="${REAPER:-reaper}"
# usage: r2_run.sh script.lua expected
export DISPLAY=:2; cd $PROJ; rm -f r2_done.txt
timeout 20 "$REAPER" -nonewinst $1 >/dev/null 2>&1
for i in $(seq 1 600); do [ -f r2_done.txt ] && grep -q "$2" r2_done.txt && break; sleep 1; done; cat r2_done.txt 2>/dev/null || echo TIMEOUT
