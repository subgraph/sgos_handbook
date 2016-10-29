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
