#!/bin/sh

# FIXME I should probably set this umask, likely 027
# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

# set PATH so it includes user's private bin directories
if ! echo "${PATH}" | grep -q "${HOME}/bin"; then
    export PATH="${PATH}:${HOME}/bin"
fi
if ! echo "${PATH}" | grep -q "${HOME}/.local/bin"; then
    export PATH="${PATH}:${HOME}/.local/bin"
fi
# FIXME this looks like haskell dotfiles
if ! echo "${PATH}" | grep -q "/opt/ghc/bin"; then
    export PATH="${PATH}:/opt/ghc/bin"
fi
if ! echo "${PATH}" | grep -q "/opt/cabal/bin"; then
    export PATH="${PATH}:/opt/cabal/bin"
fi
if ! echo "${PATH}" | grep -q "${HOME}/.cabal/bin"; then
    export PATH="${PATH}:${HOME}/.cabal/bin"
fi


if [ -d "${HOME}/.profile.d" ]; then
    for profile in "${HOME}"/.profile.d/*; do
        case "${profile}" in
            *.sh)
                . "${profile}"
                ;;
            *) ;;
        esac
    done
fi
