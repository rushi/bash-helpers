#!/bin/bash

# shellcheck disable=SC1091
source ./bash_helpers.sh

title "This is a title"
header "This is a header"
plain "This is plain"

echo ""

info "Info message"
warn "Warning message"
error "Error message"
success "Successful, yay!"

echo ""

start_task "Starting sleep 5 task..."
delay
end_task "Finished sleep 5 task"

start_task "Starting failure"
delay
fail_task "Failed another task"

echo ""

if has curl; then
    success "User has curl installed"
else
    error "They don't have curl installed"
fi

if has foo; then
    sucess "User has binary 'foo'"
else
    error "${RED}User does not have binary 'foo'${NO_COLOR}"
fi

echo ""

BIN="hello-app"
INSTALL_DIR="destination-dir"
confirm "Install ${GREEN}${BIN}${NO_COLOR} to ${GREEN}${INSTALL_DIR}${NO_COLOR} (requires sudo)?"

echo -e "\nDemo completed"
