# Features

## Sandboxing applications with Subgraph Oz

Copy an already existing oz configuration file from `/var/lib/oz/cells.d/`, e.g.

```
sudo cp /var/lib/oz/cells.d/xchat.json /var/lib/oz/cells.d/quassel.json
```

for an application that needs network connectivity or

```
sudo cp /var/lib/oz/cells.d/mpv.json /var/lib/oz/cells.d/inkscape.json
```

for one that does not.

The *xserver* section configures permissions related to how the application behaves within the X server.

The *networking* section configures if and if yes how the application uses the network/internet.

The *whitelist* section configures files and folders the application needs access to (this includes configuration and cache) and if the access is read-only or also for file (re)write.

The *seccomp* section configures if there is a file that defines syscalls the application should (whitelist) or should **not** (blacklist) have access to. For the purpose of creating such a whitelist it is recommended to set the parameter "enforce" to "false", this allows usage of the application and inspection of the syscalls made via `/var/log/oz-daemon.log`.

So create an empty file and configure it in the `whitelist` parameter of the *seccomp* section.

Then you need to register it with Oz

e.g.

```
which inkscape
sudo oz-setup install /usr/bin/inkscape
sudo systemctl restart oz-daemon.service # this will close all applications that a run via Oz
```

To be able to concentrate on the application and settings at hand, clear the oz-daemon.log via

```
sudo echo "" > /var/log/oz-daemon.log
```

Now you can start and use the application. After closing it you can reduce the output of `/var/log/oz-daemon.log` into the seccomp whitelist like so:

e.g.

```
grep 'inkscape' /var/log/oz-daemon.log > /tmp/filtered.1
grep 'syscall' /tmp/filtered.1 > /tmp/filtered.2
cut -d ' ' -f 20 /tmp/filtered.2 > /tmp/list.1
cut -d ' ' -f 22 /tmp/filtered.2 > /tmp/list.2
cat /tmp/list.{1,2} | sort | uniq | tail -n+3 > /var/lib/oz/cells.d/inkscape-whitelist.seccomp
sed -i 's/$/: 1/' /var/lib/oz/cells.d/inkscape-whitelist.seccomp
```

The last step is setting the seccomp whitelist enforcment to "true" in the .json file and restarting Oz: `systemctl restart oz-daemon.service`



\newpage

## Anonymizing communications with Tor
\newpage

## Routing applications through Tor with Subgraph Metaproxy

The Metaproxy is an important part of Subgraph OS. It is a service that runs in 
the background to help applications connect through the Tor network. This is 
done transparently, even with applications that are not configured or designed
to work with Tor. 

On a typical operating system, users must configure each application to connect 
to the Internet through Tor. This normally requires the user to configure the 
proxy settings of the application to use one of Tor's built-in proxies or to 
`torify` the application. Since Subgraph OS blocks outgoing connections that are 
not routed through Tor, this may pose a problem for applications that try to 
connect to the Internet but have not been manually `torified` or otherwise 
configured to work with Tor.

The Metaproxy addresses this problem by automatically relaying outgoing
connections through Tor. When we say this is done transparently, we mean the
following two things:

1. Users do not have to manually `torify` their applications or otherwise
configuration them to use Tor
2. Applications that are already configured to use Tor are ignored by the 
Metaproxy, therefore, it only helps those applications which need it

\newpage

## Hardening the operating system and applications with Grsecurity

Grsecurity is a third-party security enhancement to the Linux kernel. It is 
developed and maintained by the Grsecurity team. It is implemented as a patch
to the upstream Linux kernel. Subgraph OS ships with a kernel that is patched
with Grsecurity.

### Configuring PaX flags with Paxrat

\newpage

## Anonymizing MAC addresses with Macouflage

MAC addresses are the unique identifiers for the network interface on the computer
(such as Ethernet ports and WIFI cards). Due to their unique nature, they can
also compromise the privacy of the user. 

When connecting to a network, it is possible for other devices on the network to 
see the MAC address of the network interface that is connected. While this is 
not much of a concern on networks you trust such as your home network, it may 
compromise your privacy on those who do not trust. On untrustworthy or hostile
networks, uniquely identifying characteristics such as the MAC address may
allow others to track your computer.

Subgraph OS mitigates this privacy risk by always creating random MAC 
addresses for all of your network interfaces. Each time one of your interfaces 
connects to a network, it will use a different MAC address. This helps to 
anonymize you across different networks or when connecting to the same network 
over and over again.

\newpage
