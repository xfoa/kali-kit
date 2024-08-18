# foax's Kali Kit

Kali is a program that tunnels IPX network traffic over TCP/IP, allowing old games and applications that use IPX to connect over networks that only support TCP/IP, including the internet.
This repo contains a collection of tools and drivers to get [Kali](https://kali.net) running on an MS-DOS PC, and guides on how to set it up on real and emulated hardware.
It's what I wished I had when I first set up Kali in 86Box!

The programs and drivers collected here can be used directly from the `src/iso` directory, but the easiest way to get them onto a DOS machine with a CD-ROM drive is to create an ISO file using the included scripts.
This can either be used with an emulator directly, or burned onto a CD to use with real hardware.
The config files and guides included here assume a Novell NE1000 network adapter, but packet drivers are included for a large variety of NICs.

If you are using an emulator like [86Box](https://86box.net/) or [QEMU](https://www.qemu.org/) on Linux, there are some scripts provided to help set up the host side of networking with [VDE](https://github.com/virtualsquare/vde-2) in the `bin` directory.
A guide for this is also available in the [Networking using 86Box and VDE in Linux](https://fo.ax/kali-kit/html_docs/86box.html) section of the docs.

## Building the ISO

The ISO can be built using a script included in this repo, but it has only been tested on Linux.
The ISO build script requires [xorriso](https://www.gnu.org/software/xorriso/), which most should be available in most Linux distros.

To build the ISO, run:

```
./make-iso.sh
```

This will output the iso in the `build` directory.

## Building the documentation

An up-to-date version of the docs can be found [online](https://fo.ax/kali-kit/html_docs).
Optionally, you can build them from the Markdown sources included in this repo.
The docs build script requires [Pandoc](https://pandoc.org/) and [dos2unix](https://dos2unix.sourceforge.io/), which should be available in most Linux distros.

To build the docs, run:

```
./make-docs.sh
```

This will output a stand-alone HTML version of the docs to `build/html_docs`, and a DOS-readable TXT version of the docs to `src/iso/DOCS` which will included in the ISO when it's built.

## Building everything

```
./make-all.sh
```

All it does it run the previous two scripts. 😉

## VDE networking scripts

In the `bin` directory there are some useful scripts to create a VDE switch with an atteched TAP device to use with PC emulators such as [86Box](https://86box.net/) and [QEMU](https://www.qemu.org/).
Or, if you'd like to use a set of default parameters for this, run the `start-emulator-network.sh` script at the root of this repo.

## License

The contents of this repository, with the exception of programs and drivers in `src/iso`, are &copy; [foax](https://fo.ax) unless otherwise stated, and are distributed under the GPLv3 license.
Some drivers and applications included in this repository have been distrubted without the permission of their authors.
Such content is distributed under fair use for educational purposes, on the assumption that they are no longer commercially relevant.
If you are the copyright holder for any of these and would like your work removed from this repo, please [contact me](mailto:a@fo.ax) and I will do so.

The collection of network adapter packet drivers included in this repo were written by Russell Nelson, and the sources for these can be found on [his site](http://crynwr.com/drivers/00index.html).
