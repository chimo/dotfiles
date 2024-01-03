#!/bin/sh -e

file="${1}"

if [ -z "${1}" ]; then
    lxc exec imv -- imv
else
    container_name="imv"

    # Convert filename to a fullpath if it isn't already
    # ex: "foo.sh" to "/home/samsepi0l/foo.sh"
    filepath=$(readlink -f -- "${file}")

    # Grab the resulting directory
    # ex: "/home/samsepi0l/foo.sh" to "/home/samsepi0l"
    filedir=$(dirname -- "${filepath}")

    # Prefix paths with "/tmp" on the container
    # ex: "/tmp/home/samsepi0l/foo.sh"
    remote_prefix="/tmp"
    remote_dir="${remote_prefix}${filedir}"
    remote_path="${remote_prefix}${filepath}"

    # Create remote directory
    lxc exec "${container_name}" -- mkdir -p "${remote_dir}"

    # Copy file over
    lxc file push -q "${filepath}" "${container_name}${remote_path}"

    # Run
    lxc exec "${container_name}" -- sh -c "imv ${remote_path}"

    # Cleanup
    lxc exec "${container_name}" -- sh -c "rm -fr ${remote_dir}"
fi

