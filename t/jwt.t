#!perl

use strict;
use warnings;

use Test::Most;
use Test::Deep::JWT;
use Test::Exception;

use_ok( "Mojo::JWT" );
use_ok( "JSON::WebToken" );
use_ok( "Acme::JWT" );
use_ok( "Crypt::JWT" );
use_ok( "Mojar::Auth::Jwt" );

my $header_none = 'eyJhbGciOiJub25lIn0';
my $header_256  = 'eyJhbGciOiJIUzI1NiJ9';

my $body_hello  = 'eyJtZXNzYWdlIjoiSGVsbG8gWUFQQyJ9';

my $sig         = '97WnnEhTjhdQ-ymuE5KIXs1TlqQKLsWk_lNJ7leaziQ';
my $sig_bad     = 'Dt2W1tLnqf-U5N_BuLmwWO5zBwN4fokX4';
my $secret      = 'secret';

my $decoded_expect = { 'message' => 'Hello YAPC' };

my $jwt      = join( '.',$header_256,$body_hello,$sig );
my $jwt_none = $header_none . '.eyJzdWIiOiIxMDAiLCJhdWQiOiIxMjMifQ.';
my $jwt_bad  = join( '.',$header_256,$body_hello,$sig_bad );

note( "Test::Deep::JWT" );

cmp_deeply(
	$jwt,
	jwt(
		+{ message => 'Hello YAPC' },
		+{ alg => 'HS256' },
	),
	'alg: HS256'
);

# it seem Test::Deep::JWP doesn't care about the signature
cmp_deeply(
	$jwt_none,
	jwt(
		+{ sub => '100', aud => ignore() },
		+{ alg => 'none' },
	),
	'alg: none'
);

cmp_deeply(
	$jwt_bad,
	jwt(
		+{ message => 'Hello YAPC' },
		+{ alg => 'HS256' },
	),
	'alg: HS256 (bad signature)'
);

note( "Mojo::JWT" );

cmp_deeply( 
	Mojo::JWT->new( secret => $secret )->decode( $jwt ),
	$decoded_expect,
	'->decode'
);

throws_ok(
	sub { Mojo::JWT->new( secret => $secret )->decode( $jwt_bad ); },
	qr/Failed HS validation/,
	'->decode fails with bad signature'
);

throws_ok(
	sub { Mojo::JWT->new( secret => $secret )->decode( $jwt_none ); },
	qr/Algorithm "none" is prohibited/,
	'->decode fails with "none" algorithm'
);

note( "JSON::WebToken" );

cmp_deeply(
	JSON::WebToken::decode_jwt( $jwt, $secret ),
	$decoded_expect,
	'decode_jwt'
);

throws_ok(
	sub { JSON::WebToken::decode_jwt( $jwt_bad, $secret ); },
	qr/Invalid signature/,
	'decode_jwt fails with bad signature'
);

throws_ok(
	sub { JSON::WebToken::decode_jwt( $jwt_none, $secret ) },
	qr/Algorithm "none" is not acceptable/,
	'decode_jwt fails with "none" algorithm'
);

note( "Acme::JWT" );

cmp_deeply(
	Acme::JWT->decode( $jwt,$secret ),
	$decoded_expect,
	'->decode'
);

throws_ok(
	sub { Acme::JWT->decode( $jwt_bad,$secret ); },
	qr/Signature verifacation failed/,
	'->decode fails with bad signature'
);

throws_ok(
	sub { Acme::JWT->decode( $jwt_none,$secret ); },
	qr/Algorithm not supported/,
	'->decode fails with "none" algorithm'
);

note( "Crypt::JWT" );

cmp_deeply(
	Crypt::JWT::decode_jwt( token => $jwt, key => $secret ),
	$decoded_expect,
	'decode_jwt'
);

throws_ok(
	sub { Crypt::JWT::decode_jwt( token => $jwt_bad, key => $secret ); },
	qr/JWS: decode failed/,
	'decode_jwt fails with bad signature'
);

throws_ok(
	sub { Crypt::JWT::decode_jwt( token => $jwt_none, key => $secret ) },
	qr/JWS: alg 'none' not allowed/,
	'decode_jwt fails with "none" algorithm'
);

note( "Mojar::Auth::Jwt" );

my $maj = Mojar::Auth::Jwt->new(
	private_key => $secret,
);

isa_ok( $maj->decode( $jwt ),'Mojar::Auth::Jwt' );
throws_ok(
	sub { $maj->decode( $jwt_bad ); },
	qr/some error/,
	'->decode fails with bad signature'
);

throws_ok(
	sub { $maj->decode( $jwt_none ); },
	qr/some error/,
	'->decode fails with "none" algorithm',
);

done_testing();
