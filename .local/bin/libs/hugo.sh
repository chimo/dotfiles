#!/bin/sh

get_state() (
    lxc list name=hugo -c s --format csv
)


get_ip_address() (
    lxc list name=hugo -c 4 --format csv | awk '{print $1}'
)


wait_until_container_is_running() (
    state=$(get_state)

    if [ "${state}" != "RUNNING" ]; then
        printf "Instance not running. Starting now..."

        lxc start hugo

        while [ "$(get_state)" != "RUNNING" ];
        do
            printf "..."
        done

        echo ""
    fi
)


wait_until_container_has_ip_address() (
    ip_address=$(get_ip_address)

    if [ -z "${ip_addresss}" ]; then
        printf "Instance doesn't have an IP address. Waiting..."

        while [ -z "${ip_address}" ];
        do
            sleep 1
            printf "..."
            ip_address="$(get_ip_address)"
        done

        echo ""
    fi
)


main() (
    wait_until_container_is_running

    wait_until_container_has_ip_address

    ip_address=$(get_ip_address)
    lxc exec hugo -- hugo "${@}" -s /root/chromic.org/ --bind 0.0.0.0 -b http://"${ip_address}"/
)


main "${@}"

