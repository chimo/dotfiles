#!/bin/sh -e

lxc exec newsboat -- sh -c 'newsboat -r -c ~/.config/newsboat/cache.db -C ~/.config/newsboat/config'

rm -f ~/devel/swaybar/states/rss.state

