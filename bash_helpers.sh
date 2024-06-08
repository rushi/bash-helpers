#!/bin/bash

# Exit the script if any command in the script exits with a non-zero status
# It helps to catch errors and script continuing in an inconsistent state
set -o errexit

# Treat's unset varaibles as an error and causes the script to exit
set -u

# Return a non-zero status if any command in the pipeline fails (a | b | c)
# By default, only the exit status of the last command in the pipeline is considered.
# `pipefail` helps to ensure that the script fails if any command in the pipeline fails,
# rather than just the last one.
set -o pipefail

# All of these can be combined as
set -euo pipefail

readonly BOLD="$(tput bold 2>/dev/null || echo '')"
readonly GREY="$(tput setaf 8 2>/dev/null || echo '')"
readonly UNDERLINE="$(tput smul 2>/dev/null || echo '')"
readonly RED="$(tput setaf 1 2>/dev/null || echo '')"
readonly GREEN="$(tput setaf 2 2>/dev/null || echo '')"
readonly YELLOW="$(tput setaf 3 2>/dev/null || echo '')"
readonly BLUE="$(tput setaf 4 2>/dev/null || echo '')"
readonly MAGENTA="$(tput setaf 5 2>/dev/null || echo '')"
readonly CYAN="$(tput setaf 6 2>/dev/null || echo '')"
readonly NO_COLOR="$(tput sgr0 2>/dev/null || echo '')"
readonly CLEAR_LAST_MSG="\033[1F\033[0K"

title() {
    local -r text="$*"
    printf "%s\n" "${BOLD}${MAGENTA}${text}${NO_COLOR}"
}

header() {
    local -r text="$*"
    printf "%s\n" "${BOLD}${text}${NO_COLOR}"
}

plain() {
    local -r text="$*"
    printf "%s\n" "${text}"
}

info() {
    local -r text="$*"
    printf "%s\n" "${BOLD}${GREY}→${NO_COLOR} ${text}"
}

warn() {
    local -r text="$*"
    printf "%s\n" "${YELLOW}! $*${NO_COLOR}"
}

error() {
    local -r text="$*"
    printf "%s\n" "${RED}✘ ${text}${NO_COLOR}" >&2
}

success() {
    local -r text="$*"
    printf "%s\n" "${GREEN}✓${NO_COLOR} ${text}"
}

start_task() {
    local -r text="$*"
    printf "%s\n" "${BOLD}${GREY}→${NO_COLOR} ${text}..."
}

end_task() {
    local -r text="$*"
    printf "${CLEAR_LAST_MSG}%s\n" "${GREEN}✓${NO_COLOR} ${text}... [DONE]"
}

fail_task() {
    local -r text="$*"
    printf "${CLEAR_LAST_MSG}%s\n" "${RED}✘ ${text}... [FAILED]${NO_COLOR}" >&2
}

FORCE="${FORCE:-0}"
confirm() {
    if [ ${FORCE-} -ne 1 ]; then
        printf "%s " "${MAGENTA}?${NO_COLOR} $* ${BOLD}[Y/n]${NO_COLOR}"
        set +e
        read -r yn </dev/tty
        rc=$?
        set -e
        if [ $rc -ne 0 ]; then
            error "Error reading from prompt (re-run with '-f' flag to auto select Yes if running in a script)"
            exit 1
        fi
        if [ "$yn" != "y" ] && [ "$yn" != "Y" ] && [ "$yn" != "yes" ] && [ "$yn" != "" ]; then
            error 'Aborting (please answer "yes" to continue)'
            exit 1
        fi
    fi
}

has() {
    command -v "$1" 1>/dev/null 2>&1
}

delay() {
    sleep 2
}
