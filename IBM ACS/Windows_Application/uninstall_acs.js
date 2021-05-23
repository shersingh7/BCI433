// ---------------------------------------------------------------- //
// IBM Confidential                                                 //
//                                                                  //
// OCO Source Materials                                             //
//                                                                  //
// Product(s):                                                      //
//     5733-XJ1                                                     //
//                                                                  //
// (C)Copyright IBM Corp.  2015, 2015                               //
//                                                                  //
// The Source code for this program is not published  or otherwise  //
// divested of its trade secrets,  irrespective of what has been    //
// deposited with the U.S. Copyright Office.                        //
// ---------------------------------------------------------------- //
//
// This script can be used for uninstalling ACS on Windows.
//



var args = WScript.Arguments;
var argsLength = args.length;
var printhelp = "no";
var install_type_shared = "no";
var source;
var local_install_path1;
var local_install_path2;
var alluser_install_path;


// Print the help text
function print_help() {
  WScript.Echo("                  IBM i Access Client Solutions Installation\n\
\n\
Name:\n\
  uninstall_acs.js -- uninstall the ACS product.\n\
\n\
Syntax:\n\
  uninstall_acs.js\n\
\n\
Description:\n\
Uninstalls local product files, desktop icons, and file associations for IBM i Access Client Solutions (ACS).\n\
\n\
  ");

}


function ensure_elevated_privileges() {
    if (!WScript.Arguments.Named.Exists("AllUsers")) {  // Make sure we do not recurse
        // Call this script and prompt for elevation if needed
        new ActiveXObject("Shell.Application").ShellExecute(WScript.FullName, "\"" + WScript.ScriptFullName + "\"" + " /AllUsers", "", "runas", 1);
        WScript.Quit();
    }
 }


// Begin: Main
// Do some parm checking and verification
if (WScript.Arguments.Named.Exists("AllUsers")) {
  argsLength=argsLength-1;
}
if (argsLength > 0) {
  printhelp = "yes";
}

