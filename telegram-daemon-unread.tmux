#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source "$CURRENT_DIR/scripts/shared.sh"
source "$CURRENT_DIR/scripts/variables.sh"
source "$CURRENT_DIR/scripts/parsers.sh"

telegram_dialogs_unread_string="\#{telegram_dialogs_unread}"
telegram_messages_unread_string="\#{telegram_messages_unread}"

telegram_dialog_list="$($CURRENT_DIR/scripts/telegram_daemon_unread.sh)"

prepare_status_variables() {
    local noDaemonMessageString=$(get_tmux_option "$telegram_no_daemon_message" "$telegram_default_no_daemon_message")
    echo "$telegram_dialog_list" > ~/temp/temp.file
	if [ -z "$telegram_dialog_list" ]; then
        telegram_dialogs_unread=$noDaemonMessageString
        telegram_messages_unread=$noDaemonMessageString
    else
        telegram_dialogs_unread=$(get_unread_dialogs_count "$telegram_dialog_list")
        telegram_messages_unread=$(get_unread_messages_count "$telegram_dialog_list")
    fi
}

do_interpolation() {
	local string=$1
	local dialogs_interpolated=${string/$telegram_dialogs_unread_string/$telegram_dialogs_unread}
	local messages_interpolated=${dialogs_interpolated/$telegram_messages_unread_string/$telegram_messages_unread}
	echo "$messages_interpolated"
}

update_tmux_option() {
	local option=$1
	local option_value=$(get_tmux_option "$option")
	local new_option_value=$(do_interpolation "$option_value")
	set_tmux_option "$option" "$new_option_value"
}

main() {
    prepare_status_variables
	update_tmux_option "status-right"
	update_tmux_option "status-left"
}
main
