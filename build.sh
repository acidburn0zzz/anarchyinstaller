#!/usr/bin/env bash

REPO_DIR="$(pwd)"
ARCHISO_DIR=/usr/share/archiso/configs/releng
SRC_DIR="${REPO_DIR}"/src

if [ "${iscontainer}" = "yes" ]; then
  REPO_DIR=/anarchy
  SRC_DIR=/anarchy

  # Update packages with reflector
  reflector --verbose --latest 5 --sort rate --save /etc/pacman.d/mirrorlist
fi

PROFILE_DIR="${REPO_DIR}"/profile

# Check root permission
check_root() {
  [ "$(id -u)" -ne 0 ] && echo "$0 needs to be run with root permissions" && exit
}

# Check if dependencies are installed
check_deps() {
  echo "Checking dependencies"

  if ! pacman -Qi archiso >/dev/null 2>&1 || ! pacman -Qi mkinitcpio-archiso >/dev/null 2>&1; then
    echo "archiso and or mkinitcpio-archiso are not installed, installing"
    pacman -Sy --noconfirm archiso mkinitcpio-archiso
  fi
}

prepare_build_dir() {
  echo "Preparing build directory"

  # Create temporary directory if not exists
  [ ! -d "${PROFILE_DIR}" ] && mkdir "${PROFILE_DIR}"

  # Copy Archiso files to tmp dir
  cp -r "${ARCHISO_DIR}"/* "${PROFILE_DIR}"/

  # Copy Anarchy files to tmp dir
  cp -rf "${SRC_DIR}"/root/. "${PROFILE_DIR}"/airootfs/root/
  cp -rf "${SRC_DIR}"/usr/. "${PROFILE_DIR}"/airootfs/usr/
  cp -rf "${SRC_DIR}"/etc/. "${PROFILE_DIR}"/airootfs/etc/

  # Copy splash.png to bootloader directory
  cp -f "${REPO_DIR}"/assets/splash.png "${PROFILE_DIR}"/airootfs/usr/share/anarchy/boot/splash.png

  # Copy Anarchy logo to extras
  cp -f "${REPO_DIR}"/assets/logo.png "${PROFILE_DIR}"/airootfs/usr/share/anarchy/extra/anarchy-icon.png

  echo "anarchy" >>"${PROFILE_DIR}"/airootfs/root/.zlogin

  # Replace profiledef file
  rm "${PROFILE_DIR}"/profiledef.sh
  cp "${REPO_DIR}"/profiledef.sh "${PROFILE_DIR}"/

  # Remove motd since it's not useful in Anarchy
  rm "${PROFILE_DIR}"/airootfs/etc/motd

  # Set installer's hostname and console font
  echo "anarchy" >"${PROFILE_DIR}"/airootfs/etc/hostname
  echo "FONT=ter-v16n" >"${PROFILE_DIR}"/airootfs/etc/vconsole.conf

  # Add anarchy packages
  cat "${REPO_DIR}"/anarchy-packages.x86_64 >>"${PROFILE_DIR}"/packages.x86_64

  # Re-add custom bootloader entries
  cp -f "${REPO_DIR}"/assets/splash.png "${PROFILE_DIR}"/syslinux/splash.png
  sed -i 's/Arch Linux install medium/Anarchy Installer/' "${PROFILE_DIR}"/efiboot/loader/entries/archiso-x86_64-linux.conf
  sed -i 's/Arch Linux install medium/Anarchy Installer/' "${PROFILE_DIR}"/syslinux/archiso_sys-linux.cfg
  sed -i 's/Arch Linux/Anarchy/' "${PROFILE_DIR}"/syslinux/archiso_sys-linux.cfg
  sed -i 's/Arch Linux install medium/Anarchy Installer/' "${PROFILE_DIR}"/syslinux/archiso_pxe-linux.cfg
  sed -i 's/Arch Linux/Anarchy/' "${PROFILE_DIR}"/syslinux/archiso_pxe-linux.cfg
  sed -i 's/Arch Linux/Anarchy Installer/' "${PROFILE_DIR}"/syslinux/archiso_head.cfg
}

ssh_config() {
  echo "Adding SSH config"

  # Check optional configuration file for SSH connection
  if [ -f autoconnect.sh ]; then
    . autoconnect.sh

    # Copy PUBLIC_KEY to authorized_keys
    if [ ! -d airootfs/etc/skel/.ssh ]; then
      mkdir -p airootfs/etc/skel/.ssh
    fi
    cp "${PUBLIC_KEY}" airootfs/etc/skel/.ssh/authorized_keys
    chmod 700 airootfs/etc/skel/.ssh
    chmod 600 airootfs/etc/skel/.ssh/authorized_keys
  fi
}

geniso() {
  echo "Generating iso"
  cd "${REPO_DIR}" || exit
  mkarchiso -v "${PROFILE_DIR}" || exit
}

checksum_gen() {
  echo "Generating checksum"

  cd "${REPO_DIR}"/out || exit
  filename="$(basename "$(find . -name 'anarchy-*.iso')")"

  if [ ! -f "${filename}" ]; then
    echo "Mising file ${filename}"
    exit
  fi

  sha512sum --tag "${filename}" >"${filename}".sha512sum || exit
  echo "Created checksum file ${filename}.sha512sum"
}

main() {
  check_root
  check_deps
  prepare_build_dir
  ssh_config
  geniso
  checksum_gen
}

if [ $# -eq 0 ]; then
  main
else
  case "$1" in
  -c | --container)
    check_root
    [ ! -d "${REPO_DIR}"/out ] && mkdir "${REPO_DIR}"/out
    podman build --rm -t anarchy -f ./Containerfile &&
      podman run --rm -v "${REPO_DIR}"/out:/anarchy/out --tmpfs /anarchy/work -t -i --privileged localhost/anarchy &&
      podman image rm localhost/anarchy
    exit
    ;;
  *)
    echo "Usage: $0 [-c | --container]"
    exit 1
    ;;
  esac
fi
