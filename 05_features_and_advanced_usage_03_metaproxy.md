## Routing applications through Tor with Subgraph Metaproxy

The **Metaproxy** is an important part of Subgraph OS. It runs in the background 
to help applications connect through the Tor network. This is done 
transparently, even with applications that are not configured or designed to 
work with Tor. 

On other operating systems, users must specifically configure applications to 
connect to the Internet through Tor. This normally requires the user to
configure proxy settings of the application to connect through Tor's built-in 
proxies. Some applications do not support or honor proxy settings. To use Tor
with these applications, users often run them with using a command-line helper 
called **torsocks** to *torify* the application. This is a lot of work for users.

Configuring proxies or *torifying* applications by hand is not an adequate
solution for Subgraph OS. Usability and maintainability are issues with this 
approach. In Subgraph OS, some applications simply would not work if there is no
easy way to route them through Tor. This is because Subgraph OS blocks outgoing
connections that are not routed through Tor. This is to prevent accidental
privacy leaks. If an application has no way to communicate over Tor, it may not
be able to access the network at all.

The **Metaproxy** addresses this problem by automatically relaying outgoing
connections through Tor. When we say this is done transparently, we mean the
following two things:

1. Users do not have to manually *torify* their applications or otherwise
configure them to use Tor
2. Applications that are already configured to use Tor are ignored by the 
**Metaproxy**, therefore, it only helps those applications which need it

\newpage
