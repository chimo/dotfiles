#!/bin/sh

url="${1}"

lxc exec firefox -- sh -c "firefox-esr ${1}"

