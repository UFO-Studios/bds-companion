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
Global Const $guiTitle = "BDS UI - 1.0.0"

#Region ### START Koda GUI section ###
Global $gui_mainWindow = GUICreate("" & $guiTitle & "", 615, 427, 997, 461)
Global $gui_tabs = GUICtrlCreateTab(8, 8, 593, 393)
Global $gui_serverCtrlTab = GUICtrlCreateTabItem("Server Control")
Global $gui_serverStatusLabel = GUICtrlCreateLabel("Server Status:", 16, 40, 71, 17)
Global $gui_commandInput = GUICtrlCreateInput("", 16, 328, 481, 21)
Global $gui_sendCmdBtn = GUICtrlCreateButton("Send Command", 504, 328, 91, 25)
Global $gui_startServerBtn = GUICtrlCreateButton("Start Server", 16, 360, 75, 33)
Global $gui_stopServerBtn = GUICtrlCreateButton("Stop Server", 96, 360, 75, 33)
Global $gui_restartBtn = GUICtrlCreateButton("Restart Server", 176, 360, 75, 33)
Global $gui_backupBtn = GUICtrlCreateButton("Backup Server", 256, 360, 83, 33)
Global $gui_serverStatusIndicator = GUICtrlCreateLabel("Offline", 88, 40, 34, 17)
Global $gui_console = GUICtrlCreateEdit("", 16, 64, 577, 257, BitOR($GUI_SS_DEFAULT_EDIT, $ES_READONLY))
GUICtrlSetData(-1, "[BDS-UI]: Server Offline")
Global $gui_settingsTab = GUICtrlCreateTabItem("Settings")
Global $gui_backupSettingsGroup = GUICtrlCreateGroup("Backup Settings", 16, 40, 577, 121)
Global $gui_autoBackupSelect = GUICtrlCreateCheckbox("Auto Backups Enabled", 24, 64, 129, 17)
Global $gui_dateTimeLabel = GUICtrlCreateLabel("Backup Interval. E.G: 6,12,18,24", 176, 64, 160, 17)
Global $gui_backupDateTime = GUICtrlCreateInput("6,12", 176, 80, 153, 21)
GUICtrlCreateGroup("", -99, -99, 1, 1)
Global $gui_restartSettingsGroup = GUICtrlCreateGroup("Restart Settings", 16, 165, 577, 121)
Global $gui_autoRestartTimeInput = GUICtrlCreateInput("7:12:00", 173, 200, 153, 21)
Global $gui_autoRestartTimeLabel = GUICtrlCreateLabel("Restart Time. E.G: 6,12,18,24", 173, 184, 145, 17)
Global $gui_autoRestartCheck1 = GUICtrlCreateCheckbox("Auto Restarts Enabled", 21, 184, 129, 17)
GUICtrlCreateGroup("", -99, -99, 1, 1)
Global $gui_saveSettingsBtn = GUICtrlCreateButton("Save Settings", 488, 352, 107, 41)
Global $gui_UpdateCheckBtn = GUICtrlCreateButton("Check For Updates", 16, 352, 107, 41)
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
Global $LogFolder = @ScriptDir & "\logs"
Global $LogFile = $LogFolder & "/[" & @SEC & "-" & @MIN & "-" & @HOUR & "][" & @MDAY & "." & @MON & "." & @YEAR & "].log"

;Functions (Config) #############################################################################

Func LoadBDSConf() ; broken for some unknown reason. hmph
	Local $BDSconfFile = $bdsFolder & "/server.properties"
	$FileOpened = FileRead($BDSconfFile)
	If @error Then
		MsgBox(0, "ERROR!", @error)
	else
		GUICtrlSetData($gui_ServerPropertiesEdit, $FileOpened)
	endif
    ;GUICtrlSetData($gui_ServerPropertiesEdit, $BDSconfFile)
EndFunc   ;==>LoadBDSConf

Func loadConf()
	Global $cfg_autoRestart = IniRead($settingsFile, "general", "AutoRestart", "False")
	If $cfg_autoRestart = "True" Then
		GUICtrlSetState($gui_autoRestartCheck1, $GUI_CHECKED)
	Else
		GUICtrlSetState($gui_autoRestartCheck1, $GUI_UNCHECKED)
	Endif

	Global $cfg_autoBackup = IniRead($settingsFile, "general", "AutoBackup", "False")
	If $cfg_autoBackup = "True" Then
		GUICtrlSetState($gui_autoBackupSelect, $GUI_CHECKED)
	Else
		GUICtrlSetState($gui_autoBackupSelect, $GUI_UNCHECKED)
	Endif

	Global $cfg_autoBackupTime = IniRead($settingsFile, "general", "AutoBackupInterval", "6,12,18,24")
	GUICtrlSetData($gui_backupDateTime, $cfg_autoBackupTime)

	Global $cfg_autoRestartTime = IniRead($settingsFile, "general", "AutoRestartInterval", "6,12,18,24")
	GUICtrlSetData($gui_autoRestartTimeInput, $cfg_autoRestartTime)

	;LoadBDSConf()
