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
    $cmd = "pwsh -c " & $path & "/bedrock_server.exe"
    RunWait($cmd)
    return 1
EndFunc


; #FUNCTION# ====================================================================================================================
; Name...........: ConfigureBDL
; Description ...: This function configures BDL. (Server.properties). Leave second parameter blank to use default path.
; Example........: ConfigureBDL(["survival", "Bedrock level", "Welcome to my server!", "19132", "true", "normal", "10", "10"])
; Parameters ....: $config - The config array to use. (See example) 
;                  $path   - The path where BDL is installed. Default is "C:/UFO-Studios/BDS-UI/BDS".
; Return values .: Returns an error message if $path is not specified.
Func ConfigureBDL($config, $path="C:/UFO-Studios/BDS-UI/BDS")
    ;DEFAULT CONFIG ARRAY VALUES (For BDS Itself, not this program)
    ;[gamemode, level_name, motd, port, pvp, difficulty, max_players, view_distance]
    $error = "Error: "
    ;CONF VALUES
    $gamemode = $config[0]
    $level_name = $config[1]
    $motd = $config[2]
    $port = $config[3]
    $pvp = $config[4]
    $difficulty = $config[5]
    $max_players = $config[6]
    $view_distance = $config[7]
    ;Write File
    FileDelete($path & "/server.properties")
    $file = FileOpen($path & "/server.properties", 1)
    FileWriteLine($file, "gamemode=" & $gamemode)
    FileWriteLine($file, "level-name=" & $level_name)
    FileWriteLine($file, "motd=" & $motd)
    FileWriteLine($file, "server-port=" & $port)
    FileWriteLine($file, "pvp=" & $pvp)
    FileWriteLine($file, "difficulty=" & $difficulty)
    FileWriteLine($file, "max-players=" & $max_players)
    FileWriteLine($file, "view-distance=" & $view_distance)
    FileClose($file)
    return 1
    
EndFunc