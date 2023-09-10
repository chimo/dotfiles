#!/bin/sh

decimal=$(echo "scale=2; ${1}/100" | bc)
wpctl set-volume @DEFAULT_AUDIO_SINK@ "${decimal}"