EndFunc   ;==>loadConf

Func saveConf()
	If GUICtrlRead($gui_autoBackupSelect) = 1 Then
		IniWrite($settingsFile, "general", "AutoBackup", "True")
	Else
		IniWrite($settingsFile, "general", "AutoBackup", "False")
	Endif

	If GUICtrlRead($gui_autoRestartCheck1) = 1 Then
		IniWrite($settingsFile, "general", "AutoRestart", "True")
	Else
		IniWrite($settingsFile, "general", "AutoRestart", "False")
	Endif

	IniWrite($settingsFile, "general", "AutoBackupInterval", GUICtrlRead($gui_backupDateTime))
	IniWrite($settingsFile, "general", "AutoRestartInterval", GUICtrlRead($gui_autoRestartTimeInput))


EndFunc   ;==>saveConf


;Functions (Scheduled Actions) ##################################################################

Func ScheduledActions()
	$ABarr = StringSplit($cfg_autoBackupTime, ",")     ; auto backup array
	$ARarr = StringSplit($cfg_autoRestartTime, ",")     ; auto restart array
	$done = False
	; Auto Backup
	if $cfg_autoBackup Then
		For $i In $ABarr
			If @HOUR = $i Then             ; goes through all entries
				backupServer()
				$done = True
			EndIf
		Next
	EndIf
	MsgBox(0, "debug", $done)

	; Auto Restarts
	if $cfg_autoRestart Then
		For $i In $ARarr
			If @HOUR = $i Then             ; goes through all entries
				RestartServer()
			EndIf
		Next
	EndIf
EndFunc   ;==>ScheduledActions

AdlibRegister("ScheduledActions", 60 * 1000) ; run it every 60s

;Functions (World & packs) ########################################################################



;Functions (Misc) ##################################################################################

Func DelEmptyDirs()
	$cmd = "ROBOCOPY BDS BDS /S /MOVE"    ;cmd.exe func to copy to the same dir, but deletes empty folders in the process
	GUICtrlSetData($gui_serverStatusIndicator, "Backing up (Checking server files...)")
	_FileWriteLog($LogFile, "[BDS-UI]: Backup Checking server files...." & @CRLF, 1)
	RunWait($cmd, @ScriptDir, @SW_HIDE)
	return 0
EndFunc   ;==>DelEmptyDirs

