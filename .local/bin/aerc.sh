#!/bin/sh -e

# Launch mail client
lxc exec aerc -- aerc

# Run this in the background after quitting `aerc`
(
    # Force swaybar status update
    ~/.config/sway/swaybar/run_block.sh -b mail.sh -p json

    # Sync IMAP in case there were any changes
    lxc exec mbsync -- sh -c "/etc/periodic/15min/refresh_mail" < /dev/null
)&

