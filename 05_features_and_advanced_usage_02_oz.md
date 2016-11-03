## Sandboxing applications with Subgraph Oz

Subgraph OS runs desktop applications inside of our security sandbox (Oz). The 
security sandbox is an additional layer of security, above and beyond the other
security features of Subgraph OS. Subgraph OS is hardened to make it very
difficult for an attacker to compromise applications. However, it is impossible 
to prevent every vulnerability. If an attacker compromises an application, Oz
can help to protect against further compromise of the computer and the user's 
sensitive files.

Oz can provide the following protections to sandboxed applications:

* Restrict the files that the application has access to
* Restrict network access
* Restrict audio playback 
* Restrict the system calls the application can make (using **seccomp**)
* Restrict malicious interactions between X11 applications (using **xpra**)

Each sandboxed application has its own policies to restrict its capabilities.

The following table shows some of the sandbox policies in Subgraph OS:

Application    Category           Network?    Audio?
-----------   --------           --------    ------
Tor Browser    Browser            Proxy port  Yes
Icedove	       Email client       Proxy port  No
CoyIM          Instant messager   Proxy port  No
Ricochet       Instant messager   Proxy port  No
Hexchat	       IRC client         Proxy port  No
OnionShare     File sharing       Proxy port  No
VLC            Video player       No          Yes
LibreOffice    Office suite       No          No
Evince         PDF reader         No          No
Eog            Image Viewer       No          No

\newpage

Oz also sandboxes desktop applications from each other. Normally, applications
running under the X11 display server can interact with each other. This means
that one application can intercept or inject events into another application.

Without Oz or an alternate display server, there is no way to securely prevent
applications from interacting with each other. An attacker could abuse this to
perform malicious actions such as intercepting the keystrokes from another
desktop application. To prevent these attacks, Oz sandboxes use **xpra** to render
applications on the desktop. **Xpra** isolates applications by using a separate
display server to render each application. Since the applications do not share
the same display server, they cannot interact.

For more technical details about Oz and its security features, see the following
page:

https://github.com/subgraph/oz/wiki/Oz-Technical-Details


\newpage

### Enabling an Oz profile

Oz profiles can be found in the following directory:
```
/var/lib/oz/cells.d
```

Oz automatically enables profiles in this directory. However, if you need to
manually enable a profile, you can do so by running the **oz-setup** command to
*install* the profile. 

The following example installs the profile for **evince**:
```{.bash}
$ sudo oz-setup install evince
```

When the profile is installed, Oz will *divert* the path of the program
executable. Instead of the program running directly, diverting it lets Oz start
the program. So the next time it is started, the program will be sandboxed by 
Oz.

### Disabling an Oz profile

If you want to run a previously sandboxed program outside of the sandbox, you
must disable its profile. To disable a profile, run the **oz-setup** command 
with the *remove* option.

The following example removes the profile for **evince**:
```{.bash}
$ sudo oz-setup remove evince
```

When the profile is removed, Oz will undo the *divert* of the program path. The
program will not run in the Oz sandbox the next time it is started.

### Viewing the status of an Oz profile

The status of a program can also be viewed with the **oz-setup** command.

The following example shows the status of **evince**:
```{.bash}
$ sudo oz-setup status /usr/bin/evince
```

The command prints the following when **evince** profile is installed:
```
Package divert is installed for:     /usr/bin/evince
Package divert is installed for:     /usr/bin/evince-thumbnailer
Package divert is installed for:     /usr/bin/evince-previewer
```

When the **evince** profile is not installed, the command prints the following:
```
Package divert is not installed for: /usr/bin/evince
Package divert is not installed for: /usr/bin/evince-thumbnailer
Package divert is not installed for: /usr/bin/evince-previewer
```

\newpage

### Creating an Oz profile

In this section, we will walk through some of the options in a basic profile.

Oz profiles are written in JSON.

The following is the Oz profile for the **eog** image viewer:
```{.javascript}
{
 "name": "eog"
 , "path": "/usr/bin/eog"
 , "allow_files": true
 , "xserver": {
         "enabled": true
         , "enable_tray": false
         , "tray_icon":"/usr/share/icons/hicolor/scalable/apps/eog.svg"
 }
 , "networking":{
         "type":"empty"
 }
 , "whitelist": [
         {"path":"/var/lib/oz/cells.d/eog-whitelist.seccomp", "read_only": true}
 ]
 , "blacklist": [
 ]
 , "environment": [
         {"name":"GTK_THEME", "value":"Adwaita:dark"}
         , {"name":"GTK2_RC_FILES",
"value":"/usr/share/themes/Darklooks/gtk-2.0/gtkrc"}
 ]
 , "seccomp": {
         "mode":"whitelist"
         , "enforce": true
         , "whitelist":"/var/lib/oz/cells.d/eog-whitelist.seccomp"
 }
 }
```

