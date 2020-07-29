#!/bin/sh
# Compiles Anarchy with archiso

# Archiso variables
FILENAME=anarchy
VERSION=1.3.0
LABEL=ANARCHY_"$(echo ${VERSION} | tr -d .)" # Removes . from version number
PUBLISHER='Anarchy Installer <https://anarchyinstaller.org>'
NAME='Anarchy Installer'
OUT_DIR="$(pwd)/out"

# TODO:
#
# Check root permission
# Check if archiso is installed
# Create temporary directory
# Copy archiso files to tmp dir
# Copy anarchy files to tmp dir
# Append anarchy-specific stuff to airootfs/root/customise_airootfs.sh
# Run archiso's build.sh with anarchy's variables
