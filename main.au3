#include <GUIConstantsEx.au3>
#include <AutoItConstants.au3>
#include <WindowsConstants.au3>
#include <EditConstants.au3>
#include "shell/pwsh.au3"
$exePath = "D:\TAD\bds-ui\BDS\bedrock_server.exe"

Global $buttonText = ""

func buttonText() ;for the start/stop button
    if $buttonText = "Run" then
        $buttonText = "Stop"
    else
        $buttonText = "Run"
    endif
    return $buttonText
endfunc

$gui = GUICreate("BDS GUI", 600, 300)

$label = GUICtrlCreateLabel("Bedrock Dedicated Server UI  - V: Alpha 0.1", 10, 10)

$edit = GUICtrlCreateEdit("", 10, 40, 480, 200, $ES_AUTOVSCROLL + $WS_VSCROLL + $WS_BORDER) ;main console output

$button = GUICtrlCreateButton(buttonText(), 10, 240) ;run/stop button

GUISetState(@SW_SHOW, $gui)
$startStop = false
While 1
    $nMsg = GUIGetMsg()
    Switch $nMsg
        Case $GUI_EVENT_CLOSE
            Exit
        Case $button
            $startStop = not $startStop
            if $startStop = true then
                GUICtrlSetData($edit, "Starting server..." & @CRLF)
                $process = Run($exePath, "", @SW_HIDE, $STDERR_CHILD + $STDOUT_CHILD)
                While 1
                    $line = StdoutRead($process)
                    if @error then exitloop
                    GUICtrlSetData($edit, $line, 1)
                WEnd
            else
                GUICtrlSetData($edit, "Stopping server..." & @CRLF)
                ProcessClose($process)
            endif
    EndSwitch
wend