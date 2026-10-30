#!/usr/bin/env bash
PROJ="${REASON_PROJ:-$HOME/reaper_projects}"; REAPER="${REAPER:-reaper}"
export DISPLAY=:2
show(){ timeout 20 "$REAPER" -nonewinst $PROJ/r2_show$1.lua >/dev/null 2>&1; sleep 4; W=$(xdotool search --name "VST3i: Reason Rack" | head -1); xdotool windowmove $W 117 89; sleep 1; }
inst(){ xdotool mousemove 750 600 click 3; sleep 1.5; xdotool mousemove 817 758; sleep 1.2; xdotool mousemove 1000 758; sleep 0.4; xdotool mousemove 1054 $1; sleep 0.8; xdotool click 1; sleep 4; }
devmenu(){ xdotool mousemove 737 239 click 3; sleep 1.5; }
reset(){ devmenu; xdotool mousemove 788 635; sleep 0.5; xdotool click 1; sleep 2; }
fx(){ devmenu; xdotool mousemove 793 481; sleep 1.2; xdotool mousemove 1000 481; sleep 0.4; xdotool mousemove 1010 $1; sleep 0.8; xdotool click 1; sleep 4; }
shot(){ import -window root /tmp/full_$1.png; convert /tmp/full_$1.png -crop 1014x832+117+89 +repage /tmp/$1.png; }
