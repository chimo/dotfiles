# Based on: https://wiki.alpinelinux.org/wiki/Wayland
if test -z "${XDG_RUNTIME_DIR}"; then
  xdg_path=/tmp/"$(id -u)"-runtime-dir
  export XDG_RUNTIME_DIR="${xdg_path}"

  if ! test -d "${XDG_RUNTIME_DIR}"; then
    install -d -m0700 "${XDG_RUNTIME_DIR}"
    #mkdir "${XDG_RUNTIME_DIR}"
    #chmod 0700 "${XDG_RUNTIME_DIR}"
  fi
fi

alias sway="dbus-run-session sway"

# Start pipewire if it isn't running
if ! pgrep -u "${USER}" -xf /usr/bin/pipewire > /dev/null 2>&1; then
    /usr/libexec/pipewire-launcher > /dev/null 2>&1
fi

# Exit after paste so clipboard content doesn't stick around the process list
alias wl-copy="wl-copy -o" 

export PATH="${PATH}":~/.local/bin
export EDITOR=vim

GPG_TTY="$(tty)"
export GPG_TTY="${GPG_TTY}"

