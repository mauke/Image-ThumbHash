use strict;
use warnings;

return {
    NAME               => 'Image::ThumbHash',
    AUTHOR             => q{Lukas Mai <l.mai@web.de>},
    LICENSE            => 'perl',

    MIN_PERL_VERSION   => '5.10.0',
    CONFIGURE_REQUIRES => {},
    BUILD_REQUIRES     => {},
    TEST_REQUIRES      => {},
    PREREQ_PM          => {
        'strict'       => 0,
        'warnings'     => 0,
        'Carp'         => 0,
        'Exporter'     => 5.57,
        'MIME::Base64' => 0,
        'List::Util'   => 0,
    },
    DEVELOP_REQUIRES   => {
        'Test::Pod' => 1.22,
    },

    REPOSITORY => [ github => 'mauke' ],
};
