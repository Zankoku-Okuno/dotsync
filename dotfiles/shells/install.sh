# entry points for shell configuration
profile="${HOME}/.profile"
profile_src="${1}/profile.sh"

bashrc="${HOME}/.bashrc"
bashrc_src="${1}/bashrc.bash"
bashlogout="${HOME}/.bash_logout"
bashlogout_src="${1}/bash_logout.bash"

zshrc="${HOME}/.zshrc"
zshrc_src="${1}/zshrc.zsh"

# these are deleted to reduce complexity
bashlogin="${HOME}/.bash_login"
bashprofile="${HOME}/.bash_profile"

# directories for additional cofiguration to be plugged in
profiledir="${HOME}/.profile.d"
# profiledir_src="${1}/profile.d"

shrcdir="${HOME}/.shrc.d"
shrcdir_src="${1}/shrc.d"


dotsync_depsgood() { return 0 ; }

dotsync_newest() {
    diff -q "${profile}" "${profile_src}" || return 1
    [ -d "${profiledir}" ] || return 1

    [ -f "${bashprofile}" -o -L "${bashprofile}" ] && return 1
    [ -f "${bashlogin}" -o -L "${bashlogin}" ] && return 1
    diff -q "${bashrc}" "${bashrc_src}" || return 1
    diff -q "${bashlogout}" "${bashlogout_src}" || return 1

    diff -q "${zshrc}" "${zshrc_src}" || return 1

    [ -d "${shrcdir}" ] || return 1
    for rc in $(ls "${shrcdir_src}"); do
        case "$rc" in
            *.d)
                [ -d "${shrcdir}/${rc}" ] || return 1
                ;;
            *.sh|*.bash|*.zsh)
                diff -q "${shrcdir}/${rc}" "${shrcdir_src}/${rc}" || return 1
                ;;
        esac
    done
    return 0
}

dotsync_setup() {
    ln -srvf "${profile_src}" "${profile}"
    mkdir -pv "${profiledir}"

    [ -f "${bashlogin}" -o -L "${bashlogin}" ] && rm -v "${bashlogin}"
    [ -f "${bashprofile}" -o -L "${bashprofile}" ] && rm -v "${bashprofile}"
    ln -srvf "${bashrc_src}" "${bashrc}"
    ln -srvf "${bashlogout_src}" "${bashlogout}"

    ln -srvf "${zshrc_src}" "${zshrc}"

    mkdir -pv "${shrcdir}"
    for rc in $(ls "${shrcdir_src}"); do
        case "$rc" in
            *.d|*.sh|*.bash|*.zsh)
                ln -srvf "${shrcdir_src}/${rc}" "${shrcdir}/${rc}"
                ;;
        esac
    done
}

dotsync_teardown() {
    [ -L "${profile}" ] && rm -v "${profile}"
    [ -d "${profiledir}" ] && rm -r "${profiledir}"
    [ -L "${bashrc}" ] && rm -v "${bashrc}"
    [ -L "${bashlogout}" ] && rm -v "${bashlogout}"
    [ -L "${zshrc}" ] && rm -v "${zshrc}"
    [ -d "${shrcdir}" ] && rm -r "${shrcdir}"
    # TODO
    # [ -d "${zshrcdir}" ] && rm -r "${zshrcdir}"
    return 0
}
