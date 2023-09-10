#!/bin/sh

lxc exec signal -- sh -c 'export NODE_ENV=production; exec electron --no-sandbox /usr/lib/signal-desktop/app.asar --ozone-platform=wayland --enable-features=UseOzonePlatform'

