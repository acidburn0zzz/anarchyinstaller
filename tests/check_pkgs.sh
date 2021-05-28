#!/usr/bin/env bash
#
# Written by Max Ferrer (a.k.a. Panda Foss) for Anarchy Installer
#
# This script allows to verify the existence of the packages (needed by the installer) in the official repositories.
# These packages are stored in variables in the anarchy-packages.ini file.

# Relative path to anarchy-packages.ini
PKGLIST='../src/etc/anarchy-packages.ini'
. "${PKGLIST}"

# List packages in Arch Linux repos
sudo pacman -Slq --config /usr/share/archiso/configs/releng/pacman.conf | sort > pacman_db

# shellcheck disable=SC2207
array=($(awk -F'=' '/^pkglist/ {print $1}' "${PKGLIST}"))

echo ":: Checking packages in the official repositories..."

for keys in "${array[@]}"; do
    temp="${keys}"
    all_packages+="${!temp}"
done
echo "${all_packages[@]}" | tr ' ' '\n' | sort -u > pkglist

# shellcheck disable=SC2207
unlisted=($(comm -13 <(cat pacman_db) <(cat pkglist) | grep '^[[:alnum:]].*'))
rm pacman_db pkglist

# Check if unlisted are groups of packages
for elem in "${unlisted[@]}"; do
    if ! sudo pacman -Sg "${elem}" 1>/dev/null; then
        echo "[x] Package not available: ${elem}"
    fi
done

echo ":: Ready!" && exit 0
