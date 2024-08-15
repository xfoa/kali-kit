---
title: foax's Kali Kit
---

Useful stuff to get Kali IPX tunneling running on a DOS PC.
The config and guide assume a Novell NE1000 network adapter, but packet drivers are included for a large variety of NICs.

# Building the ISO

Everything here can be used directly, but the easiest way to get this all onto a DOS machine is to create and ISO either to use with an emulator or burn to a CD for use on real hardware.
There is a build script included to do this, but it has only been tested on Linux.
The script requires the `xorriso` program to run.
This can be installed either via your package manager of choice, or obtained from GNU \[<https://www.gnu.org/software/xorriso/>\].

To build the ISO:

```
./make-iso.sh
```

This will output the iso in the `build` directory.

To build the docs:

```
./make-docs.sh
```

This will output an HTML version of the docs to `build/html_docs`, and a DOS-readable TXT version of the docs to `src/iso/DOCS` which will included in the ISO when it's built.

Network adapter packet drivers were written by Russell Nelson, and the sources for them can be found on his site \[<http://crynwr.com/drivers/00index.html>\].

# License

The code in this repository, with the exception of files in `src/iso`, are copyright foax <https://fo.ax> and are distributed under the GPLv3 license.
Some content in this repository are copyrighted and distrubted without permission from their owners.
Such content is distributed under fair use for educational purposes.
If you are the copyright holder and would like your work removed, please contact me and I'll do so.
