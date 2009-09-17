use Test::More tests => 3;

use warnings;
use strict;

use Data::Dump 'dump';
use DateTime;
use Business::Payment;
use Business::Payment::Charge;
use Business::Payment::CreditCard;
use Business::Payment::Processor::AuthorizeNet;

my $amount = sprintf("%.2f", rand(15) + 5);

my $bp = Business::Payment->new(
    processor => Business::Payment::Processor::AuthorizeNet->new(
        server      => 'test.authorize.net',
        login       => 'f9zmKtPbQtD',
        password    => 'Vzx2n2Uk2TPanu3M'
    )
);

my $charge = $bp->charge( 
    amount => $amount,
    first_name  => 'Testy',
    last_name   => 'McTestes',
    address     => '1234 Any St',
    city        => 'Test',
    state       => 'WA',
    zip         => '98123',
    credit_card => Business::Payment::CreditCard->new(
        number     => '4111111111111111',
        expiration => '10/15',
        amount      => $amount,
    )
);
isa_ok($charge, 'Business::Payment::Charge', 'charge object');

my $result = $bp->handle($charge);
isa_ok($result, 'Business::Payment::Result', 'result class');
ok($result->success, 'all about getting that cash money');


my $order_number = $result->extra->{transaction_id};
ok($order_number, 'got order number');

my $refund = $bp->refund( 
    amount      => $amount,
    first_name  => 'Testy',
    last_name   => 'McTestes',
    address     => '1234 Any St',
    city        => 'Test',
    state       => 'WA',
    zip         => '98123',
    order_number => $result->extra->{transaction_id},
    credit_card => Business::Payment::CreditCard->new(
        number     => '4111111111111111',
        expiration => '10/15',
        amount      => $amount
    )
);

$result = $bp->handle($refund);
isa_ok($result, 'Business::Payment::Result', 'result class');
ok($result->success, 'refund it, getmemymoneybackman');

use Data::Dumper;
print Dumper($result->extra);
