#include <Date.au3>
func backup()
    $cmd = "pwsh -c Compress-Archive -Path "& @ScriptDir &"BDS/* -DestinationPath C:\Users\%USERNAME\BDS-backup-"& _NowDate & ".zip"
    RunWait($cmd)
    MsgBox(0, "Backup", "Backup complete")
endfunc