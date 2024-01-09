#include <AutoItConstants.au3>
#include <WindowsConstants.au3>


Func startServer()
    Global $BDS_process = Run(@ScriptDir&"BDS/bedrock_server.exe", "", $STDERR_CHILD + $STDOUT_CHILD)
    MsgBox("", "text", $BDS_process)
    $serverRunning = True
    AdlibRegister("updateConsole", 1000) ; Call updateConsole every 1s
EndFunc

Func updateConsole()
    If ProcessExists($BDS_process) Then
        Global $line = StdoutRead($BDS_process)
        If @error Then 
            $serverRunning = False
            ConsoleWrite("Server Stopped")
        Else
            ConsoleWrite($line)
        EndIf
    EndIf
EndFunc

Func stopServer()
    StdinWrite($BDS_process, "stop" & Chr(13))
    Sleep(1000) ; Wait for a while to give the process time to read the input
    StdinWrite($BDS_process) ; Close the stream
    $serverRunning = False
    Sleep(3000)
    AdlibUnRegister("updateConsole")
    If ProcessExists($BDS_process) Then
        MsgBox("s", "NOTICE", "Failed to stop server")
    else
        MsgBox("s", "NOTICE", "Server Stopped")
    endif
EndFunc

Func sendBDScmd($cmd)
    $tmp = StdinWrite($BDS_process, $cmd)
    MsgBox("", "text", $tmp)
    Return
EndFunc