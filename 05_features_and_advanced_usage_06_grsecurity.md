## Hardening the operating system and applications with Grsecurity

**Grsecurity** is a third-party security enhancement to the Linux kernel. It is 
developed and maintained by the **Grsecurity** team. It is implemented as a patch
to the upstream Linux kernel. Subgraph OS ships with a kernel that is patched
with **Grsecurity**.

For more information about **Grsecurity**, see the following page:

https://grsecurity.net/

### Configuring PaX flags with Paxrat

**Paxrat** is a utility in Subgraph OS for maintaining the *PaX flags* of
applications on the computer. 


> *What is PaX?*
>
> *PaX* is a feature of *Grsecurity* that provides *memory protection*. Many security
> vulnerabilities in applications and the Linux kernel allow attackers to 
> corrupt process memory. *Memory corruption* can be exploited to run the
> attackers *payload* of malicious code.
>
> PaX protects the computer from *memory corruption* using a number of novel
> techniques such as:
>
> 1. Randomizing the layout of process memory or *ASLR* (Address Space Layout
>    Randomization), making it harder for attackers to guess where their
>    malicious *payload* is stored in process memory
> 2. Making memory pages *non-executable*, meaning that an attacker's *payload*
>    cannot run if stored in *non-executable* memory
>
> *PaX* includes other *memory protection* and *control flow integrity* features
> so that it is more difficult for attackers to exploit *memory corruption*
> vulnerabilities in applications and the kernel.
>
> *PaX* does not prevent all vulnerabilities but it complicates attacks. The
> difference to an attacker is that with *PaX* they may be required to exploit
> multiple vulnerabilities to achieve the same effect as a single vulnerability.
>
> More information about *PaX* can be found here:
>
> https://pax.grsecurity.net/

*PaX* works by killing applications that violate its security policies. This
*proactively* prevents attacks from succeeding. However, as part of their normal
functions, some applications perform non-malicious actions that violate the
security policies. *PaX flags* are exceptions to these policies. They let
applications run normally without being killed by *PaX* when they perform an
action that appears to violate policies.

Applications such as web browsers need *PaX flags* to be set because they
perform actions such as *JIT* (Just in Time compilation). To *PaX*, *JIT* has
the same profile as an attack. Applications that use a *JIT* compiler
must be flagged as exceptions so that they are not killed.

**Paxrat** keeps track of the *PaX flags* for applications in Subgraph OS. It is 
designed to maintain the *PaX* flags between application updates. **Paxrat** 
runs when the system updates software, automatically re-applying flags to
upgraded applications.

**Paxrat** can only maintain the flags it knows about. If a user discovers that 
*PaX* is killing an application, the configuration must be changed to disable 
some *PaX flags*. Instructions are provided in this guide for changing the 
**Paxrat** configuration. We also advise users to report the exception to us so 
that we can update the configuration for everybody.

**Paxrat** configuration files are written in JSON. They are stored in the 
following directory:
```
/etc/paxrat
```

The following is a snippet of a *PaX flag* configuration for **Tor Browser**:
```{.javascript}
"/home/user/.local/share/torbrowser/tbb/x86_64/tor-browser_en-US/Browser/firefox":
{
    "flags": "m",
    "nonroot": true
}
```

> **Paxrat configuration options**
>
> The first line of the configuration (in quotes) is the path to the
> application.
> In the above example, it is:
> "/home/user/.local/share/torbrowser/tbb/x86_64/tor-browser_en-US/Browser/firefox"
> 
> *flags*: This a string of letters representing the various PaX flags
> 
> *nonroot*: This indicates whether the application is owned by the *root* user 
> or not, it is *false* by default but *true* in the example because the 
> **Tor Browser** application is owned by a normal user
> 
> **NOTE**: As a security precaution, **Paxrat** will not apply *PaX flags* to 
> an application that is owned by a *nonroot* user unless the *nonroot* option 
> is set to *true*.

There are a number of different *PaX flags* that can be *enabled* or *disabled*.
Most are *enabled* by default and must be *disabled*. *Disabled* flags are
represented by a lower-case letter such as **m**. Upper-case letters such as
**M** represent *enabled* flags.

> **PaX flags**
>
> *P/p*: *Enable/disable* PAGEXEC
>
> *E/e*: *Enable/disable* EMUTRAMP
>
> *M/m*: *Enable/disable* MPROTECT
>
> *R/r*: *Enable/disable* RANDMAP
>
> *X/x*: *Enable/disable* RANDEXEC
> 
> *S/x*: *Enable/disable* SEGMEXEC
>
>
> A detailed description of these flags can be found on the following page:
>
> https://en.wikibooks.org/wiki/Grsecurity/Appendix/PaX_Flags

Working examples can be found in the Subgraph OS **Paxrat** configuration files:
```
/etc/paxrat/paxrat.conf
```

### Applying PaX flags

*PaX flags* must be re-applied after any configuration changes. Run the
following command to re-apply *PaX flags*:
```
$ sudo paxrat
```

\newpage
