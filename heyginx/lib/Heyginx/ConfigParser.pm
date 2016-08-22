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
	my $nginx_conf_raw = "";

	foreach my $line (@file_lines) {

		#Stripping blank text in front of everyline 
		$line =~ s/^\s+//g;

		#Strip comments
		$line =~ s/#.*//g;

		#Jsonify "simple" lines
		$line =~ s/^(\w+)\s+(.*);/"$1":"$2",/g;

		#Convert Nginx hiarchy to json hierachy
		$line =~ s/(.+)\{/"$1":[\{/g;
		$line =~ s/\}/\}\],/g;

		#Removing trailing whitespace
		$line =~ s/\s+$//g;

		next unless $line; #Ignore empty lines

		unless ($line =~ m/".+":|\}\]/) {
			warn "Failed parsing this line : \n".$line;
			$line = "";
		}
		$nginx_conf_raw .= $line;
	}
	
	#Striping trailing commas
	$nginx_conf_raw =~ s/,\}/}/g;
	chop $nginx_conf_raw;

	#Last step, adding the wrapping brackets
	$nginx_conf_raw = "{".$nginx_conf_raw."}";


	#TODO : 
	# - Transform non-uniques keys into array
	# - Escape json reserved characters.
	
	warn "\n=========Parsing Progress : \n".$nginx_conf_raw."\n================";

	return $nginx_conf_raw;
}

1;
