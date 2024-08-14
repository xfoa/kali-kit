# foax's Kali Kit

Useful stuff to get Kali IPX tunneling running on a DOS PC.
The config and guide assume a Novell NE1000 network adapter, but packet drivers are included for a large variety of NICs.

## Building the ISO

Everything here can be used directly, but the easiest way to get this all onto a DOS machine is to create and ISO either to use with an emulator or burn to a CD for use on real hardware.
There is a build script included to do this, but it has only been tested on Linux.
The script requires the `xorriso` program to run.
This can be installed either via your package manager of choice, or obtained from GNU\[1\].

To build the ISO:

```
./bin/make-iso.sh
```

This will output the iso in the `build` directory.

Network adapter packet drivers were written by Russell Nelson, and the sources for them can be found on his site\[2\].

Links:

1. <https://www.gnu.org/software/xorriso/>
2. <http://crynwr.com/drivers/00index.html>
