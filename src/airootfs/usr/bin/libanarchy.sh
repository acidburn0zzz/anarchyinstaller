# Library functions that Anarchy's scripts use
# shellcheck shell=sh

# Global variables (shared between scripts and functions)
LOG_FILE="${HOME}/anarchy-$(date '+%Y-%m-%d').log"
export LOG_FILE

# Logging library, that appends its arguments (log messages) to the LOG_FILE
log() {
	if [ -n "$1" ]; then
		message="$1" # Manual log messages that use arguments (e.g. 'log "My message"')
		echo "--- [$(date '+%H:%M:%S')]: ${message} ---" | tee -a "${LOG_FILE}"
	else
		while read -r message; do # Command output
			echo "[$(date '+%H:%M:%S')]: ${message}" | tee -a "${LOG_FILE}"
		done
	fi
}

# Check if user has an internet connection
is_online() {
	if nc -zw1 1.1.1.1 443; then
		# Sucessfully connected
		return 0
	else
		# No internet connection
		return 1
	fi
}

# Puts off or on some dialog field
offon() {
	[[ "$2" == *"$1"* ]] && printf "on" || printf "off"
}

# Displays a message dialog
msg() {
	_body="$1"
	#shellcheck disable=SC2154
	dialog --ok-button "${ok}" --msgbox "${body}" 10 60
}

# Displays a yesno dialog
yesno()
{
	_body="$1"
	_yes_button="$2"
	_no_button="$3"
	if [ $# = 4 ]; then
		dialog --defaultno --yes-label "${yes_button}" --no-label \
				"${no_button}" --yesno "${body}" 0 0
	else
		dialog --yes-label "${yes_button}" --no-label "${no_button}" \
			--yesno "${body}" 0 0
	fi
	return $?
}
