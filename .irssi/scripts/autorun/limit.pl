use strict;
use Irssi;
use Irssi::Irc;

our $VERSION = '1.0';
our %IRSSI = (
    authors     => 'acidvegas',
    contact     => 'acidvegas@supernets.org',
    name        => 'Limit',
    description => 'A script to limit channel users in a timed interval with timer.pl usage.',
    license     => 'ISC',
    url         => 'http://github.com/acidvegas/irssi',
);

sub limit {
    my ($data, $server, $channel) = @_;
    my @nicklist = $channel->nicks();
    my $totalnicks = scalar @nicklist;
    my $limit_num = $totalnicks + 10;
    $channel->command("mode +l $limit_num");
}

Irssi::command_bind('limit', 'limit');