#!/bin/sh

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

    if ! pacman -Qi archiso > /dev/null 2>&1; then
        echo "'archiso' is not installed, but is required by $0, do you want to install it?"
        echo "Install [Y/n]: "
        read -r ans

        case "${ans}" in
            n|N|no|NO|No|nO) echo "Not installing 'archiso', exiting" ; exit ;;
            *) pacman -Sy --noconfirm archiso ;;
        esac
    fi

    if ! pacman -Qi mkinitcpio-archiso > /dev/null 2>&1; then
        echo "'mkinitcpio-archiso' is not installed, but is required by $0, do you want to install it?"
        echo "Install [Y/n]: "
        read -r ans

        case "${ans}" in
            n|N|no|NO|No|nO) echo "Not installing 'mkinitcpio-archiso', exiting" ; exit ;;
            *) pacman -Sy --noconfirm mkarchiso-archiso ;;
        esac
    fi
}

prepare_build_dir() {
    echo "Preparing build directory"

    # Create temporary directory if not exists
    [ ! -d "${PROFILE_DIR}" ] && mkdir "${PROFILE_DIR}"

    # Copy archiso files to tmp dir
    cp -r "${ARCHISO_DIR}"/* "${PROFILE_DIR}"/

    # Copy anarchy files to tmp dir
    cp -rf "${SRC_DIR}"/airootfs/root/* "${PROFILE_DIR}"/airootfs/root/
    cp -rf "${SRC_DIR}"/airootfs/usr/* "${PROFILE_DIR}"/airootfs/usr/
    cp -rf "${SRC_DIR}"/airootfs/etc/* "${PROFILE_DIR}"/airootfs/etc/
    #cp -Tr "$(pwd)/src/syslinux" "${PROFILE_DIR}/syslinux"
    #cp -Tr "$(pwd)/src/isolinux" "${PROFILE_DIR}/isolinux"
    #cp -Tr "$(pwd)/src/efiboot" "${PROFILE_DIR}/efiboot"

    # Remove motd file
    #rm "${PROFILE_DIR}"/airootfs/etc/motd

    # Replace profiledef file
    rm "${PROFILE_DIR}"/profiledef.sh
    cp "${REPO_DIR}"/profiledef.sh "${PROFILE_DIR}"/

    # Add anarchy packages
    cat "${REPO_DIR}"/anarchy-packages.x86_64 >> "${PROFILE_DIR}"/packages.x86_64
}

ssh_config() {
    echo "Adding SSH config"

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

geniso() {
    echo "Generating iso"
    cd "${REPO_DIR}" || exit
    mkarchiso -v -c zstd "${PROFILE_DIR}" || exit
}

cleanup() {
    echo "Cleaning up"
    # TODO: Fix, $USER is going to be root in every case
    chown -R "${USER}":"${USER}" "${REPO_DIR}"/out || exit
}

checksum_gen() {
    echo "Generating checksum"

    cd "${REPO_DIR}"/out || exit
    # TODO: handle missing iso file
    filename="$(basename "$(find . -name 'anarchy-*.iso')")"

    if [ ! -f  "${filename}" ]; then
        echo "Mising file ${filename}"
        exit
    fi

    sha512sum --tag "${filename}" > "${filename}".sha512sum || exit
    echo "Created checksum file ${filename}.sha512sum"
}

upload_iso() {
    echo "Uploading iso"

    cd "${REPO_DIR}"/out || exit
    filename="$(basename "$(find . -name 'anarchy-*.iso')")"
    checksum="${filename}.sha512sum"

    if [ ! -f "${filename}" ] || [ ! -f "${checksum}" ]; then
        echo "${filename} or ${checksum} missing, can't upload!"
        exit
    fi

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
            *) echo "Not installing 'rsync', exiting" ; exit ;;
        esac
    fi

    rsync "${REPO_DIR}/out/${filename} ${REPO_DIR}/out/${checksum}" \
            "${username}"@storage.osdn.net:/storage/groups/a/an/anarchy/"${dir}"
}

main() {
    check_root
    check_deps
    prepare_build_dir
    ssh_config
    geniso
    #cleanup
    checksum_gen
}

if [ $# -eq 0 ]; then
	main
else
    case "$1" in
        -u)
            main
            upload_iso
            ;;
        -o)
            upload_iso
            ;;
        -d)
            sudo podman build --rm -t anarchy:latest -f ./Dockerfile
            [ ! -d "${REPO_DIR}"/out ] && mkdir "${REPO_DIR}"/out

            tmpdir="$(cd "$(mktemp -d)" || exit)"
            # TODO: Possibly bindmount $WORK_DIR to tmpfs (e.g. /tmp on host)
            sudo podman run --rm -v "${REPO_DIR}"/out:/anarchy/out -v "${tmpdir}":"${REPO_DIR}"/work -t -i --privileged localhost/anarchy:latest
            ;;
        *) echo "Usage: $0 [-u|-o]" ; exit ;;
    esac
fi
