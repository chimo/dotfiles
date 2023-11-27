#!/bin/sh

url="${1}"

lxc exec qutebrowser -- qutebrowser "${url}" --qt-flag no-sandbox

