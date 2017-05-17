# Takeover (IRSSI Channel Takeover Script)
# Developed by acidvegas in Perl (thanks to munki/www for help)
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
    my @nicknames = grep { !/$server->{nick}/ } map {$_->{nick}} $channel->nicks();
    my @qops      = grep { !/$server->{nick}/ } map { $_->{prefixes} =~ /[~!]/ ? $_->{nick} : () } $channel->nicks();
    my @aops      = grep { !/$server->{nick}/ } map { $_->{prefixes} =~ /[&]/  ? $_->{nick} : () } $channel->nicks();
    my @hops      = grep { !/$server->{nick}/ } map { $_->{halfop}             ? $_->{nick} : () } $channel->nicks();
    my @ops       = grep { !/$server->{nick}/ } map { $_->{op}                 ? $_->{nick} : () } $channel->nicks();
    $channel->command("mode -" . "q" x @qops . "a" x @aops . "h" x @hops . "o" x @ops . " @qops @aops @hops @ops");
    $channel->command("kickban " . join(",", @nicknames) . " $data");
    $channel->command("mode +imbeeII *!*@* *!*\@$hostname *!$username@* *!*\@$hostname *!$username@*");
    $channel->command("topic $data");
}

Irssi::theme_register(['takeover_crap', '{line_start}{hilight takeover:} $0',]);
Irssi::command_bind('takeover', 'takeover');
