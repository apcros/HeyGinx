package Heyginx::ConfigParser;
use File::Slurp;
use Moose;
use Data::Dumper;

has 'config_path' => 
(
	is => 'rw',
	isa => 'Str'
);

sub parse {
	my($self) = @_;
	my @file_lines = File::Slurp::read_file($self->config_path);
	my %nginx_conf;
	my $in_block = 0;
	foreach my $line (@file_lines) {
		if($line =~ m/(\w+) \{/){
			my $block_name = $1;
			$in_block = $block_name;
			if($in_block) {
				if ($nginx_conf{$in_block}{$block_name}) {
					$nginx_conf{$in_block}{$block_name} .= $line 
					} else {
						$nginx_conf{$in_block}{$block_name} = $line 
					}

			} else {

			}
		}
	}
	warn Dumper(\%nginx_conf);
}

1;
