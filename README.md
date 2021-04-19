![Anarchy Installer's banner](assets/banner.svg)
<!-- ALL-CONTRIBUTORS-BADGE:START - Do not remove or modify this section -->
[![All Contributors](https://img.shields.io/badge/all_contributors-8-orange.svg?style=flat-square)](#contributors-)
<!-- ALL-CONTRIBUTORS-BADGE:END -->

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
- If it's a post-install issue check the [Arch Wiki](https://wiki.archlinux.org/) and existing posts on the
  [Arch Forums](https://bbs.archlinux.org/), since it's most likely an Arch-related issue and not connected to Anarchy
  (**Don't ask for support on the forums, they rightfully don't support downstream distributions - Ask on our Telegram**)

If the installer stops responding, but doesn't report an error (e.g. stuck at the progress bar), you can force quit by
pressing `CTRL+C`, then in the terminal you can manually run `nc termbin.com 9999 < /root/anarchy.log` (usually
the installer will upload a log automatically).
Then share the link you got as a response in the terminal.

If you don't want to sign up for Gitlab, you can also report issues
[over email](mailto:incoming+anarchyinstaller-installer-18524601-issue-@incoming.gitlab.com).

## Contributing

We're always looking for new contributors to the project, so check out our [contributing guide](CONTRIBUTING.md)
for more info.

## License

The project is licensed under the [GNU GPLv2 license](LICENSE).

## Contributors ✨

Thanks goes to these wonderful people ([emoji key](https://allcontributors.org/docs/en/emoji-key)):

<!-- ALL-CONTRIBUTORS-LIST:START - Do not remove or modify this section -->
<!-- prettier-ignore-start -->
<!-- markdownlint-disable -->
<table>
  <tr>
    <td align="center"><a href="https://gitlab.com/deadhead420"><img src="https://assets.gitlab-static.net/uploads/-/system/user/avatar/7466478/avatar.png?s=100" width="100px;" alt=""/><br /><sub><b>Dylan James</b></sub></a><br /><a href="https://gitlab.com/anarchyinstaller/Anarchy Installer/commits/master" title="Code">💻</a> <a href="#ideas-deadhead420" title="Ideas, Planning, & Feedback">🤔</a></td>
    <td align="center"><a href="https://gitlab.com/erazemk"><img src="https://assets.gitlab-static.net/uploads/-/system/user/avatar/2411685/avatar.png?s=100" width="100px;" alt=""/><br /><sub><b>Erazem Kokot</b></sub></a><br /><a href="https://gitlab.com/anarchyinstaller/Anarchy Installer/commits/master" title="Code">💻</a> <a href="#ideas-erazemk" title="Ideas, Planning, & Feedback">🤔</a> <a href="#infra-erazemk" title="Infrastructure (Hosting, Build-Tools, etc)">🚇</a> <a href="#content-erazemk" title="Content">🖋</a> <a href="#maintenance-erazemk" title="Maintenance">🚧</a> <a href="#translation-erazemk" title="Translation">🌍</a></td>
    <td align="center"><a href="https://github.com/condor2"><img src="https://avatars.githubusercontent.com/u/14251939?v=4?s=100" width="100px;" alt=""/><br /><sub><b>condor2</b></sub></a><br /><a href="https://gitlab.com/anarchyinstaller/Anarchy Installer/commits/master" title="Code">💻</a> <a href="#ideas-condor2" title="Ideas, Planning, & Feedback">🤔</a></td>
    <td align="center"><a href="https://gitlab.com/theDrake"><img src="https://secure.gravatar.com/avatar/4466db71b610aad5e041e730917ea53e?s=80&d=identicon?s=100" width="100px;" alt=""/><br /><sub><b>David C. Drake</b></sub></a><br /><a href="https://gitlab.com/anarchyinstaller/Anarchy Installer/commits/master" title="Code">💻</a></td>
    <td align="center"><a href="https://gitlab.com/AvinashReddy3108"><img src="https://assets.gitlab-static.net/uploads/-/system/user/avatar/2603938/avatar.png?s=100" width="100px;" alt=""/><br /><sub><b>Avinash Reddy</b></sub></a><br /><a href="https://gitlab.com/anarchyinstaller/Anarchy Installer/commits/master" title="Code">💻</a></td>
    <td align="center"><a href="https://gitlab.com/alexandrewurtzfr"><img src="https://secure.gravatar.com/avatar/22b32aeadbb75cccc711443fdcf4796f?s=80&d=identicon?s=100" width="100px;" alt=""/><br /><sub><b>Alexandre Wurtz</b></sub></a><br /><a href="https://gitlab.com/anarchyinstaller/Anarchy Installer/commits/master" title="Code">💻</a></td>
    <td align="center"><a href="https://gitlab.com/fredbezies"><img src="https://secure.gravatar.com/avatar/b80dd52da6b4e3e7aad1ee09c856fd81?s=80&d=identicon?s=100" width="100px;" alt=""/><br /><sub><b>Frederic Bezies</b></sub></a><br /><a href="https://gitlab.com/anarchyinstaller/Anarchy Installer/commits/master" title="Code">💻</a> <a href="#translation-fredbezies" title="Translation">🌍</a></td>
  </tr>
  <tr>
    <td align="center"><a href="https://gitlab.com/PandaFoss"><img src="https://assets.gitlab-static.net/uploads/-/system/user/avatar/4029596/avatar.png?s=100" width="100px;" alt=""/><br /><sub><b>Max Ferrer</b></sub></a><br /><a href="https://gitlab.com/anarchyinstaller/Anarchy Installer/commits/master" title="Code">💻</a> <a href="#ideas-PandaFoss" title="Ideas, Planning, & Feedback">🤔</a> <a href="#design-PandaFoss" title="Design">🎨</a> <a href="#content-PandaFoss" title="Content">🖋</a> <a href="#maintenance-PandaFoss" title="Maintenance">🚧</a> <a href="#translation-PandaFoss" title="Translation">🌍</a></td>
  </tr>
</table>

<!-- markdownlint-restore -->
<!-- prettier-ignore-end -->

<!-- ALL-CONTRIBUTORS-LIST:END -->

This project follows the [all-contributors](https://github.com/all-contributors/all-contributors) specification. Contributions of any kind welcome!