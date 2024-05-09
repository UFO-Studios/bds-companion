#include "UDF/Zip.au3"

;Get from main thread: Backup folder, BDS folder
Global $cfg_backupsDir = $CmdLine[1]
Global $cfg_bdsDir = $CmdLine[2]
Global $cfg_logsDir = $CmdLine[3]
;E.G: cmd -c C:/Users/user/bds-ui/backup.exe C:/Users/user/bds-ui/backups C:/Users/user/bds-ui/BDS
;                     BDS-Backup exe ^          ^ Backup folder                   ^ BDS folder

AutoItWinSetTitle("BDS-UI-Backup")

Func logWrite($spaces, $content)
	If $spaces = 1 Then ;For adding spaces around the content written to the log
		FileOpen($cfg_logsDir & "\log.latest", 1)
		FileWrite($cfg_logsDir & "\log.latest", @CRLF)
		FileClose($cfg_logsDir & "\log.latest")
	ElseIf $spaces = 2 Then
		FileOpen($cfg_logsDir & "\log.latest", 1)
		FileWrite($cfg_logsDir & "\log.latest", @CRLF)
		FileClose($cfg_logsDir & "\log.latest")
	EndIf

	FileOpen($cfg_logsDir & "\log.latest", 1)
	FileWrite($cfg_logsDir & "\log.latest", "[BACKUP THREAD] " & @MDAY & "/" & @MON & "/" & @YEAR & " @ " & @HOUR & ":" & @MIN & ":" & @SEC & " > " & $content & @CRLF)
	FileClose($cfg_logsDir & "\log.latest")

	If $spaces = 1 Then
		FileOpen($cfg_logsDir & "\log.latest", 1)
		FileWrite($cfg_logsDir & "\log.latest", @CRLF)
		FileClose($cfg_logsDir & "\log.latest")
	ElseIf $spaces = 3 Then
		FileOpen($cfg_logsDir & "\log.latest", 1)
		FileWrite($cfg_logsDir & "\log.latest", @CRLF)
		FileClose($cfg_logsDir & "\log.latest")
	EndIf
EndFunc   ;==>logWrite

logWrite(0, "Backup .exe started")

;PRE PROCESSING & FILE LOCKS
;~ logWrite(0, "Backing up server...")
DirCreate(@ScriptDir & "\temp\") ;for other thread
FileWrite(@ScriptDir & "\temp/is_running", "1")

;COPY FILES TO TEMP FOLDER
DirCreate(@ScriptDir & "\temp\backups\")
DirCopy($cfg_bdsDir & "\behavior_packs", @ScriptDir & "\temp\backups\behavior_packs", 1)
Sleep(100)
DirCopy($cfg_bdsDir & "\behavior_packs", @ScriptDir & "\temp\backups\config", 1)
Sleep(100)
DirCopy($cfg_bdsDir & "\resource_packs", @ScriptDir & "\temp\backups\resource_packs", 1)
Sleep(100)
DirCopy($cfg_bdsDir & "\worlds", @ScriptDir & "\temp\backups\worlds", 1)
Sleep(100)
FileCopy($cfg_bdsDir & "\allowlist.json", @ScriptDir & "\temp\backups\allowlist.json", 1)
Sleep(100)
FileCopy($cfg_bdsDir & "\permissions.json", @ScriptDir & "\temp\backups\permissions.json", 1)
Sleep(100)
FileCopy($cfg_bdsDir & "\server.properties", @ScriptDir & "\temp\backups\server.properties", 1)

;CREATE ZIP
Local $backupDateTime = "[" & @HOUR & "-" & @MIN & "-" & @SEC & "][" & @MDAY & "." & @MON & "." & @YEAR & "]"
Local $ZIPname = $cfg_backupsDir & "\Backup-" & $backupDateTime & ".zip"
_Zip_Create($ZIPname)
logWrite(0, "Backup zip created at " & $ZIPname)
Sleep(100)

;COMPRESS FILES
_Zip_AddFolder($ZIPname, @ScriptDir & "\temp\backups\behavior_packs", 0)
If @error Then MsgBox(0, "Error", "Error adding folder to zip: " & @error)
_Zip_AddFolder($ZIPname, @ScriptDir & "\temp\backups\config", 0)
If @error Then MsgBox(0, "Error", "Error adding folder to zip: " & @error)
_Zip_AddFolder($ZIPname, @ScriptDir & "\temp\backups\resource_packs", 0)
If @error Then MsgBox(0, "Error", "Error adding folder to zip: " & @error)
_Zip_AddFolder($ZIPname, @ScriptDir & "\temp\backups\worlds", 0)
If @error Then MsgBox(0, "Error", "Error adding folder to zip: " & @error)
_Zip_AddFile($ZIPname, @ScriptDir & "\temp\backups\allowlist.json", 0)
If @error Then MsgBox(0, "Error", "Error adding folder to zip: " & @error)
_Zip_AddFile($ZIPname, @ScriptDir & "\temp\backups\permissions.json", 0)
If @error Then MsgBox(0, "Error", "Error adding folder to zip: " & @error)
_Zip_AddFile($ZIPname, @ScriptDir & "\temp\backups\server.properties", 0)
If @error Then MsgBox(0, "Error", "Error adding folder to zip: " & @error)
logWrite(0, "Backup (Compressed files 7/7). Code " & @error)
logWrite(0, "Backup (Complete)")

;CLEANUP
logWrite(0, "Cleaning up temporary files")
DirRemove(@ScriptDir & "\temp\", 1)
logWrite(0, "Temporary files cleaned up")

;COMPLETE
ConsoleWrite("Backup complete")
