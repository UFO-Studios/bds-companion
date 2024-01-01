; #FUNCTION# ====================================================================================================================
; Name...........: ReadServerProperties
; Description ...: Reads the server.properties file. Returns an array of the lines.
; Example........: $serverCfg = ReadServerProperties()
; Parameters ....: $path - The path to the server.properties file. If not specified, it will use the default path.
; Return values .: [ARRAY]
Global $path = @ScriptDir & "BDS\bedrock_server.exe"
Func ReadServerProperties($path)
    if $path = "" then
        $path = @ScriptDir & "BDS\server.properties"
    endif
    $file = FileOpen($path, 0)
    $lines = FileReadToArray($file)
    FileClose($file)
    return $lines
endfunc


; #FUNCTION# ====================================================================================================================
; Name...........: WriteServerProperites
; Description ...: This function writes to the server.properties file.
; Example........: WriteServerProperites("gamemode=creative")
; Parameters ....: $property - The property to write to the file.
; Return values .: Returns true if successful.
Func WriteServerProperites($property)
    $file = @ScriptDir & "BDS\server.properties"
    $fileHandle = FileOpen($file, 0)
    $lines = FileReadToArray($fileHandle)
    $i = 0
    While $i < UBound($lines)
        $i += 1
        $lookingFor = StringSplit($lines[$i], "=")[0]
        if StringInStr($lines[$i], $lookingFor) then
            $lines[$i] = $lookingFor & "=" & $property[$i]
        endif
    WEnd
    return true
EndFunc

Func writeAppCfg($CFGline, $value)
    $file = @MyDocumentsDir & "BDS-UI.txt"
    $fileHandle = FileOpen($file, 0) 
    $lines = FileReadToArray($fileHandle) ; Read into array
    FileClose($fileHandle) 

    $lines[$CFGline - 1] = StringReplace($lines[$CFGline - 1], "", $value) 

    $fileHandle = FileOpen($file, 2) 
    For $line In $lines
        FileWriteLine($fileHandle, $line) 
    Next
    FileClose($fileHandle) 
EndFunc