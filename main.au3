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

Global Const $guiTitle = "BDS UI - V1.0.0"

#Region ### START Koda GUI section ### Form=d:\06 code\bds-ui\gui.kxf
Global $gui_mainWindow = GUICreate("" & $guiTitle & "", 615, 427, 1006, 536)
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
Global $gui_console = GUICtrlCreateEdit("", 16, 64, 577, 257, BitOR($GUI_SS_DEFAULT_EDIT,$ES_READONLY))
GUICtrlSetData(-1, "gui_console")
Global $gui_settingsTab = GUICtrlCreateTabItem("Settings")
Global $gui_backupSettingsGroup = GUICtrlCreateGroup("Backup Settings", 16, 40, 577, 121)
Global $gui_autoBackupSelect = GUICtrlCreateCheckbox("Auto Backups Enabled", 24, 64, 129, 17)
Global $gui_autoRestartCheck = GUICtrlCreateCheckbox("Auto Restarts Enabled", 24, 82, 129, 17)
Global $gui_dateTimeLabel = GUICtrlCreateLabel("Backup Time (Day:Hour:Minute)", 176, 64, 156, 17)
Global $gui_backupDateTime = GUICtrlCreateInput("7:12:00", 176, 80, 153, 21)
Global $gui_dateTimeExplain = GUICtrlCreateLabel("Days 1-7 Is Sunday-Saturday. Hours are in 24H", 176, 112, 227, 17)
GUICtrlCreateGroup("", -99, -99, 1, 1)
Global $gui_restartSettingsGroup = GUICtrlCreateGroup("Restart Settings", 16, 165, 577, 121)
Global $gui_autoRestartTimeInput = GUICtrlCreateInput("7:12:00", 173, 200, 153, 21)
Global $gui_autoRestartTimeLabel = GUICtrlCreateLabel("Restart Time (Day:Hour:Minute)", 173, 184, 153, 17)
Global $gui_autoRestartCheck1 = GUICtrlCreateCheckbox("Auto Restarts Enabled", 21, 184, 129, 17)
GUICtrlCreateGroup("", -99, -99, 1, 1)
Global $gui_saveSettingsBtn = GUICtrlCreateButton("Save Settings", 488, 352, 107, 41)
Global $gui_serverPropertiesTab = GUICtrlCreateTabItem("Server Properties")
GUICtrlCreateTabItem("")
Global $gui_copyright = GUICtrlCreateLabel("© UFO Studios 2024", 8, 408, 103, 17)
Global $gui_versionNum = GUICtrlCreateLabel("Version: 1.0.0", 528, 408, 69, 17)
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

GUICtrlSetColor($gui_ServerStatusIndicator, $COLOR_RED)

;Variables ###################################################################################

Global $bdsFolder = @ScriptDir & "\BDS"
Global $bdsExe = 'C:\Windows\System32\cmd.exe /c ' & '"' & $bdsFolder & '\bedrock_server.exe' & '"' ;We use cmd.exe otherwise bds freaks out. idk why
Global $serverRunning = False
Global $BDS_process = null
Global $backupDir = @ScriptDir & "\backups"
Global $settingsFile = @ScriptDir & "\settings.ini"
Global $LogFolder = @ScriptDir & "\logs"
Global $LogFile = $LogFolder & "[" & @SEC & "-" & @MIN & "-" & @HOUR & "][" & @MDAY & "." & @MON & "." & @YEAR & "].log"

;Functions (Config) #############################################################################

Func loadConf()
    Global $cfg_autoRestart = IniRead($settingsFile, "general", "AutoRestart", "False")
    If $cfg_autoRestart = "True" Then
        GUICtrlSetState($gui_AutoRestartCheck, $GUI_CHECKED)
    Else
        GUICtrlSetState($gui_AutoRestartCheck, $GUI_UNCHECKED)
    Endif

    Global $cfg_autoBackup = IniRead($settingsFile, "general", "AutoBackup", "False")
    If $cfg_autoBackup = "True" Then
        GUICtrlSetState($gui_AutoBackupSelect, $GUI_CHECKED)
    Else
        GUICtrlSetState($gui_AutoBackupSelect, $GUI_UNCHECKED)
    Endif

    Global $cfg_autoBackupTime = IniRead($settingsFile, "general", "AutoBackupTime", "7:12:00")
    GUICtrlSetData($gui_BackupDateTime, $cfg_autoBackupTime)

    Global $cfg_autoRestartTime = IniRead($settingsFile, "general", "AutoRestartTime", "7:12:00")
    GUICtrlSetData($gui_autoRestartTimeInput, $cfg_autoRestartTime)
