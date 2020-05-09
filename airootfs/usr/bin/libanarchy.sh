# Library functions that Anarchy's scripts use

# Global variables (shared between scripts and functions)
export LOG_FILE="${HOME}/anarchy-$(date '+%Y-%m-%d').log"

# Logging library, that appends its arguments (log messages) to the LOG_FILE
log() {
	local message="$1"
	echo "[$(date '+%H:%M:%S')]: ${message}" >> "${LOG_FILE}"
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
	local body="$1"
	#shellcheck disable=SC2154
	dialog --ok-button "${ok}" --msgbox "${body}" 10 60
}

# Displays a yesno dialog
yesno()
{
	local body="$1"
	local yes_button="$2"
	local no_button="$3"
	if [[ $# == 4 ]]; then
		dialog --defaultno --yes-label "${yes_button}" --no-label \
				"${no_button}" --yesno "${body}" 0 0
	else
		dialog --yes-label "${yes_button}" --no-label "${no_button}" \
			--yesno "${body}" 0 0
	fi
	return $?
}
