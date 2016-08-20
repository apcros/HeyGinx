use Test::More;
use Heyginx::ConfigParser;

ok my $configParser = Heyginx::ConfigParser->new(config_path => 't/fixtures/nginx_dummy.conf'), "Use ok";
is $configParser->parse(), 11,"Config parsed correctly";

done_testing();