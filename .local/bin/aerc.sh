#!/bin/sh -e

# Launch mail client
lxc exec aerc -- aerc

# Run this in the background after quitting `aerc`
(
    # Sync IMAP in case there were any changes
    lxc exec mbsync -- sh -c "/etc/periodic/15min/refresh_mail" < /dev/null

    # Force swaybar status update
    rm -f ~/devel/swaybar/states/mail.state
)&

