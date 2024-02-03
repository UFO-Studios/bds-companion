#pragma compile(Compatibility, XP, vista, win7, win8, win81, win10, win11)
#pragma compile(FileDescription, BDS UI)
#pragma compile(ProductName, BDS UI)
#pragma compile(ProductVersion, 1.0.0)
#pragma compile(FileVersion, 1.0.0)
#pragma compile(LegalCopyright, ©UFO Studios)
#pragma compile(CompanyName, UFO Studios)
#pragma compile(OriginalFilename, BDS_UI-V1.0.0)

#include <Array.au3>
#include <ButtonConstants.au3>
#include <StaticConstants.au3>
#include <TabConstants.au3>
#include <ColorConstants.au3>
#include <GUIConstantsEx.au3>
#include <AutoItConstants.au3>
#include <WindowsConstants.au3>
#include <EditConstants.au3>
#include <File.au3>
#include <GuiIPAddress.au3>

#include "UDF/Zip.au3"
;GUI #####

Global Const $currentVersionNumber = "100"
Global Const $guiTitle = "BDS UI - V1.0.0"

#Region ### START Koda GUI section ###
Global $gui_mainWindow = GUICreate("" & $guiTitle & "", 615, 427, 758, 350)
Global $gui_tabs = GUICtrlCreateTab(8, 8, 593, 393)
Global $gui_serverCtrlTab = GUICtrlCreateTabItem("Server Control")
Global $gui_serverStatusLabel = GUICtrlCreateLabel("Server Status:", 16, 40, 71, 17)
Global $gui_commandInput = GUICtrlCreateInput("", 16, 328, 481, 21)
Global $gui_sendCmdBtn = GUICtrlCreateButton("Send Command", 504, 328, 91, 25)
Global $gui_startServerBtn = GUICtrlCreateButton("Start Server", 16, 360, 75, 33)
Global $gui_stopServerBtn = GUICtrlCreateButton("Stop Server", 96, 360, 75, 33)
Global $gui_restartBtn = GUICtrlCreateButton("Restart Server", 176, 360, 75, 33)
Global $gui_backupBtn = GUICtrlCreateButton("Backup Server", 256, 360, 83, 33)
Global $gui_serverStatusIndicator = GUICtrlCreateLabel("Offline", 88, 40, 202, 17)
Global $gui_console = GUICtrlCreateEdit("", 16, 64, 577, 257, BitOR($GUI_SS_DEFAULT_EDIT,$ES_READONLY))
GUICtrlSetData(-1, "[BDS-UI]: Server Offline")
Global $gui_settingsTab = GUICtrlCreateTabItem("Settings")
Global $gui_restartSettingsGroup = GUICtrlCreateGroup("Restart Settings", 16, 37, 577, 73)
Global $gui_autoRestartTimeInput = GUICtrlCreateInput("6,12,18,24", 253, 56, 153, 21)
Global $gui_autoRestartTimeLabel = GUICtrlCreateLabel("Restart Time(s):", 173, 56, 78, 17)
Global $gui_autoRestartCheck1 = GUICtrlCreateCheckbox("Auto Restarts Enabled", 21, 56, 129, 17)
Global $gui_backupDuringRestart = GUICtrlCreateCheckbox("Backup During Restart", 21, 80, 129, 17)
Global $gui_autoRestartEgText = GUICtrlCreateLabel("E.G. 6,12,18,24", 408, 56, 79, 17)
GUICtrlCreateGroup("", -99, -99, 1, 1)
Global $gui_saveSettingsBtn = GUICtrlCreateButton("Save Settings", 488, 352, 107, 41)
Global $gui_UpdateCheckBtn = GUICtrlCreateButton("Check For Updates", 16, 352, 107, 41)
Global $gui_AboutGroup = GUICtrlCreateGroup("About", 16, 128, 577, 113)
Global $gui_aboutVersion = GUICtrlCreateLabel("Version:", 24, 152, 218, 17)
Global $gui_InstallDir = GUICtrlCreateLabel("Script Folder: ", 24, 176, 221, 17)
Global $gui_aboutBDSdir = GUICtrlCreateLabel("BDS Folder: ", 26, 198, 216, 17)
Global $gui_getHelpBtn = GUICtrlCreateButton("Join our Discord!", 472, 152, 107, 25)
Global $gui_openBackupsBtn = GUICtrlCreateButton("Open Backup Folder", 472, 184, 107, 25)
GUICtrlCreateGroup("", -99, -99, 1, 1)
Global $gui_serverPropertiesTab = GUICtrlCreateTabItem("Server Properties")
Global $gui_ServerPropertiesGroup = GUICtrlCreateGroup("Server.Properties", 32, 40, 553, 353)
Global $gui_ServerPropertiesEdit = GUICtrlCreateEdit("", 40, 64, 529, 281)
GUICtrlSetData(-1, "gui_ServerPropertiesEdit")
Global $gui_serverPropertiesSaveBtn = GUICtrlCreateButton("Save", 496, 352, 75, 25)
GUICtrlCreateGroup("", -99, -99, 1, 1)
GUICtrlCreateTabItem("")
Global $gui_copyright = GUICtrlCreateLabel("© UFO Studios 2024", 8, 408, 103, 17)
Global $gui_versionNum = GUICtrlCreateLabel("Version: 1.0.0", 528, 408, 69, 17)
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

