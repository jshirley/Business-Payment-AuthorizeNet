use inc::Module::Install;

name     'Business-Payment-Processor-AuthorizeNet';
all_from 'lib/Business/Payment/Processor/AuthorizeNet.pm';
author   'J. Shirley <jshirley@coldhardcode.com>';
license  'perl';

build_requires 'Test::More';

requires    'Business::Payment';

WriteAll;

