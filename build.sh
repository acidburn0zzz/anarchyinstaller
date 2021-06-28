#!/usr/bin/env bash

REPO_DIR="$(pwd)"
ARCHISO_DIR=/usr/share/archiso/configs/releng
SRC_DIR="${REPO_DIR}"/src

# Getopt variables
ARCHITECTURE='x86_64'
BUILD='false'
CONTAINER='false'
PURGE='false'
KEEP='false'

# Anarchy required packages
PACKAGES=(
  'dialog'
  'git'
  'networkmanager'
  'wget'
  'zsh-syntax-highlighting'
)

if [ "${iscontainer}" = "yes" ]; then
  REPO_DIR=/anarchy
  SRC_DIR=/anarchy

  # Update packages with reflector
  reflector --verbose --latest 5 --sort rate --save /etc/pacman.d/mirrorlist
fi

PROFILE_DIR="${REPO_DIR}"/profile
WORK_DIR="${REPO_DIR}"/work

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

# Note: prepare_build_dir function will be split into prepare_build_dir_common,
# prepare_build_dir_i686 and prepare_build_dir_x86_64
prepare_build_dir_common() {
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

  # Re-add custom bootloader entries
  cp -f "${REPO_DIR}"/assets/splash.png "${PROFILE_DIR}"/syslinux/splash.png
  sed -i 's/Arch Linux install medium/Anarchy Installer/' "${PROFILE_DIR}"/efiboot/loader/entries/archiso-x86_64-linux.conf
  sed -i 's/Arch Linux install medium/Anarchy Installer/' "${PROFILE_DIR}"/syslinux/archiso_sys-linux.cfg
  sed -i 's/Arch Linux/Anarchy/' "${PROFILE_DIR}"/syslinux/archiso_sys-linux.cfg
  sed -i 's/Arch Linux install medium/Anarchy Installer/' "${PROFILE_DIR}"/syslinux/archiso_pxe-linux.cfg
  sed -i 's/Arch Linux/Anarchy/' "${PROFILE_DIR}"/syslinux/archiso_pxe-linux.cfg
  sed -i 's/Arch Linux/Anarchy Installer/' "${PROFILE_DIR}"/syslinux/archiso_head.cfg
}

prepare_build_dir_i686() {
  # Add Anarchy packages
  mv "${PROFILE_DIR}"/packages.x86_64 "${PROFILE_DIR}"/packages.i686
  sed -i '/^edk2-shell$/d' "${PROFILE_DIR}"/packages.i686

  for package in "${PACKAGES[@]}"; do
    echo "${package}" >>"${PROFILE_DIR}"/packages.i686
  done

  # Some extra changes for i686 architecture
  sed -i -e 's@\bx86_64\b@i686@g'                                                                 \
    -e '/^bootmodes=/ s@\(\s\+'"'"'uefi-x64\.systemd-boot\.\S\+'"'"'\)\+@@'                       \
    "${PROFILE_DIR}"/profiledef.sh
  find "${PROFILE_DIR}"/airootfs "${PROFILE_DIR}"/efiboot "${PROFILE_DIR}"/syslinux -type f -exec \
    sed -i -e 's@\bx86_64\b@i686@g' -e 's@pacman-key --populate archlinux@\032@g' {} +

  # Add mirrorlist32 for i686 build and edit pacman.conf
  wget --no-verbose "https://www.archlinux32.org/mirrorlist/?country=all&protocol=http&protocol=https&ip_version=4&use_mirror_status=on" -O /etc/pacman.d/mirrorlist32 &&
    sed -i -e 's/#//' /etc/pacman.d/mirrorlist32
    sed -i -e 's/\/mirrorlist/\032/' -e 's/ auto/ i686/' "${PROFILE_DIR}"/pacman.conf

  # Add archlinux32 keyring and clean pacman database
  archlinux32_keyring_pkg=$(curl -s 'https://www.archlinux32.org/packages/i686/core/archlinux32-keyring/' | grep 'Download From Mirror' | cut -d'"' -f2)
  wget --no-verbose "${archlinux32_keyring_pkg}" -O /var/cache/pacman/pkg/archlinux32-keyring.pkg.tar.zst
  pacman -U /var/cache/pacman/pkg/archlinux32-keyring.pkg.tar.zst --needed --noconfirm
}

prepare_build_dir_x86_64() {
  # Add Anarchy packages
  for package in "${PACKAGES[@]}"; do
    echo "${package}" >>"${PROFILE_DIR}"/packages.x86_64
  done
}

# Remove build artifacts like work and profile dirs
purge() {
  rm -fr "${PROFILE_DIR}" "${WORK_DIR}"
  return 0
}

