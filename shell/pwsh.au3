; #FUNCTION# ====================================================================================================================
; Name...........: InstallBDL
; Description ...: This function installs BDL.
; Syntax.........: InstallBDL([$path = "C:/UFO-Studios/BDS-UI/BDS"], [$version = ""])
; Parameters ....: $path    - The path where BDL should be installed. Default is "C:/UFO-Studios/BDS-UI/BDS".
;                  $version - The version of BDL to install. If not specified, an error is returned.
; Return values .: Returns an error message if $version is not specified.
; Example .......: InstallBDL("C:/UFO-Studios/BDS-UI/BDS", "1.20.50")
; ===============================================================================================================================
Func InstallBDL($path="C:/UFO-Studios/BDS-UI/BDS", $version="")
    $error = "Error: "
    if $version = "" Then
        Return $error & "No version specified"
    EndIf
    $url = "https://minecraft.azureedge.net/bin-win/bedrock-server-" & $version & ".zip"
EndFunc

Func StartBDL($path="C:/UFO-Studios/BDS-UI/BDS")
    $error = "Error: "
    if $path = "" Then
        Return $error & "No path specified"
    EndIf
    $cmd = $path & "/bedrock_server.exe"
    Run($cmd)
    return "Success"
EndFunc

Func ConfigureBDL($path="C:/UFO-Studios/BDS-UI/BDS", $config="")
    $error = "Error: "
EndFunc

;DEFAULT CONFIG ARRAY VALUES (For BDS Itself, not this program)
;[gamemode, level_name, motd, port, pvp, difficulty, max_players, view_distance]
    