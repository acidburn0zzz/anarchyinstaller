# Library functions that Anarchy's scripts use
# Copyright (C) 2020 Erazem Kokot <contact at erazem dot eu>

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
