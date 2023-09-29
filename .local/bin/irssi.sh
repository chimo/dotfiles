#!/bin/sh -e

profile="${1}"

case "${profile}" in
    "twitch")
        . ~/devel/dotfiles/.config/irssi/env

        # https://github.com/irssi/irssi/issues/6#issuecomment-1019966535
        # POSIX "process substitution"
        # https://unix.stackexchange.com/a/639752
        lxc exec irssi -- sh -c 'irssi -c twitch --config=/dev/fd/3 3<<-EOF
            $(sed '\''s/<PASSWORD>/'"${TWITCH_OAUTH}"'/'\'' .irssi/config)
EOF'

        ;;
    "*")
        lxc exec irssi -- "${@}"
        ;;
esac

