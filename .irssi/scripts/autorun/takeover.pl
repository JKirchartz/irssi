# Takeover (IRSSI Channel Takeover Script)
# Developed by acidvegas in Perl (thanks to munki/www/mr_vile for help)
# http://github.com/acidvegas/irssi
# takeover.pl

# Usage: /takeover <KICK/TOPIC MESSAGE>
# The script will +eI your username so if you get *:Lined you can still ban/invite evade using the same username on a different host.

use strict;
use Irssi;
use Irssi::Irc;

sub takeover {
    my ($data, $server, $channel) = @_;
    Irssi::printformat(MSGLEVEL_CLIENTCRAP, "takeover_crap", "Not connected to server."),        return if (!$server or !$server->{connected});
    Irssi::printformat(MSGLEVEL_CLIENTCRAP, "takeover_crap", "No active channel in window."),    return if (!$channel or ($channel->{type} ne "CHANNEL"));
    my $own_prefixes = $channel->{ownnick}{prefixes};
    Irssi::printformat(MSGLEVEL_CLIENTCRAP, "takeover_crap", "You are not a channel operator."), return if (!$own_prefixes =~ /~|&|@|%/);
    my ($username, $hostname) = split(/@/, $channel->{ownnick}{host});
    my @nicknames = grep { $username ne $_->{nick} } $channel->nicks();
    my %modes = qw(! q ~ q & a @ o % h);
    for my $name (@nicknames) {
        for (split '', $name->{prefixes}) {
            $a .= "$modes{$_}"     if $modes{$_};
            $b .= "$name->{nick} " if $modes{$_};
        }
    }
    $channel->command("MODE -$a $b");
    $channel->command("kickban " . join(",", map { $_->{nick} } @nicknames) . " $data");
    $channel->command("mode +imklbeeII loldongs 1 *!*@* *!*\@$hostname *!$username@* *!*\@$hostname *!$username@*");
    $channel->command("topic $data");
}

Irssi::theme_register(['takeover_crap', '{line_start}{hilight takeover:} $0',]);
Irssi::command_bind('takeover', 'takeover');