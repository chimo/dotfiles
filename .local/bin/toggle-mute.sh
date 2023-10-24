#!/bin/sh -e

wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle

~/.config/sway/swaybar/run_block.sh -b volume.sh -p json

