# Useful scripts

Here are some scripts to run on a Linux host to get VDE connectivity working from an emulator like 86Box (this should also work with other emulators).
For more info, see [Networking using 86Box and VDE in Linux](https://fo.ax/kali-kit/html_docs/86box.html) in the docs for more info.
All scripts mentioned here can be run with the `--help` parameter to display usage.

| Script name               | Description                                                                       |
|---------------------------|-----------------------------------------------------------------------------------|
| `create-tap-device.sh`    | Create a TAP device that will connect the VDE bridge to the host's network stack. |
| `start-vde.sh`            | Start a VDE bridge and with a TAP device connected to it.                         |
| `route-tap-to-gateway.sh` | Set up routing so that traffic from the TAP device can be routed to the internet. |
