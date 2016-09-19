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
