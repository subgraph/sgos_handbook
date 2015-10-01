# Features

## Sandboxing applications with Subgraph Oz

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
