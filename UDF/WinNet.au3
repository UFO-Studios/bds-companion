Global $User_Agent = "BDS-COMPANION_1.0.1" ;HTTP user agent - update with release

;===============================================================================
;
; Function Name:    httpGET()
; Description:      Sends a http GET request to the specified url.
; Parameter(s):     $url - Where you want the GET request
; Requirement(s):   WinINet.dll - Default on windows.
; Return Value(s):  Returns the data from the URL, as a string
; Author(s):        Nicey
;
;===============================================================================
Func httpGET($url)
    ; open http handle for the connection
    Local $hInternet = DllCall("wininet.dll", "ptr", "InternetOpen", "str", $User_Agent, "dword", 1, "ptr", 0, "ptr", 0, "dword", 0)
    Local $hConnect = DllCall("wininet.dll", "ptr", "InternetOpenUrl", "ptr", $hInternet[0], "str", $url, "ptr", 0, "dword", 0, "dword", 0x80000000, "ptr", 0)
    
    ; create emptry buffers and pointers
    Local $sBuffer = ""
    Local $aRead
    Local $tBuffer = DllStructCreate("char[1024]")

    ; magic windows http dll things
    Do
        $aRead = DllCall("wininet.dll", "bool", "InternetReadFile", "ptr", $hConnect[0], "ptr", DllStructGetPtr($tBuffer), "dword", 1024, "dword*", 0)
        If $aRead[4] > 0 Then
            $sBuffer &= BinaryToString(DllStructGetData($tBuffer, 1), 4)
        EndIf
    Until $aRead[4] = 0
    ;~ MsgBox(0, "GET Response", $sBuffer)

    ; close pointers to free memory
    DllCall("wininet.dll", "bool", "InternetCloseHandle", "ptr", $hConnect[0])
    DllCall("wininet.dll", "bool", "InternetCloseHandle", "ptr", $hInternet[0])

    return $sBuffer
EndFunc   ;==> httpGET()

;===============================================================================
;
; Function Name:    httpPOST()
; Description:      Sends a post request to the url
; Parameter(s):     $url - Endpoint for the POST request
;                   $body - POST request body
;                   $mimeType - data type. E.g application/json
; Requirement(s):   WinINet.dll - Default on windows.
; Return Value(s):  Response body from the URL
; Author(s):        Nicey
;
;===============================================================================
Func httpPOST($url, $body, $mimeType)
    ; split hostname and uri
    ; we want hostname to be the domain (NO "HTTPS://")
    ; and uri = /api/webhook/... or ect

    $urlParts = StringSplit($url, "/")
    $hostname = $urlParts[2] & $urlParts[3]
    $uri = StringReplace($url, $hostname, "")
    $uri = StringReplace($uri, "https://", "")

    ; open http handles for the connection
    Local $hInternet = DllCall("wininet.dll", "ptr", "InternetOpen", "str", $User_Agent, "dword", 1, "ptr", 0, "ptr", 0, "dword", 0)
    Local $hConnect = DllCall("wininet.dll", "ptr", "InternetConnect", "ptr", $hInternet[0], "str", $hostname, "ushort", 443, "str", "", "str", "", "dword", 3, "dword", 0, "ptr", 0)
    Local $hRequest = DllCall("wininet.dll", "ptr", "HttpOpenRequest", "ptr", $hConnect[0], "str", "POST", "str", $uri, "str", "HTTP/1.1", "ptr", 0, "ptr", 0, "dword", BitOR(0x80000000, 0x00800000), "ptr", 0)

    ; "fill" the connection with the post body and mime type (e.g application/json)
    DllCall("wininet.dll", "bool", "HttpSendRequest", "ptr", $hRequest[0], "str", "Content-Type: "& $mimeType, "dword", -1, "str", $body, "dword", StringLen($body))
    Local $sBuffer = ""
    Local $aRead

    ; magic windows http dll things 
    Do
        $aRead = DllCall("wininet.dll", "bool", "InternetReadFile", "ptr", $hRequest[0], "ptr", DllStructCreate("char[1024]"), "dword", 1024, "dword*", 0)
        If $aRead[4] > 0 Then
            $sBuffer &= BinaryToString(DllStructGetData($aRead[2], 1), 4)
        EndIf
    Until $aRead[4] = 0


    ;~ MsgBox(0, "POST Response", $sBuffer)
    ; close handles
    DllCall("wininet.dll", "bool", "InternetCloseHandle", "ptr", $hRequest[0])
    DllCall("wininet.dll", "bool", "InternetCloseHandle", "ptr", $hConnect[0])
    DllCall("wininet.dll", "bool", "InternetCloseHandle", "ptr", $hInternet[0])

    return $sBuffer
EndFunc   ;==> httpPOST()


;===============================================================================
;
; Function Name:    DLLCheck()
; Description:      Checks to see if WinINet.dll is working correctly.
; Return Value(s):  0 = OK, -1 = Not OK
; Author(s):        Nicey
;
;===============================================================================
Func DLLCheck()
    Local $hDLL = DllOpen("wininet.dll")
    If $hDLL = -1 Then
        MsgBox(0, "DLL ERROR", "Could not find WinINet.dll! Please check that your windows installation is working correctly")
        DllClose($hDLL)
        return -1
    Else 
        Return 0
    EndIf
EndFunc   ;==> DLLCheck()
