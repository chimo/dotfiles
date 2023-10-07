#!/bin/sh

# https://unix.stackexchange.com/a/598047
is_integer ()
(
    case "${1#[+-]}" in
        (*[!0123456789]*) return 1 ;;
        ('')              return 1 ;;
        (*)               return 0 ;;
    esac
)


print_volume() (
    if ! output=$(wpctl get-volume @DEFAULT_AUDIO_SINK@); then
        return 1
    fi

    # Volume
    vol=$(echo "${output}" | cut -d " " -f2)
    vol_percent=$(echo "${vol} * 100" | bc | cut -d "." -f1)

    # Mute state
    muted=$(echo "${output}" | cut -d " " -f3 | tr '[:upper:]' '[:lower:]')

    # Remove square brackets
    muted="${muted%]*}"
    muted="${muted#*[}"

    echo "${vol_percent} (${muted})"
)


set_volume() (
    value="${1}"

    if is_integer "${1}"; then
		value=$(echo "scale=2; ${value}/100" | bc)
    fi

	wpctl set-volume @DEFAULT_AUDIO_SINK@ "${value}"

    rm -f ~/devel/swaybar/states/volume.state
)


main() (
    value="${1}"

    if [ -z "${value}" ]; then
        print_volume
    else
        set_volume "${1}"
    fi
)


main "${@}"

