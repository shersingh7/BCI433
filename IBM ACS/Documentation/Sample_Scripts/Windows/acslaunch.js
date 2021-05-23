/*

  This JScript is only expected to work on Windows based operating systems.



Description:

  The main entry point to IBM i Access Client Solutions is invoked with optional
  arguments.

  By default, this script expects the IBM i Access Client Solutions product
  to exist in the current directory or one of the two previous directories.  

  This script may be used to start the main GUI for IBM i Access Client Solutions
  or any of its command line functions.  It may also be used for creating
  short-cuts and/or file associations.


Usage: [args...]

   where args include:
     /plugin=<name> [plugin-options...]
     <file>

*/

// java command to be invoked
var callthis = "cmd.exe /c java -Xmx1024m \
-Djava.class.path=acsmain.jar;acsbundle.jar;..\\acsmain.jar;..\\acsbundle.jar;..\\..\\acsmain.jar;..\\..\\acsbundle.jar;..\\..\\..\\acsmain.jar;..\\..\\..\\acsbundle.jar \
com/ibm/iaccess/launch/AcsLaunchPad"

// build string of parameters passed in from the command line
var total_parms = WSH.Arguments.Length;
var parms = "";
var idx;
for(idx = 0; idx < total_parms; idx++) {
   parms = parms + " \"" + WSH.Arguments.Item(idx) + "\"";
}

var final_cmd = callthis + parms;
// WSH.Echo (final_cmd);

// Show_CommandPrompt=0  false
// Show_CommandPrompt=1  true  - displays command prompt
var Show_CommandPrompt=0

// Initialize shell
var script_shell = WScript.CreateObject("WScript.Shell")

var result = script_shell.Run(final_cmd, Show_CommandPrompt)
