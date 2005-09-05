package MMS::ProviderMailParser::UKVodafone;

use warnings;
use strict;

use base 'MMS::ProviderMailParser';

use MIME::Entity;
use MMS::MailMessage::ProviderParsed;
use HTML::TableExtract;

=head1 NAME

MMS::ProviderMailParser::UKVodafone - This provides a class for parsing an MMS::MailMessage object that has been sent via the UK Vodafone network.

=head1 VERSION

Version 0.02

=cut

our $VERSION = '0.02';

=head1 SYNOPSIS

This static class provides a parse method for parsing an MMS::MailMessage into an MMS::MailMessage::ProviderParsed message for MMS messages sent from the UK Vodafone network.

=head1 METHODS

The following are the top-level methods of the MMS::ProviderMailParser::UKVodafone class.

=head2 Constructor

=over

=item new()

Return a new MMS::ProviderMailParser::UKVodafone object.

=back

=head2 Regular Methods

=over

=item parse MMS::MailMessage

The parse method can be called as a class method or an instance method, normally it will be invoked as a class method.  It parses the MMS::MailMessage and returns an MMS::MailMessage::ProviderParsed.

=back

=head1 AUTHOR

Rob Lee, C<< <robl@robl.co.uk> >>

=head1 BUGS

Please report any bugs or feature requests to
C<bug-mms-providermailparser-ukvodafone@rt.cpan.org>, or through the web interface at
L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=MMS-ProviderMailParser-UKVodafone>.
I will be notified, and then you'll automatically be notified of progress on
your bug as I make changes.

=head1 NOTES

To quote the perl artistic license ('perldoc perlartistic') :

10. THIS PACKAGE IS PROVIDED "AS IS" AND WITHOUT ANY EXPRESS OR IMPLIED
    WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED WARRANTIES
    OF MERCHANTIBILITY AND FITNESS FOR A PARTICULAR PURPOSE.

=head1 ACKNOWLEDGEMENTS

As per usual this module is sprinkled with a little Deb magic.

=head1 COPYRIGHT & LICENSE

Copyright 2005 Rob Lee, all rights reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

=cut

sub parse {

  my $self;
  if (MMS::ProviderMailParser::_isobject(@_)) {
    $self = shift;
  }

  my $message = shift;

  unless (defined $message) {
    return undef;
  }

  my $parsed = new MMS::MailMessage::ProviderParsed($message);

  my $htmltext=undef;
  foreach my $element (@{$parsed->attachments}) {
    if ($element->mime_type eq 'text/html') {
      $htmltext = $element->bodyhandle->as_string;
    } elsif ($element->mime_type =~ /jpeg$/) {
      my $header = $element->head;
      if ($header->recommended_filename() !~ /(images\/vf3\.jpg|images\/vf4\.jpg|images\/vf6\.jpg)/) {
        $parsed->add_picture($element);
      }
    } elsif ($element->mime_type =~ /avi$/) {
        $parsed->add_video($element);
    }
  }

  unless (defined $htmltext) {
    return undef;
  }

  my $te1 = new HTML::TableExtract( depth => 0, count => 3 );
  $te1->parse($htmltext);
  foreach my $ts1 ($te1->table_states) {
    foreach my $row1 ($ts1->rows) {
      foreach my $ele (@$row1) {
        if ($ele ne '') {
          $parsed->subject($ele);
        }
      }
    }
  }

  my $te2 = new HTML::TableExtract( depth => 1, count => 0 );
  $te2->parse($htmltext);
  my $text;
  foreach my $ts2 ($te2->table_states) {
    foreach my $row2 ($ts2->rows) {
      $text = join('\n', @$row2);
    }
    $parsed->text($text);
  }

  return $parsed;

}


1; # End of MMS::ProviderMailParser::UKVodafone
