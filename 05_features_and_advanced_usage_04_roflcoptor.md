# Securing the Tor control port with ROFLCopTor

The Tor service is managed by a control protocol. This lets users perform
various actions such as querying information about Tor connections, starting
hidden services, and changing configuration options. However, most applications do not
need all of these features. These extra features may actually introduce security
and privacy risks if someone gains unauthorized access to the control port. To
mitigate these risks, Subgraph OS includes a control port filter called
*ROFLCopTor*.

*ROFLCopTor* is a proxy server that is placed between Tor control clients and the
Tor control server port. *ROFLCopTor* handles authentication itself, meaning 
clients do not need to know the authentication credentials or run with higher
privileges to access to Tor control port. It intercepts the incoming commands 
and outgoing responses. *ROFLCopTor* enforces policies on a per-application 
basis for the traffic between the Tor control clients and the server.

*ROFLCopTor* supports policies that are bi-directional. This means that a policy 
can filter both the incoming commands and the outgoing responses from the Tor 
control port. Policies can also replace command and response strings.
Replacements can be used to filter sensitive information from Tor control port
responses.

*ROFLCopTor* has a number of default policies for applications in Subgraph OS that
require access to the Tor control port. The policies work without modification
for most use-cases. This section describes how to profile applications to create
new policies or modify existing ones.

## Profiling applications with ROFLCopTor

*ROFLCopTor* can profile applications to determine the Tor control commands that
they run on a regular basis. This makes it easier to create or edit policies.

Before profiling applications, you should stop the currently running version of
*ROFLCopTor*:
```{bash}
$ sudo systemctl stop roflcoptor
```

To begin profiling, you must start *ROFLCopTor* in *watch* mode:
```{bash}
$ sudo -u roflcoptor roflcoptor watch -log_level DEBUG -config /etc/roflcoptor/roflcoptor_config.json  

```

The log shows some of the commands that applications tried to run:
```
18:21:53 - DEBU 017 connection received tcp:127.0.0.1:44860 ->
tcp:127.0.0.1:9051
18:21:55 - ERRO 018 filter policy for gnome-shell-torstatus DENY: A->T: [GETCONF
ORPort]
18:21:55 - ERRO 019 filter policy for gnome-shell-torstatus DENY: A->T: [GETINFO
events/names]
18:21:55 - ERRO 01a filter policy for gnome-shell-torstatus DENY: A->T:
[SETEVENTS NOTICE NS NEWDESC NEWCONSENSUS]
18:21:55 - ERRO 01b filter policy for gnome-shell-torstatus DENY: A->T: [GETINFO
process/user]
18:21:55 - ERRO 01c filter policy for gnome-shell-torstatus DENY: A->T: [GETINFO
process/pid]
...
```

Press **Ctrl-C** to stop the *ROFLCopTor* watch process. Make sure to restart 
*ROFLCopTor* normally after you are done profiling. Run the following command to 
restart *ROFLCopTor*:
```{bash}
$ sudo systemctl restart roflcoptor
```

## Editing ROFLCopTor policies

Once you have a list of commands required by an application, you can create or
edit a policy.

*ROFLCopTor* policies are written in JSON. Policies can be found in the following
directory on Subgraph OS:
```
/etc/roflcoptor/filters/
```

The following is a simple policy for the Tor Status Gnome shell extension in
Subgraph OS:
```{javascript}
{
    "Name": "gnome-shell-torstatus",
    "AuthNetAddr" : "tcp",
    "AuthAddr" : "127.0.0.1:9051",
    "client-allowed" : ["GETINFO status/bootstrap-phase", "SIGNAL NEWNYM"],
    "client-allowed-prefixes" : [],
    "client-replacements" : {},
    "client-replacement-prefixes" : {},
    "server-allowed" : ["250 OK"],
    "server-allowed-prefixes" : ["250-status/bootstrap-phase="],
    "server-replacement-prefixes" : {}
}
```

> **ROFLCopTor policy configuration options**
>
> *Name*: The name of the application to apply the policy to
>
> *AuthNetAddr*: The protocol used by the Tor control port
>
> *AuthAddr*: The address of the Tor control port
>
> *client-allowed*: The list of commands allowed by the client
>
> *client-allowed-prefixes*: A list of prefixes for partial allowed client 
>commands (commands where the suffix varies)
>
> *client-replacements*: A list of commands to replace and their replacement
> strings
>
> *client-replacement-prefixes*: A list of client command prefixes to replace 
> and their replacement strings (for commands where the suffix varies)
>
> *server-allowed*: The list of responses allowed by the server
> 
> *server-allowed-prefixes*: A list of prefixes for partial allowed server 
> responses (responds where the suffix varies)
>
> *server-replacement-prefixes*: A list of server response prefixes to replace
> and their replacement strings (for responses where the suffix varies)

The most common configuration task is to add new commands and responses to the
*client-allowed*, *client-allowed-prefixes*, *server-allowed*, and
*server-allowed-prefixes* options. 

More documentation on configuring and using ROFLCopTor is located on the
following page:
https://github.com/subgraph/roflcoptor

\newpage

