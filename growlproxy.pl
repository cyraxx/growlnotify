#!/usr/bin/perl

# growlproxy.pl
# proxies messages from tcp 9999 to local growl (udp 9887)
# run this on your local machine

use strict;
use Net::Growl;
use IO::Socket;

my $appname = 'irssi';
my $password = 'changeme';

sub send_packet {
	my($payload) = @_;

	my $sock = IO::Socket::INET->new(PeerAddr => '127.0.0.1', PeerPort => '9887', Proto => 'udp');
	if(!$sock) {
		print STDERR "Could not connect: $!\n";
		return;
	}
	print $sock $payload;
	close($sock);
}

my $p = Net::Growl::RegistrationPacket->new(application => $appname, password => $password);
$p->addNotification();
send_packet($p->payload);

my $sock = new IO::Socket::INET(LocalHost => '127.0.0.1', LocalPort => '9999', Proto => 'tcp', Listen => 1, Reuse => 1) or die("Could not create socket: $!");

while(defined(my $client = $sock->accept())) {
	my $text = <$client>;
	$p = Net::Growl::NotificationPacket->new(application => $appname, title => 'irssi', description => $text, password => $password);
	send_packet($p->payload());
	close($client);
}

