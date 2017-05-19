use strict;
use Irssi;
use Irssi::Irc;
sub send_greet {
  my ($channel) = @_;
  my $msg = Irssi::settings_get_str('greet_message');
  $channel->command("/msg ".$channel->{name}." ".$msg);

}

sub event_channel_sync {
  my ($channel) = @_;
  Irssi::timeout_add_once( 50000, &send_greet, $channel, );
}
Irssi::settings_add_str('misc', 'greet_message', "<-");
Irssi::signal_add_last('channel sync', 'event_channel_sync');
