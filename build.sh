#!/bin/sh
# shellcheck disable=SC2034

# Compiles Anarchy with archiso

# Archiso variables
iso_name="anarchy"
iso_version="1.3.0"
iso_label="ANARCHY_130"
iso_publisher="Anarchy Installer <https://anarchyinstaller.org>"
install_dir="arch"
bootmodes="('bios.syslinux.mbr' 'bios.syslinux.eltorito' 'uefi-x64.systemd-boot.esp' 'uefi-x64.systemd-boot.eltorito')"
arch="x86_64"
pacman_conf="pacman.conf"

# Anarchy specific variables
BUILD_DIR="$(pwd)/anarchy_build"
ARCHISO_DIR="/usr/share/archiso/configs/releng"

# Check root permission
check_root() {
    if [ "$(id -u)" -ne 0 ]; then
        echo "Please run as root"
        exit
    fi
}

# Check if archiso is installed
check_archiso() {
    if ! sudo pacman -Qqs '^archiso' >/dev/null; then
        printf "archiso was not found.\n"
        printf "Do you want to install it? [Y/n] "
        read -r answer
        if [ "${answer}" != "${answer#[Yy]}" ] ;then
            sudo pacman -Syy archiso
        else
            echo "archiso is necessary. Please install it before continuing."
            exit 1
        fi
        exit
    fi
}

create_build_dir() {
    # Create temporary directory if not exists
    [ -d "${BUILD_DIR}" ] || mkdir "${BUILD_DIR}"

    # Copy archiso files to tmp dir
    sudo cp -r "${ARCHISO_DIR}"/* "${BUILD_DIR}"

    # Create needed folders
    mkdir -p "${BUILD_DIR}/airootfs/usr/share/anarchy/boot"
    mkdir -p "${BUILD_DIR}/airootfs/usr/share/anarchy/etc"
    mkdir -p "${BUILD_DIR}/airootfs/root"
    mkdir -p "${BUILD_DIR}/airootfs/etc/zsh"
    mkdir -p "${BUILD_DIR}/airootfs/usr/share/anarchy/extra"
    mkdir -p "${BUILD_DIR}/airootfs/usr/share/anarchy/lang"
    mkdir -p "${BUILD_DIR}/airootfs/usr/bin"
    mkdir -p "${BUILD_DIR}/airootfs/usr/lib"
    mkdir -p "${BUILD_DIR}/airootfs/etc"

    # Copy anarchy files to tmp dir
    sudo cp -Tr "$(pwd)/src/anarchy/boot" "${BUILD_DIR}/airootfs/usr/share/anarchy/boot"
    sudo cp -Tr "$(pwd)/src/anarchy/etc" "${BUILD_DIR}/airootfs/usr/share/anarchy/etc"
    sudo cp "$(pwd)/src/anarchy/extra/.dialogrc" "${BUILD_DIR}/airootfs/root/.dialogrc"
    sudo cp "$(pwd)/src/anarchy/extra/.zlogin" "${BUILD_DIR}/airootfs/root/.zlogin"
    sudo cp "$(pwd)/src/anarchy/extra/.zshrc" "${BUILD_DIR}/airootfs/etc/zsh/.zshrc"
    sudo cp -Tr "$(pwd)/src/anarchy/extra" "${BUILD_DIR}/airootfs/usr/share/anarchy/extra"
    sudo cp -Tr "$(pwd)/src/anarchy/lang" "${BUILD_DIR}/airootfs/usr/share/anarchy/lang"
    sudo cp -Tr "$(pwd)/src/bin" "${BUILD_DIR}/airootfs/usr/bin"
    sudo cp -Tr "$(pwd)/src/lib" "${BUILD_DIR}/airootfs/usr/lib"
    sudo cp "$(pwd)/src/etc/zsh/.zshrc" "${BUILD_DIR}/airootfs/usr/share/anarchy/extra/.zshrc"
    sudo cp -Tr "$(pwd)/src/etc" "${BUILD_DIR}/airootfs/etc"
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
    iso_name="${iso_name}"
    iso_version="${iso_version}"
    iso_label="${iso_label}"
    iso_publisher="${iso_publisher}"
    install_dir="${install_dir}"
    bootmodes=${bootmodes}
    arch="${arch}"
    pacman_conf="${pacman_conf}"
EOF
}

main() {
    check_root
    check_archiso
    create_build_dir
    ssh_config
    profiledef_gen
    sudo mkarchiso -v "${BUILD_DIR}" command_iso
}

main
