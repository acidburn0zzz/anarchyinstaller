#!/usr/bin/env bash

REPO_DIR="$(pwd)"
ARCHISO_DIR=/usr/share/archiso/configs/releng
SRC_DIR="${REPO_DIR}"/src

# Getopt variables
GETOPT=$(getopt -o ca: --long container,arch: -- "$@")
ARCHITECTURE='x86_64'

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
  if ! pacman -Qi archiso >/dev/null 2>&1 || ! pacman -Qi mkinitcpio-archiso >/dev/null 2>&1; then
    pacman -Sy --noconfirm archiso mkinitcpio-archiso
  fi
}

prepare_build_dir() {
  # Show message with architecture
  echo "Building for architecture: ${ARCHITECTURE}"

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
  echo "FONT=ter-v16n" >>"${PROFILE_DIR}"/airootfs/etc/vconsole.conf

  # Add anarchy packages
  packages=(
    'dialog'
    'git'
    'networkmanager'
    'wget'
    'zsh-syntax-highlighting'
  )

  if [ "${ARCHITECTURE}" == 'i686' ]; then
    mv "${PROFILE_DIR}"/packages.x86_64 "${PROFILE_DIR}"/packages.i686
    sed -i '/^edk2-shell$/d' "${PROFILE_DIR}"/packages.i686
  fi

  for package in "${packages[@]}"; do
    if [ "${ARCHITECTURE}" == 'x86_64' ]; then
        echo "${package}" >>"${PROFILE_DIR}"/packages.x86_64
    else
        echo "${package}" >>"${PROFILE_DIR}"/packages.i686
    fi
  done

  # Re-add custom bootloader entries
  cp -f "${REPO_DIR}"/assets/splash.png "${PROFILE_DIR}"/syslinux/splash.png
  sed -i 's/Arch Linux install medium/Anarchy Installer/' "${PROFILE_DIR}"/efiboot/loader/entries/archiso-x86_64-linux.conf
  sed -i 's/Arch Linux install medium/Anarchy Installer/' "${PROFILE_DIR}"/syslinux/archiso_sys-linux.cfg
  sed -i 's/Arch Linux/Anarchy/' "${PROFILE_DIR}"/syslinux/archiso_sys-linux.cfg
  sed -i 's/Arch Linux install medium/Anarchy Installer/' "${PROFILE_DIR}"/syslinux/archiso_pxe-linux.cfg
  sed -i 's/Arch Linux/Anarchy/' "${PROFILE_DIR}"/syslinux/archiso_pxe-linux.cfg
  sed -i 's/Arch Linux/Anarchy Installer/' "${PROFILE_DIR}"/syslinux/archiso_head.cfg

  # If arquitecture is i686, add extra changes
  if [ "${ARCHITECTURE}" == 'i686' ]; then
    sed -i -e 's@\bx86_64\b@i686@g'                                                                 \
           -e '/^bootmodes=/ s@\(\s\+'"'"'uefi-x64\.systemd-boot\.\S\+'"'"'\)\+@@'                  \
           "${PROFILE_DIR}"/profiledef.sh
    find "${PROFILE_DIR}"/airootfs "${PROFILE_DIR}"/efiboot "${PROFILE_DIR}"/syslinux -type f -exec \
      sed -i -e 's@\bx86_64\b@i686@g' -e 's@pacman-key --populate archlinux@\032@g' {} +

    # Add mirrorlist32 for i686 build and edit pacman.conf
    wget --no-verbose "https://www.archlinux32.org/mirrorlist/?country=all&protocol=http&protocol=https&ip_version=4&use_mirror_status=on" -O /etc/pacman.d/mirrorlist32 &&
        sed -i -e 's/#//' /etc/pacman.d/mirrorlist32
        sed -i -e 's/\/mirrorlist/\032/' -e 's/ auto/ i686/' "${PROFILE_DIR}"/pacman.conf

    # Add archlinux32 keyring and clean pacman database
    wget --no-verbose "http://pool.mirror.archlinux32.org/i686/core/archlinux32-keyring-20210331-1.0-any.pkg.tar.zst" -O /var/cache/pacman/pkg/archlinux32-keyring.pkg.tar.zst
    pacman -U /var/cache/pacman/pkg/archlinux32-keyring.pkg.tar.zst --needed --noconfirm
    pacman -Scc --noconfirm
  fi
}

ssh_config() {
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
  cd "${REPO_DIR}" || exit
  mkarchiso -v "${PROFILE_DIR}" || exit
}

checksum_gen() {
  cd "${REPO_DIR}"/out || exit
  filename="$(basename "$(find . -name 'anarchy-*.iso')")"

  if [ ! -f "${filename}" ]; then
    echo "Mising file ${filename}"
    exit
  fi

  sha512sum --tag "${filename}" >"${filename}".sha512sum || exit
}

main() {
  check_root
  check_deps
  prepare_build_dir
  ssh_config
  geniso
  checksum_gen
}

eval set -- "${GETOPT}"

case "$1" in
  -c | --container)
    check_root
    [ ! -d "${REPO_DIR}"/out ] && mkdir "${REPO_DIR}"/out
    podman build --rm -t anarchy --no-cache -f ./Containerfile &&
      podman run --rm -v "${REPO_DIR}"/out:/anarchy/out -t -i --privileged localhost/anarchy &&
      podman image rm localhost/anarchy
    exit
    ;;
  -a | --arch)
    [ "$2" == 'x86_64' ] ||
    [ "$2" == 'i686' ] &&
    ARCHITECTURE="$2"
    main
    exit
    ;;
  *)
    echo "Usage: $0 [-c | --container]"
    echo "       $0 [-a <ARCH> | --arch=<ARCH>]"
    echo
    echo "ARCH can take 'x86_64' or 'i686' value."
    echo "Default value: 'x86_64'"
    exit 1
    ;;
esac
