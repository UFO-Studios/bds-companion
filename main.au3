; This is Bedrock Dedicated Server UI (BDS-UI) licensed under the BSD 3-Clause license
; Created with ❤️ & 👽 by the UFO Studios Dev Team (https://github.com/UFO-Studios).
; Check out the github repository of this project for more info @ https://github.com/UFO-Studios/bds-ui.
; Copyright UFO Studios. All rights reserved. For more info, email us: UFOStudios@TheAlienDoctor.com

#pragma compile(Compatibility, XP, vista, win7, win8, win81, win10, win11)
#pragma compile(FileDescription, BDS UI)
#pragma compile(ProductName, BDS UI)
#pragma compile(ProductVersion, 0.1.0)
#pragma compile(FileVersion, 0.1.0)
#pragma compile(LegalCopyright, ©UFO Studios)
#pragma compile(CompanyName, UFO Studios)
#pragma compile(OriginalFilename, BDS UI Beta-0.1.0)

#include <Array.au3>
#include <ButtonConstants.au3>
#include <StaticConstants.au3>
#include <TabConstants.au3>
#include <ColorConstants.au3>
#include <GUIConstantsEx.au3>
#include <GuiEdit.au3>
#include <AutoItConstants.au3>
#include <WindowsConstants.au3>
#include <EditConstants.au3>
#include <File.au3>
#include <GuiIPAddress.au3>
#include <WinAPI.au3>

#include "UDF/Zip.au3"
#include "UDF/WinHttp.au3"
#include "UDF/JSON.au3"

Global Const $currentVersionNumber = "010"
Global Const $guiTitle = "BDS UI - Beta-0.1.0"

; Koda doesn't let you set certain things, so change to match the below manually:
;Global $gui_mainWindow = GUICreate("" & $guiTitle & "", 723, 506)
;Global $gui_serverStatusIndicator = GUICtrlCreateLabel("Offline", 88, 32, 250, 17)
;Global $gui_serverPropertiesLabel = GUICtrlCreateLabel("gui_serverPropertiesLabel", 24, 448, 590, 17)

#Region ### START Koda GUI section ###
Global $gui_mainWindow = GUICreate("" & $guiTitle & "", 723, 506)
Global $gui_tabs = GUICtrlCreateTab(8, 0, 705, 481)
Global $gui_serverCtrlTab = GUICtrlCreateTabItem("Server Control")
Global $gui_serverStatusLabel = GUICtrlCreateLabel("Server Status:", 16, 32, 71, 17)
Global $gui_commandInput = GUICtrlCreateInput("", 16, 408, 585, 21)
Global $gui_sendCmdBtn = GUICtrlCreateButton("Send Command", 608, 407, 91, 25)
Global $gui_startServerBtn = GUICtrlCreateButton("Start Server", 16, 440, 75, 33)
Global $gui_stopServerBtn = GUICtrlCreateButton("Stop Server", 96, 440, 75, 33)
Global $gui_restartBtn = GUICtrlCreateButton("Restart Server", 256, 440, 75, 33)
Global $gui_backupBtn = GUICtrlCreateButton("Backup Server", 336, 440, 83, 33)
Global $gui_serverStatusIndicator = GUICtrlCreateLabel("Offline", 88, 32, 250, 17)
Global $gui_console = GUICtrlCreateEdit("", 16, 56, 689, 345, BitOR($GUI_SS_DEFAULT_EDIT, $ES_READONLY))
Global $gui_killServerBtn = GUICtrlCreateButton("Kill Server", 177, 440, 75, 33)
Global $gui_serverPropertiesTab = GUICtrlCreateTabItem("Server Properties")
Global $gui_ServerPropertiesGroup = GUICtrlCreateGroup("Server.Properties", 16, 32, 689, 441)
Global $gui_ServerPropertiesEdit = GUICtrlCreateEdit("", 24, 56, 673, 377)
GUICtrlSetData(-1, "gui_ServerPropertiesEdit")
Global $gui_serverPropertiesSaveBtn = GUICtrlCreateButton("Save", 624, 440, 75, 25)
Global $gui_serverPropertiesLabel = GUICtrlCreateLabel("gui_serverPropertiesLabel", 24, 448, 590, 17)
GUICtrlCreateGroup("", -99, -99, 1, 1)
Global $gui_settingsTab = GUICtrlCreateTabItem("Settings")
Global $gui_restartSettingsGroup = GUICtrlCreateGroup("Restart Settings", 16, 29, 689, 73)
Global $gui_autoRestartTimeInput = GUICtrlCreateInput("", 445, 48, 169, 21)
Global $gui_autoRestartTimeLabel = GUICtrlCreateLabel("Restart Times:", 373, 48, 72, 17)
Global $gui_autoRestartCheck = GUICtrlCreateCheckbox("Auto Restarts Enabled", 21, 48, 129, 17)
Global $gui_backupDuringRestartCheck = GUICtrlCreateCheckbox("Backup During Restart", 21, 72, 129, 17)
Global $gui_autoRestartEgText = GUICtrlCreateLabel("E.G. 6,12,18,24", 616, 48, 79, 17)
GUICtrlCreateGroup("", -99, -99, 1, 1)
Global $gui_saveSettingsBtn = GUICtrlCreateButton("Save Settings", 600, 440, 107, 33)
Global $gui_dirSettingGroup = GUICtrlCreateGroup("File Paths", 16, 112, 689, 153)
Global $gui_bdsDirInput = GUICtrlCreateInput("", 120, 136, 577, 21)
Global $gui_bdsDirLabel = GUICtrlCreateLabel("BDS File Location:", 24, 136, 92, 17)
Global $gui_logsDirLabel = GUICtrlCreateLabel("Logs Folder:", 24, 168, 62, 17)
Global $gui_logsDirInput = GUICtrlCreateInput("", 88, 168, 609, 21)
Global $gui_bdsLogsDirTitle = GUICtrlCreateLabel("BDS Logs Folder:", 24, 200, 87, 17)
Global $gui_bdsLogsDirInput = GUICtrlCreateInput("", 112, 200, 585, 21)
Global $gui_backupsDirTitle = GUICtrlCreateLabel("Backup Folder:", 24, 232, 76, 17)
Global $gui_backupsDirInput = GUICtrlCreateInput("", 104, 232, 593, 21)
GUICtrlCreateGroup("", -99, -99, 1, 1)
Global $gui_aboutGroup = GUICtrlCreateGroup("About", 16, 352, 257, 121)
Global $gui_abtVerNum = GUICtrlCreateLabel("Version: " & $guiTitle & "", 24, 380, 119, 17)
Global $gui_discordBtn = GUICtrlCreateButton("Join Our Discord!", 152, 408, 107, 25)
Global $gui_UpdateCheckBtn = GUICtrlCreateButton("Check for Updates", 152, 376, 107, 25)
Global $gui_patreonBtn = GUICtrlCreateButton("Support this project :)", 24, 408, 115, 25)
Global $gui_readmeBtn = GUICtrlCreateButton("Instructions and Credits", 24, 440, 243, 25)
GUICtrlCreateGroup("", -99, -99, 1, 1)
Global $gui_DebugGroup = GUICtrlCreateGroup("Debug", 280, 352, 209, 121)
Global $gui_debugEnableBtn = GUICtrlCreateButton("Enable Debug Mode", 288, 376, 131, 25)
Global $gui_UploadLogsBtn = GUICtrlCreateButton("Upload Logs For Help", 288, 408, 131, 25)
;~ Global $gui_FindServerBtn = GUICtrlCreateButton("Find Running BDS Server", 288, 440, 131, 25)
GUICtrlCreateGroup("", -99, -99, 1, 1)
GUICtrlCreateTabItem("")
Global $gui_copyright = GUICtrlCreateLabel("© UFO Studios 2024", 8, 488, 103, 17)
GUICtrlSetCursor(-1, 0)
Global $gui_versionNum = GUICtrlCreateLabel("Version: 1.0.0", 648, 488, 69, 17)
Global $gui_githubLabel = GUICtrlCreateLabel("View source code, report bugs and contribute on GitHub", 248, 488, 270, 17)
GUICtrlSetCursor(-1, 0)
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

;Variables ###################################################################################

Global $bdsFolder = @ScriptDir & "\BDS"
Global $bdsExe = $bdsFolder & "\bedrock_server.exe"
Global $settingsFile = @ScriptDir & "\settings.ini"
Global $serverRunning = False
Global $BDS_process = Null


;Functions (Server Status) #############################################################################

Func setServerStatus($colour, $status)
	GUICtrlSetColor($gui_serverStatusIndicator, $colour)
	GUICtrlSetData($gui_serverStatusIndicator, $status)
EndFunc   ;==>setServerStatus

;Functions (Config) #############################################################################

Func loadConf()
	Global $cfg_autoRestart = IniRead($settingsFile, "autoRestart", "restartEnabled", "False")
	If $cfg_autoRestart = "True" Then
		GUICtrlSetState($gui_autoRestartCheck, $GUI_CHECKED)
	ElseIf $cfg_autoRestart = "False" Then
		GUICtrlSetState($gui_autoRestartCheck, $GUI_UNCHECKED)
	EndIf

	Global $cfg_backupDuringRestart = IniRead($settingsFile, "autoRestart", "backupDuringRestart", "False")
	If $cfg_backupDuringRestart = "True" Then
		GUICtrlSetState($gui_backupDuringRestartCheck, $GUI_CHECKED)
	ElseIf $cfg_backupDuringRestart = "False" Then
		GUICtrlSetState($gui_backupDuringRestartCheck, $GUI_UNCHECKED)
	EndIf

	Global $cfg_autoRestartInterval = IniRead($settingsFile, "autoRestart", "restartInterval", "6,12,18,24")
	GUICtrlSetData($gui_autoRestartTimeInput, $cfg_autoRestartInterval)

	If IniRead($settingsFile, "dirs", "bdsDir", "") = "" Then ;For first time ran
		IniWrite($settingsFile, "dirs", "bdsDir", @ScriptDir & "\BDS")
	EndIf
	Global $cfg_bdsDir = IniRead($settingsFile, "dirs", "bdsDir", @ScriptDir & "\BDS")
	Global $bdsExeRun = 'C:\Windows\System32\cmd.exe /c ' & '"' & $cfg_bdsDir & '\bedrock_server.exe' & '"' ;We use cmd.exe otherwise bds freaks out. idk why
	GUICtrlSetData($gui_bdsDirInput, $cfg_bdsDir)

	If IniRead($settingsFile, "dirs", "logsDir", "") = "" Then ;For first time ran
		IniWrite($settingsFile, "dirs", "logsDir", @ScriptDir & "\logs")
	EndIf
	Global $cfg_logsDir = IniRead($settingsFile, "dirs", "logsDir", @ScriptDir & "\Logs")
	GUICtrlSetData($gui_logsDirInput, $cfg_logsDir)

	If IniRead($settingsFile, "dirs", "bdsLogsDir", @ScriptDir & "") = "" Then ;For first time ran
		IniWrite($settingsFile, "dirs", "bdsLogsDir", @ScriptDir & "\Server Logs")
	EndIf
	Global $cfg_bdsLogsDir = IniRead($settingsFile, "dirs", "bdsLogsDir", @ScriptDir & "\Server Logs")
	GUICtrlSetData($gui_bdsLogsDirInput, $cfg_bdsLogsDir)

	If IniRead($settingsFile, "dirs", "backupsDir", @ScriptDir & "") = "" Then ;For first time ran
		IniWrite($settingsFile, "dirs", "backupsDir", @ScriptDir & "\Backups")
	EndIf
	Global $cfg_backupsDir = IniRead($settingsFile, "dirs", "backupsDir", @ScriptDir & "\Backups")
	GUICtrlSetData($gui_backupsDirInput, $cfg_backupsDir)

	Global $cfg_verboseLogging = IniRead($settingsFile, "debug", "verboseLogging", "False")

	saveConf()
EndFunc   ;==>loadConf

loadConf()

Func saveConf()
	If GUICtrlRead($gui_autoRestartCheck) = $GUI_CHECKED Then
		$cfg_autoRestart = "True"
	ElseIf GUICtrlRead($gui_autoRestartCheck) = $GUI_UNCHECKED Then
		$cfg_autoRestart = "False"
	EndIf
	IniWrite($settingsFile, "autoRestart", "restartEnabled", $cfg_autoRestart)

	If GUICtrlRead($gui_backupDuringRestartCheck) = $GUI_CHECKED Then
		$cfg_backupDuringRestart = "True"
	ElseIf GUICtrlRead($gui_backupDuringRestartCheck) = $GUI_UNCHECKED Then
		$cfg_backupDuringRestart = "False"
	EndIf
	IniWrite($settingsFile, "autoRestart", "backupDuringRestart", $cfg_backupDuringRestart)

	$cfg_autoRestartInterval = GUICtrlRead($gui_autoRestartTimeInput)
	IniWrite($settingsFile, "autoRestart", "restartInterval", $cfg_autoRestartInterval)

	$cfg_bdsDir = GUICtrlRead($gui_bdsDirInput)
	IniWrite($settingsFile, "dirs", "bdsDir", $cfg_bdsDir)

	$cfg_logsDir = GUICtrlRead($gui_logsDirInput)
	IniWrite($settingsFile, "dirs", "logsDir", $cfg_logsDir)

	$cfg_bdsLogsDir = GUICtrlRead($gui_bdsLogsDirInput)
	IniWrite($settingsFile, "dirs", "bdsLogsDir", $cfg_bdsLogsDir)

	$cfg_backupsDir = GUICtrlRead($gui_backupsDirInput)
	IniWrite($settingsFile, "dirs", "backupsDir", $cfg_backupsDir)
EndFunc   ;==>saveConf


;Functions (Logging) ############################################################################

Func logWrite($spaces, $content, $onlyVerbose = False)
	If $spaces = 1 Then ;For adding spaces around the content written to the log
		FileOpen($cfg_logsDir & "\log.latest", 1)
		FileWrite($cfg_logsDir & "\log.latest", @CRLF)
		FileClose($cfg_logsDir & "\log.latest")
	ElseIf $spaces = 2 Then
		FileOpen($cfg_logsDir & "\log.latest", 1)
		FileWrite($cfg_logsDir & "\log.latest", @CRLF)
		FileClose($cfg_logsDir & "\log.latest")
	EndIf

	FileOpen($cfg_logsDir & "\log.latest", 1)
	If ($onlyVerbose = True) Then
		If ($cfg_verboseLogging = "True") Then ;if both are true then write to log, else drop it
			FileWrite($cfg_logsDir & "\log.latest", @MDAY & "/" & @MON & "/" & @YEAR & " @ " & @HOUR & ":" & @MIN & ":" & @SEC & " > " & $content & @CRLF)
		EndIf
	Else ;write to log as normal
		FileWrite($cfg_logsDir & "\log.latest", @MDAY & "/" & @MON & "/" & @YEAR & " @ " & @HOUR & ":" & @MIN & ":" & @SEC & " > " & $content & @CRLF)
	EndIf
	FileClose($cfg_logsDir & "\log.latest")

	If $spaces = 1 Then
		FileOpen($cfg_logsDir & "\log.latest", 1)
		FileWrite($cfg_logsDir & "\log.latest", @CRLF)
		FileClose($cfg_logsDir & "\log.latest")
	ElseIf $spaces = 3 Then
		FileOpen($cfg_logsDir & "\log.latest", 1)
		FileWrite($cfg_logsDir & "\log.latest", @CRLF)
		FileClose($cfg_logsDir & "\log.latest")
	EndIf
EndFunc   ;==>logWrite

Func createLog()
	If FileExists($cfg_logsDir & "\latest.log") Then
		logWrite(0, "createLog() called. Skipping as log.latest already exists.", True)
	EndIf

	If FileExists($cfg_logsDir) Then ;If directory exists then begin writing logs
		logWrite(0, "Log file generated at " & @HOUR & ":" & @MIN & ":" & @SEC & " on " & @MDAY & "/" & @MON & "/" & @YEAR & " (HH:MM:SS on DD.MM.YY)")
		logWrite(0, "###################################################################")
	ElseIf FileExists($cfg_logsDir) = 0 Then ;If directory doesn't exist create it then begin writing logs
		DirCreate($cfg_logsDir)
		logWrite(0, "Log file generated at " & @HOUR & ":" & @MIN & ":" & @SEC & " on " & @MDAY & "/" & @MON & "/" & @YEAR & " (HH:MM:SS on DD.MM.YY)")
		logWrite(0, "###################################################################")
		logWrite(0, "Created logging directory!")
	EndIf
EndFunc   ;==>createLog

Func closeLog()
	FileOpen($cfg_logsDir & "\log.latest", 1)
	logWrite(0, "###################################################################")
	logWrite(0, "Log file closed at " & @HOUR & ":" & @MIN & ":" & @SEC & " on " & @MDAY & "/" & @MON & "/" & @YEAR & " (HH:MM:SS on DD.MM.YY)")
	FileMove($cfg_logsDir & "\log.latest", $cfg_logsDir & "\log[" & @MDAY & '.' & @MON & '.' & @YEAR & '-' & @HOUR & '.' & @MIN & '.' & @SEC & "].txt")
EndFunc   ;==>closeLog

;Functions (Server Logging) #######################################################################

Func BDScreateLog()
	If FileExists($cfg_bdsLogsDir & "\latest.log") Then
		FileMove($cfg_bdsLogsDir & "\log.latest", $cfg_bdsLogsDir & "\log.old")
	EndIf

	If FileExists($cfg_bdsLogsDir) Then ;If directory exists then begin writing logs
		FileWrite(0, "Log file generated at " & @HOUR & ":" & @MIN & ":" & @SEC & " on " & @MDAY & "/" & @MON & "/" & @YEAR & " (HH:MM:SS on DD.MM.YY)")
		FileWrite(0, "###################################################################")
	ElseIf FileExists($cfg_bdsLogsDir) = 0 Then ;If directory doesn't exist create it then begin writing logs
		DirCreate($cfg_bdsLogsDir)
		FileWrite(0, "Log file generated at " & @HOUR & ":" & @MIN & ":" & @SEC & " on " & @MDAY & "/" & @MON & "/" & @YEAR & " (HH:MM:SS on DD.MM.YY)")
		FileWrite(0, "###################################################################")
		logWrite(0, "Created logging directory!")
	EndIf
EndFunc   ;==>BDScreateLog

Func BDScloseLog()
	FileOpen($cfg_bdsLogsDir & "\log.latest", 1)
	BDSlogWrite("###################################################################")
	BDSlogWrite("Log file closed at " & @HOUR & ":" & @MIN & ":" & @SEC & " on " & @MDAY & "/" & @MON & "/" & @YEAR & " (HH:MM:SS on DD.MM.YY)")
	FileMove($cfg_bdsLogsDir & "\log.latest", $cfg_bdsLogsDir & "\log[" & @MDAY & '.' & @MON & '.' & @YEAR & '-' & @HOUR & '.' & @MIN & '.' & @SEC & "].txt")
EndFunc   ;==>BDScloseLog

Func BDSlogWrite($content)
	FileOpen($cfg_bdsLogsDir & "\log.latest", 1)
	FileWrite($cfg_bdsLogsDir & "\log.latest", @MDAY & "/" & @MON & "/" & @YEAR & " @ " & @HOUR & ":" & @MIN & ":" & @SEC & " > " & $content & @CRLF)
	FileClose($cfg_bdsLogsDir & "\log.latest")
EndFunc   ;==>BDSlogWrite

Func outputToConsole($content)

	GUICtrlSetData($gui_console, @MDAY & "/" & @MON & "/" & @YEAR & " @ " & @HOUR & ":" & @MIN & ":" & @SEC & " > " & "[BDS-UI]: " & $content & @CRLF, 1)

	FileOpen($cfg_bdsLogsDir & "\log.latest", 1)
	FileWrite($cfg_bdsLogsDir & "\log.latest", @MDAY & "/" & @MON & "/" & @YEAR & " @ " & @HOUR & ":" & @MIN & ":" & @SEC & " > " & "[BDS-UI]: " & $content & @CRLF)
	FileClose($cfg_bdsLogsDir & "\log.latest")

	logWrite(0, "Output to console: [BDS-UI]: " & $content)
EndFunc   ;==>outputToConsole

;Functions (BDS Config) #########################################################################

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
	Local $BDSconfFile = $cfg_bdsDir & "/server.properties"
	logWrite(0, "Loading BDS conf file from " & $BDSconfFile & "...")
	$FileOpened = FileRead($BDSconfFile)
	If @error Then
		logWrite(0, "Error opening file. Error code: " & @error)
		MsgBox(0, $guiTitle, "Error: cannot open server.properties! " & @CRLF & " is it in " & $cfg_bdsDir & "?" & @CRLF & "Error code: " & @error)
		GUICtrlSetData($gui_ServerPropertiesEdit, "Error opening file! Is it in  " & $bdsFolder & "? (Code: " & @error & ")")
	Else
		logWrite(0, "File opened successfully.")
		GUICtrlSetData($gui_ServerPropertiesEdit, $FileOpened)
	EndIf
EndFunc   ;==>LoadBDSConf

Func SaveBDSConf()
	Local $BDSconfFile = $cfg_bdsDir & "/server.properties"
	Local $NewFileValue = GUICtrlRead($gui_ServerPropertiesEdit)
	logWrite(0, "Saved BDS conf file to " & $BDSconfFile)
	ReplaceFileContents($BDSconfFile, $NewFileValue)
EndFunc   ;==>SaveBDSConf

;Functions (Scheduled Actions) ##################################################################

Func ScheduledActions()
	logWrite(0, "Scheduled actions called")
	If $cfg_autoRestart = "True" Then
		logWrite(0, "Auto Restart is enabled")
		; Split the autoRestartInterval string into an array
		Local $aIntervals = StringSplit($cfg_autoRestartInterval, ",")
		logWrite(0, "Split intervals into array")
		Local $hour = @HOUR

		If @HOUR = 23 Then
			$hour = 0
		Else
			$hour += 1
		EndIf
		logWrite(0, "Added 1 to hour for check")

		logWrite(0, "Checking if hour matches config")
		; Find the index of the current hour in the array
		Local $iIndex = _ArraySearch($aIntervals, $hour)
		If $iIndex > 0 Then
			logWrite(0, "Auto Restart time reached")
			; Check if the current time is 5 minutes before the hour
			If @MIN = 55 Then
				logWrite(0, "Sending 5 minute warning")
				sendServerCommand("say Server will restart in 5 minutes")
			EndIf

			If @MIN = 59 Then
				sendServerCommand("say Server will restart in 1 minute")
			EndIf
		EndIf

		; For when restart time is reached
		If @MIN = 0 Then
			$iIndex = 0
			$iIndex = _ArraySearch($aIntervals, @HOUR)
			If $iIndex > 0 Then
				logWrite(0, "Auto restart time reached. Restarting server...")
				GUICtrlSetData($gui_serverStatusIndicator, "Running scheduled restart")
				GUICtrlSetColor($gui_serverStatusIndicator, $COLOR_PURPLE)
				If ($cfg_backupDuringRestart = "True") Then
					RestartServer(1)  ;Backup during restart
				Else
					RestartServer(0)
				EndIf
			EndIf
		Else
			logWrite(0, "Minute is not 0")
		EndIf
	EndIf
EndFunc   ;==>ScheduledActions

;Functions (Misc) ##################################################################################

Func IsBackupThread()
	;Check if the current thread is the backup thread
	If ($CmdLine[0] > 0) Then
		If ($CmdLine[1] = "backup") Then
			logWrite(0, "Backup thread detected. Running backup...")
			backupServer()
			logWrite(0, "Backup complete. Exiting backup thread.")
			Exit
		Else
			logWrite(0, "Backup thread not detected. Continuing...")
		EndIf
	Else
		logWrite(0, "Backup thread not detected. Continuing...")
	EndIf
EndFunc   ;==>IsBackupThread

Func UploadLog()
	logWrite(0, "Uploading log (" & $cfg_logsDir & "\log.latest) to server...")
	Local $logFile = FileOpen($cfg_logsDir & "\log.latest", 0)
	$logFile = FileRead($logFile)
	$res = HttpPost("https://api.mclo.gs/1/log", "content=" & $logFile)
	logWrite(0, "Log uploaded to server. Getting url...")
	$tmp = StringSplit($res, '"')
	$url = $tmp[10]
	$url = StringReplace($url, "\/", "/")
	logWrite(0, "URL: " & $url)
	MsgBox(0, "Log Uploaded", "Log uploaded to server. URL: " & $url)
	FileClose($logFile)
	ShellExecute($url)
EndFunc   ;==>UploadLog

Func startup()
	createLog()
	logWrite(0, "Starting " & $guiTitle & "...")
	logWrite(0, "Verbose logging is " & $cfg_verboseLogging, True)

	;Disable buttons that can't be used
	GUICtrlSetState($gui_stopServerBtn, $GUI_DISABLE)
	GUICtrlSetState($gui_restartBtn, $GUI_DISABLE)
	GUICtrlSetState($gui_sendCmdBtn, $GUI_DISABLE)

	;Register scheduled actions
	AdlibRegister("ScheduledActions", 60 * 1000) ;every minute
	logWrite(0, "Auto restart scheduled actions registered.")

	;Config
	checkForBDS()
	LoadBDSConf()
	loadConf()
	logWrite(0, "Startup functions complete, starting main loop")

	;Set initial server status
	GUICtrlSetData($gui_console, "[BDS-UI]: Server Offline" & @CRLF, 1)
	GUICtrlSetColor($gui_serverStatusIndicator, $COLOR_RED)
	_GUICtrlEdit_SetLimitText($gui_console, 200000)
	logWrite(0, "Server status set to offline.")

	GUICtrlSetData($gui_serverPropertiesLabel, "File Location: " & $cfg_bdsDir & "\server.properties")
	logWrite(0, "Complete! Started main loop", True)
EndFunc   ;==>startup

Func exitScript()
	logWrite(0, "Exiting script...")
	AdlibUnRegister("ScheduledActions")
	If $BDS_process = Null Then ;stopServer has closed it properly
		logWrite(0, "BDS Process isn't running. Closing script")
	ElseIf ProcessExists($BDS_process) Then
		_WinAPI_FlashWindow($gui_mainWindow, 1)
		logWrite(0, "BDS Process is still running. Checking if user wants it closed")
		Local $msgBox = MsgBox(4, $guiTitle, "BDS process is still running. Would you like to kill it?" & @CRLF & "This can result in loss of data, so  only do this if you need to")
		If $msgBox = 6 Then ;Yes
			RunWait("taskkill /IM bedrock_server.exe /F", @SW_HIDE) ;Kills all bedrock_server.exe instances, works better than ProcessClose
		ElseIf $msgBox = 7 Then ;No
			logWrite(0, "User chose not to kill BDS process. Canceling close")
			Return
		EndIf

		$serverRunning = False
		AdlibUnRegister("updateConsole")
		logWrite(0, "BDS Process killed. Closing script")
	Else
		logWrite(0, "BDS Process is not running. Closing script")
	EndIf
	closeLog()

	DirRemove(@ScriptDir & "\temp\", 1)
	Exit
EndFunc   ;==>exitScript

Func checkForBDS()
	If FileExists($cfg_bdsDir & "/bedrock_server.exe") Then
		logWrite(0, "BDS exe found, proceeding with startup")
	Else
		logWrite(0, "BDS file not found, asking user what to do")
		Local $msgBox = MsgBox(6, $guiTitle, "Could not find BDS executable. Please make sure the below folder is correct." & @CRLF & $cfg_bdsDir & "/bedrock_server.exe")

		If $msgBox = 2 Then ;Cancel
			logWrite(0, "Canceled. Exiting script.")
			exitScript()
			Exit
		ElseIf $msgBox = 10 Then ;Try again
			logWrite(0, "Trying again")
			checkForBDS()
		ElseIf $msgBox = 11 Then ;Continue
			logWrite(0, "Continuing, ignoring missing BDS.")
			;Do nothing
		EndIf
	EndIf
EndFunc   ;==>checkForBDS


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
				ShellExecute("https://www.thealiendoctor.com/downloads/bds-ui")
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
	If (ProcessExists($BDS_process)) Then
		logWrite(0, "BDS process already running. Skipping startServer()")
		;MsgBox(0, $guiTitle, "BDS process already running. Skipping startServer()")
		Return
	EndIf
	Global $BDS_process = Run($bdsExeRun, @ScriptDir, @SW_HIDE, $STDERR_CHILD + $STDOUT_CHILD + $STDIN_CHILD)     ;DO NOT forget $STDIN_CHILD
	$serverRunning = True
	AdlibRegister("updateConsole", 1000)     ; Call updateConsole every 1s
	outputToConsole("Server Startup Triggered. BDS PID is " & $BDS_process)
	GUICtrlSetColor($gui_serverStatusIndicator, $COLOR_GREEN)
	GUICtrlSetData($gui_serverStatusIndicator, "Online")
	BDScreateLog()
	logWrite(0, "Server started. BDS PID is " & $BDS_process)

	GUICtrlSetState($gui_stopServerBtn, $GUI_ENABLE)
	GUICtrlSetState($gui_restartBtn, $GUI_ENABLE)
	GUICtrlSetState($gui_sendCmdBtn, $GUI_ENABLE)

	GUICtrlSetState($gui_startServerBtn, $GUI_DISABLE)
EndFunc   ;==>startServer

Func updateConsole() ;not logging for this one
	If ProcessExists($BDS_process) Then
		Global $line = StdoutRead($BDS_process)
		If @error Then
			$serverRunning = False
			AdlibUnRegister("updateConsole")
		Else
			Local $lineCount = _GUICtrlEdit_GetLineCount($gui_console) ;Get line count
			_GUICtrlEdit_LineScroll($gui_console, 0, $lineCount) ;Scroll down to bottom of console, stops existing text from being overwritten
			GUICtrlSetData($gui_console, $line, 1)
			If $line <> "" Then ;if line has content
				BDSlogWrite($line)
			EndIf
		EndIf
	EndIf
EndFunc   ;==>updateConsole

Func RestartServer($backup)
	If (ProcessExists($BDS_process)) Then
		If $backup = 1 Then
			logWrite(0, "Restarting server...")
			outputToConsole("Server Restart Triggered")
			stopServer()
;~ backupServer()
			setServerStatus($COLOR_ORANGE, "Backing up (see other window for progress...)")
			ShellExecute(@ScriptFullPath, " backup")
			Sleep(5000)
			While 1
				If (FileExists(@ScriptDir & "\temp\is_running") = 0) Then
					setServerStatus($COLOR_GREEN, "Online")
				EndIf
				ExitLoop
			WEnd
			startServer()
			logWrite(0, "Server restarted")
		ElseIf $backup = 0 Then
			logWrite(0, "Restarting server...")
			outputToConsole("Server Restart Triggered")
			stopServer()
			startServer()
			logWrite(0, "Server restarted")
		EndIf
	Else
		logWrite(0, "BDS process not found. Skipping restart.")
	EndIf
EndFunc   ;==>RestartServer

Func FindServerPID()
	logWrite(0, "Finding BDS PID...")
	Local $cmd = "pwsh -c (Get-Process bedrock_server.exe).Id"
	Local $output = Run($cmd, @ScriptDir, @SW_HIDE, $STDERR_CHILD + $STDOUT_CHILD + $STDIN_CHILD)
	Local $tmp = StdoutRead($output)
	If ($tmp = "") Then
		logWrite(0, "BDS PID not found. BDS is not running.")
		Return 0
	Else
		logWrite(0, "BDS PID found. BDS is running.")
		$BDS_process = $tmp

		logWrite(0, "BDS PID is " & $BDS_process)
		Return $BDS_process
	EndIf
EndFunc   ;==>FindServerPID

Func stopServer()
	logWrite(0, "Stopping server")
	outputToConsole("Server Stop Triggered")
	$attempts = 0
	sendServerCommand("stop")
	Sleep(5 * 1000) ;5s
	While ($attempts < 5 And ProcessExists($BDS_process))
		$attempts = $attempts + 1
		sendServerCommand("stop")
		logWrite(0, "Server stop attempt " & $attempts & " of 4")
		Sleep((5 - $attempts) * 1000) ;so it gets shorter each time
	WEnd
	If (ProcessExists($BDS_process)) Then
		logWrite(0, "Server stop failed.")
		MsgBox(0, $guiTitle, "Server stop failed. Please kill the process manually.")
	Else
		GUICtrlSetColor($gui_serverStatusIndicator, $COLOR_RED)
		GUICtrlSetData($gui_serverStatusIndicator, "Offline")
		logWrite(0, "Server stopped.")
		outputToConsole("Server Stopped")

		GUICtrlSetState($gui_stopServerBtn, $GUI_DISABLE)
		GUICtrlSetState($gui_restartBtn, $GUI_DISABLE)
		GUICtrlSetState($gui_sendCmdBtn, $GUI_DISABLE)

		GUICtrlSetState($gui_startServerBtn, $GUI_ENABLE)

		BDScloseLog()
	EndIf

	Global $BDS_process = Null
EndFunc   ;==>stopServer

Func killServer()
	logWrite(0, "Kill Server Triggered")
	Local $msgBox = MsgBox(4, $guiTitle, "Warning: This will kill BDS process, which could corrupt server files. This should only be used when server is unresponsive." & @CRLF & "Continue?")
	If $msgBox = 6 Then ;Yes
		outputToConsole("Server Kill Triggered")
		RunWait("taskkill /IM bedrock_server.exe /F", @SW_HIDE) ;Kills all bedrock_server.exe instances, works better than ProcessClose

		$serverRunning = False
		$BDS_process = Null

		outputToConsole("Server Offline")
		GUICtrlSetColor($gui_serverStatusIndicator, $COLOR_RED)
		GUICtrlSetData($gui_serverStatusIndicator, "Offline")

		GUICtrlSetState($gui_stopServerBtn, $GUI_DISABLE)
		GUICtrlSetState($gui_restartBtn, $GUI_DISABLE)
		GUICtrlSetState($gui_sendCmdBtn, $GUI_DISABLE)

		GUICtrlSetState($gui_startServerBtn, $GUI_ENABLE)

		BDScloseLog()

		AdlibUnRegister("updateConsole")

		logWrite(0, "Server Killed")
	ElseIf $msgBox = 7 Then ;No
		logWrite(0, "Aborted server killing. It will live for another day!")
	EndIf
EndFunc   ;==>killServer


Func backupServer()
	If (ProcessExists($BDS_process)) Then
		If MsgBox(4, $guiTitle, "The server is still running. Are you sure you want to backup? Backing up the server whilst its running can lead to world corruption if the server crashes.") = 6 Then
			sendServerCommand("Server is backing up")
			Sleep(2)
			sendServerCommand("save hold")
		Else
			logWrite(0, "Backup Cancelled")
			Return
		EndIf
	EndIf

	;PRE PROCESSING & FILE LOCKS
	logWrite(0, "Backing up server...")
	DirCreate(@ScriptDir & "\temp\") ;for other thread
	FileWrite("/temp/is_running", "1")

	If ($cfg_verboseLogging = "True") Then logWrite(0, "Verbose logging for backup enabled! Current status: 'Pre Processing...'")
	setServerStatus($COLOR_ORANGE, "Backing up (Pre Processing...)")
	outputToConsole("Server Backup Started")

	;COPY FILES TO TEMP FOLDER
	;backup: "behavior_packs/, config/, resource_packs/, worlds/, allowlist.json, permissions.json, server.properties"
	logWrite(0, "Copying files to tempory folder")
	setServerStatus($COLOR_ORANGE, "Backing up (Copying files...)")
	DirCreate(@ScriptDir & "\temp\backups\")
	DirCopy($cfg_bdsDir & "\behavior_packs", @ScriptDir & "\temp\backups\behavior_packs", 1)
	DirCopy($cfg_bdsDir & "\behavior_packs", @ScriptDir & "\temp\backups\config", 1)
	DirCopy($cfg_bdsDir & "\resource_packs", @ScriptDir & "\temp\backups\resource_packs", 1)
	DirCopy($cfg_bdsDir & "\worlds", @ScriptDir & "\temp\backups\worlds", 1)
	FileCopy($cfg_bdsDir & "\allowlist.json", @ScriptDir & "\temp\backups\allowlist.json", 1)
	FileCopy($cfg_bdsDir & "\permissions.json", @ScriptDir & "\temp\backups\permissions.json", 1)
	FileCopy($cfg_bdsDir & "\server.properties", @ScriptDir & "\temp\backups\server.properties", 1)
	logWrite(0, "Files copied to temporary folder. Restarting BDS if it was running")

	;POST PROCESSING & RELEASE FILE LOCKS. Not (in theory) in use, but keeping it for edge cases.
	If (ProcessExists($BDS_process)) Then
		sendServerCommand("save resume")
		logWrite(0, "BDS's Lock has been reacquired. Copy Complete.")
	EndIf
	logWrite(0, "Creating Zip & compressing files...")
	setServerStatus($COLOR_ORANGE, "Backing up (Compressing files...)")

	;CREATE ZIP
	Local $backupDateTime = "[" & @HOUR & "-" & @MIN & "-" & @SEC & "][" & @MDAY & "." & @MON & "." & @YEAR & "]"
	Local $ZIPname = $cfg_backupsDir & "\Backup-" & $backupDateTime & ".zip"
	_Zip_Create($ZIPname)
	logWrite(0, "Backup zip created at " & $ZIPname)
	Sleep(100)

	;COMPRESS FILES
	setServerStatus($COLOR_ORANGE, "Backing up (Compressing files 1/7)")
	_Zip_AddFolder($ZIPname, @ScriptDir & "\temp\backups\behavior_packs", 0)
	If @error Then MsgBox(0, "Error", "Error adding folder to zip: " & @error)
	logWrite(0, "Backup (Compressed files 1/7). Code " & @error, True)
	setServerStatus($COLOR_ORANGE, "Backing up (Compressing files 2/7)")
	_Zip_AddFolder($ZIPname, @ScriptDir & "\temp\backups\config", 0)
	If @error Then MsgBox(0, "Error", "Error adding folder to zip: " & @error)
	logWrite(0, "Backup (Compressed files 2/7). Code " & @error, True)
	setServerStatus($COLOR_ORANGE, "Backing up (Compressing files 3/7)")
	_Zip_AddFolder($ZIPname, @ScriptDir & "\temp\backups\resource_packs", 0)
	If @error Then MsgBox(0, "Error", "Error adding folder to zip: " & @error)
	logWrite(0, "Backup (Compressed files 3/7). Code " & @error, True)
	setServerStatus($COLOR_ORANGE, "Backing up (Compressing files 4/7)")
	_Zip_AddFolder($ZIPname, @ScriptDir & "\temp\backups\worlds", 0)
	If @error Then MsgBox(0, "Error", "Error adding folder to zip: " & @error)
	logWrite(0, "Backup (Compressed files 4/7). Code " & @error, True)
	setServerStatus($COLOR_ORANGE, "Backing up (Compressing files 5/7)")
	_Zip_AddFile($ZIPname, @ScriptDir & "\temp\backups\allowlist.json", 0)
	If @error Then MsgBox(0, "Error", "Error adding folder to zip: " & @error)
	logWrite(0, "Backup (Compressed files 5/7). Code " & @error, True)
	setServerStatus($COLOR_ORANGE, "Backing up (Compressing files 6/7)")
	_Zip_AddFile($ZIPname, @ScriptDir & "\temp\backups\permissions.json", 0)
	If @error Then MsgBox(0, "Error", "Error adding folder to zip: " & @error)
	logWrite(0, "Backup (Compressed files 6/7). Code " & @error, True)
	setServerStatus($COLOR_ORANGE, "Backing up (Compressing files 7/7)")
	_Zip_AddFile($ZIPname, @ScriptDir & "\temp\backups\server.properties", 0)
	If @error Then MsgBox(0, "Error", "Error adding folder to zip: " & @error)
	logWrite(0, "Backup (Compressed files 7/7). Code " & @error, True)
	logWrite(0, "Backup (Complete)", True)
	outputToConsole("Server Backup Complete")

	;CLEANUP
	logWrite(0, "Cleaning up temporary files")
	DirRemove(@ScriptDir & "\temp\", 1)
	logWrite(0, "Temporary files cleaned up")

	;SET STATUS
	If (ProcessExists($BDS_process)) Then
		setServerStatus($COLOR_GREEN, "Online")
		outputToConsole("Server backup complete")
	Else
		setServerStatus($COLOR_RED, "Offline")
	EndIf
EndFunc   ;==>backupServer

Func sendServerCommand($content)
	If (ProcessExists($BDS_process)) Then StdinWrite($BDS_process, $content & @CRLF)
	outputToConsole("Command Sent: '" & $content & "'")
	logWrite(0, "Sent server command: " & $content)
EndFunc   ;==>sendServerCommand


If FileExists(@ScriptDir & "\LICENSE.txt") = 0 Then ;License re-download
	InetGet("https://thealiendoctor.com/software-license/pack-converter-2022.txt", @ScriptDir & "\LICENSE.txt") ;Temp license until public
	logWrite(0, "Re-downloaded license")
EndIf

If ($CmdLine[0] > 0) Then
	If ($CmdLine[1] = "backup") Then
		logWrite(0, "Backup thread detected. Running backup...")
		GUICtrlSetState($gui_mainWindow, @SW_HIDE)
		backupServer()
		logWrite(0, "Backup complete. Exiting backup thread.")
		Exit
	Else
		startup()
	EndIf
Else
	startup()
EndIf

While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			exitScript()
;~ exit ;this is done in exitScript()

		Case $gui_startServerBtn
			startServer()

		Case $gui_stopServerBtn
			stopServer()

		Case $gui_killServerBtn
			killServer()

		Case $gui_restartBtn
			RestartServer(0)

		Case $gui_backupBtn
			backupServer()

		Case $gui_sendCmdBtn
			sendServerCommand(GUICtrlRead($gui_commandInput))
			GUICtrlSetData($gui_commandInput, "")

		Case $gui_saveSettingsBtn
			saveConf()
			MsgBox(0, $guiTitle, "Settings Saved!")

		Case $gui_UpdateCheckBtn
			checkForUpdates(1)

		Case $gui_serverPropertiesSaveBtn
			SaveBDSConf()
			MsgBox(0, $guiTitle, "Settings Properties Saved!")

		Case $gui_copyright
			If FileExists(@ScriptDir & "\LICENSE.txt") = 0 Then
				InetGet("https://thealiendoctor.com/software-license/pack-converter-2022.txt", @ScriptDir & "\LICENSE.txt") ;Temp URL until release
				logWrite(0, "Re-downloaded license")
				ShellExecute(@ScriptDir & "\LICENSE.txt")
			ElseIf FileExists(@ScriptDir & "\LICENSE.txt") Then
				ShellExecute(@ScriptDir & "\LICENSE.txt")
			EndIf

		Case $gui_githubLabel
			ShellExecute("https://github.com/ufo-studios/bds-ui")

		Case $gui_patreonBtn
			ShellExecute("https://TheAlienDoctor.com/r/Patreon")

		Case $gui_discordBtn
			ShellExecute("https://TheAlienDoctor.com/r/Discord")

		Case $gui_readmeBtn
			ShellExecute("https://github.com/ufo-studios/bds-ui/blob/main/README.md")

		Case $gui_UploadLogsBtn
			UploadLog()

		Case $gui_debugEnableBtn
			ScheduledActions()

;~ Case $gui_FindServerBtn
;~ 	$pid = FindServerPID()
;~ 	if($pid = 0) then
;~ 		MsgBox(0, $guiTitle, "BDS is not running.")
;~ 	Else
;~ 		$BDS_process = $pid
;~ 		$serverRunning = True
;~ 		AdlibRegister("updateConsole", 1000)     ; Call updateConsole every 1s
;~ 		outputToConsole("Server Startup Triggered. BDS PID is " & $BDS_process)
;~ 		GUICtrlSetColor($gui_serverStatusIndicator, $COLOR_GREEN)
;~ 		GUICtrlSetData($gui_serverStatusIndicator, "Online")
;~ 		BDScreateLog()
;~ 		GUICtrlSetState($gui_stopServerBtn, $GUI_ENABLE)
;~ 		GUICtrlSetState($gui_restartBtn, $GUI_ENABLE)
;~ 		GUICtrlSetState($gui_startServerBtn, $GUI_DISABLE)
;~ 		MsgBox(0, $guiTitle, "BDS found! The console will update with any new messages")
;~ 	EndIf
	EndSwitch
WEnd
