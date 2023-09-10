#!/bin/sh -e

print_usage() (
    echo "Usage: ${0} PERCENT"
)


get_max_brightness() (
    cat /sys/class/backlight/intel_backlight/max_brightness
)


get_current_brightness_percent() (
    max=$(get_max_brightness)
    cur=$(cat /sys/class/backlight/intel_backlight/brightness)

    cur_percent=$(echo "scale=2; ${cur}/${max}*100" | bc)

    echo "${cur_percent%.*}"
)


sanitize_input() (
    err=0

    case "${target}" in
        ("" | *[!0-9]*)
            echo 'error (not a positive decimal integer number)' >&2
            err=1
            ;;
        *)
            if [ "${target}" -lt 1 ] || [ "${target}" -gt 100 ]; then
                echo 'error (out of range)' >&2
                err=1
            fi
            ;;
    esac

    return "${err}"
)


main() (
    target="${1}"

    if [ -z "${target}" ]; then
        get_current_brightness_percent
    else
        if ! sanitize_input "${target}"; then
            print_usage
            exit 1
        fi

        max=$(get_max_brightness)

        # Convert percentage into actual value
        result_float=$(echo "scale=2; ${target}/100*${max}" | bc)

        # Remove decimal points
        result_int=${result_float%.*}

        doas ash -c "echo \"${result_int}\" > /sys/class/backlight/intel_backlight/brightness"

    fi
)


main "${@}"

