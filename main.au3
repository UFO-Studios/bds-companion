#include <GUIConstantsEx.au3>
#include <AutoItConstants.au3>
#include <WindowsConstants.au3>
#include <EditConstants.au3>
#include "shell/pwsh.au3"
$exePath = "D:\TAD\bds-ui\BDS\bedrock_server.exe"


func buttonText() ;for the start/stop button
    $buttonText = ""
    if $buttonText = "Run" then
        $buttonText = "Stop"
    else
        $buttonText = "Run"
    endif
    return $buttonText
endfunc

$gui = GUICreate("BDS GUI", 500, 300)

$label = GUICtrlCreateLabel("Bedrock Dedicated Server UI  - V:Alpha 0.1", 10, 10)

$edit = GUICtrlCreateEdit("", 10, 40, 480, 200, $ES_AUTOVSCROLL + $WS_VSCROLL + $WS_BORDER) ;main console output

$button = GUICtrlCreateButton(buttonText(), 10, 240) ;run/stop button

GUISetState(@SW_SHOW, $gui)

While 1 ;main loop
    $msg = GUIGetMsg()

    If $msg = $GUI_EVENT_CLOSE Then ExitLoop
    If $msg = $button Then 
        ; Run the bds
        $pid = Run($exePath, "", @SW_HIDE, $STDERR_CHILD + $STDOUT_CHILD)
        While 1
            $output = StdoutRead($pid)
            If @error Then ExitLoop
            GUICtrlSetData($edit, GUICtrlRead($edit) & $output)
            if $msg = $button Then
                ProcessClose($pid)
                ExitLoop
            endif
        WEnd
    EndIf
WEnd