This is not the right way to do things and using ipset makes a lot more sense since that does not add as much overhead on iptables (firewald)

But I keep this here fore historical reasons.

this is more like an little extra to fail2ban which puts ip's to jail (iptables) if someone from that ip tries to break into the computer.

So for this to make sense then fail2ban has to be running.

but every time fail2ban is restarted then it clears the iptables and this script puts ip's back in based on the /var/log/fail2ban.log but in there are all the ip's that fail2ban banned, well you know what I mean.

JO
Hjölli
