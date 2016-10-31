## Preventing unauthorized USB access with USB Lockout

**USB Lockout** is a background feature in Subgraph OS. It protects your 
computer from unauthorized USB access while your desktop session is locked or 
you have logged out.

**USB Lockout** is intended for situations where your computer must be left
unattended for short periods. Particularly, in situations where you do not fear
your computer will be stolen but you do do not want to expose it to other risks 
while unattended. 

Normally, when you lock the screen or logout, people may still insert a
malicious USB device into the computer. While the computer is running, a
malicious device can easily compromise it. **USB Lockout** denies all access for
new USB devices while the screen is locked or the user is logged out.

**USB Lockout** works by monitoring the state of the desktop session. When the
session is locked or logged out, **USB Lockout** enables the Grsecurity *Deny
New USB* setting. When the user unlocks the screen or logs back in, this setting
is disabled, allowing access to new USB devices once again.

See the following page page for more information about the Grsecurity *Deny New
USB* feature:

```
https://en.wikibooks.org/wiki/Grsecurity/Appendix/Grsecurity_and_PaX_Configuration_Options#Deny_new_USB_connections_after_toggle
```
### Enabling/disabling USB Lockout

While **USB Lockout** runs automatically in the background, you can manually
*enable* or *disable* it.

Run the following command to *enable* **USB Lockout**:
```{bash}
$ usblockout --enable
```

Run the following command to *disable* **USB Lockout**:
```{bash}
$ usblockout --disable
```

\newpage

