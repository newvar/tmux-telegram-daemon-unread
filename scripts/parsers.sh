get_telegram_dialog_list() {
    local port=$(get_tmux_option "$telegram_daemon_port" "$telegram_daemon_default_port")
    local timeout=$(get_tmux_option "$telegram_daemon_timeout" "$telegram_daemon_default_timeout")
    echo "dialog_list" | nc -i $timeout localhost $port
}

get_unread_dialogs_count() {
	local list=$1
    echo "${list}" | grep -c '[1-9][0-9]* unread'
}

get_unread_messages_count() {
	local list=$1
    echo "${list}" | sed 's/.* \([0-9]*\) unread/\1/' | awk '{ sum += $1 } END { print sum }'
}