> **Example Oz profile configuration options**
>
> *name*: The name of the profile
>
> *path*: The path to the program executable
>
> *allow_files*: Allow files to be passed as arguments to the program (such as
> image files for **eog**)
>
> *xserver -> enabled*: Enable the use of the Xserver (**xpra**)
>
> *xserver -> enable_tray*: Enable the **xpra** diagnostic tray (defaults to
> `false`, enabling it requires extra software)
>
> *xserver -> tray_icon*: The path to the tray icon
>
> *networking -> type*: The networking configuration type, *empty* disables
> networking entirely
>
> *whitelist -> path*: The path of a file to add to the sandbox, in this case it
> is the *seccomp whitelist* for **eog**
>
> *whitelist -> path -> read_only*: Whether or not the allowed file is
> *read-only*, should be *true* in most cases
>
> *blacklist*: Removes access to a file in the sandbox, accepts the *path*
> argument
>
> *environment -> name, value*: Adds environment variables by name and value to
> the sandbox
>
> *seccomp -> mode*: Adds a seccomp policy (either *whitelist* or *blacklist*) 
> to the sandbox
>
> *seccomp -> enforce*": The seccomp enforcement mode
>
> *seccomp -> whitelist*: The path to the whitelist policy

Oz supports a number of different profile configurations. More examples for real
applications are located in the profiles directory:
```
/var/lib/oz/cells.d
```

Complete documentation for creating Oz profiles can be found here:

https://github.com/subgraph/oz 

\newpage

### Securing system calls with seccomp in Oz

*Seccomp* is a feature of the Linux kernel to limit exposed system calls. As
system calls provide a user interface to the kernel, they expose it to attacks.
These attacks can let an attacker elevate their privileges on the computer. The
Oz sandbox uses *seccomp* to protect against this type of attack.

Oz supports *seccomp* policies on a per-application basis. *Seccomp* kills
applications whenever they violate a policy. This protects the computer in cases
where an attacker tries to exploit a vulnerability in the kernel that depends on 
the blocked system call. 

Some attacks also use system calls as part of their *payload*. A *payload* is 
the malicious code that runs as a result of a successful exploit. The *seccomp* 
policies in Oz can prevent *payloads* from running if they use a blocked system 
call.

Oz supports **whitelist** or **blacklist** policies. Whitelist policies are *default
deny*. This means that only system calls that are explicitly permitted will be
allowed. All other system calls (those not on the **whitelist**)  cause the 
application to be killed. 

**Blacklist** policies are *default allow*. This means that seccomp blocks system
calls in the blacklist policy but allows all others (those not on the
**blacklist**). 

**Whitelist** policies are appropriate when the application is well understood.
By well understood, we mean that the behavior of the application is predictable
enough to create a precise profile of allowed system calls. This is more secure
than a **blacklist** because known behavior of the application is allowed but
unknown behavior is blocked. The disadvantage of this approach is that the
**whitelists** must be updated regularly to reflect the known behavior of the
application.

**Blacklist** policies are appropriate for applications that are not as well
understood. We use them prior to the creation of a **whitelist** or if there is
some other reason a **whitelist** cannot be created. 

Oz includes a generic **blacklist** that will work out-of-the-box with many 
applications. This policy blocks unusual or exotic system calls that 
applications do not normally use.

The Oz generic **blacklist** is located here:
```
/var/lib/oz/cells.d/generic-blacklist.seccomp
```

In Subgraph OS, we try to create **whitelist** policies for all of our supported
applications.

\newpage

### Profiling applications with oz-seccomp-tracer

Oz includes a tool to help with the creation and maintenance of seccomp
**whitelists**. The **oz-seccomp-tracer** profiles applications as they run to
determine the system calls that they use. This tool will generate a seccomp
`whitelist` after it exits.  

To profile Firefox using **oz-seccomp-tracer**, run the following command:
```{.bash}
$ oz-seccomp-tracer -trace -output firefox-whitelist.seccomp /usr/bin/firefox \ 
2>firefox_syscalls.txt
```

You can then use Firefox as you normally would. When you are finished, a seccomp
**whitelist** will be saved to **firefox-whitelist.seccomp**. **oz-seccomp-tracer**
prints all of the system calls from the application to **stdout**. So we also
advise you to redirect this output to a separate file. We use
**firefox_syscalls.txt** in this example. You could also redirect this output to
**/dev/null** if you don't want to save it.

### Adding a seccomp policy to an Oz application profile

Once you are satisfied with the **whitelist**, you can copy it to the following
directory:
```
/var/lib/oz/cells.d
```
Using Firefox as an example, the following snippets from
*/var/lib/oz/cells.d/firefox.json* show how to apply the policy.

First, the seccomp policy file must be added to the list of files allowed in
the sandbox:
```{.javascript}
"whitelist": [
        , {"path":"/var/lib/oz/cells.d/firefox-whitelist.seccomp", 
                "read_only": true}
]
```

Then the seccomp policy needs to be enabled to run in *enforce* mode:
```{.javascript}
"seccomp": {
         "mode":"whitelist"
         ,
"whitelist":"/var/lib/oz/cells.d/firefox-whitelist.seccomp"
         , "enforce": true
}
```

Lastly, the Oz daemon must be restarted to load the seccomp policy. You
should save your work at this point as restarting Oz will close all of the open
sandboxes. To restart the Oz daemon, run the following command:
```{.bash}
$ sudo systemctl restart oz-daemon.service 
```

\newpage

