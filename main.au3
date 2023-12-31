#include <GUIConstantsEx.au3>
#include <AutoItConstants.au3>
#include <WindowsConstants.au3>
#include <EditConstants.au3>
#include "shell/pwsh.au3"
$exePath = "to be updated :D"

$gui = GUICreate("BDS GUI", 500, 250)

$label = GUICtrlCreateLabel("Bedrock Dedicated Server UI  - V Alpha 0.1", 10, 10)

$edit = GUICtrlCreateEdit("", 10, 40, 480, 200, $ES_AUTOVSCROLL + $WS_VSCROLL + $WS_BORDER)

$button = GUICtrlCreateButton("Run", 10, 220)

GUISetState(@SW_SHOW, $gui)

While 1
    $msg = GUIGetMsg()

    If $msg = $GUI_EVENT_CLOSE Then ExitLoop
    If $msg = $button Then 
        ; Run the external executable
        $pid = Run($exePath, "", @SW_HIDE, $STDERR_CHILD + $STDOUT_CHILD)
        While 1
            $output = StdoutRead($pid)
            If @error Then ExitLoop
            GUICtrlSetData($edit, GUICtrlRead($edit) & $output)
        WEnd
    EndIf
WEnd