package UAV::Pilot::Video::Ffmpeg;
use v5.14;
use warnings;
use Moose;
use namespace::autoclean;

our $VERSION = 0.1;


no Moose;
__PACKAGE__->meta->make_immutable;
1;
__END__


=head1 NAME

    UAV::Pilot::Video::Ffmpeg

=head1 DESCRIPTION

Hooks into the ffmpeg library to decode video frames in real-time.

=cut
