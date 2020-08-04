package Tags::HTML::Stars;

use strict;
use warnings;

use Class::Utils qw(set_params);
use Error::Pure qw(err);
use List::Util qw(max);
use MIME::Base64;
use Readonly;

# Constants.
Readonly::Scalar our $STAR_FULL_FILENAME => 'Star*.svg';
Readonly::Scalar our $STAR_HALF_FILENAME => 'Star-.svg';
Readonly::Scalar our $STAR_NOTHING_FILENAME => 'Star½.svg';
Readonly::Scalar our $IMG_STAR_FULL => encode_base64(<<'END', '');
<svg width="300px" height="275px" viewBox="0 0 300 275" xmlns="http://www.w3.org/2000/svg" version="1.1">
  <polygon fill="#fdff00" stroke="#605a00" stroke-width="15" points="150,25 179,111 269,111 197,165 223,251 150,200 77,251 103,165 31,111 121,111" />
</svg>
END
Readonly::Scalar our $IMG_STAR_HALF => encode_base64(<<'END', '');
<svg width="300px" height="275px" viewBox="0 0 300 275" xmlns="http://www.w3.org/2000/svg" version="1.1">
  <clipPath id="empty"><rect x="150" y="0" width="150" height="275" /></clipPath>
  <clipPath id="filled"><rect x="0" y="0" width="150" height="275" /></clipPath>
  <polygon fill="none" stroke="#808080" stroke-width="15" stroke-opacity="0.37647060" points="150,25 179,111 269,111 197,165 223,251 150,200 77,251 103,165 31,111 121,111" clip-path="url(#empty)" />
  <polygon fill="#fdff00" stroke="#605a00" stroke-width="15" points="150,25 179,111 269,111 197,165 223,251 150,200 77,251 103,165 31,111 121,111" clip-path="url(#filled)" />
</svg>
END
Readonly::Scalar our $IMG_STAR_NOTHING => encode_base64(<<'END', '');
<svg width="300px" height="275px" viewBox="0 0 300 275" xmlns="http://www.w3.org/2000/svg" version="1.1">
  <polygon fill="none" stroke="#808080" stroke-width="15" stroke-opacity="0.37647060" points="150,25 179,111 269,111 197,165 223,251 150,200 77,251 103,165 31,111 121,111" />
</svg>
END

our $VERSION = 0.01;

# Constructor.
sub new {
	my ($class, @params) = @_;

	# Create object.
	my $self = bless {}, $class;

	# Public image directory.
	$self->{'public_image_dir'} = undef;

	# Star width (300px).
	$self->{'star_width'} = undef;

	# 'Tags' object.
	$self->{'tags'} = undef;

	# Process params.
	set_params($self, @params);

	# Check to 'Tags' object.
	if (! $self->{'tags'} || ! $self->{'tags'}->isa('Tags::Output')) {
		err "Parameter 'tags' must be a 'Tags::Output::*' class.";
	}

	# Object.
	return $self;
}

# Process 'Tags'.
sub process {
	my ($self, $stars_hr) = @_;

	# Main stars.
	$self->{'tags'}->put(
		['b', 'div'],
	);

	my $max_num = max(keys %{$stars_hr});
	foreach my $num (1 .. $max_num) {
		my $image_src = $self->_star_src($stars_hr->{$num});

		$self->{'tags'}->put(
			['b', 'img'],
			(
				$self->{'star_width'}
				? (
				['a', 'style', 'width: '.$self->{'star_width'}.';'],
				) : (),
			),
			['a', 'src', $image_src],
			['e', 'img'],
		);
	}

	$self->{'tags'}->put(
		['e', 'div'],
	);

	return;
}

sub _star_src {
	my ($self, $id) = @_;

	# Link to file.
	my $src;
	if (defined $self->{'public_image_dir'}) {
		$src = $self->{'public_image_dir'};
		if ($src ne '') {
			$src .= '/';
		}
		if ($id eq 'full') {
			$src .= $STAR_FULL_FILENAME;
		} elsif ($id eq 'half') {
			$src .= $STAR_HALF_FILENAME;
		} elsif ($id eq 'nothing') {
			$src .= $STAR_NOTHING_FILENAME
		}
	} else {
		$src = 'data:image/svg+xml;base64,';
		if ($id eq 'full') {
			$src .= $IMG_STAR_FULL;
		} elsif ($id eq 'half') {
			$src .= $IMG_STAR_HALF;
		} elsif ($id eq 'nothing') {
			$src .= $IMG_STAR_NOTHING;
		}
	}

	return $src;
}

1;
