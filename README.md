growlnotify
===========

What is it?
-----------
It's a pair of pretty simple perl scripts to pop up Growl notifications when someone hilights or queries you
in your irssi session which you are connected to via SSH.

How does it work?
-----------------
The irssi plugin is currently set up so that it reacts to query windows changing to hilighted state (so you
get a notification when someone sends you a message, but not again when you already have the query window open)
as well as hilights (so you get a notification when someone mentions your name).

It then connects to a local port tunnelled through SSH to your local machine where the second perl script
listens and sends a UDP packet to Growl.

Aren't there many other ways to do this already?
------------------------------------------------
Yes, but none of them worked for me.

iTerm2 supports Growl notifications via terminal escape sequences, but they don't work through GNU screen
because screen filters out non-standard escape sequences.

Some people use a second SSH connection to tail -f a notification file written to by fnotify.pl. Some people
tunnel their local SSH port through the SSH connection to the irssi host, which then connects back to the
local host via SSH for every notification. That just seemed excessive and way too complicated.

Simply tunnelling the Growl port via SSH isn't possible out of the box because it uses UDP (in theory, it should
be possible to send notifications via Growl's TCP port too, but I couldn't get that to work). There is a new protocol
called GNTP that uses TCP, but it's only supported by Growl 1.3 which has gotten a lot of bad reviews so I'm
still using 1.2.2.

My solution is as simple as it gets without requiring Growl 1.3.

How do I use it?
----------------
1. Ensure you have IO::Socket::INET on both your irssi host and your local host as well as Net::Growl on your local host
(available via CPAN).
2. Enable network connections in your Growl configuration and choose a password.
3. Add a tunnel for port 9999 to your irssi SSH connection (-R 9999:127.0.0.1:9999). I recommend adding -q as well
so it doesn't spam you with error messages if the local script isn't running.
4. Add your Growl password to growlproxy.pl and start it in the background on your local machine.
5. Put growlnotify.pl in your .irssi/scripts directory and load it into irssi.

Known issues
------------
* Special characters (such as German Umlauts) don't work correctly
* Probably full of bugs, bad coding style, security issues, etc.

