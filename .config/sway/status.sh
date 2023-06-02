#!/bin/bash

# You should see changes to the status bar after saving this script.
# If not, do "killall swaybar" and $mod+Shift+c to reload the configuration.

net=$(ip route get 1 | sed -n 's/.*src \([0-9.]\+\).*/\1/p')
bitrate=$(iwlist wlan0 bitrate | head -n 2 | tail -n 1 | cut -b 28-35)
channel=$(iwlist wlan0 channel | tail -n 2 | head -n 1 | cut -b 29-49)


vol="$(pactl get-sink-volume @DEFAULT_SINK@ | head -n1 | awk -F '/' '{ print $2 }' | awk -F ' ' '{ print $1 }') "


if [ "$(pactl get-sink-mute @DEFAULT_SINK@ | awk -F 'Mute: ' '{ print $2 }')" = "yes" ]
then
	mute="🔇"
else
	mute="🔈"
fi

# The abbreviated weekday (e.g., "Sat"), followed by the ISO-formatted date
# like 2018-10-06 and the time (e.g., 14:01)
date_formatted=$(date "+%a %d.%b %H:%M")

# Get the Linux version but remove the "-1-ARCH" part
linux_version=$(uname -r | cut -d '-' -f-2)

# Returns the battery status: "Full", "Discharging", or "Charging".
if [ "$(cat /sys/class/power_supply/BAT0/capacity)" -gt 25 ]
then 
	battery_capacity="🔋$(cat /sys/class/power_supply/BAT0/capacity)%"
else
	battery_capacity="🪫$(cat /sys/class/power_supply/BAT0/capacity)%"
fi	
	
if [ "$(cat /sys/class/power_supply/BAT0/status)" = "Not charging" ] ; then
    battery_status="🔌" 
elif [ "$(cat /sys/class/power_supply/BAT0/status)" = "Charging" ] ; then
    battery_status="⚡"
else
       battery_status="🔋"
fi

# battery_status=
cpuclock=$(cat /proc/cpuinfo | grep MHz | awk -F ' ' '{ print $4 }' | awk -F '.' '{ print $1 }' | head -n 1)
cputemp=$(
    temp=$(cat /sys/class/thermal/thermal_zone0/temp);   
    echo "scale=2; $temp/1000" | bc
)
#gputeemp=$(
#    temp=$(cat /sys/class/thermal/thermal_zone0/temp);   
#    echo "scale=2; $temp/1000" | bc
#)

ssdcapacity=$(df -k / | tail -n 1 | awk '{printf("%d%%\n", int($3/$2 * 100))}')
# Emojis and characters for the status bar
# 💎 💻 💡 🔌 ⚡ 📁 \|
echo $date_formatted "|" $net" ($bitrate)" $channel "|" $linux_version "|" CPU: $cpuclock "MHz " $cputemp "°C |" 🖴 $ssdcapacity "|" $battery_status $battery_capacity "|" $mute$vol
