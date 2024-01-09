#include <AutoItConstants.au3>
#include <WindowsConstants.au3>

Func Main()
    $EXE = "D:/TAD/bds-ui/BDS/bedrock_server.exe"
    $PS = Run($EXE, "", $STDERR_CHILD + $STDOUT_CHILD + $STDIN_CHILD)
    MsgBox("", "", $PS)

EndFunc

;Main()
StdinWrite(22856, "help")