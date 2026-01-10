#!/bin/bash

# Save the output of the following command in "workspace" var
actual_workspace=$(hyprctl activewindow | grep "workspace: " | cut -d' ' -f2)

# Get active workspaces
#Example of output of 'hyprctl workspaces':
#workspace ID 1 (1) on monitor HDMI-A-1:
# 	windows: 3
# 	hasfullscreen: 0
# 	lastwindow: 0x42f9830
# 	lastwindowtitle: hyprctl workspaces ~
#
# workspace ID 2 (2) on monitor HDMI-A-1:
# 	windows: 2
# 	hasfullscreen: 0
# 	lastwindow: 0x87f1ed0
# 	lastwindowtitle: Mozilla Firefox
#
# workspace ID 4 (4) on monitor HDMI-A-1:
# 	windows: 1
# 	hasfullscreen: 0
# 	lastwindow: 0x4a51e30
# 	lastwindowtitle: Mozilla Firefox

# With that output, we'll get the lowest ID and the highest ID.
active_workspaces=$(hyprctl workspaces | grep "workspace ID" | cut -d' ' -f3)

# Output:
# 1 2 4

# Get the highest and lowest ID
lowest_id="${active_workspaces:0:1}"
highest_id="${active_workspaces: -1}"

# Direction from argument
direction=$1

# if direction is "down" and the workspace is not lowest_id, return "e+1"
if [ "$direction" = "down" ] && [ "$actual_workspace" != "$lowest_id" ]; then
  hyprctl dispatch workspace e-1
fi

# if direction is "up" and the workspace is not 9, return "e-1"
if [ "$direction" = "up" ] && [ "$actual_workspace" != "$highest_id" ]; then
  hyprctl dispatch workspace e+1
fi
