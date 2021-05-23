#!/usr/bin/perl
#
# This script is only expected to work on platforms where perl is installed.
# Perl exists by default on most Linux and Mac operating systems.
# Since some operating systems are sensitive to the file extension, this script
# is being made available with various file extensions.
#       
#
#
#
# Description:
#
# The main entry point to IBM i Access Client Solutions is invoked with optional
# arguments.
#
# By default, this script expects the IBM i Access Client Solutions product
# to exist in the current directory or one of the two previous directories.  
#
# This script may be used to start the main GUI for IBM i Access Client Solutions
# or any of its command line functions.  It may also be used for creating
# short-cuts and/or file associations.
#
#
# Usage: [args...]
#
#  where args include:
#    /plugin=<name> [plugin-options...]
#    <file>
#
#
use FindBin;
my $argc = 0;
my @arg_list = "";
foreach my $arg (@ARGV) {
  $arg_list = $arg_list . " \"" . $ARGV[$argc] . "\"";
  $argc++;
}
#print	"cd $FindBin::Bin; java -Xmx1024m -Djava.class.path=$FindBin::Bin/acsmain.jar:$FindBin::Bin/acsbundle.jar:$FindBin::Bin/../acsmain.jar:$FindBin::Bin/../acsbundle.jar:$FindBin::Bin/../../acsmain.jar:$FindBin::Bin/../../acsbundle.jar:$FindBin::Bin/../../../acsmain.jar:$FindBin::Bin/../../../acsbundle.jar com/ibm/iaccess/launch/AcsLaunchPad $arg_list\n";
system ("cd $FindBin::Bin; java -Xmx1024m -Djava.class.path=$FindBin::Bin/acsmain.jar:$FindBin::Bin/acsbundle.jar:$FindBin::Bin/../acsmain.jar:$FindBin::Bin/../acsbundle.jar:$FindBin::Bin/../../acsmain.jar:$FindBin::Bin/../../acsbundle.jar:$FindBin::Bin/../../../acsmain.jar:$FindBin::Bin/../../../acsbundle.jar com/ibm/iaccess/launch/AcsLaunchPad $arg_list");
