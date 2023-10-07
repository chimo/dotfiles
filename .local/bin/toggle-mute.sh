#!/bin/sh -e

wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle

rm -f ~/devel/swaybar/states/volume.state

