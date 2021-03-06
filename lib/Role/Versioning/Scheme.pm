package Role::Versioning::Scheme;

# DATE
# VERSION

use Role::Tiny;

requires qw(
               is_valid_version
               normalize_version
               cmp_version
               bump_version
               parse_version
       );

1;
# ABSTRACT: Role for Versioning::Scheme::* modules

=head1 REQUIRED METHODS

=head2 is_valid_version

Usage:

 my $valid = $vs->is_valid_version('1.2.3'); # bool

Must return true when a string is a valid version number for the associated
scheme, or false otherwise.

=head2 parse_version

Usage:

 my $hash = $vs->parse_version('1.2.3'); # => {major=>1, minor=>2, patch=>3}

Parse version number into elements. Should return hashref, or undef if version
number is invalid.

=head2 normalize_version

Usage:

 my $normalized = $vs->normalize_version('1.2.3'); # bool

Return the canonical string form of a version number according to the associated
scheme.

Must die when input is not a valid version number string.

=head2 cmp_version

Usage:

 my $res = $vs->cmp_version($v1, $v2); # -1|0|1

Compare two version number strings and, like Perl's C<cmp>, must return -1, 0,
or 1 depending on C<$v1> is less than, equal to, or greater than C<$v2>,
respectively, according to the associated scheme.

Must die when either C<$v1> or C<$v2> is invalid.

=head2 bump_version

Usage:

 my $v2 = $vs->bump_version($v[ , \%opts ]); # => str

Bump a version number string and return a bumped version number string.

Must die when C<$v> is invalid.

By default it must bump the bumpable least significant part by one. Example in
dotted scheme:

 my $v2 = $vs->bump_version('1.2.3'); # => '1.2.4'

In monotonic scheme:

 my $v2 = $vs->bump_version('1.2+foo'); # => '1.3+foo'

Some options this method can accept:

=over

=item * num => int (default: 1)

Number of version numbers to bump, for example:

 my $v2 = $vs->bump_version('1.2.3', {num=>2}); # => '1.2.5'

It can be negative:

 my $v2 = $vs->bump_version('1.2.3', {num=>-1}); # => '1.2.2'
 my $v2 = $vs->bump_version('1.2.3', {num=>-3}); # => '1.2.0'

It must die when an ambiguous number is specified:

 my $v2 = $vs->bump_version('1.2.3', {num=>-4}); # dies

=item * part => int

Specify which part to bump, where 0 means the most significant part, 1 means the
second most significant part, and so on. It can also be negative (-1 means the
least significant part, -2 the second least significant part, and so on). The
default should be the bumpable least significant part. For example in dotted
version:

 my $v2 = $vs->bump_version('1.2.3', {part=>-2}); # => '1.3.0'

=item * reset_smaller => bool (default: 1)

By default, when a bigger part is increased, the smaller parts are reset (see
previous example). Setting this option to 0 prevents that:

 my $v2 = $vs->bump_version('1.2.3', {part=>-2, reset_smaller=>0}); # => '1.3.3'

=back
