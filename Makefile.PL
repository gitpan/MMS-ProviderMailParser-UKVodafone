use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME                => 'MMS::ProviderMailParser::UKVodafone',
    AUTHOR              => 'Rob Lee <robl@robl.co.uk>',
    VERSION_FROM        => 'lib/MMS/ProviderMailParser/UKVodafone.pm',
    ABSTRACT_FROM       => 'lib/MMS/ProviderMailParser/UKVodafone.pm',
    PL_FILES            => {},
    PREREQ_PM => {
        'Test::More' => 0,
	'MMS::MailMessage::ProviderParsed' => 0.02,
	'HTML::TableExtract' => 0,
	'MMS::ProviderMailParser' => 0.02
    },
    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean               => { FILES => 'MMS-ProviderMailParser-UKVodafone-*' },
);
