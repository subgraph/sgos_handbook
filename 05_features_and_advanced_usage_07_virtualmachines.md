## Using virtual machines in Subgraph OS

Contrary to popular belief, there is nothing that stops the use of virtual machines in Subgraph OS.
While there are, as of this writing, some known incompatibilities with VirtualBox, Qemu/KVM works as expected.

Qemu/KVM can be obtained by installing it the normal way: `sudo apt install qemu-system qemu-kvm qemu-utils`

### Creating a virtual machine with Qemu.

To create a virtual machine you will, if required, create a hard drive image for it:

	qemu-img create -f qcow2 disk.qcow2 8G

You're virtual machine drive is ready for use. You may launch a virtual machine using this drive like so:

	qemu-system-x86_64 -enable-kvm -hda ./disk.qcow2 -m 4096

Where `-enable-kvm` enables KVM virtualisation instead of using emulation; `-hda ./disk.qcow2` attaches the disk image; and `-m 4096` allocates 4096MB of RAM to the virtual machine.

To attach a cdrom image, for example to install an operating system:

	qemu-system-x86_64 -enable-kvm -hda ./disk.qcow2 -m 4096 -cdrom ./subgraph-os-alpha_2016-06-16_2.iso -boot d

For other information regarding the operation of Qemu/KVM virtual machine see the official [Qemu manual](http://wiki.qemu.org/Manual).

### Managing virtual machine using an interface

There are multiple user interfaces that allow interfacing with Qemu/KVM with various degrees of complexity such as:

* [gnome-boxes](https://wiki.gnome.org/Apps/Boxes)
* [virt-manager](http://virt-manager.et.redhat.com/)
* [qemuctl](http://qemuctl.sourceforge.net/)
* [virtualbricks](https://launchpad.net/virtualbrick)

\newpage