EndFunc

Func saveConf()
    If GUICtrlRead($gui_AutoBackupSelect) = 1 Then
        IniWrite($settingsFile, "general", "AutoBackup", "True")
    Else
        IniWrite($settingsFile, "general", "AutoBackup", "False")
    Endif

    If GUICtrlRead($gui_AutoRestartCheck) = 1 Then
        IniWrite($settingsFile, "general", "AutoRestart", "True")
    Else
        IniWrite($settingsFile, "general", "AutoRestart", "False")
    Endif

    IniWrite($settingsFile, "general", "AutoBackupTime", GUICtrlRead($gui_BackupDateTime))
    IniWrite($settingsFile, "general", "AutoRestartTime", GUICtrlRead($gui_autoRestartTimeInput))

EndFunc

;Functions (Scheduled Actions) ##################################################################

Func ScheduledActions()
    ;Backup
    Local $ABtimeArr = StringSplit($cfg_autoBackupTime, ":"); Auto Backup Time Array
    If $ABtimeArr[0] = @WDAY Then
        If $ABtimeArr[1] = @HOUR Then
            If $ABtimeArr[2] = @MIN Then
                _FileWriteLog($LogFile, "[BDS-UI]: Auto Backup Triggered" & @CRLF, 1)
                backupServer()
            EndIf
        EndIf
    EndIf
    ;Restart
    Local $ABtimeArr = StringSplit($cfg_autoBackupTime, ":"); Auto Backup Time Array
    If $ABtimeArr[0] = @WDAY Then
        If $ABtimeArr[1] = @HOUR Then
            If $ABtimeArr[2] = @MIN Then
                _FileWriteLog($LogFile, "[BDS-UI]: Auto Restart Triggered" & @CRLF, 1)
                backupServer()
            EndIf
        EndIf
    EndIf
    
EndFunc


AdlibRegister("ScheduledActions", 60*1000); run it every 60s

;Functions (World & packs) ########################################################################

Func ListPacks()
    $BpackDir = $bdsFolder & "/behavior_packs"
    Local $FolderArray[]
    Local $hSearch = FileFindFirstFile($BpackDir)
    While 1
        Local $sFile = FileFindNextFile($hSearch)
        If @error Then ExitLoop
    
        ; Check if the file is actually a directory
        If StringInStr(FileGetAttrib($sFile), "D") Then
            _ArrayAdd($FolderArray, FileGetAttrib($sFile))            
        EndIf
    WEnd
    return $FolderArray
Endfunc

;Functions (Misc) ##################################################################################

Func DelEmptyDirs()
    $cmd = "ROBOCOPY BDS BDS /S /MOVE";cmd.exe func to copy to the same dir, but deletes empty folders in the process
    GUICtrlSetData($gui_ServerStatusIndicator, "Backing up (Checking server files...)") 
    _FileWriteLog($LogFile, "[BDS-UI]: Backup Checking server files...." & @CRLF, 1)
    RunWait($cmd, @ScriptDir, @SW_HIDE)
    return 0
EndFunc


;Functions (Server Management) ################################################################################

Func startServer()
    Global $BDS_process = Run($bdsExe, "", @SW_HIDE, $STDERR_CHILD + $STDOUT_CHILD + $STDIN_CHILD);DO NOT forget $STDIN_CHILD
    $serverRunning = True
    AdlibRegister("updateConsole", 1000) ; Call updateConsole every 1s
    GUICtrlSetData($gui_console, "[BDS-UI]: Server Startup Triggered. BDS PID is " & $BDS_process & @CRLF, 1)
    GUICtrlSetColor($gui_ServerStatusIndicator, $COLOR_GREEN)
    GUICtrlSetData($gui_ServerStatusIndicator, "Online")
