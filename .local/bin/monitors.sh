#!/bin/sh -e

print_usage() (
    echo "Usage ${0} [basement|den]"
)

main() (
    location="${1}"

    if [ -z "${location}" ]; then
        swaymsg -t get_outputs
    else
        case "${location}" in
            "basement")
                swaymsg 'output DP-2 pos 0 0 res 1920x1080' # monitor
                swaymsg 'output eDP-1 pos 1920 0 res 1920x1080' # xps
                ;;
            "den")
                echo "TODO"
                exit 1
                ;;
            *)
                echo "Unknown location: ${location}"
                exit 1
        esac
    fi
)


main "${@}"

