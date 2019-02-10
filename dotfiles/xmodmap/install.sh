xinitrc="${HOME}/.xinitrc"
xinitrc_src="${1}/xinitrc"

xinputrc="${HOME}/.xinputrc"
xinputrc_src="${1}/xinputrc"

modmap="${HOME}/.Xmodmap"
if setxkbmap -query | grep -qi 'model:\s*macbook'; then
    modmap_src="${1}/Xmodmap-macbook"
else
    modmap_src="${1}/Xmodmap"
fi

compose="${HOME}/.XCompose"
compose_src="${1}/XCompose"
composedir="${HOME}/.XCompose.d"
composedir_src="${1}/XCompose.d"


dotsync_depsgood() {
    if ! im-config -l | grep -q '\buim\b'; then
        echo >&2 "[WARNING] uim is not installed"
        return 1
    fi
    if which runghc >/dev/null && which m4 >/dev/null; then
        echo >&2 "Building XCompose afresh…"
        "${1}/build/XCompose.sh"
        echo >&2 "freshened up."
    fi
    return 0
}

dotsync_newest() {
    diff -q "${xinitrc_src}" "${xinitrc}" || return 1
    diff -q "${xinputrc_src}" "${xinputrc}" || return 1
    diff -q "${modmap_src}" "${modmap}" || return 1
    diff -q "${compose_src}" "${compose}" || return 1
    # TODO diff the contents of XCompose.d
}

dotsync_setup() {
    ln -sv "${composedir_src}" "${composedir}"
    ln -sv "${compose_src}" "${compose}"
    ln -sv "${modmap_src}" "${modmap}"
    ln -sv "${xinputrc_src}" "${xinputrc}"
    ln -sv "${xinitrc_src}" "${xinitrc}"
}

dotsync_teardown() {
    if [ -L "${xinitrc}" ]; then rm -v "${xinitrc}"; fi
    if [ -L "${xinputrc}" ]; then rm -v "${xinputrc}"; fi
    if [ -L "${modmap}" ]; then rm -v "${modmap}"; fi
    if [ -L "${compose}" ]; then rm -v "${compose}"; fi
    if [ -L "${composedir}" ]; then rm -v "${composedir}"; fi
}
