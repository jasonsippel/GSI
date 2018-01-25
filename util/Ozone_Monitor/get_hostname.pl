#! /usr/bin/perl

#-------------------------------------------------------------------
#  get_hostname.pl
#
#  This script determines the hostname of the current machine.  The
#  possiblities are cray, theia, ibm or "" if the host is not  
#  one of those three.
#-------------------------------------------------------------------

#   use IO::File;
#   use File::Copy qw(move);

   my $arch;
   $arch = ` uname -s | tr '[:upper:]' '[:lower:]' `;
   $arch =~ s/^\s+|\s+$//g;
   my $my_os = "export MY_OS=$arch";

   #
   #  Determine if installation is on WCOSS, Theia, or Zeus.
   #
   if( $arch ne "linux" && $arch ne "aix" ) {
      die( "only linux and aix are supported, $arch is not\n" );
   }
#   print "\n";
#   print "arch = $arch\n";

   my $machine = "";
  
   #
   # theia login nodes are tfe1-tfe8, and hostname command only returns the node name,
   # while ccs and (perhaps) ibm return [hostname].ncep.noaa.gov.  Keep only the
   # actual hostname and see if it matches the node names for zeus, tide, or gyre.
   #
   my $host_zeus  = 0;
   my $host = "";
   $host = ` hostname `;
   chomp( $host );

   if( $host =~ /\./ ) {
      my @hostnames = split( '\.', $host );     
      $host = $hostnames[0];
   }

   if( $host =~ /tfe/ ) { 
      $machine = "theia";
   } 
   elsif( $host =~ /login/ ) {
      $machine = "cray";
   }
   elsif( $host =~ /t/ || $host =~ /g/ ){	# ibm nodes are tXXaY and gXXaY
      $machine = "ibm";
   }

   print "$machine";

   exit 0;
