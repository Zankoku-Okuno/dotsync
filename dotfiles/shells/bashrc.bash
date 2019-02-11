# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

if [ -f "${HOME}/.bashrc.d/history.bash" ]; then
    . "${HOME}/.bashrc.d/history.bash"
fi


# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

if [ -f "${HOME}/.bashrc.d/color.bash" ]; then
    . "${HOME}/.bashrc.d/color.bash"
fi


if [ -f "${HOME}/.bashrc.d/prompt.bash" ]; then
    . "${HOME}/.bashrc.d/prompt.bash"
fi

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
shopt -s globstar

if [ -f "${HOME}/.bashrc.d/aliases.bash" ]; then
    . "${HOME}/.bashrc.d/aliases.bash"
fi



# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

if [ -e "${HOME}/.bashrc.d/$(hostname).bash" ]; then
    . "${HOME}/.bashrc.d/$(hostname).bash"
fi