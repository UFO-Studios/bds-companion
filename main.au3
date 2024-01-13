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

#include "UDF/Zip.au3"
;GUI #####

Global Const $guiTitle = "BDS UI - V1.0.0"

#Region ### START Koda GUI section ### Form=d:\tad\bds-ui\gui.kxf
Global $gui_mainWindow = GUICreate("" & $guiTitle & "", 615, 427, 1108, 382)
Global $gui_tabs = GUICtrlCreateTab(8, 8, 593, 393)
Global $gui_serverCtrlTab = GUICtrlCreateTabItem("Server Control")
Global $gui_serverStatusLabel = GUICtrlCreateLabel("Server Status", 16, 40, 68, 17)
Global $gui_commandInput = GUICtrlCreateInput("", 16, 296, 481, 21)
Global $gui_sendCmdBtn = GUICtrlCreateButton("Send Command", 504, 296, 91, 25)
Global $gui_startServerBtn = GUICtrlCreateButton("Start Server", 16, 328, 75, 57)
Global $gui_stopServerBtn = GUICtrlCreateButton("Stop Server", 96, 328, 75, 57)
Global $gui_restartBtn = GUICtrlCreateButton("Restart Button", 176, 328, 75, 57)
Global $gui_backupBtn = GUICtrlCreateButton("Start Backup", 256, 328, 75, 57)
Global $gui_ServerStatusIndicator = GUICtrlCreateLabel("Offline", 88, 40, 234, 17)
Global $gui_serverSettingsTab = GUICtrlCreateTabItem("Server Settings")
GUICtrlCreateTabItem("")
Global $gui_copyright = GUICtrlCreateLabel("� UFO Studios 2024", 8, 408, 112, 17)
Global $gui_versionNum = GUICtrlCreateLabel("Version: 1.0.0", 528, 408, 69, 17)
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

;Variables #####

Global $gui_console = GUICtrlCreateEdit("Server Console" & @CRLF, 16, 64, 577, 225, $ES_AUTOVSCROLL + $WS_VSCROLL)
Global $bdsFolder = @ScriptDir & "\BDS"
Global $bdsExe = 'C:\Windows\System32\cmd.exe /c ' & '"' & $bdsFolder & '\bedrock_server.exe' & '"' ;We use cmd.exe otherwise bds freaks out. idk why
Global $serverRunning = False
Global $BDS_process = null
Global $backupDir = @ScriptDir & "\backups"

;Presets ##########

GUICtrlSetColor($gui_ServerStatusIndicator, $COLOR_RED)

;Functions ########

Func scheduleBackup($time); 24h time!

EndFunc


;Functions (Misc)

Func DelEmptyDirs();Deletes empty directorys.
    $cmd = "ROBOCOPY BDS BDS /S /MOVE";we can use relative dirs
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
EndFunc

Func backupServer()
    GUICtrlSetData($gui_console, "[BDS-UI]: Server Backup Started" & @CRLF, 1)
    GUICtrlSetColor($gui_ServerStatusIndicator, $COLOR_ORANGE)
    GUICtrlSetData($gui_ServerStatusIndicator, "Backing Up (Pre Processing...)")
    $backupDateTime = "[" & @SEC & "-" & @MIN & "-" & @HOUR & "][" & @MDAY & "." & @MON & "." & @YEAR & "]"
    StdinWrite($BDS_process, "save hold" & @CRLF);releases BDS's lock on the file
    Sleep(5000) ;5s
    StdinWrite($BDS_process, "save query" & @CRLF)
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
