#include <GUIConstantsEx.au3>
#include <AutoItConstants.au3>
#include <WindowsConstants.au3>
#include <EditConstants.au3>
#include "cfg.au3"
;#include "backup.au3"
$exePath = "D:\TAD\bds-ui\BDS\bedrock_server.exe"

Global $buttonText = ""

;~ Func buttonText()
;~     if $buttonText = "Run" then
;~         $buttonText = "Stop"
;~     else
;~         $buttonText = "Run"
;~     endif
;~     return $buttonText
;~ EndFunc

$gui = GUICreate("BDS GUI", 600, 300)

$title = GUICtrlCreateLabel("Bedrock Dedicated Server UI  - V: Alpha 0.1", 10, 10)

$console = GUICtrlCreateEdit("", 10, 40, 480, 200, $ES_AUTOVSCROLL + $WS_VSCROLL + $WS_BORDER) ;main console output
$runButton = GUICtrlCreateButton("Start/Stop", 10, 240) ;run/stop button

$manualBackupButton = GUICtrlCreateButton("Manual Backup", 70, 240) ;manual backup button

GUISetState(@SW_SHOW, $gui)
$startStop = false
While 1
    $nMsg = GUIGetMsg()
    Switch $nMsg
        Case $GUI_EVENT_CLOSE
            Exit
        Case $runButton
            $startStop = not $startStop
            if $startStop = true then
                $exePath = "D:\TAD\bds-ui\BDS\bedrock_server.exe"
                GUICtrlSetData($console, "Starting server..." & @CRLF)
                $process = Run($exePath, "", @SW_HIDE, $STDERR_CHILD + $STDOUT_CHILD)
                While ProcessExists($process)
                    $line = StdoutRead($process)
                    if @error then exitloop
                    GUICtrlSetData($console, $line, 1)
                WEnd
            else
                $tmp = StdinWrite($process, "stop" & @CRLF)
                MsgBox(0, "test", $tmp)
                GUICtrlSetData($console, "Stopping server..." & @CRLF)
                ProcessClose($process)
            endif
    EndSwitch
WEnd