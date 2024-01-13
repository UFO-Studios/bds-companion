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

#Region ### START Koda GUI section ### Form=d:\tad\bds-ui\gui.kxf
Global $gui_mainWindow = GUICreate("" & $guiTitle & "", 615, 427, 198, 137)
Global $gui_tabs = GUICtrlCreateTab(8, 8, 593, 393)
Global $gui_serverCtrlTab = GUICtrlCreateTabItem("Server Control")
Global $gui_serverStatusLabel = GUICtrlCreateLabel("Server Status", 16, 40, 68, 17)
Global $gui_commandInput = GUICtrlCreateInput("", 16, 296, 481, 21)
Global $gui_sendCmdBtn = GUICtrlCreateButton("Send Command", 504, 296, 91, 25)
Global $gui_startServerBtn = GUICtrlCreateButton("Start Server", 16, 328, 75, 57)
Global $gui_stopServerBtn = GUICtrlCreateButton("Stop Server", 96, 328, 75, 57)
Global $gui_restartBtn = GUICtrlCreateButton("Restart Server", 176, 328, 75, 57)
Global $gui_backupBtn = GUICtrlCreateButton("Start Backup", 256, 328, 75, 57)
Global $gui_ServerStatusIndicator = GUICtrlCreateLabel("Offline", 88, 40, 34, 17)
Global $gui_console = GUICtrlCreateEdit("", 16, 64, 577, 225)
GUICtrlSetData(-1, "gui_console")
Global $gui_serverSettingsTab = GUICtrlCreateTabItem("Server Settings")
GUICtrlSetState(-1,$GUI_SHOW)
Global $gui_settingsTab = GUICtrlCreateGroup("Settings", 16, 48, 545, 105)
Global $gui_SettingsApplyBtn = GUICtrlCreateButton("Apply", 480, 120, 75, 25)
Global $gui_AutoBackupSelect = GUICtrlCreateCheckbox("Auto Backups", 24, 72, 97, 17)
Global $gui_AutoRestartCheck = GUICtrlCreateCheckbox("Auto Restart", 24, 90, 97, 17)
Global $gui_DateTimeLabel = GUICtrlCreateLabel("Backup Time (Day:Hour:Minute)", 136, 72, 156, 17)
Global $gui_BackupDateTime = GUICtrlCreateInput("7:12:00", 136, 88, 201, 21)
GUICtrlCreateGroup("", -99, -99, 1, 1)
Global $gui_AboutGroup = GUICtrlCreateGroup("About", 16, 152, 545, 129)
Global $gui_VersionLabel = GUICtrlCreateLabel("Version:", 24, 176, 42, 17)
Global $gui_VersionLabelText = GUICtrlCreateLabel("V???", 72, 176, 29, 17)
GUICtrlCreateGroup("", -99, -99, 1, 1)
GUICtrlCreateTabItem("")
Global $gui_copyright = GUICtrlCreateLabel("� UFO Studios 2024", 8, 408, 112, 17)
Global $gui_versionNum = GUICtrlCreateLabel("Version: 1.0.0", 528, 408, 69, 17)
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

;Variables #####

Global $bdsFolder = @ScriptDir & "\BDS"
Global $bdsExe = 'C:\Windows\System32\cmd.exe /c ' & '"' & $bdsFolder & '\bedrock_server.exe' & '"' ;We use cmd.exe otherwise bds freaks out. idk why
Global $serverRunning = False
Global $BDS_process = null
Global $backupDir = @ScriptDir & "\backups"
Global $SettingsFile = @ScriptDir & "\settings.ini"

;Functions (Config) #############################################################################

Func LoadConf()
    Global $cfg_AutoRestart = IniRead($SettingsFile, "general", "AutoRestart", "False")
    If $cfg_AutoRestart = "True" Then
        GUICtrlSetState($gui_AutoRestartCheck, $GUI_CHECKED)
    Else
        GUICtrlSetState($gui_AutoRestartCheck, $GUI_UNCHECKED)
    Endif

    Global $cfg_AutoBackup = IniRead($SettingsFile, "general", "AutoBackup", "False")
    If $cfg_AutoBackup = "True" Then
        GUICtrlSetState($gui_AutoBackupSelect, $GUI_CHECKED)
    Else
        GUICtrlSetState($gui_AutoBackupSelect, $GUI_UNCHECKED)
    Endif

    Global $cfg_AutoBackupTime = IniRead($SettingsFile, "general", "AutoBackupTime", "7:12:00")
    GUICtrlSetData($gui_BackupDateTime, $cfg_AutoBackupTime)
EndFunc

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

;Functions (Misc)

Func IsBackupTime()
    Sleep(60000); 1m
    
Endfunc

Func DelEmptyDirs()
    $cmd = "ROBOCOPY BDS BDS /S /MOVE";cmd.exe func to copy to the same dir, but deletes empty folders in the process
    GUICtrlSetData($gui_ServerStatusIndicator, "Backing up (Checking server files...)") 
    RunWait($cmd, @ScriptDir, @SW_HIDE)
    return 0
EndFunc


;Functions (Server Management) #####

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
        EndIf
    EndIf
EndFunc

Func restartServer()
    GUICtrlSetData($gui_console, "[BDS-UI]: Server Restart Triggered" & @CRLF, 1)
    stopServer()
    startServer()
EndFunc

Func stopServer()
    GUICtrlSetData($gui_console, "[BDS-UI]: Server Stop Triggered" & @CRLF, 1)
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
    Global $BDS_process == Null
EndFunc

Func backupServer()
    GUICtrlSetData($gui_console, "[BDS-UI]: Server Backup Started" & @CRLF, 1)
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
Endfunc

Func sendServerCommand()
    $cmd = GUICtrlRead($gui_commandInput) ;cmd input box
    StdinWrite($BDS_process, $cmd & @CRLF)
    GUICtrlSetData($gui_console, "[BDS-UI]: Command Sent: '"& $cmd &"'" & @CRLF, 1)
    GUICtrlSetData($gui_commandInput, "") ;emptys box
    Return
EndFunc

;Main GUI Loop


LoadConf(); load conf at first start

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

	EndSwitch
WEnd
