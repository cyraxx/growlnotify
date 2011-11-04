use strict;
use vars qw($VERSION %IRSSI);

use IO::Socket;
use Irssi;
#use Data::Dumper;

$VERSION = '42';
%IRSSI = (
	authors     => 'Andreas Reich',
	contact     => 'andreas@reich.name',
	name        => 'growlnotify',
);

sub win_text {
	my ($dest, $text, $stripped) = @_;
	if ($dest->{level} & MSGLEVEL_HILIGHT) {
		notify($dest->{target}. ": " .$stripped );
	}
}

sub win_hilight {
	my($window) = @_;
	my $winitem = $window->{active};
	#print Dumper($window) if $winitem->{type} eq 'QUERY';
	notify('Private message from ' . $winitem->{name}) if $winitem->{type} eq 'QUERY' && $window->{data_level} >= 3;
}

sub notify {
	my ($text) = @_;
	my $sock = new IO::Socket::INET(PeerAddr => '127.0.0.1', 'PeerPort' => 9999, 'Proto' => 'tcp');
	if($sock) {
		print $sock $text . "\n";
		close($sock);
	}
}

Irssi::signal_add_last('print text', 'win_text');
Irssi::signal_add_last('window hilight', 'win_hilight');

