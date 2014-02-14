use Test::More tests => 8;
use v5.14;
use UAV::Pilot;
use UAV::Pilot::Video::H264Decoder;
use UAV::Pilot::Video::Mock::RawHandler;
use Test::Moose;

use constant VIDEO_DUMP_FILE => 't_data/frame.h264';


my $display = UAV::Pilot::Video::Mock::RawHandler->new({
    cb => sub {
        my ($self, $width, $height, $decoder) = @_;
        cmp_ok( $width,  '==', 640, "Width passed" );
        cmp_ok( $height, '==', 360, "Height passed" );

        isa_ok( $decoder => 'UAV::Pilot::Video::H264Decoder' );

        my $pixels = $decoder->get_last_frame_pixels_arrayref;
        cmp_ok( ref($pixels), 'eq', 'ARRAY', "Got array ref of pixels" );
        cmp_ok( scalar(@$pixels), '==', 3, "Got 3 channels in YUV420P format" );
    },
});
my $display2 = UAV::Pilot::Video::Mock::RawHandler->new({
    cb => sub {
        pass( "Got stacked handler" );
    },
});
my $video = UAV::Pilot::Video::H264Decoder->new({
    displays => [ $display, $display2 ],
});
isa_ok( $video => 'UAV::Pilot::Video::H264Decoder' );
does_ok( $video => 'UAV::Pilot::Video::H264Handler' );


my @frame;
open( my $fh, '<', VIDEO_DUMP_FILE )
    or die "Can't open " . VIDEO_DUMP_FILE . ": $!\n";
while( read( $fh, my $buf, 4096 ) ) {
    push @frame, unpack( 'C*', $buf );
}
close $fh;


$video->process_h264_frame( \@frame, 640, 480, 640, 480 );
