#!/bin/sh -eu

start_container() (
    container_name="${1}"
    state=$(lxc list -c s "${container_name}" --format csv)

    if [ "${state}" = "STOPPED" ]; then
        lxc start "${container_name}"

        # TODO: find a better way to wait for container
        #       while state != AVAILABLE (?)
        sleep 5s
    fi
)


run_app() (
    script_name="${1}"
    shift

    main_dir=$(dirname -- "$( readlink -f -- "$0"; )")
    script="${main_dir}/${script_name}"

    # Call the script
    "${script}" "${@}"
)


main() (
    script_name=$(basename "${0}")      # ex: aerc.sh
    container_name=${script_name%.*}    # ex: aerc

    start_container "${container_name}"
    run_app "${script_name}" "${@}"
)


main "${@}"

