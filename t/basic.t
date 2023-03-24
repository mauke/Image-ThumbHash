use Test2::V0;
use Image::ThumbHash qw(
    rgba_to_thumb_hash
    rgba_to_png
    rgba_to_data_url
    thumb_hash_to_rgba
    thumb_hash_to_average_rgba
    thumb_hash_to_approximate_aspect_ratio
    thumb_hash_to_data_url
);
use MIME::Base64 qw(encode_base64 decode_base64);
use FindBin qw($Bin);
use Imager ();

like
    dies { () = thumb_hash_to_rgba 'abcd' },
    qr/\bthumb_hash_to_rgba: thumb hash length is less than 5\b/,
    "thumb_hash_to_rgba throws if argument too short";
like
    dies { my $dummy = thumb_hash_to_rgba 'abcdefg' },
    qr/\bthumb_hash_to_rgba: must be called in list context\b/,
    "thumb_hash_to_rgba dies in scalar context";

like
    dies { () = thumb_hash_to_average_rgba 'abcd' },
    qr/\bthumb_hash_to_average_rgba: thumb hash length is less than 5\b/,
    "thumb_hash_to_average_rgba throws if argument too short";
like
    dies { my $dummy = thumb_hash_to_average_rgba 'abcdefg' },
    qr/\bthumb_hash_to_average_rgba: must be called in list context\b/,
    "thumb_hash_to_average_rgba dies in scalar context";

{
    my $list = "$Bin/data/pngified.txt";
    open my $fh, '<', $list
        or die "Can't open $list: $!";
    while (my $spec = readline $fh) {
        my ($thumbhash_b64, $xratio, $xr, $xg, $xb, $xa, $expected_png_b64) = split ' ', $spec;
        my $hash = decode_base64 $thumbhash_b64;
        my $expected_png = decode_base64 $expected_png_b64;
        my $expected_url = "data:image/png;base64,$expected_png_b64";

        my @average_color = thumb_hash_to_average_rgba $hash;
        is \@average_color, [$xr, $xg, $xb, $xa];

        my $approx_aspect_ratio = thumb_hash_to_approximate_aspect_ratio $hash;
        is $approx_aspect_ratio, $xratio;

        my ($width, $height, $rgba) = thumb_hash_to_rgba $hash;

        my $png = rgba_to_png $width, $height, $rgba;
        is $png, $expected_png;

        my $url = rgba_to_data_url $width, $height, $rgba;
        is $url, $expected_url;

        my $url2 = thumb_hash_to_data_url $hash;
        is $url2, $expected_url;
    }
}

for my $known (
    ['sunrise.jpg', '1QcSHQRnh493V4dIh4eXh1h4kJUI'],
    ['firefox.png', 'YJqGPQw7sFlslqhFafSE+Q6oJ1h2iHB2Rw'],
) {
    my ($file, $expected_hash) = @$known;
    my $img = Imager->new;
    $img->read(file => "$Bin/data/$file") or die $img->errstr;
    $img = $img->convert(preset => 'addalpha');
    $img->write(type => 'raw', data => \my $data) or die $img->errstr;

    my $hash = rgba_to_thumb_hash $img->getwidth, $img->getheight, $data;
    (my $hash_b64 = encode_base64 $hash, '') =~ s/=+\z//;  # strip padding
    is $hash_b64, $expected_hash, "data/$file has expected thumb hash";
}

done_testing;
