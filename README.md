![Anarchy Installer's banner](assets/banner.svg)
<!-- ALL-CONTRIBUTORS-BADGE:START - Do not remove or modify this section -->
[![All Contributors](https://img.shields.io/badge/all_contributors-66-orange.svg?style=flat-square)](#contributors-)
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
dd if=anarchy-<version>-<architecture>.iso of=/dev/sdx status=progress conv=sync
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

- If on Arch Linux: run `build.sh -a x86_64` with root permissions (e.g. with `sudo`) to build a 64-bit ISO image or run `build.sh -a i686` in case you want to build a 32-bit iso image (the latter option is based on the [Arch Linux 32](https://www.archlinux32.org/) project)
- If elsewhere: run `build.sh -c`, which will build it with `podman` in a container

You can also manually build Anarchy using the `Containerfile` with your preferred arguments.

Finally, you can use the -h (or --help) option to see other available options:

```sh
Usage: ./build.sh [options]
Options:
  -c, --container         Create Anarchy in a container using podman (only for 'x86_64' architecture).
  -a, --arch <ARCH>       Generates the ISO with the specified architecture ('x86_64', 'i686' or 'both').
  -p, --purge             Remove build artefacts.
  -k, --keep              Retain the packages, mirrorlist and other things required to build the 32-bit ISO.
  -h, --help              Display this help message and exit.
```

__Warning:__ While the build script supports the generation of 64-bit and 32-bit ISO images, __it was designed to be run on a 64-bit machine only__. Possibly on a 32-bit machine it may only allow 32-bit ISO generation, but ___this has not been tested yet___.

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
    <td align="center"><a href="https://github.com/pnedkov"><img src="https://avatars.githubusercontent.com/u/6212427?v=4?s=100" width="100px;" alt=""/><br /><sub><b>Plamen Nedkov</b></sub></a><br /><a href="https://gitlab.com/anarchyinstaller/Anarchy Installer/commits/master" title="Code">💻</a></td>
    <td align="center"><a href="https://github.com/Bricabraque"><img src="https://avatars.githubusercontent.com/u/25384614?v=4?s=100" width="100px;" alt=""/><br /><sub><b>Badaboum</b></sub></a><br /><a href="https://gitlab.com/anarchyinstaller/Anarchy Installer/commits/master" title="Code">💻</a> <a href="#translation-Bricabraque" title="Translation">🌍</a></td>
    <td align="center"><a href="http://dotconfig.wordpress.com/"><img src="https://avatars.githubusercontent.com/u/2768725?v=4?s=100" width="100px;" alt=""/><br /><sub><b>Fábio Nogueira</b></sub></a><br /><a href="#translation-frnogueira" title="Translation">🌍</a></td>
    <td align="center"><a href="https://github.com/teacher4711"><img src="https://avatars.githubusercontent.com/u/6697859?v=4?s=100" width="100px;" alt=""/><br /><sub><b>Michael</b></sub></a><br /><a href="https://gitlab.com/anarchyinstaller/Anarchy Installer/commits/master" title="Code">💻</a> <a href="#translation-teacher4711" title="Translation">🌍</a></td>
    <td align="center"><a href="https://github.com/Mauladen"><img src="https://avatars.githubusercontent.com/u/12824589?v=4?s=100" width="100px;" alt=""/><br /><sub><b>Danil Antoshkin</b></sub></a><br /><a href="#translation-Mauladen" title="Translation">🌍</a></td>
    <td align="center"><a href="https://github.com/viviengraffin"><img src="https://avatars.githubusercontent.com/u/22659321?v=4?s=100" width="100px;" alt=""/><br /><sub><b>viviengraffin</b></sub></a><br /><a href="https://gitlab.com/anarchyinstaller/Anarchy Installer/commits/master" title="Code">💻</a> <a href="#translation-viviengraffin" title="Translation">🌍</a></td>
  </tr>
  <tr>
    <td align="center"><a href="https://github.com/Kaobear"><img src="https://avatars.githubusercontent.com/u/223496?v=4?s=100" width="100px;" alt=""/><br /><sub><b>Kaobear</b></sub></a><br /><a href="https://gitlab.com/anarchyinstaller/Anarchy Installer/commits/master" title="Code">💻</a></td>
    <td align="center"><a href="https://github.com/Uyuiyu"><img src="https://avatars.githubusercontent.com/u/55355414?v=4?s=100" width="100px;" alt=""/><br /><sub><b>Uyuiyu</b></sub></a><br /><a href="#translation-Uyuiyu" title="Translation">🌍</a></td>
    <td align="center"><a href="https://github.com/yumiris"><img src="https://avatars.githubusercontent.com/u/10241434?v=4?s=100" width="100px;" alt=""/><br /><sub><b>Miris Wisdom</b></sub></a><br /><a href="https://gitlab.com/anarchyinstaller/Anarchy Installer/commits/master" title="Code">💻</a> <a href="#content-yumiris" title="Content">🖋</a></td>
    <td align="center"><a href="https://github.com/DraGiuS"><img src="https://avatars.githubusercontent.com/u/26351654?v=4?s=100" width="100px;" alt=""/><br /><sub><b>Yosh</b></sub></a><br /><a href="https://gitlab.com/anarchyinstaller/Anarchy Installer/commits/master" title="Code">💻</a> <a href="#content-DraGiuS" title="Content">🖋</a></td>
    <td align="center"><a href="https://github.com/tenten8401"><img src="https://avatars.githubusercontent.com/u/6174343?v=4?s=100" width="100px;" alt=""/><br /><sub><b>Isaac A.</b></sub></a><br /><a href="https://gitlab.com/anarchyinstaller/Anarchy Installer/commits/master" title="Code">💻</a></td>
    <td align="center"><a href="https://github.com/CRImier"><img src="https://avatars.githubusercontent.com/u/3173633?v=4?s=100" width="100px;" alt=""/><br /><sub><b>Arsenijs</b></sub></a><br /><a href="https://gitlab.com/anarchyinstaller/Anarchy Installer/commits/master" title="Code">💻</a></td>
    <td align="center"><a href="https://github.com/andrew-grechkin"><img src="https://avatars.githubusercontent.com/u/3592512?v=4?s=100" width="100px;" alt=""/><br /><sub><b>Andrew Grechkin</b></sub></a><br /><a href="https://gitlab.com/anarchyinstaller/Anarchy Installer/commits/master" title="Code">💻</a></td>
  </tr>
  <tr>
    <td align="center"><a href="https://github.com/Firminator"><img src="https://avatars.githubusercontent.com/u/12078737?v=4?s=100" width="100px;" alt=""/><br /><sub><b>Firminator</b></sub></a><br /><a href="https://gitlab.com/anarchyinstaller/Anarchy Installer/commits/master" title="Code">💻</a></td>
    <td align="center"><a href="http://cv.ftes.de/"><img src="https://avatars.githubusercontent.com/u/2614732?v=4?s=100" width="100px;" alt=""/><br /><sub><b>Fredrik Teschke</b></sub></a><br /><a href="https://gitlab.com/anarchyinstaller/Anarchy Installer/commits/master" title="Code">💻</a></td>
    <td align="center"><a href="https://github.com/m00nyONE"><img src="https://avatars.githubusercontent.com/u/23294566?v=4?s=100" width="100px;" alt=""/><br /><sub><b>m00ny</b></sub></a><br /><a href="https://gitlab.com/anarchyinstaller/Anarchy Installer/commits/master" title="Code">💻</a></td>
    <td align="center"><a href="https://github.com/herobrauni"><img src="https://avatars.githubusercontent.com/u/20051140?v=4?s=100" width="100px;" alt=""/><br /><sub><b>herobrauni</b></sub></a><br /><a href="https://gitlab.com/anarchyinstaller/Anarchy Installer/commits/master" title="Code">💻</a></td>
    <td align="center"><a href="https://daylien.de/"><img src="https://avatars.githubusercontent.com/u/22529605?v=4?s=100" width="100px;" alt=""/><br /><sub><b>Malte Grave</b></sub></a><br /><a href="https://gitlab.com/anarchyinstaller/Anarchy Installer/commits/master" title="Code">💻</a></td>
    <td align="center"><a href="https://github.com/Baltazaras"><img src="https://avatars.githubusercontent.com/u/28072815?v=4?s=100" width="100px;" alt=""/><br /><sub><b>Tautvydas</b></sub></a><br /><a href="#translation-Baltazaras" title="Translation">🌍</a></td>
    <td align="center"><a href="https://github.com/phenri"><img src="https://avatars.githubusercontent.com/u/5457809?v=4?s=100" width="100px;" alt=""/><br /><sub><b>phenri</b></sub></a><br /><a href="#translation-phenri" title="Translation">🌍</a></td>
  </tr>
  <tr>
    <td align="center"><a href="https://sourcerer.io/robsonsilv4"><img src="https://avatars.githubusercontent.com/u/17673296?v=4?s=100" width="100px;" alt=""/><br /><sub><b>Robson Silva</b></sub></a><br /><a href="https://gitlab.com/anarchyinstaller/Anarchy Installer/commits/master" title="Code">💻</a></td>
    <td align="center"><a href="https://github.com/TheRingMaster"><img src="https://avatars.githubusercontent.com/u/7809663?v=4?s=100" width="100px;" alt=""/><br /><sub><b>John Brewer</b></sub></a><br /><a href="https://gitlab.com/anarchyinstaller/Anarchy Installer/commits/master" title="Code">💻</a></td>
    <td align="center"><a href="https://github.com/sfanxiang"><img src="https://avatars.githubusercontent.com/u/5893440?v=4?s=100" width="100px;" alt=""/><br /><sub><b>Xiang Fan</b></sub></a><br /><a href="https://gitlab.com/anarchyinstaller/Anarchy Installer/commits/master" title="Code">💻</a></td>
    <td align="center"><a href="https://github.com/oscarholst"><img src="https://avatars.githubusercontent.com/u/10300231?v=4?s=100" width="100px;" alt=""/><br /><sub><b>Oscar Holst</b></sub></a><br /><a href="#translation-oscarholst" title="Translation">🌍</a></td>
    <td align="center"><a href="https://github.com/yousefvand"><img src="https://avatars.githubusercontent.com/u/18329462?v=4?s=100" width="100px;" alt=""/><br /><sub><b>Remisa Yousefvand</b></sub></a><br /><a href="https://gitlab.com/anarchyinstaller/Anarchy Installer/commits/master" title="Code">💻</a></td>
    <td align="center"><a href="https://github.com/includes08"><img src="https://avatars.githubusercontent.com/u/11631681?v=4?s=100" width="100px;" alt=""/><br /><sub><b>includes08</b></sub></a><br /><a href="#translation-includes08" title="Translation">🌍</a> <a href="https://gitlab.com/anarchyinstaller/Anarchy Installer/commits/master" title="Code">💻</a></td>
    <td align="center"><a href="https://stanislas.blog/"><img src="https://avatars.githubusercontent.com/u/11699655?v=4?s=100" width="100px;" alt=""/><br /><sub><b>Stanislas</b></sub></a><br /><a href="https://gitlab.com/anarchyinstaller/Anarchy Installer/commits/master" title="Code">💻</a></td>
  </tr>
  <tr>
    <td align="center"><a href="https://github.com/gmcclins"><img src="https://avatars.githubusercontent.com/u/1461924?v=4?s=100" width="100px;" alt=""/><br /><sub><b>Geoffrey McClinsey</b></sub></a><br /><a href="#content-gmcclins" title="Content">🖋</a></td>
    <td align="center"><a href="https://github.com/UNIcodeX"><img src="https://avatars.githubusercontent.com/u/8235002?v=4?s=100" width="100px;" alt=""/><br /><sub><b>UNIcodeX</b></sub></a><br /><a href="https://gitlab.com/anarchyinstaller/Anarchy Installer/commits/master" title="Code">💻</a></td>
    <td align="center"><a href="https://github.com/mikunimaru"><img src="https://avatars.githubusercontent.com/u/43168745?v=4?s=100" width="100px;" alt=""/><br /><sub><b>mikunimaru</b></sub></a><br /><a href="https://gitlab.com/anarchyinstaller/Anarchy Installer/commits/master" title="Code">💻</a></td>
    <td align="center"><a href="https://github.com/W3ndige"><img src="https://avatars.githubusercontent.com/u/17812121?v=4?s=100" width="100px;" alt=""/><br /><sub><b>W3ndige</b></sub></a><br /><a href="#translation-W3ndige" title="Translation">🌍</a></td>
    <td align="center"><a href="https://www.linkedin.com/in/filisfutsarov"><img src="https://avatars.githubusercontent.com/u/8798694?v=4?s=100" width="100px;" alt=""/><br /><sub><b>Filis Futsarov</b></sub></a><br /><a href="#content-filisko" title="Content">🖋</a></td>
    <td align="center"><a href="https://github.com/dszryan"><img src="https://avatars.githubusercontent.com/u/9117127?v=4?s=100" width="100px;" alt=""/><br /><sub><b>dszryan</b></sub></a><br /><a href="https://gitlab.com/anarchyinstaller/Anarchy Installer/commits/master" title="Code">💻</a></td>
    <td align="center"><a href="https://github.com/BakasuraRCE"><img src="https://avatars.githubusercontent.com/u/26231582?v=4?s=100" width="100px;" alt=""/><br /><sub><b>Bakasura</b></sub></a><br /><a href="#translation-BakasuraRCE" title="Translation">🌍</a></td>
  </tr>
  <tr>
    <td align="center"><a href="https://iptables.sh/"><img src="https://avatars.githubusercontent.com/u/28601081?v=4?s=100" width="100px;" alt=""/><br /><sub><b>Michael</b></sub></a><br /><a href="#translation-clrxbl" title="Translation">🌍</a></td>
    <td align="center"><a href="https://github.com/marcelofern"><img src="https://avatars.githubusercontent.com/u/17491689?v=4?s=100" width="100px;" alt=""/><br /><sub><b>Marcelo Fern</b></sub></a><br /><a href="https://gitlab.com/anarchyinstaller/Anarchy Installer/commits/master" title="Code">💻</a></td>
    <td align="center"><a href="https://github.com/Nornort"><img src="https://avatars.githubusercontent.com/u/17450093?v=4?s=100" width="100px;" alt=""/><br /><sub><b>Nornort</b></sub></a><br /><a href="https://gitlab.com/anarchyinstaller/Anarchy Installer/commits/master" title="Code">💻</a></td>
    <td align="center"><a href="https://github.com/Leezio"><img src="https://avatars.githubusercontent.com/u/28710712?v=4?s=100" width="100px;" alt=""/><br /><sub><b>François F.</b></sub></a><br /><a href="#translation-Leezio" title="Translation">🌍</a></td>
    <td align="center"><a href="https://github.com/efreeking"><img src="https://avatars.githubusercontent.com/u/3921471?v=4?s=100" width="100px;" alt=""/><br /><sub><b>efreeking</b></sub></a><br /><a href="#translation-efreeking" title="Translation">🌍</a></td>
    <td align="center"><a href="https://nemanja.top/"><img src="https://avatars.githubusercontent.com/u/448151?v=4?s=100" width="100px;" alt=""/><br /><sub><b>Nemanja Nedeljković</b></sub></a><br /><a href="https://gitlab.com/anarchyinstaller/Anarchy Installer/commits/master" title="Code">💻</a></td>
    <td align="center"><a href="https://agravelot.dev/"><img src="https://avatars.githubusercontent.com/u/13699253?v=4?s=100" width="100px;" alt=""/><br /><sub><b>Antoine Gravelot</b></sub></a><br /><a href="https://gitlab.com/anarchyinstaller/Anarchy Installer/commits/master" title="Code">💻</a></td>
  </tr>
  <tr>
    <td align="center"><a href="https://github.com/PatrickNByrne"><img src="https://avatars.githubusercontent.com/u/1676451?v=4?s=100" width="100px;" alt=""/><br /><sub><b>Patrick Byrne</b></sub></a><br /><a href="https://gitlab.com/anarchyinstaller/Anarchy Installer/commits/master" title="Code">💻</a></td>
    <td align="center"><a href="http://www.lguruprasad.in/"><img src="https://avatars.githubusercontent.com/u/218870?v=4?s=100" width="100px;" alt=""/><br /><sub><b>Guruprasad</b></sub></a><br /><a href="https://gitlab.com/anarchyinstaller/Anarchy Installer/commits/master" title="Code">💻</a></td>
    <td align="center"><a href="https://fyang.me/"><img src="https://avatars.githubusercontent.com/u/10241267?v=4?s=100" width="100px;" alt=""/><br /><sub><b>Fan YANG</b></sub></a><br /><a href="https://gitlab.com/anarchyinstaller/Anarchy Installer/commits/master" title="Code">💻</a></td>
    <td align="center"><a href="https://github.com/ralacerda"><img src="https://avatars.githubusercontent.com/u/19380403?v=4?s=100" width="100px;" alt=""/><br /><sub><b>Renato Lacerda</b></sub></a><br /><a href="#translation-ralacerda" title="Translation">🌍</a></td>
    <td align="center"><a href="https://github.com/liyiheng"><img src="https://avatars.githubusercontent.com/u/16461061?v=4?s=100" width="100px;" alt=""/><br /><sub><b>liyiheng</b></sub></a><br /><a href="https://gitlab.com/anarchyinstaller/Anarchy Installer/commits/master" title="Code">💻</a></td>
    <td align="center"><a href="https://github.com/jorgeluiscarrillo"><img src="https://avatars.githubusercontent.com/u/33134232?v=4?s=100" width="100px;" alt=""/><br /><sub><b>jorgeluiscarrillo</b></sub></a><br /><a href="#translation-jorgeluiscarrillo" title="Translation">🌍</a></td>
    <td align="center"><a href="https://stackoverflow.com/users/2089675/smac89?tab=profile"><img src="https://avatars.githubusercontent.com/u/8305511?v=4?s=100" width="100px;" alt=""/><br /><sub><b>smac89</b></sub></a><br /><a href="#content-smac89" title="Content">🖋</a></td>
  </tr>
  <tr>
    <td align="center"><a href="https://github.com/JackNapier151"><img src="https://avatars.githubusercontent.com/u/23581810?v=4?s=100" width="100px;" alt=""/><br /><sub><b>Jack Napier</b></sub></a><br /><a href="https://gitlab.com/anarchyinstaller/Anarchy Installer/commits/master" title="Code">💻</a></td>
    <td align="center"><a href="https://github.com/jmayday"><img src="https://avatars.githubusercontent.com/u/10167533?v=4?s=100" width="100px;" alt=""/><br /><sub><b>Jakub</b></sub></a><br /><a href="#translation-jmayday" title="Translation">🌍</a></td>
    <td align="center"><a href="https://github.com/segeda"><img src="https://avatars.githubusercontent.com/u/504956?v=4?s=100" width="100px;" alt=""/><br /><sub><b>Petr Severa</b></sub></a><br /><a href="https://gitlab.com/anarchyinstaller/Anarchy Installer/commits/master" title="Code">💻</a> <a href="#translation-segeda" title="Translation">🌍</a></td>
    <td align="center"><a href="https://github.com/DeicPro"><img src="https://avatars.githubusercontent.com/u/12710770?v=4?s=100" width="100px;" alt=""/><br /><sub><b>Deiki</b></sub></a><br /><a href="#translation-DeicPro" title="Translation">🌍</a></td>
    <td align="center"><a href="https://github.com/michaelgilch"><img src="https://avatars.githubusercontent.com/u/15143333?v=4?s=100" width="100px;" alt=""/><br /><sub><b>Michael Gilchrist</b></sub></a><br /><a href="https://gitlab.com/anarchyinstaller/Anarchy Installer/commits/master" title="Code">💻</a></td>
    <td align="center"><a href="https://archstrike.org/team"><img src="https://avatars.githubusercontent.com/u/12876622?v=4?s=100" width="100px;" alt=""/><br /><sub><b>James Stronz</b></sub></a><br /><a href="https://gitlab.com/anarchyinstaller/Anarchy Installer/commits/master" title="Code">💻</a></td>
    <td align="center"><a href="https://github.com/rhssk"><img src="https://avatars.githubusercontent.com/u/14257984?v=4?s=100" width="100px;" alt=""/><br /><sub><b>Rihards Skuja</b></sub></a><br /><a href="https://gitlab.com/anarchyinstaller/Anarchy Installer/commits/master" title="Code">💻</a></td>
  </tr>
  <tr>
    <td align="center"><a href="https://github.com/satory-ra"><img src="https://avatars.githubusercontent.com/u/21138526?v=4?s=100" width="100px;" alt=""/><br /><sub><b>satory-ra</b></sub></a><br /><a href="https://gitlab.com/anarchyinstaller/Anarchy Installer/commits/master" title="Code">💻</a></td>
    <td align="center"><a href="https://jona3717.gitlab.io/"><img src="https://avatars.githubusercontent.com/u/42119681?v=4?s=100" width="100px;" alt=""/><br /><sub><b>Jonathan Córdova</b></sub></a><br /><a href="https://gitlab.com/anarchyinstaller/Anarchy Installer/commits/master" title="Code">💻</a></td>
    <td align="center"><a href="https://liberapay.com/Bond_009/"><img src="https://avatars.githubusercontent.com/u/21289123?v=4?s=100" width="100px;" alt=""/><br /><sub><b>Bond-009</b></sub></a><br /><a href="#translation-Bond-009" title="Translation">🌍</a></td>
  </tr>
</table>

<!-- markdownlint-restore -->
<!-- prettier-ignore-end -->

<!-- ALL-CONTRIBUTORS-LIST:END -->

This project follows the [all-contributors](https://github.com/all-contributors/all-contributors) specification. Contributions of any kind welcome!