if ("yes" == printhelp) {
  print_help();
}
else {

  // Main
  //
  fso = new ActiveXObject("Scripting.FileSystemObject");
  Shell1 = new ActiveXObject("WScript.Shell");

  // Find local install path 1
  BasePath = Shell1.SpecialFolders("MyDocuments");
  InstallPath = fso.GetAbsolutePathName(BasePath+"\\..\\");
  local_install_path1 = (InstallPath + "\\IBM\\ClientSolutions");


  // Find local install path 2
  BasePath = Shell1.ExpandEnvironmentStrings("%HOMEPATH%");
  HomeDrive = Shell1.ExpandEnvironmentStrings("%HOMEDRIVE%");
  //InstallPath = fso.GetAbsolutePathName(BasePath);
  InstallPath = (HomeDrive+BasePath);
  //WScript.Echo("InstallPath:"+InstallPath);
  local_install_path2 = (InstallPath + "\\IBM\\ClientSolutions");


  // Find All users install path
  AllPgmsPath = "C:\\Users\\Public";
  InstallPath = fso.GetAbsolutePathName(AllPgmsPath);
  alluser_install_path = (InstallPath + "\\IBM\\ClientSolutions");


  // Find log path
  HomePath = Shell1.ExpandEnvironmentStrings("%HOMEPATH%");
  HomeDrive = Shell1.ExpandEnvironmentStrings("%HOMEDRIVE%");
  //HomePath = fso.GetAbsolutePathName(HomePath);
  log_target = HomeDrive + HomePath + "\\IBM";
  // WScript.Echo("log_target:"+log_target);
  try {
    // Create the IBM directory if it does not exist
    if (!fso.FolderExists(log_target)) {
      fso.CreateFolder(log_target);
    }
  }
  catch (exception) {
    // Either the environment variables are not set or the user is not authorized.
    // Fallback to %TEMP%
    log_target = Shell1.ExpandEnvironmentStrings("%TEMP%");
  }



  // Get the directory of this script
  var script_path = WScript.ScriptFullName;
  var script_file = fso.GetFile(script_path);
  var script_dir = fso.GetParentFolderName(script_file);
  // Source directory of unpacked product should be the parent of this script
  source = fso.GetAbsolutePathName(script_dir+"\\..\\");

  // Open install_acs_log.txt trace file
  outputfile = new ActiveXObject("Scripting.FileSystemObject");
  install_log = outputfile.OpenTextFile(log_target+"\\install_acs_log.txt",8,true); // Open for append
  var sTime = new Date();
  install_log.writeline("BEGIN----uninstall---- "+sTime+" ----uninstall----BEGIN");
  install_log.writeline("script_path:  "+script_path);
  install_log.writeline("source path: "+source);
  install_log.writeline("local install path1: "+local_install_path1);
  install_log.writeline("local install path2: "+local_install_path2);
  install_log.writeline("alluser install path: "+alluser_install_path);

  // Delete product files for local user 1
  if (fso.FolderExists(local_install_path1)) {
    fso.DeleteFolder(local_install_path1);
    install_log.writeline("Deleting folder: "+local_install_path1);
  }

  // Delete product files for local user 2
  if (fso.FolderExists(local_install_path2)) {
    fso.DeleteFolder(local_install_path2);
    install_log.writeline("Deleting folder: "+local_install_path2);
  }

  // Delete product files for all users
  if (fso.FolderExists(alluser_install_path)) {
    ensure_elevated_privileges();
    fso.DeleteFolder(alluser_install_path);
    install_log.writeline("Deleting folder: "+alluser_install_path);
  }



  Shell4 = new ActiveXObject("WScript.Shell");

  // Delete desktop link for local user - product files
  DesktopPath = Shell4.SpecialFolders("Desktop");
  product_link = DesktopPath + "\\Access Client Solutions.lnk";
  if (fso.FileExists(product_link)) {
    fso.DeleteFile(product_link);
    install_log.writeline("Deleting desktop shortcut: "+product_link);
  }

  // Delete desktop link for local user - session mgr
  sessionMgr_link = DesktopPath + "\\ACS Session Mgr.lnk";
  if (fso.FileExists(sessionMgr_link)) {
    fso.DeleteFile(sessionMgr_link);
    install_log.writeline("Deleting desktop shortcut: "+sessionMgr_link);
  }

  // Delete desktop link for ALL users - product files
  DesktopPath = "C:\\Users\\Public\\Desktop";
  product_link = DesktopPath + "\\Access Client Solutions.lnk";
  if (fso.FileExists(product_link)) {
    ensure_elevated_privileges();
    fso.DeleteFile(product_link);
    install_log.writeline("Deleting desktop shortcut: "+product_link);
  }

  // Delete desktop link for ALL users - session mgr
  sessionMgr_link = DesktopPath + "\\ACS Session Mgr.lnk";
  if (fso.FileExists(sessionMgr_link)) {
    ensure_elevated_privileges();
    fso.DeleteFile(sessionMgr_link);
    install_log.writeline("Deleting desktop shortcut: "+sessionMgr_link);
  }

  // Delete file associations for 32
  Shell2 = new ActiveXObject("WScript.Shell");
  win32_exe = "\\Start_Programs\\Windows_i386-32\\acslaunch_win-32.exe";
  // Use source directory because if this is a shared install, that is the only binary available
  acslaunch32_exe = source + win32_exe;  // Location of Windows binary
  if (fso.FileExists(acslaunch32_exe)) {
    clear_command32 = "\""+acslaunch32_exe + "\" -norecurse /PLUGIN=fileassoc dttx dtfx hod bchx ws /c";                            
    install_log.writeline(clear_command32);
    try {
      Shell2.Run(clear_command32,1,true);
      install_log.writeline("File associations deleted: "+win32_exe);
    }
    catch(error) {
      install_log.writeline("Skipping deleting file associations for 32bit.");
    }
  }

  // Delete file associations for 64
  Shell3 = new ActiveXObject("WScript.Shell");
  win64_exe = "\\Start_Programs\\Windows_x86-64\\acslaunch_win-64.exe";
  // Use source directory because if this is a shared install, that is the only binary available
  acslaunch64_exe = source + win64_exe;  // Location of Windows binary
  if (fso.FileExists(acslaunch64_exe)) {
    clear_command64 = "\""+acslaunch64_exe + "\" -norecurse /PLUGIN=fileassoc dttx dtfx hod bchx ws /c";
    install_log.writeline(clear_command64);
    try {
      Shell3.Run(clear_command64,1,true);
      install_log.writeline("File associations deleted: "+win64_exe);
    }
    catch(error) {
      install_log.writeline("Skipping deleting file associations for 64bit.");
    }
  }




  sTime = new Date();
  install_log.writeline("END----uninstall----- "+sTime+" ----uninstall----END");

  install_log.Close();
  WScript.Echo("IBM i Access Client Solution has been uninstalled.");

} // End: Main