GUICtrlSetColor($gui_serverStatusIndicator, $COLOR_RED)

;Variables ###################################################################################

Global $bdsFolder = @ScriptDir & "\BDS"
Global $bdsExe = 'C:\Windows\System32\cmd.exe /c ' & '"' & $bdsFolder & '\bedrock_server.exe' & '"' ;We use cmd.exe otherwise bds freaks out. idk why
Global $backupDir = @ScriptDir & "\backups"
Global $settingsFile = @ScriptDir & "\settings.ini"
Global $serverRunning = False
Global $BDS_process = null
Global $logDir = @ScriptDir & "\logs"
Global $BDSlogDir = @ScriptDir & "\logs\bds"

;Functions (Logging) ############################################################################

Func createLog()
	If FileExists($logDir & "\latest.log") Then
		FileMove($logDir & "\log.latest", $logDir & "\log.old")
	EndIf

	If FileExists($logDir) Then ;If directory exists then begin writing logs
		logWrite(0, "Log file generated at " & @HOUR & ":" & @MIN & ":" & @SEC & " on " & @MDAY & "/" & @MON & "/" & @YEAR & " (HH:MM:SS on DD.MM.YY)")
		logWrite(0, "###################################################################")
	ElseIf FileExists($logDir) = 0 Then ;If directory doesn't exist create it then begin writing logs
		DirCreate($logDir)
		logWrite(0, "Log file generated at " & @HOUR & ":" & @MIN & ":" & @SEC & " on " & @MDAY & "/" & @MON & "/" & @YEAR & " (HH:MM:SS on DD.MM.YY)")
		logWrite(0, "###################################################################")
		logWrite(0, "Created logging directory!")
	EndIf
EndFunc   ;==>createLog

Func logWrite($spaces, $content)
	If $spaces = 1 Then ;For adding spaces around the content written to the log
		FileOpen($logDir & "\log.latest", 1)
		FileWrite($logDir & "\log.latest", @CRLF)
		FileClose($logDir & "\log.latest")
	ElseIf $spaces = 2 Then
		FileOpen($logDir & "\log.latest", 1)
		FileWrite($logDir & "\log.latest", @CRLF)
		FileClose($logDir & "\log.latest")
	EndIf

	FileOpen($logDir & "\log.latest", 1)
	FileWrite($logDir & "\log.latest", @MDAY & "/" & @MON & "/" & @YEAR & " @ " & @HOUR & ":" & @MIN & ":" & @SEC & " > " & $content & @CRLF)
	FileClose($logDir & "\log.latest")

	If $spaces = 1 Then
		FileOpen($logDir & "\log.latest", 1)
		FileWrite($logDir & "\log.latest", @CRLF)
		FileClose($logDir & "\log.latest")
	ElseIf $spaces = 3 Then
		FileOpen($logDir & "\log.latest", 1)
		FileWrite($logDir & "\log.latest", @CRLF)
		FileClose($logDir & "\log.latest")
	EndIf
EndFunc   ;==>logWrite