# Remove i686 packages and stuff
purge_all_i686() {
  echo "Removing the mirrorlist and 32-bit packages..."
  # Remove mirrorlist32
  rm -f /etc/pacman.d/mirrorlist32 && echo "  /etc/pacman.d/mirrorlist32"
  # Remove i686 packages from pacman cache
  find /var/cache/pacman/pkg/ -name '*i686.pkg.tar.zst' -exec rm -f {} \;
  # Some packages are downloaded as "any" architecture but belong to ArchLinux32.
  # I'm still investigating the best way to detect and delete them.
  while IFS= read -r -d '' file; do
    if grep -q 'arch32' <(tar -axf "${file}" .PKGINFO -O 2>/dev/null); then
      echo "  ${file}"
      rm -f "${file}"
    fi
  done < <(find /var/cache/pacman/pkg/ -type f)
  return 0
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
  filename="$(basename "$(find . -name "anarchy-*${ARCHITECTURE}.iso")")"

  if [ ! -f "${filename}" ]; then
    echo "Mising file ${filename}"
    exit
  fi

  sha512sum --tag "${filename}" >"${filename}".sha512sum || exit
}

# Show usage info
usage() {
cat <<END
Usage: $0 [options]
Options:
  -c, --container         Create Anarchy in a container using podman (only for 'x86_64' architecture).
  -a, --arch <ARCH>       Generates the ISO with the specified architecture ('x86_64', 'i686' or 'both').
  -p, --purge             Remove build artefacts.
  -k, --keep              Retain the packages, mirrorlist and other things required to build the 32-bit ISO.
  -h, --help              Display this help message and exit.
END
}

main() {
  check_root
  check_deps
  prepare_build_dir_common
  if [ "${ARCHITECTURE}" == 'i686' ]; then
    prepare_build_dir_i686
  else
    prepare_build_dir_x86_64
  fi
  ssh_config
  geniso
  checksum_gen
}

# Parse getopt
error_file=$(mktemp)
GETOPT=$(getopt -o ca:pkh --long container,arch:,purge,keep,help -- "$@" 2>"${error_file}")
GETOPT_ERR=$(<"${error_file}")
if [ "${GETOPT_ERR}" ]; then
  sed -i "s/getopt: u/U/g" "${error_file}"
  cat "${error_file}"
  usage
  exit 1
fi

eval set -- "${GETOPT}"

while true; do
  case "$1" in
    -c | --container)
      CONTAINER='true'
      shift
      ;;
    -a | --arch)
      [ "$2" == 'x86_64' ] ||
      [ "$2" == 'i686' ] ||
      [ "$2" == 'both' ] &&
      ARCHITECTURE="$2"
      BUILD='true'
      shift 2
      ;;
    -p | --purge)
      PURGE='true'
      shift
      ;;
    -k | --keep)
        KEEP='true'
        shift
      ;;
    -h | --help)
        usage
        exit 0
      ;;
    --)
      shift
      break
      ;;
    *)
      usage
      exit 0
      ;;
  esac
done

# The options are evaluated outside the 'case' statement and the 'while' loop to allow
# the options to be entered in different order. For example, "--arch=x86_64 --container"
# and "--container --arch=x86_64" should return the same action.
if [ "${CONTAINER}" == 'true' ]; then
  if [ "${ARCHITECTURE}" == 'x86_64' ]; then
    # CONTAINER == 'true' | ARCHITECTURE == 'x86_64'
    check_root
    [ ! -d "${REPO_DIR}"/out ] && mkdir "${REPO_DIR}"/out
    podman build --rm -t anarchy --no-cache -f ./Containerfile &&
      podman run --rm -v "${REPO_DIR}"/out:/anarchy/out -t -i --privileged localhost/anarchy &&
      podman image rm localhost/anarchy
  else
    # CONTAINER == 'true' | ARCHITECTURE != 'x86_64'
    echo "The --container option is only available for 64-bit architecture."
    exit 1
  fi
else
  if [ "${ARCHITECTURE}" == 'both' ] && [ "${BUILD}" == 'true' ]; then
    # CONTAINER == 'false' | ARCHITECTURE == 'both'
    ARCHITECTURE='i686' && BUILD='true' && main && purge &&
    ARCHITECTURE='x86_64' && BUILD='true' && main
    [ "${KEEP}" == 'false' ] && [ "${BUILD}" == 'true' ] && purge_all_i686
    [ "${PURGE}" == 'true' ] && purge
  else
    # CONTAINER == 'false' | ARCHITECTURE != 'both'
    [ "${BUILD}" == 'true' ] && main
    [ "${KEEP}" == 'false' ] && [ "${BUILD}" == 'true' ] && purge_all_i686
    [ "${PURGE}" == 'true' ] && purge
  fi
fi