Func checkForUpdates($updateCheckOutputMsg) ; from alien's pack converter. Thanks TAD ;D
	Local $ping = Ping("TheAlienDoctor.com")
	Local $NoInternetMsgBox = 0

	If $ping > 0 Then
		DirCreate(@ScriptDir & "\temp\")
		InetGet("https://thealiendoctor.com/software-versions/bds-ui-versions.ini", @ScriptDir & "\temp\versions.ini", 1)
		Global $latestVersionNum = IniRead(@ScriptDir & "\temp\versions.ini", "latest", "latest-version-num", "100")

		If $latestVersionNum > $currentVersionNumber Then
			Global $updateMsg = IniRead(@ScriptDir & "\temp\versions.ini", $latestVersionNum, "update-message", "(updated message undefined)")
			Global $updateMsgBox = MsgBox(4, $guiTitle, "There is a new update out now!" & @CRLF & $updateMsg & @CRLF & @CRLF & "Would you like to download it?")

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
		$NoInternetMsgBox = "clear variable"
		$NoInternetMsgBox = MsgBox(6, $guiTitle, "Warning: You are not connected to the internet or TheAlienDoctor.com is down. This means the update checker could not run. Continue?")
	EndIf

	If $NoInternetMsgBox = 2 Then ;Cancel
		Exit

	ElseIf $NoInternetMsgBox = 10 Then ;Try again
		checkForUpdates(1)

	ElseIf $NoInternetMsgBox = 11 Then ;Continue
	EndIf

	DirRemove(@ScriptDir & "\temp\", 1)
EndFunc   ;==>checkForUpdates

;Functions (Server Management) ################################################################################

Func startServer()
	Global $BDS_process = Run($bdsExe, @ScriptDir, @SW_HIDE, $STDERR_CHILD + $STDOUT_CHILD + $STDIN_CHILD)    ;DO NOT forget $STDIN_CHILD
	$serverRunning = True
	AdlibRegister("updateConsole", 1000)     ; Call updateConsole every 1s
	GUICtrlSetData($gui_console, "[BDS-UI]: Server Startup Triggered. BDS PID is " & $BDS_process & @CRLF, 1)
	GUICtrlSetColor($gui_serverStatusIndicator, $COLOR_GREEN)
	GUICtrlSetData($gui_serverStatusIndicator, "Online")
EndFunc   ;==>startServer

Func updateConsole()
	If ProcessExists($BDS_process) Then
		Global $line = StdoutRead($BDS_process)
		If @error Then
			$serverRunning = False
			AdlibUnRegister("updateConsole")
		Else
			GUICtrlSetData($gui_console, $line, 1)
			_FileWriteLog($LogFile, $line & @CRLF, 1)
		EndIf
	EndIf
EndFunc   ;==>updateConsole

Func RestartServer()
	GUICtrlSetData($gui_console, "[BDS-UI]: Server Restart Triggered" & @CRLF, 1)
	_FileWriteLog($LogFile, "[BDS-UI]: Server Restart Triggered" & @CRLF, 1)
	stopServer()
	startServer()
EndFunc   ;==>RestartServer

Func stopServer()
	GUICtrlSetData($gui_console, "[BDS-UI]: Server Stop Triggered" & @CRLF, 1)
	_FileWriteLog($LogFile, "[BDS-UI]: Server Stop Triggered" & @CRLF, 1)
	StdinWrite($BDS_process, "stop" & @CRLF)
	Sleep(1000)     ; Wait for a while to give the process time to read the input
	StdinWrite($BDS_process)     ; Close the stream
	$serverRunning = False
	Sleep(3000)
	AdlibUnRegister("updateConsole")
	If ProcessExists($BDS_process) Then
		MsgBox("", "NOTICE", "Failed to stop server")
	else
		GUICtrlSetData($gui_console, "[BDS-UI]: Server Offline")
		GUICtrlSetColor($gui_serverStatusIndicator, $COLOR_RED)
		GUICtrlSetData($gui_serverStatusIndicator, "Offline")
	endif
	Global $BDS_process = Null
EndFunc   ;==>stopServer

Func backupServer()
	GUICtrlSetData($gui_console, "[BDS-UI]: Server Backup Started" & @CRLF, 1)
	_FileWriteLog($LogFile, "[BDS-UI]: Server Backup Triggered" & @CRLF, 1)
	GUICtrlSetColor($gui_serverStatusIndicator, $COLOR_ORANGE)
	GUICtrlSetData($gui_serverStatusIndicator, "Backing Up (Pre Processing...)")
	$backupDateTime = "[" & @SEC & "-" & @MIN & "-" & @HOUR & "][" & @MDAY & "." & @MON & "." & @YEAR & "]"
	If $BDS_process = Null Then    ; bds isnt running
		Sleep(10)        ;aka do nothing
	Else    ;bds is running
		StdinWrite($BDS_process, "save hold" & @CRLF)        ;releases BDS's lock on the file
		Sleep(5000)         ;5s
		StdinWrite($BDS_process, "save query" & @CRLF)
	Endif
	DelEmptyDirs()
	Local $ZIPname = $backupDir & "\Backup-" & $backupDateTime & ".zip"    ; E.G: D:/BDS_UI/Backups/Backup-10.01.24.zip
	_Zip_Create($ZIPname)
	Sleep(100)
	GUICtrlSetData($gui_serverStatusIndicator, "Backing up (Compressing files...)")
	_Zip_AddFolder($ZIPname, @ScriptDir & "\BDS", 0)    ; see CopyToTemp()
	StdinWrite($BDS_process, "save resume" & @CRLF)
	GUICtrlSetColor($gui_serverStatusIndicator, $COLOR_GREEN)
	GUICtrlSetData($gui_serverStatusIndicator, "Online")
	GUICtrlSetData($gui_console, "[BDS-UI]: Server Backup Completed" & @CRLF, 1)
	_FileWriteLog($LogFile, "[BDS-UI]: Server Backup Done" & @CRLF, 1)
Endfunc   ;==>backupServer

Func sendServerCommand()
	$cmd = GUICtrlRead($gui_commandInput)     ;cmd input box
	StdinWrite($BDS_process, $cmd & @CRLF)
	GUICtrlSetData($gui_console, "[BDS-UI]: Command Sent: '" & $cmd & "'" & @CRLF, 1)
	_FileWriteLog($LogFile, "[BDS-UI]: Server Command Sent: '" & $cmd & "'" & @CRLF, 1)
	GUICtrlSetData($gui_commandInput, "")     ;emptys box
	Return
EndFunc   ;==>sendServerCommand

;Main GUI Loop

LoadBDSConf()

loadConf() ; load conf at first start


While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			if $BDS_process == null Then             ;if everything goes pear-shaped it will shoot it when closed
				Exit
			Else
				If ProcessExists($BDS_process) Then
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
	EndSwitch
WEnd
