## Anonymizing communications with Tor

*Tor* is an essential privacy tool that provides anonymity to its users. In
particular, Tor hides the location of its users. By location, we mean your IP
address (which can also be used to geo-locate your computer).

Tor hides your location by relaying your traffic through a random series of 
network connections (called a *circuit*). While your traffic passes through the 
*hops* in this circuit, the source and destination of the traffic are hidden. The 
traffic eventually leaves the *circuit* through an *exit node*. The *exit node* 
relays the traffic to its final destination but is also unaware of the source.
They are called *exit nodes* because they are the point where the traffic leaves 
the Tor network to reach its destination on the regular Internet. *Exit nodes* 
may observe or tamper with the traffic en-route to its destination, unless an 
additional layer of encryption is applied such as *TLS*.

Due to the possibility that some *exit nodes* are malicious, we strongly advise
you to use Tor with an additional layer of encryption. This means
connecting to websites over *HTTPS* only, using TLS with applications such as
**Icedove** or **Hexchat**, etc.

**NOTE**: Tor hidden services provide a way to send network traffic *only* 
through the Tor network. This eliminates the risks involved when the traffic 
passes through an *exit node* to the regular Internet. However, this requires 
that the destination service is configured to run as a hidden service. It also 
adds more latency to the network traffic because it must pass through more 
*hops* to reach the hidden service. Tor hidden services are discussed in further 
detail in other sections of this book.

More information about Tor can be found here:

<https://www.torproject.org/about/overview>

\newpage

### Tor integration in Subgraph OS

Subgraph OS is integrated with the Tor anonymity network. We include many
applications that are designed to be used with Tor. These include:

* **Tor Browser** for browsing the web anonymously and accessing Tor hidden
  service websites
* **OnionShare** for sharing files anonymously over Tor
* **Ricochet** for chatting anonymously of Tor
* **CoyIM** instant messager, which supports connecting to the *.onion*
  addresses for *XMPP/Jabber* chat servers

Other parts of Subgraph OS are engineered to integrate with Tor seamlessly. The
**Metaproxy** routes non-Tor applications over Tor. Our **Oz** sandbox also lets
applications work seamlessly with Tor. We also include a Gnome Shell extension
that monitors that status of connections to the Tor network. Lastly,
**ROFLCopTor** is a filter for the Tor control port that enforces security
policies on applications that run Tor control commands.

\newpage

