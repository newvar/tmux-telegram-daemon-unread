#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source "$CURRENT_DIR/shared.sh"
source "$CURRENT_DIR/variables.sh"

print_telegram_dialogs_list() {
    local port=$(get_tmux_option "$telegram_daemon_port" "$telegram_daemon_default_port")
    local timeout=$(get_tmux_option "$telegram_daemon_timeout" "$telegram_daemon_default_timeout")
    echo "dialog_list" | nc -i $timeout localhost $port
}

main() {
	print_telegram_dialogs_list
}
main
