#!/bin/sh -e

lxc exec newsboat -- sh -c 'newsboat -c ~/.config/newsboat/cache.db -C ~/.config/newsboat/config'