EndFunc

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
EndFunc

Func restartServer()
    GUICtrlSetData($gui_console, "[BDS-UI]: Server Restart Triggered" & @CRLF, 1)
    _FileWriteLog($LogFile, "[BDS-UI]: Server Restart Triggered" & @CRLF, 1)
    stopServer()
    startServer()
EndFunc

Func stopServer()
    GUICtrlSetData($gui_console, "[BDS-UI]: Server Stop Triggered" & @CRLF, 1)
    _FileWriteLog($LogFile, "[BDS-UI]: Server Stop Triggered" & @CRLF, 1)
    StdinWrite($BDS_process, "stop" & @CRLF)
    Sleep(1000) ; Wait for a while to give the process time to read the input
    StdinWrite($BDS_process) ; Close the stream
    $serverRunning = False
    Sleep(3000)
    AdlibUnRegister("updateConsole")
    If ProcessExists($BDS_process) Then
        MsgBox("", "NOTICE", "Failed to stop server")
    else
        GUICtrlSetData($gui_console, "[BDS-UI]: Server Offline")
        GUICtrlSetColor($gui_ServerStatusIndicator, $COLOR_RED)
        GUICtrlSetData($gui_ServerStatusIndicator, "Offline")
    endif
    Global $BDS_process = Null
EndFunc

Func backupServer()
    GUICtrlSetData($gui_console, "[BDS-UI]: Server Backup Started" & @CRLF, 1)
    _FileWriteLog($LogFile, "[BDS-UI]: Server Backup Triggered" & @CRLF, 1)
    GUICtrlSetColor($gui_ServerStatusIndicator, $COLOR_ORANGE)
    GUICtrlSetData($gui_ServerStatusIndicator, "Backing Up (Pre Processing...)")
    $backupDateTime = "[" & @SEC & "-" & @MIN & "-" & @HOUR & "][" & @MDAY & "." & @MON & "." & @YEAR & "]"
    If $BDS_process = Null Then; bds isnt running
        Sleep(10);aka do nothing
    Else;bds is running
        StdinWrite($BDS_process, "save hold" & @CRLF);releases BDS's lock on the file
        Sleep(5000) ;5s
        StdinWrite($BDS_process, "save query" & @CRLF)
    Endif
    DelEmptyDirs()
    Local $ZIPname = $backupDir & "\Backup-" & $backupDateTime & ".zip"; E.G: D:/BDS_UI/Backups/Backup-10.01.24.zip
    _Zip_Create($ZIPname)
    Sleep(100)
    GUICtrlSetData($gui_ServerStatusIndicator, "Backing up (Compressing files...)") 
    _Zip_AddFolder($ZIPname, @ScriptDir & "\BDS", 0); see CopyToTemp()
    StdinWrite($BDS_process, "save resume" & @CRLF)
    GUICtrlSetColor($gui_ServerStatusIndicator, $COLOR_GREEN)
    GUICtrlSetData($gui_ServerStatusIndicator, "Online")
    GUICtrlSetData($gui_console, "[BDS-UI]: Server Backup Completed" & @CRLF, 1)
    _FileWriteLog($LogFile, "[BDS-UI]: Server Backup Done" & @CRLF, 1)
Endfunc

Func sendServerCommand()
    $cmd = GUICtrlRead($gui_commandInput) ;cmd input box
    StdinWrite($BDS_process, $cmd & @CRLF)
    GUICtrlSetData($gui_console, "[BDS-UI]: Command Sent: '"& $cmd &"'" & @CRLF, 1)
    _FileWriteLog($LogFile, "[BDS-UI]: Server Command Sent: '"& $cmd &"'" & @CRLF, 1)
    GUICtrlSetData($gui_commandInput, "") ;emptys box
    Return
EndFunc

;Main GUI Loop


loadConf(); load conf at first start

While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
            if $BDS_process == null Then ;if everything goes pear-shaped it will shoot it when closed
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
            restartServer()

        Case $gui_backupBtn
            backupServer()

        Case $gui_sendCmdBtn
            sendServerCommand()

        Case $gui_saveSettingsBtn
            saveConf()

	EndSwitch
WEnd
