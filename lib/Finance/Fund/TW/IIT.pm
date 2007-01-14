package Finance::Fund::TW::IIT; 
use Spiffy -Base;
use WWW::Mechanize;
use HTML::TableExtract;
use Data::Dumper;
use Encode qw/from_to/;

our $VERSION = '0.1';

sub new() {
	my $class = shift;
	my %args = @_;
	bless \%args, $class;
}

sub fetch {
	my $mech = WWW::Mechanize->new;
	$mech->get('http://www.iit.com.tw/NewWork/fund_xle.aspx');

	my $te = HTML::TableExtract->new;
	$te->parse($mech->content);

	my @ts = $te->tables;
	my @rows = $ts[2]->rows;
	shift @rows;
	my %result;

	foreach my $row (@rows) {
		my @data = @$row;
		from_to($data[0], 'big5', 'utf8') if $self->{'utf8'};
		$result{$data[0]} = {
			date   => $data[1],
			nav    => $data[2],
			change => $data[3],
		};
	}

	$self->{result} = \%result;
	return wantarray ? %result : \%result;
}

sub names {
	keys %{$self->{result}};
}

=head1 NAME

Finance::Fund::TW::IIT - Get mutual fund quotes from www.iit.com.tw

=head1 SYNOPSIS

    use Finance::Fund::TW::IIT;
    my $iit = Finance::Fund::TW::IIT->new(utf8 => 1);
    my %hash = $iit->fetch;

    my @names = $iit->names;

=head1 AVAILABLE METHODS

=head2 NEW

Return a new Finance::Fund::TW::IIT object. Valid attributes are:

=over

=item *

utf8 => [0|1]

convert current encoding(big5) to utf8

=back


=head2 FETCH

When called in an array context, a hash is returned. In a scalar context, a reference to a hash will be returned.

=head2 NAMES

Return an array of fund names

=head1 AUTHOR

Alec Chen <alec@cpan.org>

=head1 COPYRIGHT

Copyright (c) 2007. Alec Chen. All rights reserved.

This program is free software; you can redistribute it 
and/or modify it under the same terms as Perl itself.

See L<http://www.perl.com/perl/misc/Artistic.html>

=cut

