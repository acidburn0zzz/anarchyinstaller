#!/bin/sh
# shellcheck disable=SC2034
# Compiles Anarchy with archiso

# Archiso variables
ISO_VERSION="1.3.0-beta"
ISO_LABEL="ANARCHY_13" # This is an incremental number, so bump it when updating the version number
ISO_PUBLISHER="Anarchy Installer <https://anarchyinstaller.org>"
BOOTMODES="('bios.syslinux.mbr' 'bios.syslinux.eltorito' 'uefi-x64.systemd-boot.esp' 'uefi-x64.systemd-boot.eltorito')"
ARCHITECTURE="x86_64"
PACMAN_CONFIG="pacman.conf"
BUILD_DIR="$(pwd)/temp"
ARCHISO_DIR="/usr/share/archiso/configs/releng"

# Check root permission
check_root() {
    if [ "$(id -u)" -ne 0 ]; then
        echo "$0 needs to be run with root permissions"
        exit
    fi
}

# Check if dependencies are installed
check_deps() {
    if ! pacman -Qi archiso > /dev/null 2>&1; then
        echo "'archiso' is not installed, but is required by $0, do you want to install it?"
        echo "Install [Y/n]: "
        read -r ans

        case "${ans}" in
            n|N|no|NO|No|nO) echo "Not installing 'archiso', exiting" ; exit 1 ;;
            *) sudo pacman -Sy archiso ;;
        esac
    fi

    if ! pacman -Qi mkinitcpio-archiso > /dev/null 2>&1; then
        echo "'mkinitcpio-archiso' is not installed, but is required by $0, do you want to install it?"
        echo "Install [Y/n]: "
        read -r ans

        case "${ans}" in
            n|N|no|NO|No|nO) echo "Not installing 'mkinitcpio-archiso', exiting" ; exit 1 ;;
            *) sudo pacman -Sy mkarchiso-archiso ;;
        esac
    fi
}

create_build_dir() {
    # Create temporary directory if not exists
    [ ! -d "${BUILD_DIR}" ] && mkdir "${BUILD_DIR}"

    # Copy archiso files to tmp dir
    sudo cp -r "${ARCHISO_DIR}"/* "${BUILD_DIR}"

    # Copy anarchy files to tmp dir
    sudo cp -Tr "$(pwd)/src/airootfs/root" "${BUILD_DIR}/airootfs/root"
    sudo cp -Tr "$(pwd)/src/airootfs/usr" "${BUILD_DIR}/airootfs/usr"
    sudo cp -Tr "$(pwd)/src/airootfs/etc" "${BUILD_DIR}/airootfs/etc"
    sudo cp -Tr "$(pwd)/src/syslinux" "${BUILD_DIR}/syslinux"
    sudo cp -Tr "$(pwd)/src/isolinux" "${BUILD_DIR}/isolinux"
    sudo cp -Tr "$(pwd)/src/efiboot" "${BUILD_DIR}/efiboot"

    # Remove motd file
    sudo rm "${BUILD_DIR}/airootfs/etc/motd"

    # Add anarchy packages
    cat "$(pwd)/anarchy-packages.x86_64" >> "${BUILD_DIR}/packages.x86_64"
    sort --unique --output="${BUILD_DIR}/packages.x86_64" "${BUILD_DIR}/packages.x86_64"
}

ssh_config() {
    # Check optional configuration file for SSH connection
    if [ -f autoconnect.sh ]; then
        # shellcheck disable=SC1091
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

# Generate profiledef.sh file
profiledef_gen() {
    [ ! -f "${BUILD_DIR}"/profiledef.sh ] || rm "${BUILD_DIR}/profiledef.sh"
    touch "${BUILD_DIR}/profiledef.sh"
    cat << EOF > "${BUILD_DIR}/profiledef.sh"
    iso_name="anarchy"
    iso_version="${ISO_VERSION}"
    iso_label="${ISO_LABEL}"
    iso_publisher="Anarchy Installer <https://anarchyinstaller.org>"
    install_dir="arch"
    bootmodes=${BOOTMODES}
    arch="${ARCHITECTURE}"
    pacman_conf="${PACMAN_CONFIG}"
EOF
}

checksum_gen() {
    cd out/ || exit
    filename="anarchy-${ISO_VERSION}-${ARCHITECTURE}.iso"

    if [ ! -f  "${filename}" ]; then
        echo "Mising file ${filename}"
        exit 1
    fi

    sha512sum --tag "${filename}" > "${filename}".sha512sum
    echo "Created checksum file ${filename}.sha512sum"
}

upload_iso() {
    filename="anarchy-${ISO_VERSION}-${ARCHITECTURE}.iso"
    checksum="${filename}.sha512sum"

    echo "Enter your osdn.net username: "
    read -r username

    echo "Is this a testing or release iso?"
    echo "[T/r]: "
    read -r reltype

    case "${reltype}" in
        r|R|rel|Rel|release|Release|RELEASE) dir='' ;;
        *) dir='testing/' ;;
    esac

    if ! pacman -Qi rsync > /dev/null 2>&1; then
        echo "'rsync' is not installed, do you want to install it?"
        echo "Install [Y/n]: "
        read -r ans

        case "${ans}" in
            n|N|no|NO|No|nO) sudo pacman -Sy rsync ;;
            *) echo "Not installing 'rsync', exiting" ; exit 1 ;;
        esac
    fi

    rsync out/${filename}" out/${checksum}" \
            "${username}"@storage.osdn.net:/storage/groups/a/an/anarchy/"${dir}"
}

main() {
    check_root
    check_deps
    create_build_dir
    ssh_config
    profiledef_gen
    sudo mkarchiso -v "${BUILD_DIR}" command_iso
    checksum_gen
}

if [ $# -eq 0 ]; then
	main
else
    case "$1" in
        -u|--upload-iso)
            main
            upload_iso
            ;;
        -o|--only-upload) upload_iso ;;
        *) exit 1 ;;
    esac
fi
