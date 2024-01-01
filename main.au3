#pragma compile(Compatibility, XP, vista, win7, win8, win81, win10, win11)
#pragma compile(FileDescription, BDS UI)
#pragma compile(ProductName, BDS UI)
#pragma compile(ProductVersion, 1.0.0)
#pragma compile(FileVersion, 1.0.0)
#pragma compile(LegalCopyright, ©UFO Studios)
#pragma compile(CompanyName, UFO Studios)
#pragma compile(OriginalFilename, BDS_UI-V1.0.0)

#include <ButtonConstants.au3>
#include <StaticConstants.au3>
#include <TabConstants.au3>
#include <GUIConstantsEx.au3>
#include <AutoItConstants.au3>
#include <WindowsConstants.au3>
#include <EditConstants.au3>

#include "cfg.au3"

;GUI #####

Global Const $guiTitle = "BDS UI - V1.0.0"

#Region ### START Koda GUI section ### Form=d:\06 code\bds-ui\gui.kxf
Global $gui_mainWindow = GUICreate("" & $guiTitle & "", 615, 427, 905, 459)
Global $gui_tabs = GUICtrlCreateTab(8, 8, 593, 393)
Global $gui_serverCtrlTab = GUICtrlCreateTabItem("Server Control")
GUICtrlSetData(-1, "gui_console")
Global $gui_serverStatusLabel = GUICtrlCreateLabel("Server Status", 16, 40, 68, 17)
Global $gui_commandIInput = GUICtrlCreateInput("", 16, 296, 481, 21)
Global $gui_sendCmdBtn = GUICtrlCreateButton("Send Command", 504, 296, 91, 25)
Global $gui_startServerBtn = GUICtrlCreateButton("Start Server", 16, 328, 75, 57)
Global $gui_stopServerBtn = GUICtrlCreateButton("Stop Server", 96, 328, 75, 57)
Global $gui_restartBtn = GUICtrlCreateButton("Restart Button", 176, 328, 75, 57)
Global $gui_backupBtn = GUICtrlCreateButton("Start Backup", 256, 328, 75, 57)
Global $gui_serverSettingsTab = GUICtrlCreateTabItem("Server Settings")
GUICtrlCreateTabItem("")
Global $gui_copyright = GUICtrlCreateLabel("© UFO Studios 2024", 8, 408, 103, 17)
Global $gui_versionNum = GUICtrlCreateLabel("Version: 1.0.0", 528, 408, 69, 17)
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

;Variables #####

Global $gui_console = GUICtrlCreateEdit("Server Console" & @CRLF, 16, 64, 577, 225, $ES_AUTOVSCROLL + $WS_VSCROLL)
Global $bdsFolder = @ScriptDir & "\BDS"
Global $bdsExe = $bdsFolder & "\bedrock_server.exe"

;Functions #####

Func startServer()
    Global $BDS_process = Run($bdsExe, "", @SW_HIDE, $STDERR_CHILD + $STDOUT_CHILD)
    While ProcessExists($BDS_process)
       Global $line = StdoutRead($BDS_process)
        If @error Then ExitLoop
        GUICtrlSetData($gui_console, $line, 1)
        Sleep(1000)
    Wend
EndFunc

Func stopServer(); Send Stop > Wait 30s > if process still exists, the shoot it, else return
    StdinWrite($BDS_process, "save hold")
	;Sleep(30000) ;30s, aka a timeout. WIll kill the PID after this
	
EndFunc

While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			Exit

        Case $gui_startServerBtn
            startServer()

        Case $gui_stopServerBtn
            stopServer()

	EndSwitch
WEnd
