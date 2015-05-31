#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source "$CURRENT_DIR/shared.sh"
source "$CURRENT_DIR/variables.sh"
source "$CURRENT_DIR/parsers.sh"

telegram_dialogs_unread_string="@telegram_dialogs_unread"
telegram_messages_unread_string="@telegram_messages_unread"

print_telegram_unread() {
    local port=$(get_tmux_option "$telegram_daemon_port" "$telegram_daemon_default_port")
    local telegram_dialog_list="$(get_telegram_dialog_list)"

	if [ -z "$telegram_dialog_list" ]; then
        local noDaemonMessageString=$(get_tmux_option "$telegram_no_daemon_message" "$telegram_default_no_daemon_message")
        local noDaemonMessage="${noDaemonMessageString//@port/$port}"
        echo $noDaemonMessage
    else
        local unreadMessageString=$(get_tmux_option "$telegram_unread_message" "$telegram_default_unread_message")
        local telegram_dialogs_unread=$(get_unread_dialogs_count "$telegram_dialog_list")
        local telegram_messages_unread=$(get_unread_messages_count "$telegram_dialog_list")
        local dialogs_interpolated=${unreadMessageString/$telegram_dialogs_unread_string/$telegram_dialogs_unread}
        local messages_interpolated=${dialogs_interpolated/$telegram_messages_unread_string/$telegram_messages_unread}
        echo "$messages_interpolated"
    fi
}

main() {
	print_telegram_unread
}
main
