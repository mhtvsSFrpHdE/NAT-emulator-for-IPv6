# NAT-emulator-for-IPv6
[Fanboy" series - IPv6 and NATs](https://www.youtube.com/watch?v=v26BAlfWBm8)

> NATs are good.  
> IPv4 address exhaustion is not a problem at all because we have NATs.  
> I have a perfectly running network.  
> NATs provides free security, my network is not seen from outside.  
> NATs makes me comfortable.

## What is this
So you are entering IPv6 world and realize  
you lost the egg shell provided by IPv4 NAT.  
In IPv6 world, you use firewall to block incoming connections.

However, Windows Firewall by default expose many ports.  
It is not a IPv4 NAT equivalent.

This script help you control your Windows firewall rules,  
then you can block all incoming connections to  
let you can imagine you are using IPv4 NAT,  
with minimal broke to your system and recoverable as needed.

## How to use
Best start by backup your current firewall rules and  
"Restore Default Policy" to delete may unwanted changes.  
**WARNING: "Export list..." is not backup, look for "Export Policy..." instead.**  
**WARNING: this will turn off Remote Desktop and you can lock yourself out  
if you only have remote desktop session to the computer.  
Skip restore default if you can't enable Remote Desktop again.**

If you use Remote Desktop, edit rules under "Remote Desktop" group,  
limit access range to Private address like VPN address.  
See `Access control` in FAQ for more information.  
You may connect remote desktop via VPN, instead of expose 3389 on IPv6 address.

Change your network profile to "Public".  
You can't have two profiles for different address.  
In this case, treat your IPv6 network adapter as Public network,  
even if it also gets Private IPv4 address at the same time.  
See `Access control` in FAQ for more information.

Open terminal with admin permission and run `nats.ps1`,  
script will disable all of your incoming firewall rules.  
Rules in "Core Network" and "Remote Desktop" groups are untouched.  
The result is you don't have any incoming connections  
and should be able to be verified by TCP and UDP port scanner.

Enable required rules manually. They may be  
Network discovery, WINS, Samba file sharing, ICMP ping...

Append your own rules by "New Rule..." to allow your  
application and service to have incoming connection,  
like how you do port forwarding in IPv4 NAT.

# Troubleshooting (FAQ)
## Behind
By default, Windows Firewall doesn't allow incoming connections.  
You get ports on port scanner because Windows have built-in rules allowed them.

We discovered delete rules lead to no incoming connections,  
but later some services are broken.  
Disable is better than delete in this case, can be easily undo.

If "Core Network" is disabled, IPv6 and certain IPv4 feature will broken.  
For example you can't listen on IPv6 SLAAC address, etc.

## Access control, Private network with Public profile
Now all interface with IPv6 address is Public profile.  
You may have ports only want to expose to Private IPv4 address.  
In this case, under rules properties, go to "Scope",  
insert your range to "Local IP address, These IP address".  
For example, IP `192.168.1.x`, mask `255.255.255.0` is `192.168.1.0/24`.

Leave "Remote IP address" untouched (Any IP address), in this case,  
your rules will not allow ports to be accessed from IPv6 address.
