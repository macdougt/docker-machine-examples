#!/usr/bin/env perl
my $command = "docker-machine ls";
my @list;

open (PIPE, "$command |") || die "Sorry, I couldn't open pipe.\n";
while (<PIPE>) {
  next if /^NAME/;
  chomp($_);
  push(@list, $_);
}
close PIPE;

my $chosen_machine_info = &getPick(\@list);
my $chosen_machine = (split(/\s+/,$chosen_machine_info))[0];

# Set the context to current machine
my $env_command = "eval \$(docker-machine env $chosen_machine)";
print "$env_command\n";
#&create_shell_script($env_command);

#my $output = qx($env_command);
#print "Output\n--------------\n$output\n---------------";


#print "Connected to $chosen_machine\n";


sub create_shell_script {
  my $file_content = shift;
  # create temp file
  #use File::Temp qw(tempfile);
  my $filename = "/tmp/tempytemp";
  # just the handle
  #$fh = tempfile( );

  # handle and filename
  #($fh, $filename) = tempfile( );
  open (FILE, "> $filename") || die "Sorry, I couldn't write $filename.\n";
    print FILE $file_content;
  close FILE;

  print "Created temp file $filename\n";

}

sub set_env_callback {
  my $string_input = shift;
  # Grab and set the environment variables
  if (/export\s+([^=]+)=\"([^"]+)\"/) {
    #print "$1 $2\n";
    $ENV{$1} = $2;
  }
}



sub command_pipe_with_callback {
    my $command = shift;
    my $callback = shift;
  open (PIPE3, "$command |") || die "Sorry, I couldn't open pipe.\n";
  while (<PIPE3>) {   
    &$callback($_,@_);
  }
  close PIPE3;
}


# Print an interactive choice from a given list
sub getPick {
   my $ra_list = shift;
   if ($#{$ra_list} > 0) {
        print STDERR "List:\n";
        for (my $i=0; $i <= $#{$ra_list}; $i++) {
           print STDERR ($i+1);
           print STDERR ") $$ra_list[$i]\n";
        }
        print STDERR "Make your choice\n";
        my $choice = <STDIN>;
        if ($choice =~ /\d+/) {
           return $$ra_list[$choice-1];
        }
   } elsif ($#{$ra_list} == 0) {
        return $$ra_list[0];
   } else {
        print STDERR "No list\n";
   }
}