Func BDScreateLog()
	If FileExists($BDSlogDir & "\latest.log") Then
		FileMove($BDSlogDir & "\log.latest", $BDSlogDir & "\log.old")
	EndIf

	If FileExists($BDSlogDir) Then ;If directory exists then begin writing logs
		logWrite(0, "Log file generated at " & @HOUR & ":" & @MIN & ":" & @SEC & " on " & @MDAY & "/" & @MON & "/" & @YEAR & " (HH:MM:SS on DD.MM.YY)")
		logWrite(0, "###################################################################")
	ElseIf FileExists($BDSlogDir) = 0 Then ;If directory doesn't exist create it then begin writing logs
		DirCreate($BDSlogDir)
		logWrite(0, "Log file generated at " & @HOUR & ":" & @MIN & ":" & @SEC & " on " & @MDAY & "/" & @MON & "/" & @YEAR & " (HH:MM:SS on DD.MM.YY)")
		logWrite(0, "###################################################################")
		logWrite(0, "Created logging directory!")
	EndIf
EndFunc   ;==>createLog

Func BDSlogWrite($spaces, $content)
	If $spaces = 1 Then ;For adding spaces around the content written to the log
		FileOpen($BDSlogDir & "\log.latest", 1)
		FileWrite($BDSlogDir & "\log.latest", @CRLF)
		FileClose($BDSlogDir & "\log.latest")
	ElseIf $spaces = 2 Then
		FileOpen($BDSlogDir & "\log.latest", 1)
		FileWrite($BDSlogDir & "\log.latest", @CRLF)
		FileClose($BDSlogDir & "\log.latest")
	EndIf

	FileOpen($BDSlogDir & "\log.latest", 1)
	FileWrite($BDSlogDir & "\log.latest", @MDAY & "/" & @MON & "/" & @YEAR & " @ " & @HOUR & ":" & @MIN & ":" & @SEC & " > " & $content & @CRLF)
	FileClose($BDSlogDir & "\log.latest")

	If $spaces = 1 Then
		FileOpen($BDSlogDir & "\log.latest", 1)
		FileWrite($BDSlogDir & "\log.latest", @CRLF)
		FileClose($BDSlogDir & "\log.latest")
	ElseIf $spaces = 3 Then
		FileOpen($BDSlogDir & "\log.latest", 1)
		FileWrite($BDSlogDir & "\log.latest", @CRLF)
		FileClose($BDSlogDir & "\log.latest")
	EndIf
EndFunc   ;==>logWrite

;Functions (Config) #############################################################################

Func ReplaceFileContents($sFilePath, $sNewContent)
	Local $hFile = FileOpen($sFilePath, 2)     ; Open the file for write and erase the current content
	logWrite(2, "Opening file" & $sFilePath)
	If $hFile = -1 Then
		MsgBox(0, $guiTitle, "Unable to open file.")
		logWrite(0, "Unable to open file.")
		Return False
	EndIf

	FileWrite($hFile, $sNewContent)     ; Write the new content to the file
	FileClose($hFile)     ; Close the file
	logWrite(3, "Contents written to file. Returning...")
	Return True
EndFunc   ;==>ReplaceFileContents

Func LoadBDSConf()
	Local $BDSconfFile = $bdsFolder & "/server.properties"
	logWrite(0, "Loading BDS conf file from " & $BDSconfFile & "...")
	$FileOpened = FileRead($BDSconfFile)
	If @error Then
		logWrite(0, "Error opening file. Error code: " & @error)
		MsgBox(0, $guiTitle, @error)
	else
		logWrite(0, "File opened successfully.")
		GUICtrlSetData($gui_ServerPropertiesEdit, $FileOpened)
	endif
EndFunc   ;==>LoadBDSConf

Func SaveBDSConf()
	Local $BDSconfFile = $bdsFolder & "/server.properties"
	local $NewFileValue = GUICtrlRead($gui_ServerPropertiesEdit)
	logWrite(0, "Saved BDS conf file to " & $BDSconfFile)
	ReplaceFileContents($BDSconfFile, $NewFileValue)
endfunc   ;==>SaveBDSConf

