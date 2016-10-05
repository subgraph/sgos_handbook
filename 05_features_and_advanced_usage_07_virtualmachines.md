## Using virtual machines in Subgraph OS

Contrary to popular belief, there is nothing that stops the use of virtual machines in Subgraph OS.
While there are, as of this writing, some known incompatibilities with VirtualBox, Qemu/KVM works as expected.

Qemu/KVM can be obtained by installing it the normal way: `sudo apt install qemu-system qemu-kvm qemu-utils`

### Creating a virtual machine with Qemu.

To create a virtual machine you will, if required, create a hard drive image for it:

```
qemu-img create -f qcow2 disk.qcow2 8G
```

You're virtual machine drive is ready for use. You may launch a virtual machine using this drive like so:

```
qemu-system-x86_64 -enable-kvm -hda ./disk.qcow2 -m 4096
```

Where `-enable-kvm` enables KVM virtualisation instead of using emulation; `-hda ./disk.qcow2` attaches the disk image; and `-m 4096` allocates 4096MB of RAM to the virtual machine.

To attach a cdrom image, for example to install an operating system:

```
qemu-system-x86_64 -enable-kvm -hda ./disk.qcow2 -m 4096 -cdrom ./subgraph-os-alpha_2016-06-16_2.iso -boot d
```

For other information regarding the operation of Qemu/KVM virtual machine see the official [Qemu manual](http://wiki.qemu.org/Manual).

#### Advanced virtual machine creation

For more control and easier installation of Debian releases inside of a virtual machine, one may use debootstrap to create pre installed images without going through the installer process.

Let's start by creating an 8GB raw sparse image for our VM, then format and mount it:

```
truncate --size 8G ./disk.img
# Here you could decide to create a proper partition table if you wanted... or not...
/sbin/mkfs.ext4 ./disk.img
sudo mount -o loop ./disk.img /mnt
```

It's worth nothing that you should have enough free disk space for the image you create (and possible twice as much if you want to convert it later on).

However, the truncated image will only take as much as space as required:

```
du -sh disk.img
189M	disk.img
du --apparent-size -sh disk.img
8.0G	disk.img
```

Now that we have an image created and mounted, we can use debootstrap to expand a basic install into it:

```
sudo debootstrap --variant=mintbase --include=systemd-sysv stretch /mnt

# We will grab a copy of the kernel and initramfs we just installed to boot the system
cp /mnt/boot/vmlinuz-<version>-amd64 /mnt/boot/initrd.img-<version>-amd64 ./

# And set a root password
sudo chroot /mnt passwd

# Create a standard fstab
sudo tee /mnt/etc/fstab << EOL
/dev/sda	/	ext4	defaults,errors=remount-ro	0	1
EOL

# Let's download the subgraph grsec kernel and install it
cd /tmp
apt-get download linux-{image,headers}-grsec-amd64-subgraph linux-{image,headers}-$(uname -r)
sudo cp ./linux-{image,headers}-$(uname -r) /mnt/tmp
sudo chroot /mnt
$ dpkg -i /tmp/linux-{image,headers}-*
$ update-initramfs -u -k all
$ exit

# After, we will sync and umount
sync
sudo umount /mnt
```

Once done, we can use it as is with Qemu/KVM, or if you prefer it can be converted to a qcow2 image for convenience:

```
qemu-img convert -f raw -O qcow2 ./disk.img ./disk.qcow2
```

We can now launch our image:

```
qemu-system-x86_64 -enable-kvm -hda ./disk.qcow2 -kernel ./vmlinuz-<version>-amd64 -initrd ./initrd.img-<version>-amd64 -append root=/dev/sda
```

If you want to install grub to keep the kernel and initrd images inside the virtual machine you'll have to create a full partition table, and potentially a separate /boot partition. But this is out of scope for this short tutorial.

#### Simple networking

By default, Qemu will transparently NAT your virtual machines to the host network. This can be disabled by using the `-net none` flag.

Alternatively, you can also open simple tunnels between the host and the virtual machine using the port redirection mechanism with the `-redir` flag:

```
-redir tcp:55700::55700
```

For more on networking in Qemu/KVM see:

* http://wiki.qemu.org/Documentation/Networking
* https://en.wikibooks.org/wiki/QEMU/Networking


### Managing virtual machine using an interface

There are multiple user interfaces that allow interfacing with Qemu/KVM with various degrees of complexity such as:

* [gnome-boxes](https://wiki.gnome.org/Apps/Boxes)
* [virt-manager](http://virt-manager.et.redhat.com/)
* [qemuctl](http://qemuctl.sourceforge.net/)
* [virtualbricks](https://launchpad.net/virtualbrick)

\newpage

