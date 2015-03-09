#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source "$CURRENT_DIR/shared.sh"
source "$CURRENT_DIR/variables.sh"

print_telegram_daemon_unread() {
    local port=$(get_tmux_option "$telegram_daemon_port" "$telegram_daemon_default_port")
    local timeout=$(get_tmux_option "$telegram_daemon_timeout" "$telegram_daemon_default_timeout")
    local tgList=`echo "dialog_list" | nc -i $timeout localhost $port`
	if [ -z "$tgList" ]; then
        echo "No Telegram at $port"
    else
        echo $tgList | grep -c '[1-9][0-9]* unread'
	fi
}

main() {
	print_telegram_daemon_unread
}
main