#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.16.1
 Author:         UFO Studios

 Script Function:
	A GUI and companion software for the Minecraft Bedrock Dedicated Server Software.

#ce ----------------------------------------------------------------------------

; Created with ❤️ & 👽 by the UFO Studios Dev Team (https://github.com/UFO-Studios).
; Check out the github repository of this project for more info @ https://github.com/UFO-Studios/bds-companion.
; Copyright UFO Studios. All rights reserved. For more info, email us: UFOStudios@TheAlienDoctor.com

#pragma compile(Compatibility, XP, vista, win7, win8, win81, win10, win11)
#pragma compile(FileDescription, BDS Companion)
#pragma compile(ProductName, BDS Companion)
#pragma compile(ProductVersion, 0.1.0)
#pragma compile(FileVersion, 0.1.0)
#pragma compile(LegalCopyright, ©UFO Studios)
#pragma compile(CompanyName, UFO Studios)
#pragma compile(OriginalFilename, BDS-Companion.exe)

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


Global Const $currentVersionNumber = "010"
Global Const $guiTitle = "BDS Companion - Beta-0.1.0"

; Koda doesn't let you set certain things, so change to match the below manually:
;Global $gui_mainWindow = GUICreate("" & $guiTitle & "", 723, 506)
;Global $gui_serverStatusIndicator = GUICtrlCreateLabel("Offline", 88, 32, 250, 17)
;Global $gui_serverPropertiesLabel = GUICtrlCreateLabel("gui_serverPropertiesLabel", 24, 448, 590, 17)

Global $gui_mainWindow = GUICreate("" & $guiTitle & "", 723, 506)
Global $gui_tabs = GUICtrlCreateTab(8, 0, 705, 497)
Global $gui_serverCtrlTab = GUICtrlCreateTabItem("Server Control")
Global $gui_serverStatusLabel = GUICtrlCreateLabel("Server Status:", 16, 32, 71, 17)
Global $gui_commandInput = GUICtrlCreateInput("", 16, 424, 585, 21)
Global $gui_sendCmdBtn = GUICtrlCreateButton("Send Command", 608, 423, 91, 25)
Global $gui_startServerBtn = GUICtrlCreateButton("Start Server", 16, 456, 75, 33)
Global $gui_stopServerBtn = GUICtrlCreateButton("Stop Server", 96, 456, 75, 33)
Global $gui_restartBtn = GUICtrlCreateButton("Restart Server", 256, 456, 75, 33)
Global $gui_backupBtn = GUICtrlCreateButton("Backup Server", 336, 456, 83, 33)
Global $gui_serverStatusIndicator = GUICtrlCreateLabel("Offline", 88, 32, 250, 17)
Global $gui_console = GUICtrlCreateEdit("", 16, 56, 689, 361, BitOR($GUI_SS_DEFAULT_EDIT, $ES_READONLY))
Global $gui_killServerBtn = GUICtrlCreateButton("Kill Server", 177, 456, 75, 33)
Global $gui_serverPropertiesTab = GUICtrlCreateTabItem("Server Properties")
Global $gui_ServerPropertiesGroup = GUICtrlCreateGroup("Server.Properties", 16, 32, 689, 457)
Global $gui_ServerPropertiesEdit = GUICtrlCreateEdit("", 24, 56, 673, 393)
GUICtrlSetData(-1, "gui_ServerPropertiesEdit")
Global $gui_serverPropertiesSaveBtn = GUICtrlCreateButton("Save", 624, 456, 75, 25)
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
Global $gui_saveSettingsBtn = GUICtrlCreateButton("Save Settings", 600, 456, 107, 33)
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
Global $gui_aboutGroup = GUICtrlCreateGroup("About", 16, 368, 273, 121)
Global $gui_abtVerNum = GUICtrlCreateLabel("Version: " & $guiTitle & "", 24, 460, 255, 17)
Global $gui_discordBtn = GUICtrlCreateButton("Join Our Discord!", 176, 424, 107, 25)
Global $gui_UpdateCheckBtn = GUICtrlCreateButton("Check for Updates", 176, 392, 107, 25)
Global $gui_patreonBtn = GUICtrlCreateButton("Support this project :)", 24, 424, 123, 25)
Global $gui_readmeBtn = GUICtrlCreateButton("Instructions and Credits", 24, 392, 123, 25)
GUICtrlCreateGroup("", -99, -99, 1, 1)
Global $gui_DebugGroup = GUICtrlCreateGroup("Debug", 296, 400, 289, 89)
Global $gui_debugEnableBtn = GUICtrlCreateButton("Enable Debug Mode", 304, 424, 131, 25)
Global $gui_UploadLogsBtn = GUICtrlCreateButton("Upload Logs For Help", 440, 456, 131, 25)
Global $gui_FindServerBtn = GUICtrlCreateButton("Find Running BDS Server", 304, 456, 131, 25)
Global $gui_testDiscWebhooks = GUICtrlCreateButton("Test Discord Webhook", 440, 424, 131, 25)
GUICtrlCreateGroup("", -99, -99, 1, 1)
Global $gui_discordIntegrationGroup = GUICtrlCreateGroup("Discord Intergration", 16, 272, 689, 89)
Global $gui_discNotifCheck = GUICtrlCreateCheckbox("Output Server Notifications", 24, 296, 145, 17)
Global $gui_discConsoleCheck = GUICtrlCreateCheckbox("Output Console", 24, 320, 97, 17)
Global $gui_discNotifLabel = GUICtrlCreateLabel("Notification Webhook URL:", 176, 296, 135, 17)
Global $gui_discConsoleLabel = GUICtrlCreateLabel("Console Webhook URL:", 176, 328, 120, 17)
Global $gui_discNotifInput = GUICtrlCreateInput("", 320, 296, 369, 21)
Global $gui_discConsoleInput = GUICtrlCreateInput("", 304, 328, 385, 21)
GUICtrlCreateGroup("", -99, -99, 1, 1)
GUICtrlCreateTabItem("")
Global $gui_copyright = GUICtrlCreateLabel("© UFO Studios 2024", 8, 504, 103, 17)
GUICtrlSetCursor (-1, 0)
Global $gui_versionNum = GUICtrlCreateLabel("Version: 1.0.0", 648, 504, 69, 17)
Global $gui_githubLabel = GUICtrlCreateLabel("View source code, report bugs and contribute on GitHub", 248, 504, 270, 17)
GUICtrlSetCursor (-1, 0)
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
	Sleep(200) ;to avoid lagg
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

	Global $cfg_discOutputNotifs = IniRead($settingsFile, "discordIntegration", "outputNotifs", "False")
	If $cfg_discOutputNotifs = "True" Then
		GUICtrlSetState($gui_discNotifCheck, $GUI_CHECKED)
	ElseIf $cfg_discOutputNotifs = "False" Then
		GUICtrlSetState($gui_discNotifCheck, $GUI_UNCHECKED)
	EndIf

	Global $cfg_discNotifUrl = IniRead($settingsFile, "discordIntegration", "notifUrl", "")
	GUICtrlSetData($gui_discNotifInput, $cfg_discNotifUrl)

	Global $cfg_discOutputConsole = IniRead($settingsFile, "discordIntegration", "outputConsole", "False")
	If $cfg_discOutputConsole = "True" Then
		GUICtrlSetState($gui_discConsoleCheck, $GUI_CHECKED)
	ElseIf $cfg_discOutputConsole = "False" Then
		GUICtrlSetState($gui_discConsoleCheck, $GUI_UNCHECKED)
	EndIf

	Global $cfg_discConsoleUrl = IniRead($settingsFile, "discordIntegration", "consoleUrl", "")
	GUICtrlSetData($gui_discConsoleInput, $cfg_discConsoleUrl)

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

	If GUICtrlRead($gui_discNotifCheck) = $GUI_CHECKED Then
		$cfg_discOutputNotifs = "True"
	ElseIf GUICtrlRead($gui_discNotifCheck) = $GUI_UNCHECKED Then
		$cfg_discOutputNotifs = "False"
	EndIf
	IniWrite($settingsFile, "discordIntegration", "outputNotifs", $cfg_discOutputNotifs)

	$cfg_discNotifUrl = GUICtrlRead($gui_discNotifInput)
	IniWrite($settingsFile, "discordIntegration", "notifUrl", $cfg_discNotifUrl)

	If GUICtrlRead($gui_discConsoleCheck) = $GUI_CHECKED Then
		$cfg_discOutputConsole = "True"
	ElseIf GUICtrlRead($gui_discConsoleCheck) = $GUI_UNCHECKED Then
		$cfg_discOutputConsole = "False"
	EndIf
	IniWrite($settingsFile, "discordIntegration", "outputConsole", $cfg_discOutputConsole)

	$cfg_discConsoleUrl = GUICtrlRead($gui_discConsoleInput)
	IniWrite($settingsFile, "discordIntegration", "consoleUrl", $cfg_discConsoleUrl)
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
	BDSlogWrite("Server log file closed at " & @HOUR & ":" & @MIN & ":" & @SEC & " on " & @MDAY & "/" & @MON & "/" & @YEAR & " (HH:MM:SS on DD.MM.YY)")
	FileMove($cfg_bdsLogsDir & "\log.latest", $cfg_bdsLogsDir & "\log[" & @MDAY & '.' & @MON & '.' & @YEAR & '-' & @HOUR & '.' & @MIN & '.' & @SEC & "].txt")
EndFunc   ;==>BDScloseLog

Func BDSlogWrite($content)
	FileOpen($cfg_bdsLogsDir & "\log.latest", 1)

	FileWrite($cfg_bdsLogsDir & "\log.latest", @MDAY & "/" & @MON & "/" & @YEAR & " @ " & @HOUR & ":" & @MIN & ":" & @SEC & " > " & $content & @CRLF)

	$newContent = StringReplace($content, @CRLF, "\n")
	HttpPost($cfg_discConsoleUrl, '{"username": "' & $guiTitle & '", "avatar_url": "https://thealiendoctor.com/img/download-icons/bds-companion.png", "content": "[BDS-Companion]: ' & $newContent & '"}', "application/json")

	FileClose($cfg_bdsLogsDir & "\log.latest")
EndFunc   ;==>BDSlogWrite

Func outputToConsole($content)

	GUICtrlSetData($gui_console, @MDAY & "/" & @MON & "/" & @YEAR & " @ " & @HOUR & ":" & @MIN & ":" & @SEC & " > " & "[BDS-Companion]: " & $content & @CRLF, 1)

	If $cfg_discOutputConsole = "True" Then
		HttpPost($cfg_discConsoleUrl, '{"username": "' & $guiTitle & '", "avatar_url": "https://thealiendoctor.com/img/download-icons/bds-companion.png", "content": "[BDS-companion]: ' & $content & '"}', "application/json")
	EndIf

	FileOpen($cfg_bdsLogsDir & "\log.latest", 1)
	FileWrite($cfg_bdsLogsDir & "\log.latest", @MDAY & "/" & @MON & "/" & @YEAR & " @ " & @HOUR & ":" & @MIN & ":" & @SEC & " > " & "[BDS-companion]: " & $content & @CRLF)
	FileClose($cfg_bdsLogsDir & "\log.latest")

	logWrite(0, "Output to console: [BDS-Companion]: " & $content)
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

	If $serverRunning = False Then
		logWrite(0, "Server not running, scheduled action cancelled")
		Return
	EndIf

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

;Functions (Discord Integration) ###################################################################

Func outputToDiscNotif($content) ;Sends content to notifcations channel on Discord
	If $cfg_discOutputNotifs = "True" Then
		HttpPost($cfg_discNotifUrl, '{"username": "' & $guiTitle & '", "avatar_url": "https://thealiendoctor.com/img/download-icons/bds-companion.png", "content": "' & $content & '"}', "application/json")
		logWrite(0, 'Sent "' & $content & '" to Discord notifcation channel')
	EndIf
EndFunc   ;==>outputToDiscNotif

;Functions (Misc) ##################################################################################

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
	GUICtrlSetData($gui_console, "[BDS-Companion]: Server Offline" & @CRLF, 1)
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
		InetGet("https://thealiendoctor.com/software-versions/bds-companion-versions.ini", @ScriptDir & "\temp\versions.ini", 1)
		Global $latestVersionNum = IniRead(@ScriptDir & "\temp\versions.ini", "latest", "latest-version-num", "100")

		If $latestVersionNum > $currentVersionNumber Then
			Global $updateMsg = IniRead(@ScriptDir & "\temp\versions.ini", $latestVersionNum, "update-message", "(updated message undefined)")
			Local $updateMsgBox = MsgBox(4, $guiTitle, "There is a new update out now!" & @CRLF & $updateMsg & @CRLF & @CRLF & "Would you like to download it?")

			If $updateMsgBox = 6 Then
				ShellExecute("https://www.thealiendoctor.com/downloads/bds-companion")
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
	outputToDiscNotif(":yellow_square: Server is starting")
	Global $BDS_process = Run($bdsExeRun, @ScriptDir, @SW_HIDE, $STDERR_CHILD + $STDOUT_CHILD + $STDIN_CHILD)     ;DO NOT forget $STDIN_CHILD
	$serverRunning = True
	AdlibRegister("updateConsole", 1000)     ; Call updateConsole every 1s
	outputToConsole("Server Startup Triggered. BDS PID is " & $BDS_process)
	GUICtrlSetColor($gui_serverStatusIndicator, $COLOR_GREEN)
	GUICtrlSetData($gui_serverStatusIndicator, "Online")
	BDScreateLog()
	outputToDiscNotif(":white_check_mark: Server has started")
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
			If $line <> "" Then ;if line has content then write it to output
				Local $lineCount = _GUICtrlEdit_GetLineCount($gui_console) ;Get line count
				_GUICtrlEdit_LineScroll($gui_console, 0, $lineCount) ;Scroll down to bottom of console, stops existing text from being overwritten
				GUICtrlSetData($gui_console, $line, 1)
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
			logWrite(0, "Backup during restart enabled. Starting backup...")
			backupServer()
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
	outputToDiscNotif(":yellow_square: Server stopping")
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
		outputToDiscNotif(":octagonal_sign: Server stopped")

		GUICtrlSetState($gui_stopServerBtn, $GUI_DISABLE)
		GUICtrlSetState($gui_restartBtn, $GUI_DISABLE)
		GUICtrlSetState($gui_sendCmdBtn, $GUI_DISABLE)

		GUICtrlSetState($gui_startServerBtn, $GUI_ENABLE)

		BDScloseLog()
		$serverRunning = False
	EndIf

	Global $BDS_process = Null
EndFunc   ;==>stopServer

Func killServer()
	logWrite(0, "Kill Server Triggered")
	Local $msgBox = MsgBox(4, $guiTitle, "Warning: This will kill BDS process, which could corrupt server files. This should only be used when server is unresponsive." & @CRLF & "Continue?")
	If $msgBox = 6 Then ;Yes
		outputToConsole("Server Kill Triggered")
		outputToDiscNotif(":red_square: Server kill triggered")
		RunWait("taskkill /IM bedrock_server.exe /F", @SW_HIDE) ;Kills all bedrock_server.exe instances, works better than ProcessClose (except when it doesn't)

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

	If $serverRunning = True Then ;Manual Backup
		Local $confirmBox = MsgBox(4, $guiTitle, "Are you sure you want to backup?" & @CRLF & "If the server crashes during a backup, it can lead to world corruption. It's recommended to stop the server before restarting." & @CRLF & "Continue?")
		If $confirmBox = 7 Then
			logWrite(0, "Manual Restart Aborted")
			Return
		EndIf
	EndIf

	logWrite(0, "Backing up BDS server")
	outputToDiscNotif(":blue_square: Server backup started")
	Local $finished = False
	While @error == 0 Or $finished == False
		setServerStatus($COLOR_ORANGE, "Backing up server...")

		If $serverRunning = True Then
			outputToConsole("Server Backup Requested")
			sendServerCommand("save hold")
			Sleep(5000)
		EndIf

		Local $backupFileName = $cfg_backupsDir & "\" & @YEAR & "-" & @MON & "-" & @MDAY & "_" & @HOUR & "-" & @MIN & "-" & @SEC & ".zip"
		Local $backupFile = _Zip_Create($backupFileName)

		;COPY DIRS TO TMP DIR
		setServerStatus($COLOR_ORANGE, "Copying folders (1/5)")
		DirCreate(@ScriptDir & "\temp\")
		DirCopy($cfg_bdsDir & "\behavior_packs\", @ScriptDir & "\temp\behavior_packs", 1)
		setServerStatus($COLOR_ORANGE, "Copying folders (2/5)")
		DirCopy($cfg_bdsDir & "\worlds\", @ScriptDir & "\temp\worlds", 1)
		setServerStatus($COLOR_ORANGE, "Copying folders (3/5)")
		DirCopy($cfg_bdsDir & "\resource_packs\", @ScriptDir & "\temp\resource_packs", 1)
		setServerStatus($COLOR_ORANGE, "Copying folders (4/5)")
		DirCopy($cfg_bdsDir & "\development_behavior_packs\", @ScriptDir & "\temp\development_behavior_packs", 1)
		setServerStatus($COLOR_ORANGE, "Copying folders (5/5)")
		DirCopy($cfg_bdsDir & "\development_resource_packs\", @ScriptDir & "\temp\development_resource_packs", 1)

		setServerStatus($COLOR_ORANGE, "Copying files (1/5)")
		;COPY FILES
		Dim $files[5] = ["permissions.json", "whitelist.json", "server.properties", "allowlist.json", "valid_known_packs.json"]
		FileCopy($cfg_bdsDir & "\permissions.json", @ScriptDir & "\temp\permissions.json", 1)
		setServerStatus($COLOR_ORANGE, "Copying files (2/5)")
		FileCopy($cfg_bdsDir & "\whitelist.json", @ScriptDir & "\temp\whitelist.json", 1)
		setServerStatus($COLOR_ORANGE, "Copying files (3/5)")
		FileCopy($cfg_bdsDir & "\server.properties", @ScriptDir & "\temp\server.properties", 1)
		setServerStatus($COLOR_ORANGE, "Copying files (4/5)")
		FileCopy($cfg_bdsDir & "\allowlist.json", @ScriptDir & "\temp\allowlist.json", 1)
		setServerStatus($COLOR_ORANGE, "Copying files (5/5)")
		FileCopy($cfg_bdsDir & "\valid_known_packs.json", @ScriptDir & "\temp\valid_known_packs.json", 1)

		If $serverRunning = True Then ;Files have been copied so server can continue running as normal
			sendServerCommand("save resume")
			Sleep(5000)
		EndIf

		;ZIP DIR
		setServerStatus($COLOR_ORANGE, "Zipping files")
		_Zip_AddFolder($backupFile, @ScriptDir & "\temp\", 0)

		;CLEAN UP
		DirRemove(@ScriptDir & "\temp\", 1)

		;FINISH
		$finished = True
		setServerStatus($COLOR_GREEN, "Backup complete!")

		If $serverRunning = True Then ;Reset server status
			GUICtrlSetColor($gui_serverStatusIndicator, $COLOR_GREEN)
			GUICtrlSetData($gui_serverStatusIndicator, "Online")
		EndIf
	WEnd
	outputToDiscNotif(":blue_square: Server backup complete")
EndFunc   ;==>backupServer

Func sendServerCommand($content)
	If $serverRunning = False Then
		Return
	EndIf
	outputToConsole("Command Sent: '" & $content & "'")
	If (ProcessExists($BDS_process)) Then StdinWrite($BDS_process, $content & @CRLF)
	logWrite(0, "Sent server command: " & $content)
EndFunc   ;==>sendServerCommand


If FileExists(@ScriptDir & "\LICENSE.txt") = 0 Then ;License re-download
	InetGet("https://thealiendoctor.com/software-license/pack-converter-2022.txt", @ScriptDir & "\LICENSE.txt") ;Temp license until public
	logWrite(0, "Re-downloaded license")
EndIf

startup()

While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			exitScript()

		Case $gui_startServerBtn
			startServer()

		Case $gui_stopServerBtn
			stopServer()

		Case $gui_killServerBtn
			killServer()

		Case $gui_restartBtn
			RestartServer(1)

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
			Else
				ShellExecute(@ScriptDir & "\LICENSE.txt")
			EndIf

		Case $gui_githubLabel
			ShellExecute("https://github.com/ufo-studios/bds-companion")

		Case $gui_patreonBtn
			ShellExecute("https://TheAlienDoctor.com/r/Patreon")

		Case $gui_discordBtn
			ShellExecute("https://TheAlienDoctor.com/r/Discord")

		Case $gui_readmeBtn
			ShellExecute("https://github.com/ufo-studios/bds-companion/blob/main/README.md")

		Case $gui_UploadLogsBtn
			UploadLog()

		Case $gui_debugEnableBtn
			ScheduledActions()

		Case $gui_testDiscWebhooks
			outputToDiscNotif("This is a test message sent to the notifications channel")
			HttpPost($cfg_discConsoleUrl, '{"username": "' & $guiTitle & '", "avatar_url": "https://thealiendoctor.com/img/download-icons/bds-companion.png", "content": "This is a test message sent to the console channel"}', "application/json")

	EndSwitch
WEnd