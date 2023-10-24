#!/bin/sh -e

lxc exec newsboat -- sh -c 'newsboat -r -c ~/.config/newsboat/cache.db -C ~/.config/newsboat/config'

~/.config/sway/swaybar/run_block.sh -b rss.sh -p json

