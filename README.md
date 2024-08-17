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

Open terminal with admin permission and run `nats.ps1`,  
script will preview all of your incoming firewall rules going to be disabled.  
Rules in "Core Network" and "Remote Desktop" groups are untouched.  
If you find no errors in preview, run `nats.ps1 -Sure` to apply.  
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

## Access control
You may have ports only want to expose to Private IPv4 address.  
In this case, under rules properties, go to "Scope",  
insert your range to "Local IP address, These IP address".  
For example, IP `192.168.1.x`, mask `255.255.255.0` is `192.168.1.0/24`.

Leave "Remote IP address" untouched (Any IP address), in this case,  
your rules will not allow ports to be accessed from IPv6 address.

## Windows Update keeps enable unwanted rules
`nats.ps1` has a parameter to filter rules, accept array as input:  
```
nats.ps1 -Ignores "CustomRule_"
nats.ps1 -Ignores "CustomRule_","Wireless Display"
```
If a rule name contains one or one of the multiple values,  
it will be untouched, otherwize disable it.  
If you find no errors, create task scheduler task run at startup:
```
powershell -Command "C:\path\to\nats.ps1" -Ignores "CustomRule_","Wireless Display" -Sure
```
Do not use `powershell -File`, otherwize array input will not work, can't pass multiple values in.

## `dump.ps1`
You can use this script to determine what process are listening on what IPv4 ports,  
so you can config IPv4 port forwarder properly for programs lack documents.  
The script only handle IPv4, for IPv6, add firewall rules by program should fit  
because there is no NATs.

Example:
```
.\dump.ps1 -Hosts 192.168.1.100`
.\dump.ps1 -Hosts 192.168.1.100,172.16.1.100`
```
Hosts parameter to specify one or multiple listen address to filter.  
`127.0.0.1` and `0.0.0.0` will always append to Hosts.

Example:
```
.\dump.ps1 -Hosts 192.168.1.100 -ProcessNames steam
```
Once you confirmed the process name, you can filter by process name.
