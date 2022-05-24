#!/usr/bin/env bash

# Terminate already running bar instances and applets
killall -q polybar
killall -q nm-applet
killall -q blueman-applet
killall -q pnmixer 
killall -q caffeine-ng

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

# Start applets
nm-applet &
pnmixer &
blueman-applet &
sleep 1 
caffeine &

# Launch bar1 and bar2
if [ "$1" == "light" ]
then
	#polybar -c $HOME/.config/polybar/light-config nord-top &
	for m in $(polybar --list-monitors | cut -d":" -f1); do
    		#MONITOR=$m polybar --reload example &
    		MONITOR=$m polybar --reload -c $HOME/.config/polybar/light-config nord-down &
	done
else
	#polybar -c $HOME/.config/polybar/dark-config nord-top &
	for m in $(polybar --list-monitors | cut -d":" -f1); do
    		#MONITOR=$m polybar --reload example &
    		MONITOR=$m polybar --reload -c $HOME/.config/polybar/dark-config nord-down &
	done
fi

echo "Bars launched..."