Func loadConf()
	Global $cfg_autoRestart = IniRead($settingsFile, "general", "AutoRestart", "False")
	logWrite(0, "Settings.ini read successfully! Setting GUI data.")
	If $cfg_autoRestart = "True" Then
		GUICtrlSetState($gui_autoRestartCheck1, $GUI_CHECKED)
	Else
		GUICtrlSetState($gui_autoRestartCheck1, $GUI_UNCHECKED)
	Endif

	Global $cfg_BackupDuringRestart = IniRead($settingsFile, "general", "BackupDuringRestart", "False")
	If $cfg_BackupDuringRestart = "True" Then
		GUICtrlSetState($gui_backupDuringRestart, $GUI_CHECKED)
	Else
		GUICtrlSetState($gui_backupDuringRestart, $GUI_UNCHECKED)
	Endif

	Global $cfg_autoRestartTime = IniRead($settingsFile, "general", "AutoRestartInterval", "6,12,18,24")
	GUICtrlSetData($gui_autoRestartTimeInput, $cfg_autoRestartTime)

	Global $cfg_autoBackupRestartTime = IniRead($settingsFile, "general", "AutoRestartBackupInterval", "6,12,18,24")

	;About Buttons & Data

	GUICtrlSetData($gui_aboutVersion, "Version: " & $guiTitle)
	GUICtrlSetData($gui_InstallDir, "Script Folder: " & @ScriptDir)
	GUICtrlSetData($gui_aboutBDSdir, "BDS Folder: " & $bdsFolder)

	logWrite(0, "Settings.ini read sucsessfiully! GUI data set.")
EndFunc   ;==>loadConf

Func saveConf()
	logWrite(0, "Writing Settings.ini...")

	If GUICtrlRead($gui_autoRestartCheck1) = 1 Then
		IniWrite($settingsFile, "general", "AutoRestart", "True")
	Else
		IniWrite($settingsFile, "general", "AutoRestart", "False")
	Endif

	;IniWrite($settingsFile, "general", "AutoBackupInterval", GUICtrlRead($gui_backupDateTime))
	IniWrite($settingsFile, "general", "AutoRestartInterval", GUICtrlRead($gui_autoRestartTimeInput))
	logWrite(0, "Settings.ini written sucsessfiully!")
EndFunc   ;==>saveConf


;Functions (Scheduled Actions) ##################################################################

Func ScheduledActions()
	logWrite(0, "Running scheduled actions...")
	$done = False
	GUICtrlSetData($gui_serverStatusIndicator, "Running scheduled actions")
	GUICtrlSetColor($gui_serverStatusIndicator, $COLOR_PURPLE)
	If $cfg_autoRestart = "True" Then
		$times = StringSplit($cfg_autoRestartTime, ",")
		$currentTime = @HOUR
		For $i = 1 To $times[0]
			If $currentTime = $times[$i] Then
				if $cfg_BackupDuringRestart = "True" Then
					logWrite(0, "Auto restart time reached. BackupDuringRestart is true so backing up server...")
					stopServer()
					backupServer()
					RestartServer()
					$done = True
				Else
				logWrite(0, "Auto restart time reached. Restarting server...")
				RestartServer()
				$done = True
				endif
			EndIf
		Next
	endif

	if $done = True Then
		logWrite(0, "Scheduled actions completed.")
	Else
		logWrite(0, "No scheduled actions to run. Next run is in 60s")
	endif
	if $BDS_process = Null Then
		GUICtrlSetData($gui_serverStatusIndicator, "Offline")
		GUICtrlSetColor($gui_serverStatusIndicator, $COLOR_RED)
	Else
		GUICtrlSetData($gui_serverStatusIndicator, "Online")
		GUICtrlSetColor($gui_serverStatusIndicator, $COLOR_GREEN)
	endif
	logWrite(0, "Scheduled actions completed.")
EndFunc   ;==>ScheduledActions

logWrite(0, "Starting scheduled actions...")
AdlibRegister("ScheduledActions", 60 * 1000) ; run it every 60s
logWrite(0, "Scheduled actions started Next run in 60s.")

;Functions (World & packs) ########################################################################



;Functions (Misc) ##################################################################################

Func DelEmptyDirs()
	logWrite(0, "Deleting empty directories...")
	$cmd = "ROBOCOPY BDS BDS /S /MOVE"    ;cmd.exe func to copy to the same dir, but deletes empty folders in the process
	GUICtrlSetData($gui_serverStatusIndicator, "Backing up (Checking server files...)")
	logWrite(0, "Running ROBOCOPY command to delete empty directories")
	RunWait($cmd, @ScriptDir, @SW_HIDE)
	logWrite(0, "Empty directories deleted.")
	return 0
