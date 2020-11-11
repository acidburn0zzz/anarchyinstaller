#!/usr/bin/env bash
# Library functions that Anarchy's scripts use

# Global variables (shared between scripts and functions)
LOG_FILE="/root/anarchy.log"
export LOG_FILE

# Logging library, that appends its arguments (log messages) to the LOG_FILE
log() {
  if [ -n "$1" ]; then
    # Manual logging
    message="$1"
    echo "[$(date '+%H:%M:%S')]: ${message}" | tee -a "${LOG_FILE}"
  else
    # Command output
    echo "*** COMMAND OUTPUT ***" | tee -a "${LOG_FILE}"
    while read -r message; do
      echo "${message}" | tee -a "${LOG_FILE}"
    done
    echo "*** END OF COMMAND OUTPUT ***" | tee -a "${LOG_FILE}"
  fi
}

# Enable systemd services
enable_service() {
  systemctl enable "$1"
  log "Enabled systemd service: $1"
}

# Check if user has an internet connection, if not connect to wifi
check_connection() {
  if ! nc -zw1 1.1.1.1 443; then
    # No connection, use wifi
    wifi-menu -o
  fi
}

dialog() {
  # If terminal height is more than 25 lines add extra info at the top
  if "${screen_h}"; then
    if "${LAPTOP}"; then
      # Show battery charge next to Anarchy heading
      local backtitle
      backtitle="${backtitle} $(acpi)"
    fi

    # op_title is the current menu title
    /usr/bin/dialog --colors --backtitle "${backtitle}" --title "${op_title}" "$@"
  else
    # title is the main title (Anarchy)
    /usr/bin/dialog --colors --title "${title}" "$@"
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
  dialog --ok-button "${ok}" --msgbox "${_body}" 10 60
}

# Displays a yesno dialog
yesno() {
  _body="$1"
  _yes_button="$2"
  _no_button="$3"
  if [ $# = 4 ]; then
    dialog --defaultno --yes-label "${_yes_button}" --no-label \
      "${_no_button}" --yesno "${_body}" 0 0
  else
    dialog --yes-label "${_yes_button}" --no-label "${_no_button}" \
      --yesno "${_body}" 0 0
  fi
  return $?
}

# Automatically upload log to termbin and print info to user on fatal error
report_error() {
  log "Installation failed, uploading log to termbin.com"
  log_url="$(nc termbin.com 9999 </root/anarchy.log)"
  msg "\n${failed_msg} ${log_url}"
}

# Function for handling installer exits when users press CTRL+C
force_quit() {
  log "User force quit the installation"
  msg "\n${force_quit_msg}"
  reset
  exit 1
}
