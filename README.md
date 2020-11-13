![Anarchy Installer's banner](assets/banner.svg)

# About

Anarchy is a simple and intuitive Terminal based (TUI) [Arch Linux](https://archlinux.org) installer.
It guides you through every aspect of the installation procedure, from partitioning to installing your favorite DE/WM.

## Installation

### Linux

The easiest way to flash Anarchy onto a USB drive is to use `dd`:

```sh
# Do NOT copy and paste the following, manually type the command, filling in the appropriate information
# Replace sdx with the name of your USB
dd if=anarchy-<version>-x86_64.iso of=/dev/sdx status=progress conv=sync
```

If you're more comfortable with GUI-based programs, you can use [Etcher](https://www.balena.io/etcher/) or
GNOME Disks (Restore image option).

### Windows

Use [Win32DiskImager](https://sourceforge.net/projects/win32diskimager/) or [Rufus](https://rufus.ie/).

### Install via SSH

_Keep in mind that running the installer over an SSH connection requires physical access to the remote machine._

After flashing Anarchy on a USB drive, it must be booted from the machine where you want to install.
If it has a wired internet connection, you only have to wait approximately one minute for Anarchy to start before
connecting.
If you have a wireless connection, you have two options: you normally connect to the target machine
(requires physical access), or you must compile the installer yourself as indicated in the next step, but adding the
file `autoconnect.sh` (it must be kept exactly the same name) along with the script `build.sh`.
The `autoconnect.sh` file must have the following format:

```sh
SSID="your_wifi_network_ssid"
PASSWORD="your_wifi_network_password"
PUBLIC_KEY=/path/to/your/public/key
```

`SSID` must contain the name that identifies the wifi network, `PASSWORD` is its respective password, and `PUBLIC_KEY`
refers to the local path of our public SSH key.
Then you can compile the installer normally.
To connect simply run on your local machine (from where you will install via SSH): `ssh root@ip.address.of.target`
The default password is `anarchy`.

## Compiling the installer

You have two options for compiling the installer:

- If on Arch Linux: run `build.sh` with root permissions (e.g. with `sudo`)
- If elsewhere: run `build.sh -c`, which will build it with `podman` in a container

You can also manually build Anarchy using the `Containerfile` with your preferred arguments.

## Reporting issues

Before [reporting an issue](https://gitlab.com/anarchyinstaller/installer/issues) do the following:

- Make sure you're using the latest version of Anarchy
- Write down the log's automatically generated url (e.g. *termbin.com/xywz*)
- If it's a post-install issue check the [Arch Wiki](https://wiki.archlinux.org/) and
  [Arch Forums](https://bbs.archlinux.org/), since it's most likely an Arch-related issue and not connected to Anarchy

If you don't want to sign up for Gitlab, you can also report issues
[over email](mailto:incoming+anarchyinstaller-installer-18524601-issue-@incoming.gitlab.com).

## Contributing

We're always looking for new contributors to the project, so check out our [contributing guide](CONTRIBUTING.md)
for more info.

## License

The project is licensed under the [GNU GPLv2 license](LICENSE).
