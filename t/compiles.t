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

pass "at least it compiles";

todo "write some actual tests" => sub {
    fail "not implemented";
};

done_testing;