EndFunc   ;==>DelEmptyDirs

Func checkForUpdates($updateCheckOutputMsg) ; from alien's pack converter. Thanks TAD ;D
	Local $ping = Ping("TheAlienDoctor.com")
	Local $noInternetMsgBox = 0

	If $ping > 0 Then
		DirCreate(@ScriptDir & "\temp\")
		InetGet("https://thealiendoctor.com/software-versions/bds-ui-versions.ini", @ScriptDir & "\temp\versions.ini", 1)
		Global $latestVersionNum = IniRead(@ScriptDir & "\temp\versions.ini", "latest", "latest-version-num", "100")

		If $latestVersionNum > $currentVersionNumber Then
			Global $updateMsg = IniRead(@ScriptDir & "\temp\versions.ini", $latestVersionNum, "update-message", "(updated message undefined)")
			Local $updateMsgBox = MsgBox(4, $guiTitle, "There is a new update out now!" & @CRLF & $updateMsg & @CRLF & @CRLF & "Would you like to download it?")

			If $updateMsgBox = 6 Then
				Global $versionPage = IniRead(@ScriptDir & "\temp\versions.ini", $latestVersionNum, "version-page", "https://www.thealiendoctor.com/downloads/bds-ui")
				ShellExecute($versionPage)
				Exit
			EndIf
		Else
			If $updateCheckOutputMsg = 1 Then
				MsgBox(0, $guiTitle, "No new updates found." & @CRLF & "You're up-to-date!")
			EndIf

		EndIf

	Else ;If ping is below 0 then update server is down, or user is not connected to the internet
		$noInternetMsgBox = "clear variable"
		$noInternetMsgBox = MsgBox(6, $guiTitle, "Warning: You are not connected to the internet or TheAlienDoctor.com is unavailable. This means the update checker could not run. Continue?")
	EndIf

	If $noInternetMsgBox = 2 Then ;Cancel
		Exit

	ElseIf $noInternetMsgBox = 10 Then ;Try again
		checkForUpdates(1)

	ElseIf $noInternetMsgBox = 11 Then ;Continue
	EndIf

	DirRemove(@ScriptDir & "\temp\", 1)
EndFunc   ;==>checkForUpdates

;Functions (Server Management) ################################################################################

Func startServer()
	logWrite(0, "Starting BDS...")
	Global $BDS_process = Run($bdsExe, @ScriptDir, @SW_HIDE, $STDERR_CHILD + $STDOUT_CHILD + $STDIN_CHILD)    ;DO NOT forget $STDIN_CHILD
	$serverRunning = True
	AdlibRegister("updateConsole", 1000)     ; Call updateConsole every 1s
	GUICtrlSetData($gui_console, "[BDS-UI]: Server Startup Triggered. BDS PID is " & $BDS_process & @CRLF, 1)
	GUICtrlSetColor($gui_serverStatusIndicator, $COLOR_GREEN)
	GUICtrlSetData($gui_serverStatusIndicator, "Online")
	logWrite(0, "Server started. BDS PID is " & $BDS_process)
EndFunc   ;==>startServer

Func updateConsole() ;not logging for this one
	If ProcessExists($BDS_process) Then
		Global $line = StdoutRead($BDS_process)
		If @error Then
			$serverRunning = False
			AdlibUnRegister("updateConsole")
		Else
			GUICtrlSetData($gui_console, $line, 1)
		EndIf
	EndIf
EndFunc   ;==>updateConsole

Func RestartServer()
	logWrite(0, "Restarting server...")
	GUICtrlSetData($gui_console, "[BDS-UI]: Server Restart Triggered" & @CRLF, 1)
	stopServer()
	startServer()
	logWrite(0, "Server restarted.")
EndFunc   ;==>RestartServer

Func stopServer()
	logWrite(0, "Stopping server...")
	GUICtrlSetData($gui_console, "[BDS-UI]: Server Stop Triggered" & @CRLF, 1)
	StdinWrite($BDS_process, "stop" & @CRLF)
	Sleep(1000)     ; Wait for a while to give the process time to read the input
	StdinWrite($BDS_process)     ; Close the stream
	$serverRunning = False
	Sleep(3000)
	AdlibUnRegister("updateConsole")
	If ProcessExists($BDS_process) Then
		logWrite(0, "Failed to stop server. PID is still in use, although the process status is unknown")
		MsgBox(0, $guiTitle, "Failed to stop server")
	else
		GUICtrlSetData($gui_console, @CRLF & "[BDS-UI]: Server Offline")
		GUICtrlSetColor($gui_serverStatusIndicator, $COLOR_RED)
		GUICtrlSetData($gui_serverStatusIndicator, "Offline")
		logWrite(0, "Server stopped.")
	endif
	Global $BDS_process = Null
EndFunc   ;==>stopServer

Func backupServer()
	logWrite(0, "Backing up server...")
	GUICtrlSetData($gui_console, "[BDS-UI]: Server Backup Started" & @CRLF, 1)
	GUICtrlSetColor($gui_serverStatusIndicator, $COLOR_ORANGE)
	GUICtrlSetData($gui_serverStatusIndicator, "Backing Up (Pre Processing...)")
	$backupDateTime = "[" & @SEC & "-" & @MIN & "-" & @HOUR & "][" & @MDAY & "." & @MON & "." & @YEAR & "]"
	If $BDS_process = Null Then    ; bds isnt running
		logWrite(0, "BDS is not running. Skipping pre-processing...")
	Else    ;bds is running
		StdinWrite($BDS_process, "save hold" & @CRLF)        ;releases BDS's lock on the file
		Sleep(5000)         ;5s
		StdinWrite($BDS_process, "save query" & @CRLF)
		logWrite(0, "BDS is running. Pre-processing complete.")
	Endif
	DelEmptyDirs()
	Local $ZIPname = $backupDir & "\Backup-" & $backupDateTime & ".zip"    ; E.G: D:/BDS_UI/Backups/Backup-10.01.24.zip
	_Zip_Create($ZIPname)
	logWrite(0, "Backup zip created at " & $ZIPname)
	Sleep(100)
	GUICtrlSetData($gui_serverStatusIndicator, "Backing up (Compressing files...)")
	_Zip_AddFolder($ZIPname, @ScriptDir & "\BDS", 0)    ; see CopyToTemp()
	StdinWrite($BDS_process, "save resume" & @CRLF)
	GUICtrlSetColor($gui_serverStatusIndicator, $COLOR_GREEN)
	GUICtrlSetData($gui_serverStatusIndicator, "Online")
	GUICtrlSetData($gui_console, "[BDS-UI]: Server Backup Completed" & @CRLF, 1)
logWrite(0, "Backup complete. BDS world files released.")
Endfunc   ;==>backupServer

Func sendServerCommand()
	$cmd = GUICtrlRead($gui_commandInput)     ;cmd input box
	StdinWrite($BDS_process, $cmd & @CRLF)
	GUICtrlSetData($gui_console, "[BDS-UI]: Command Sent: '" & $cmd & "'" & @CRLF, 1)
	GUICtrlSetData($gui_commandInput, "")     ;emptys box
	Return
EndFunc   ;==>sendServerCommand

;Main GUI Loop
logWrite(0, "Loading all config files...")
LoadBDSConf()
loadConf()
logWrite(0, "Config files loaded. Starting main loop...")


While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			if $BDS_process == null Then             ;if everything goes pear-shaped it will shoot it when closed
				logWrite(0, "BDS process is closed. Exited main loop")
				Exit
			Else
				logWrite(0, "BDS process is still running. Closing BDS process...")
				If ProcessExists($BDS_process) Then
					logWrite(0, "BDS Process closed. Exited main loop.")
					ProcessClose($BDS_process)
				endif
			endif
			exit

		Case $gui_startServerBtn
			startServer()

		Case $gui_stopServerBtn
			stopServer()

		Case $gui_restartBtn
			RestartServer()

		Case $gui_backupBtn
			backupServer()

		Case $gui_sendCmdBtn
			sendServerCommand()

		Case $gui_saveSettingsBtn
			saveConf()

		Case $gui_UpdateCheckBtn
			checkForUpdates(1)

		Case $gui_serverPropertiesSaveBtn
			SaveBDSConf()
		
		Case $gui_getHelpBtn
			ShellExecute("https://thealiendoctor.com/r/Discord")
		
		Case $gui_openBackupsBtn
			ShellExecute($backupDir)
	EndSwitch
WEnd
