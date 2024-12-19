#pragma compile(Compatibility, XP, vista, win7, win8, win81, win10, win11)
#pragma compile(FileDescription, BDS Companion)
#pragma compile(ProductName, BDS Companion)
#pragma compile(ProductVersion, 0.1.2)
#pragma compile(FileVersion, 0.1.2)
#pragma compile(LegalCopyright, ©UFO Studios)
#pragma compile(CompanyName, UFO Studios)
#pragma compile(OriginalFilename, BDS-Companion.exe)
Global Const $STDIN_CHILD = 1
Global Const $STDOUT_CHILD = 2
Global Const $STDERR_CHILD = 4
Global Const $UBOUND_DIMENSIONS = 0
Global Const $UBOUND_ROWS = 1
Global Const $UBOUND_COLUMNS = 2
Global Const $STR_ENTIRESPLIT = 1
Global Const $STR_NOCOUNT = 2
Global Enum $ARRAYFILL_FORCE_DEFAULT, $ARRAYFILL_FORCE_SINGLEITEM, $ARRAYFILL_FORCE_INT, $ARRAYFILL_FORCE_NUMBER, $ARRAYFILL_FORCE_PTR, $ARRAYFILL_FORCE_HWND, $ARRAYFILL_FORCE_STRING, $ARRAYFILL_FORCE_BOOLEAN
Func _ArrayAdd(ByRef $aArray, $vValue, $iStart = 0, $sDelim_Item = "|", $sDelim_Row = @CRLF, $iForce = $ARRAYFILL_FORCE_DEFAULT)
If $iStart = Default Then $iStart = 0
If $sDelim_Item = Default Then $sDelim_Item = "|"
If $sDelim_Row = Default Then $sDelim_Row = @CRLF
If $iForce = Default Then $iForce = $ARRAYFILL_FORCE_DEFAULT
If Not IsArray($aArray) Then Return SetError(1, 0, -1)
Local $iDim_1 = UBound($aArray, $UBOUND_ROWS)
Local $hDataType = 0
Switch $iForce
Case $ARRAYFILL_FORCE_INT
$hDataType = Int
Case $ARRAYFILL_FORCE_NUMBER
$hDataType = Number
Case $ARRAYFILL_FORCE_PTR
$hDataType = Ptr
Case $ARRAYFILL_FORCE_HWND
$hDataType = Hwnd
Case $ARRAYFILL_FORCE_STRING
$hDataType = String
Case $ARRAYFILL_FORCE_BOOLEAN
$hDataType = "Boolean"
EndSwitch
Switch UBound($aArray, $UBOUND_DIMENSIONS)
Case 1
If $iForce = $ARRAYFILL_FORCE_SINGLEITEM Then
ReDim $aArray[$iDim_1 + 1]
$aArray[$iDim_1] = $vValue
Return $iDim_1
EndIf
If IsArray($vValue) Then
If UBound($vValue, $UBOUND_DIMENSIONS) <> 1 Then Return SetError(5, 0, -1)
$hDataType = 0
Else
Local $aTmp = StringSplit($vValue, $sDelim_Item, $STR_NOCOUNT + $STR_ENTIRESPLIT)
If UBound($aTmp, $UBOUND_ROWS) = 1 Then
$aTmp[0] = $vValue
EndIf
$vValue = $aTmp
EndIf
Local $iAdd = UBound($vValue, $UBOUND_ROWS)
ReDim $aArray[$iDim_1 + $iAdd]
For $i = 0 To $iAdd - 1
If String($hDataType) = "Boolean" Then
Switch $vValue[$i]
Case "True", "1"
$aArray[$iDim_1 + $i] = True
Case "False", "0", ""
$aArray[$iDim_1 + $i] = False
EndSwitch
ElseIf IsFunc($hDataType) Then
$aArray[$iDim_1 + $i] = $hDataType($vValue[$i])
Else
$aArray[$iDim_1 + $i] = $vValue[$i]
EndIf
Next
Return $iDim_1 + $iAdd - 1
Case 2
Local $iDim_2 = UBound($aArray, $UBOUND_COLUMNS)
If $iStart < 0 Or $iStart > $iDim_2 - 1 Then Return SetError(4, 0, -1)
Local $iValDim_1, $iValDim_2 = 0, $iColCount
If IsArray($vValue) Then
If UBound($vValue, $UBOUND_DIMENSIONS) <> 2 Then Return SetError(5, 0, -1)
$iValDim_1 = UBound($vValue, $UBOUND_ROWS)
$iValDim_2 = UBound($vValue, $UBOUND_COLUMNS)
$hDataType = 0
Else
Local $aSplit_1 = StringSplit($vValue, $sDelim_Row, $STR_NOCOUNT + $STR_ENTIRESPLIT)
$iValDim_1 = UBound($aSplit_1, $UBOUND_ROWS)
Local $aTmp[$iValDim_1][0], $aSplit_2
For $i = 0 To $iValDim_1 - 1
$aSplit_2 = StringSplit($aSplit_1[$i], $sDelim_Item, $STR_NOCOUNT + $STR_ENTIRESPLIT)
$iColCount = UBound($aSplit_2)
If $iColCount > $iValDim_2 Then
$iValDim_2 = $iColCount
ReDim $aTmp[$iValDim_1][$iValDim_2]
EndIf
For $j = 0 To $iColCount - 1
$aTmp[$i][$j] = $aSplit_2[$j]
Next
Next
$vValue = $aTmp
EndIf
If UBound($vValue, $UBOUND_COLUMNS) + $iStart > UBound($aArray, $UBOUND_COLUMNS) Then Return SetError(3, 0, -1)
ReDim $aArray[$iDim_1 + $iValDim_1][$iDim_2]
For $iWriteTo_Index = 0 To $iValDim_1 - 1
For $j = 0 To $iDim_2 - 1
If $j < $iStart Then
$aArray[$iWriteTo_Index + $iDim_1][$j] = ""
ElseIf $j - $iStart > $iValDim_2 - 1 Then
$aArray[$iWriteTo_Index + $iDim_1][$j] = ""
Else
If String($hDataType) = "Boolean" Then
Switch $vValue[$iWriteTo_Index][$j - $iStart]
Case "True", "1"
$aArray[$iWriteTo_Index + $iDim_1][$j] = True
Case "False", "0", ""
$aArray[$iWriteTo_Index + $iDim_1][$j] = False
EndSwitch
ElseIf IsFunc($hDataType) Then
$aArray[$iWriteTo_Index + $iDim_1][$j] = $hDataType($vValue[$iWriteTo_Index][$j - $iStart])
Else
$aArray[$iWriteTo_Index + $iDim_1][$j] = $vValue[$iWriteTo_Index][$j - $iStart]
EndIf
EndIf
Next
Next
Case Else
Return SetError(2, 0, -1)
EndSwitch
Return UBound($aArray, $UBOUND_ROWS) - 1
EndFunc
Func _ArraySearch(Const ByRef $aArray, $vValue, $iStart = 0, $iEnd = 0, $iCase = 0, $iCompare = 0, $iForward = 1, $iSubItem = -1, $bRow = False)
If $iStart = Default Then $iStart = 0
If $iEnd = Default Then $iEnd = 0
If $iCase = Default Then $iCase = 0
If $iCompare = Default Then $iCompare = 0
If $iForward = Default Then $iForward = 1
If $iSubItem = Default Then $iSubItem = -1
If $bRow = Default Then $bRow = False
If Not IsArray($aArray) Then Return SetError(1, 0, -1)
Local $iDim_1 = UBound($aArray) - 1
If $iDim_1 = -1 Then Return SetError(3, 0, -1)
Local $iDim_2 = UBound($aArray, $UBOUND_COLUMNS) - 1
Local $bCompType = False
If $iCompare = 2 Then
$iCompare = 0
$bCompType = True
EndIf
If $bRow Then
If UBound($aArray, $UBOUND_DIMENSIONS) = 1 Then Return SetError(5, 0, -1)
If $iEnd < 1 Or $iEnd > $iDim_2 Then $iEnd = $iDim_2
If $iStart < 0 Then $iStart = 0
If $iStart > $iEnd Then Return SetError(4, 0, -1)
Else
If $iEnd < 1 Or $iEnd > $iDim_1 Then $iEnd = $iDim_1
If $iStart < 0 Then $iStart = 0
If $iStart > $iEnd Then Return SetError(4, 0, -1)
EndIf
Local $iStep = 1
If Not $iForward Then
Local $iTmp = $iStart
$iStart = $iEnd
$iEnd = $iTmp
$iStep = -1
EndIf
Switch UBound($aArray, $UBOUND_DIMENSIONS)
Case 1
If Not $iCompare Then
If Not $iCase Then
For $i = $iStart To $iEnd Step $iStep
If $bCompType And VarGetType($aArray[$i]) <> VarGetType($vValue) Then ContinueLoop
If $aArray[$i] = $vValue Then Return $i
Next
Else
For $i = $iStart To $iEnd Step $iStep
If $bCompType And VarGetType($aArray[$i]) <> VarGetType($vValue) Then ContinueLoop
If $aArray[$i] == $vValue Then Return $i
Next
EndIf
Else
For $i = $iStart To $iEnd Step $iStep
If $iCompare = 3 Then
If StringRegExp($aArray[$i], $vValue) Then Return $i
Else
If StringInStr($aArray[$i], $vValue, $iCase) > 0 Then Return $i
EndIf
Next
EndIf
Case 2
Local $iDim_Sub
If $bRow Then
$iDim_Sub = $iDim_1
If $iSubItem > $iDim_Sub Then $iSubItem = $iDim_Sub
If $iSubItem < 0 Then
$iSubItem = 0
Else
$iDim_Sub = $iSubItem
EndIf
Else
$iDim_Sub = $iDim_2
If $iSubItem > $iDim_Sub Then $iSubItem = $iDim_Sub
If $iSubItem < 0 Then
$iSubItem = 0
Else
$iDim_Sub = $iSubItem
EndIf
EndIf
For $j = $iSubItem To $iDim_Sub
If Not $iCompare Then
If Not $iCase Then
For $i = $iStart To $iEnd Step $iStep
If $bRow Then
If $bCompType And VarGetType($aArray[$j][$i]) <> VarGetType($vValue) Then ContinueLoop
If $aArray[$j][$i] = $vValue Then Return $i
Else
If $bCompType And VarGetType($aArray[$i][$j]) <> VarGetType($vValue) Then ContinueLoop
If $aArray[$i][$j] = $vValue Then Return $i
EndIf
Next
Else
For $i = $iStart To $iEnd Step $iStep
If $bRow Then
If $bCompType And VarGetType($aArray[$j][$i]) <> VarGetType($vValue) Then ContinueLoop
If $aArray[$j][$i] == $vValue Then Return $i
Else
If $bCompType And VarGetType($aArray[$i][$j]) <> VarGetType($vValue) Then ContinueLoop
If $aArray[$i][$j] == $vValue Then Return $i
EndIf
Next
EndIf
Else
For $i = $iStart To $iEnd Step $iStep
If $iCompare = 3 Then
If $bRow Then
If StringRegExp($aArray[$j][$i], $vValue) Then Return $i
Else
If StringRegExp($aArray[$i][$j], $vValue) Then Return $i
EndIf
Else
If $bRow Then
If StringInStr($aArray[$j][$i], $vValue, $iCase) > 0 Then Return $i
Else
If StringInStr($aArray[$i][$j], $vValue, $iCase) > 0 Then Return $i
EndIf
EndIf
Next
EndIf
Next
Case Else
Return SetError(2, 0, -1)
EndSwitch
Return SetError(6, 0, -1)
EndFunc
Global Const $COLOR_GREEN = 0x008000
Global Const $COLOR_ORANGE = 0xFFA500
Global Const $COLOR_PURPLE = 0x800080
Global Const $COLOR_RED = 0xFF0000
Global Const $GUI_EVENT_CLOSE = -3
Global Const $GUI_CHECKED = 1
Global Const $GUI_UNCHECKED = 4
Global Const $GUI_ENABLE = 64
Global Const $GUI_DISABLE = 128
Global Const $ES_READONLY = 2048
Global Const $EM_GETLINECOUNT = 0xBA
Global Const $EM_LIMITTEXT = 0xC5
Global Const $EM_LINESCROLL = 0xB6
Global Const $EM_SETLIMITTEXT = $EM_LIMITTEXT
Global Const $GUI_SS_DEFAULT_EDIT = 0x003010c0
Func _SendMessage($hWnd, $iMsg, $wParam = 0, $lParam = 0, $iReturn = 0, $wParamType = "wparam", $lParamType = "lparam", $sReturnType = "lresult")
Local $aCall = DllCall("user32.dll", $sReturnType, "SendMessageW", "hwnd", $hWnd, "uint", $iMsg, $wParamType, $wParam, $lParamType, $lParam)
If @error Then Return SetError(@error, @extended, "")
If $iReturn >= 0 And $iReturn <= 4 Then Return $aCall[$iReturn]
Return $aCall
EndFunc
Func _GUICtrlEdit_GetLineCount($hWnd)
If Not IsHWnd($hWnd) Then $hWnd = GUICtrlGetHandle($hWnd)
Return _SendMessage($hWnd, $EM_GETLINECOUNT)
EndFunc
Func _GUICtrlEdit_LineScroll($hWnd, $iHoriz, $iVert)
If Not IsHWnd($hWnd) Then $hWnd = GUICtrlGetHandle($hWnd)
Return _SendMessage($hWnd, $EM_LINESCROLL, $iHoriz, $iVert) <> 0
EndFunc
Func _GUICtrlEdit_SetLimitText($hWnd, $iLimit)
If Not IsHWnd($hWnd) Then $hWnd = GUICtrlGetHandle($hWnd)
_SendMessage($hWnd, $EM_SETLIMITTEXT, $iLimit)
EndFunc
Global Const $HGDI_ERROR = Ptr(-1)
Global Const $INVALID_HANDLE_VALUE = Ptr(-1)
Global Const $KF_EXTENDED = 0x0100
Global Const $KF_ALTDOWN = 0x2000
Global Const $KF_UP = 0x8000
Global Const $LLKHF_EXTENDED = BitShift($KF_EXTENDED, 8)
Global Const $LLKHF_ALTDOWN = BitShift($KF_ALTDOWN, 8)
Global Const $LLKHF_UP = BitShift($KF_UP, 8)
Func _WinAPI_FlashWindow($hWnd, $bInvert = True)
Local $aCall = DllCall("user32.dll", "bool", "FlashWindow", "hwnd", $hWnd, "bool", $bInvert)
If @error Then Return SetError(@error, @extended, False)
Return $aCall[0]
EndFunc
If UBound($CMDLine) > 1 Then
If $CMDLine[1] <> "" Then _Zip_VirtualZipOpen()
EndIf
Func _Zip_Create($hFilename)
$hFp = FileOpen($hFilename, 26)
$sString = Chr(80) & Chr(75) & Chr(5) & Chr(6) & Chr(0) & Chr(0) & Chr(0) & Chr(0) & Chr(0) & Chr(0) & Chr(0) & Chr(0) & Chr(0) & Chr(0) & Chr(0) & Chr(0) & Chr(0) & Chr(0) & Chr(0) & Chr(0) & Chr(0) & Chr(0)
FileWrite($hFp, $sString)
If @error Then Return SetError(1,0,0)
FileClose($hFp)
While Not FileExists($hFilename)
Sleep(10)
Wend
Return $hFilename
EndFunc
Func _Zip_AddFolder($hZipFile, $hFolder, $flag = 1)
Local $DLLChk = _Zip_DllChk()
If $DLLChk <> 0 Then Return SetError($DLLChk, 0, 0)
If not _IsFullPath($hZipFile) then Return SetError(4,0)
If Not FileExists($hZipFile) Then Return SetError(1, 0, 0)
If StringRight($hFolder, 1) <> "\" Then $hFolder &= "\"
$files = _Zip_Count($hZipFile)
$oApp = ObjCreate("Shell.Application")
Local $oZipFolder = $oApp.NameSpace($hZipFile)
If Not IsObj($oZipFolder) Then Return SetError(5, 0, 0)
Local $oFolder = $oApp.Namespace($hFolder)
If Not IsObj($oFolder) Then Return SetError(6, 0, 0)
$oCopy = $oZipFolder.CopyHere($oFolder)
While 1
If $flag = 1 then _Hide()
If _Zip_Count($hZipFile) =($files+1) Then ExitLoop
Sleep(10)
WEnd
Return SetError(0,0,1)
EndFunc
Func _Zip_Unzip($hZipFile, $hFilename, $hDestPath, $flag = 1)
Local $DLLChk = _Zip_DllChk()
If $DLLChk <> 0 Then Return SetError($DLLChk, 0, 0)
If not _IsFullPath($hZipFile) then Return SetError(4,0)
If Not FileExists($hZipFile) Then Return SetError(1, 0, 0)
If Not FileExists($hDestPath) Then DirCreate($hDestPath)
$oApp = ObjCreate("Shell.Application")
$hFolderitem = $oApp.NameSpace($hZipFile).Parsename($hFilename)
$oApp.NameSpace($hDestPath).Copyhere($hFolderitem)
While 1
If $flag = 1 then _Hide()
If FileExists($hDestPath & "\" & $hFilename) Then
return SetError(0, 0, 1)
ExitLoop
EndIf
Sleep(500)
WEnd
EndFunc
Func _Zip_Count($hZipFile)
Local $DLLChk = _Zip_DllChk()
If $DLLChk <> 0 Then Return SetError($DLLChk, 0, 0)
If not _IsFullPath($hZipFile) then Return SetError(4,0)
If Not FileExists($hZipFile) Then Return SetError(1, 0, 0)
$items = _Zip_List($hZipFile)
Return UBound($items) - 1
EndFunc
Func _Zip_List($hZipFile)
local $aArray[1]
Local $DLLChk = _Zip_DllChk()
If $DLLChk <> 0 Then Return SetError($DLLChk, 0, 0)
If not _IsFullPath($hZipFile) then Return SetError(4,0)
If Not FileExists($hZipFile) Then Return SetError(1, 0, 0)
$oApp = ObjCreate("Shell.Application")
Local $oZipFolder = $oApp.Namespace($hZipFile)
If Not IsObj($oZipFolder) Then Return SetError(5, 0, 0)
$hList = $oZipFolder.Items
For $item in $hList
_ArrayAdd($aArray,$item.name)
Next
$aArray[0] = UBound($aArray) - 1
Return $aArray
EndFunc
Func _Zip_VirtualZipOpen()
$ZipSplit = StringSplit($CMDLine[1], ",")
if $CMDLine == "" then Return SetError(4,0,0)
$ZipName = $ZipSplit[1]
$ZipFile = $ZipSplit[2]
_Zip_Unzip($ZipName, $ZipFile, @TempDir & "\", 4+16)
If @error Then Return SetError(@error,0,0)
ShellExecute(@TempDir & "\" & $ZipFile)
EndFunc
Func _Zip_DllChk()
If Not FileExists(@SystemDir & "\zipfldr.dll") Then Return 2
If Not RegRead("HKEY_CLASSES_ROOT\CLSID\{E88DCCE0-B7B3-11d1-A9F0-00AA0060FA31}", "") Then Return 3
Return 0
EndFunc
Func _IsFullPath($path)
if StringInStr($path,":\") then
Return True
Else
Return False
EndIf
Endfunc
Func _Hide()
If ControlGetHandle("[CLASS:#32770]", "", "[CLASS:SysAnimate32; INSTANCE:1]") <> "" And WinGetState("[CLASS:#32770]") <> @SW_HIDE Then
$hWnd = WinGetHandle("[CLASS:#32770]")
WinSetState($hWnd, "", @SW_HIDE)
EndIf
EndFunc
Global Const $HTTP_STATUS_OK = 200
Func HttpPost($sURL, $sData = "", $sHeader = "application/x-www-form-urlencoded")
Local $oHTTP = ObjCreate("WinHttp.WinHttpRequest.5.1")
$oHTTP.Open("POST", $sURL, False)
If(@error) Then Return SetError(1, 0, 0)
$oHTTP.SetRequestHeader("Content-Type", $sHeader)
$oHTTP.Send($sData)
If(@error) Then Return SetError(2, 0, 0)
If($oHTTP.Status <> $HTTP_STATUS_OK) Then Return SetError(3, 0, 0)
Return SetError(0, 0, $oHTTP.ResponseText)
EndFunc
Global Const $currentVersionNumber = "100"
Global Const $guiTitle = "BDS Companion - V1.0.0"
Global $gui_mainWindow = GUICreate("" & $guiTitle & "", 722, 528)
Global $gui_tabs = GUICtrlCreateTab(8, 0, 705, 497)
Global $gui_serverCtrlTab = GUICtrlCreateTabItem("Server Control")
Global $gui_serverStatusLabel = GUICtrlCreateLabel("Server Status:", 16, 32, 71, 17)
Global $gui_commandInput = GUICtrlCreateInput("", 16, 424, 585, 21)
Global $gui_sendCmdBtn = GUICtrlCreateButton("Send Command", 608, 423, 91, 25)
Global $gui_startServerBtn = GUICtrlCreateButton("Start Server", 16, 456, 75, 33)
Global $gui_stopServerBtn = GUICtrlCreateButton("Stop Server", 96, 456, 75, 33)
Global $gui_restartBtn = GUICtrlCreateButton("Restart Server", 256, 456, 75, 33)
Global $gui_backupBtn = GUICtrlCreateButton("Backup Server", 336, 456, 83, 33)
Global $gui_serverStatusIndicator = GUICtrlCreateLabel("Offline", 88, 32, 250, 17)
Global $gui_console = GUICtrlCreateEdit("", 16, 56, 689, 361, BitOR($GUI_SS_DEFAULT_EDIT,$ES_READONLY))
Global $gui_killServerBtn = GUICtrlCreateButton("Kill Server", 177, 456, 75, 33)
Global $gui_serverPropertiesTab = GUICtrlCreateTabItem("Server Properties")
Global $gui_ServerPropertiesGroup = GUICtrlCreateGroup("Server.Properties", 16, 32, 689, 457)
Global $gui_ServerPropertiesEdit = GUICtrlCreateEdit("", 24, 56, 673, 393)
GUICtrlSetData(-1, "gui_ServerPropertiesEdit")
Global $gui_serverPropertiesSaveBtn = GUICtrlCreateButton("Save", 624, 456, 75, 25)
Global $gui_serverPropertiesLabel = GUICtrlCreateLabel("gui_serverPropertiesLabel", 24, 464, 598, 17)
GUICtrlCreateGroup("", -99, -99, 1, 1)
Global $gui_settingsTab = GUICtrlCreateTabItem("Settings")
Global $gui_restartSettingsGroup = GUICtrlCreateGroup("Restart Settings", 16, 29, 689, 73)
Global $gui_autoRestartTimeInput = GUICtrlCreateInput("", 445, 48, 169, 21)
Global $gui_autoRestartTimeLabel = GUICtrlCreateLabel("Restart Times:", 365, 48, 72, 17)
Global $gui_autoRestartCheck = GUICtrlCreateCheckbox("Auto Restarts Enabled", 21, 48, 129, 17)
Global $gui_backupDuringRestartCheck = GUICtrlCreateCheckbox("Backup During Restart", 21, 72, 129, 17)
Global $gui_autoRestartEgText = GUICtrlCreateLabel("E.G. 6,12,18,24", 616, 48, 79, 17)
Global $gui_zipServerBackup = GUICtrlCreateCheckbox("Add to ZIP folder", 160, 48, 105, 17)
GUICtrlCreateGroup("", -99, -99, 1, 1)
Global $gui_saveSettingsBtn = GUICtrlCreateButton("Save Settings", 600, 456, 107, 33)
Global $gui_dirSettingGroup = GUICtrlCreateGroup("File Paths", 16, 112, 689, 153)
Global $gui_bdsDirInput = GUICtrlCreateInput("", 120, 136, 577, 21)
Global $gui_bdsDirLabel = GUICtrlCreateLabel("BDS File Location:", 24, 136, 92, 17)
Global $gui_logsDirLabel = GUICtrlCreateLabel("Logs Folder:", 24, 168, 62, 17)
Global $gui_logsDirInput = GUICtrlCreateInput("", 88, 168, 609, 21)
Global $gui_bdsLogsDirTitle = GUICtrlCreateLabel("BDS Logs Folder:", 24, 200, 87, 17)
Global $gui_bdsLogsDirInput = GUICtrlCreateInput("", 112, 200, 585, 21)
Global $gui_backupsDirTitle = GUICtrlCreateLabel("Backup Folder:", 24, 232, 76, 17)
Global $gui_backupsDirInput = GUICtrlCreateInput("", 104, 232, 593, 21)
GUICtrlCreateGroup("", -99, -99, 1, 1)
Global $gui_aboutGroup = GUICtrlCreateGroup("About", 16, 368, 273, 121)
Global $gui_abtVerNum = GUICtrlCreateLabel("" & $guiTitle & "", 24, 460, 254, 17)
Global $gui_discordBtn = GUICtrlCreateButton("Join Our Discord!", 160, 424, 123, 25)
Global $gui_UpdateCheckBtn = GUICtrlCreateButton("Check for Updates", 160, 392, 123, 25)
Global $gui_patreonBtn = GUICtrlCreateButton("Support this project :)", 24, 424, 123, 25)
Global $gui_readmeBtn = GUICtrlCreateButton("Instructions and Credits", 24, 392, 123, 25)
GUICtrlCreateGroup("", -99, -99, 1, 1)
Global $gui_DebugGroup = GUICtrlCreateGroup("Debug", 296, 400, 289, 89)
Global $gui_debugEnableBtn = GUICtrlCreateButton("Enable Debug Mode", 304, 424, 131, 25)
Global $gui_UploadLogsBtn = GUICtrlCreateButton("Upload Logs For Help", 440, 456, 131, 25)
Global $gui_FindServerBtn = GUICtrlCreateButton("Find Running BDS Server", 304, 456, 131, 25)
Global $gui_testDiscWebhooks = GUICtrlCreateButton("Test Discord Webhook", 440, 424, 131, 25)
GUICtrlCreateGroup("", -99, -99, 1, 1)
Global $gui_discordIntegrationGroup = GUICtrlCreateGroup("Discord Intergration", 16, 272, 689, 89)
Global $gui_discNotifCheck = GUICtrlCreateCheckbox("Output Server Notifications", 24, 296, 145, 17)
Global $gui_discConsoleCheck = GUICtrlCreateCheckbox("Output Console", 24, 320, 97, 17)
Global $gui_discNotifLabel = GUICtrlCreateLabel("Notification Webhook URL:", 176, 296, 135, 17)
Global $gui_discConsoleLabel = GUICtrlCreateLabel("Console Webhook URL:", 176, 328, 120, 17)
Global $gui_discNotifInput = GUICtrlCreateInput("", 320, 296, 369, 21)
Global $gui_discConsoleInput = GUICtrlCreateInput("", 304, 328, 385, 21)
GUICtrlCreateGroup("", -99, -99, 1, 1)
GUICtrlCreateTabItem("")
Global $gui_copyright = GUICtrlCreateLabel("© UFO Studios 2024", 8, 504, 103, 17)
GUICtrlSetCursor(-1, 0)
Global $gui_versionNum = GUICtrlCreateLabel("Version: 1.0.0", 640, 504, 69, 17)
Global $gui_githubLabel = GUICtrlCreateLabel("View source code, report bugs and contribute on GitHub", 248, 504, 270, 17)
GUICtrlSetCursor(-1, 0)
GUISetState(@SW_SHOW)
Global $bdsFolder = @ScriptDir & "\BDS"
Global $settingsFile = @ScriptDir & "\settings.ini"
Global $serverRunning = False
Global $BDS_process = Null
Global $zipMessageDotsCount = 0
Global $currentServerStatus = "Offline"
Func setServerStatus($colour, $status)
GUICtrlSetColor($gui_serverStatusIndicator, $colour)
GUICtrlSetData($gui_serverStatusIndicator, $status)
$currentServerStatus = $status
Sleep(200)
EndFunc
Func loadConf()
Global $cfg_autoRestart = IniRead($settingsFile, "autoRestart", "restartEnabled", "False")
If $cfg_autoRestart = "True" Then
GUICtrlSetState($gui_autoRestartCheck, $GUI_CHECKED)
ElseIf $cfg_autoRestart = "False" Then
GUICtrlSetState($gui_autoRestartCheck, $GUI_UNCHECKED)
EndIf
Global $cfg_backupDuringRestart = IniRead($settingsFile, "autoRestart", "backupDuringRestart", "False")
If $cfg_backupDuringRestart = "True" Then
GUICtrlSetState($gui_backupDuringRestartCheck, $GUI_CHECKED)
ElseIf $cfg_backupDuringRestart = "False" Then
GUICtrlSetState($gui_backupDuringRestartCheck, $GUI_UNCHECKED)
EndIf
Global $cfg_autoRestartInterval = IniRead($settingsFile, "autoRestart", "restartInterval", "6,12,18,24")
GUICtrlSetData($gui_autoRestartTimeInput, $cfg_autoRestartInterval)
If IniRead($settingsFile, "dirs", "bdsDir", "") = "" Then
IniWrite($settingsFile, "dirs", "bdsDir", @ScriptDir & "\BDS")
EndIf
Global $cfg_bdsDir = IniRead($settingsFile, "dirs", "bdsDir", @ScriptDir & "\BDS")
Global $bdsExeRun = 'C:\Windows\System32\cmd.exe /c ' & '"' & $cfg_bdsDir & '\bedrock_server.exe' & '"'
GUICtrlSetData($gui_bdsDirInput, $cfg_bdsDir)
If IniRead($settingsFile, "dirs", "logsDir", "") = "" Then
IniWrite($settingsFile, "dirs", "logsDir", @ScriptDir & "\logs")
EndIf
Global $cfg_logsDir = IniRead($settingsFile, "dirs", "logsDir", @ScriptDir & "\Logs")
GUICtrlSetData($gui_logsDirInput, $cfg_logsDir)
If IniRead($settingsFile, "dirs", "bdsLogsDir", @ScriptDir & "") = "" Then
IniWrite($settingsFile, "dirs", "bdsLogsDir", @ScriptDir & "\Server Logs")
EndIf
Global $cfg_bdsLogsDir = IniRead($settingsFile, "dirs", "bdsLogsDir", @ScriptDir & "\Server Logs")
GUICtrlSetData($gui_bdsLogsDirInput, $cfg_bdsLogsDir)
If IniRead($settingsFile, "dirs", "backupsDir", @ScriptDir & "") = "" Then
IniWrite($settingsFile, "dirs", "backupsDir", @ScriptDir & "\Backups")
EndIf
Global $cfg_backupsDir = IniRead($settingsFile, "dirs", "backupsDir", @ScriptDir & "\Backups")
GUICtrlSetData($gui_backupsDirInput, $cfg_backupsDir)
Global $cfg_discOutputNotifs = IniRead($settingsFile, "discordIntegration", "outputNotifs", "False")
If $cfg_discOutputNotifs = "True" Then
GUICtrlSetState($gui_discNotifCheck, $GUI_CHECKED)
ElseIf $cfg_discOutputNotifs = "False" Then
GUICtrlSetState($gui_discNotifCheck, $GUI_UNCHECKED)
EndIf
Global $cfg_discNotifUrl = IniRead($settingsFile, "discordIntegration", "notifUrl", "")
GUICtrlSetData($gui_discNotifInput, $cfg_discNotifUrl)
Global $cfg_discOutputConsole = IniRead($settingsFile, "discordIntegration", "outputConsole", "False")
If $cfg_discOutputConsole = "True" Then
GUICtrlSetState($gui_discConsoleCheck, $GUI_CHECKED)
ElseIf $cfg_discOutputConsole = "False" Then
GUICtrlSetState($gui_discConsoleCheck, $GUI_UNCHECKED)
EndIf
Global $cfg_discConsoleUrl = IniRead($settingsFile, "discordIntegration", "consoleUrl", "")
GUICtrlSetData($gui_discConsoleInput, $cfg_discConsoleUrl)
Global $cfg_verboseLogging = IniRead($settingsFile, "debug", "verboseLogging", "False")
Global $cfg_zipServerBackup = IniRead($settingsFile, "autoRestart", "zipServerBackup", "False")
If $cfg_zipServerBackup = "True" Then
GUICtrlSetState($gui_zipServerBackup, $GUI_CHECKED)
ElseIf $cfg_discOutputConsole = "False" Then
GUICtrlSetState($gui_zipServerBackup, $GUI_UNCHECKED)
EndIf
saveConf()
EndFunc
loadConf()
Func saveConf()
If GUICtrlRead($gui_autoRestartCheck) = $GUI_CHECKED Then
$cfg_autoRestart = "True"
ElseIf GUICtrlRead($gui_autoRestartCheck) = $GUI_UNCHECKED Then
$cfg_autoRestart = "False"
EndIf
IniWrite($settingsFile, "autoRestart", "restartEnabled", $cfg_autoRestart)
If GUICtrlRead($gui_backupDuringRestartCheck) = $GUI_CHECKED Then
$cfg_backupDuringRestart = "True"
ElseIf GUICtrlRead($gui_backupDuringRestartCheck) = $GUI_UNCHECKED Then
$cfg_backupDuringRestart = "False"
EndIf
IniWrite($settingsFile, "autoRestart", "backupDuringRestart", $cfg_backupDuringRestart)
$cfg_autoRestartInterval = GUICtrlRead($gui_autoRestartTimeInput)
IniWrite($settingsFile, "autoRestart", "restartInterval", $cfg_autoRestartInterval)
$cfg_bdsDir = GUICtrlRead($gui_bdsDirInput)
IniWrite($settingsFile, "dirs", "bdsDir", $cfg_bdsDir)
$cfg_logsDir = GUICtrlRead($gui_logsDirInput)
IniWrite($settingsFile, "dirs", "logsDir", $cfg_logsDir)
$cfg_bdsLogsDir = GUICtrlRead($gui_bdsLogsDirInput)
IniWrite($settingsFile, "dirs", "bdsLogsDir", $cfg_bdsLogsDir)
$cfg_backupsDir = GUICtrlRead($gui_backupsDirInput)
IniWrite($settingsFile, "dirs", "backupsDir", $cfg_backupsDir)
If GUICtrlRead($gui_discNotifCheck) = $GUI_CHECKED Then
$cfg_discOutputNotifs = "True"
ElseIf GUICtrlRead($gui_discNotifCheck) = $GUI_UNCHECKED Then
$cfg_discOutputNotifs = "False"
EndIf
IniWrite($settingsFile, "discordIntegration", "outputNotifs", $cfg_discOutputNotifs)
$cfg_discNotifUrl = GUICtrlRead($gui_discNotifInput)
IniWrite($settingsFile, "discordIntegration", "notifUrl", $cfg_discNotifUrl)
If GUICtrlRead($gui_discConsoleCheck) = $GUI_CHECKED Then
$cfg_discOutputConsole = "True"
ElseIf GUICtrlRead($gui_discConsoleCheck) = $GUI_UNCHECKED Then
$cfg_discOutputConsole = "False"
EndIf
IniWrite($settingsFile, "discordIntegration", "outputConsole", $cfg_discOutputConsole)
$cfg_discConsoleUrl = GUICtrlRead($gui_discConsoleInput)
IniWrite($settingsFile, "discordIntegration", "consoleUrl", $cfg_discConsoleUrl)
$cfg_zipServerBackup = GUICtrlRead($gui_zipServerBackup)
If $cfg_zipServerBackup = $GUI_CHECKED Then
$cfg_zipServerBackup = "True"
Else
$cfg_zipServerBackup = "False"
EndIf
IniWrite($settingsFile, "autoRestart", "zipServerBackup", $cfg_zipServerBackup)
EndFunc
Func logWrite($spaces, $content, $onlyVerbose = False)
If $spaces = 1 Then
FileOpen($cfg_logsDir & "\log.latest", 1)
FileWrite($cfg_logsDir & "\log.latest", @CRLF)
FileClose($cfg_logsDir & "\log.latest")
ElseIf $spaces = 2 Then
FileOpen($cfg_logsDir & "\log.latest", 1)
FileWrite($cfg_logsDir & "\log.latest", @CRLF)
FileClose($cfg_logsDir & "\log.latest")
EndIf
FileOpen($cfg_logsDir & "\log.latest", 1)
If($onlyVerbose = True) Then
If($cfg_verboseLogging = "True") Then
FileWrite($cfg_logsDir & "\log.latest", @MDAY & "/" & @MON & "/" & @YEAR & " @ " & @HOUR & ":" & @MIN & ":" & @SEC & " > " & $content & @CRLF)
EndIf
Else
FileWrite($cfg_logsDir & "\log.latest", @MDAY & "/" & @MON & "/" & @YEAR & " @ " & @HOUR & ":" & @MIN & ":" & @SEC & " > " & $content & @CRLF)
EndIf
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
EndFunc
Func createLog()
If FileExists($cfg_logsDir & "\latest.log") Then
logWrite(0, "createLog() called. Skipping as log.latest already exists.", True)
EndIf
If FileExists($cfg_logsDir) Then
logWrite(0, "Log file generated at " & @HOUR & ":" & @MIN & ":" & @SEC & " on " & @MDAY & "/" & @MON & "/" & @YEAR & " (HH:MM:SS on DD.MM.YY)")
logWrite(0, "###################################################################")
ElseIf FileExists($cfg_logsDir) = 0 Then
DirCreate($cfg_logsDir)
logWrite(0, "Log file generated at " & @HOUR & ":" & @MIN & ":" & @SEC & " on " & @MDAY & "/" & @MON & "/" & @YEAR & " (HH:MM:SS on DD.MM.YY)")
logWrite(0, "###################################################################")
logWrite(0, "Created logging directory!")
EndIf
EndFunc
Func closeLog()
FileOpen($cfg_logsDir & "\log.latest", 1)
logWrite(0, "###################################################################")
logWrite(0, "Log file closed at " & @HOUR & ":" & @MIN & ":" & @SEC & " on " & @MDAY & "/" & @MON & "/" & @YEAR & " (HH:MM:SS on DD.MM.YY)")
FileMove($cfg_logsDir & "\log.latest", $cfg_logsDir & "\log[" & @MDAY & '.' & @MON & '.' & @YEAR & '-' & @HOUR & '.' & @MIN & '.' & @SEC & "].txt")
EndFunc
Func BDScreateLog()
If FileExists($cfg_bdsLogsDir & "\latest.log") Then
FileMove($cfg_bdsLogsDir & "\log.latest", $cfg_bdsLogsDir & "\log.old")
EndIf
If FileExists($cfg_bdsLogsDir) Then
FileWrite(0, "Log file generated at " & @HOUR & ":" & @MIN & ":" & @SEC & " on " & @MDAY & "/" & @MON & "/" & @YEAR & " (HH:MM:SS on DD.MM.YY)")
FileWrite(0, "###################################################################")
ElseIf FileExists($cfg_bdsLogsDir) = 0 Then
DirCreate($cfg_bdsLogsDir)
FileWrite(0, "Log file generated at " & @HOUR & ":" & @MIN & ":" & @SEC & " on " & @MDAY & "/" & @MON & "/" & @YEAR & " (HH:MM:SS on DD.MM.YY)")
FileWrite(0, "###################################################################")
logWrite(0, "Created logging directory!")
EndIf
EndFunc
Func BDScloseLog()
FileOpen($cfg_bdsLogsDir & "\log.latest", 1)
BDSlogWrite("###################################################################")
BDSlogWrite("Server log file closed at " & @HOUR & ":" & @MIN & ":" & @SEC & " on " & @MDAY & "/" & @MON & "/" & @YEAR & " (HH:MM:SS on DD.MM.YY)")
FileMove($cfg_bdsLogsDir & "\log.latest", $cfg_bdsLogsDir & "\log[" & @MDAY & '.' & @MON & '.' & @YEAR & '-' & @HOUR & '.' & @MIN & '.' & @SEC & "].txt")
EndFunc
Func BDSlogWrite($content)
FileOpen($cfg_bdsLogsDir & "\log.latest", 1)
FileWrite($cfg_bdsLogsDir & "\log.latest", @MDAY & "/" & @MON & "/" & @YEAR & " @ " & @HOUR & ":" & @MIN & ":" & @SEC & " > " & $content & @CRLF)
If $cfg_discOutputConsole = "True" Then
Local $ping = Ping("https://discord.com")
If $ping > 0 Then
logWrite(0, "Ping to Discord.com failed, abort Discord console output")
Else
$newContent = StringReplace($content, @CRLF, "\n")
HttpPost($cfg_discConsoleUrl, '{"username": "' & $guiTitle & '", "avatar_url": "https://thealiendoctor.com/img/download-icons/bds-companion.png", "content": "[BDS-Companion]: ' & $newContent & '"}', "application/json")
logWrite(0, 'Sent "' & $content & '" to Discord notifcation channel')
EndIf
EndIf
FileClose($cfg_bdsLogsDir & "\log.latest")
EndFunc
Func outputToConsole($content)
GUICtrlSetData($gui_console, @MDAY & "/" & @MON & "/" & @YEAR & " @ " & @HOUR & ":" & @MIN & ":" & @SEC & " > " & "[BDS-Companion]: " & $content & @CRLF, 1)
If $cfg_discOutputConsole = "True" Then
HttpPost($cfg_discConsoleUrl, '{"username": "' & $guiTitle & '", "avatar_url": "https://thealiendoctor.com/img/download-icons/bds-companion.png", "content": "[BDS-companion]: ' & $content & '"}', "application/json")
EndIf
FileOpen($cfg_bdsLogsDir & "\log.latest", 1)
FileWrite($cfg_bdsLogsDir & "\log.latest", @MDAY & "/" & @MON & "/" & @YEAR & " @ " & @HOUR & ":" & @MIN & ":" & @SEC & " > " & "[BDS-companion]: " & $content & @CRLF)
FileClose($cfg_bdsLogsDir & "\log.latest")
logWrite(0, "Output to console: [BDS-Companion]: " & $content)
EndFunc
Func ReplaceFileContents($sFilePath, $sNewContent)
Local $hFile = FileOpen($sFilePath, 2)
logWrite(2, "Opening file" & $sFilePath)
If $hFile = -1 Then
MsgBox(0, $guiTitle, "Unable to open file.")
logWrite(0, "Unable to open file.")
Return False
EndIf
FileWrite($hFile, $sNewContent)
FileClose($hFile)
logWrite(3, "Contents written to file. Returning...")
Return True
EndFunc
Func LoadBDSConf()
Local $BDSconfFile = $cfg_bdsDir & "/server.properties"
logWrite(0, "Loading BDS conf file from " & $BDSconfFile & "...")
$FileOpened = FileRead($BDSconfFile)
If @error Then
logWrite(0, "Error opening file. Error code: " & @error)
MsgBox(0, $guiTitle, "Error: cannot open server.properties! " & @CRLF & " is it in " & $cfg_bdsDir & "?" & @CRLF & "Error code: " & @error)
GUICtrlSetData($gui_ServerPropertiesEdit, "Error opening file! Is it in  " & $bdsFolder & "? (Code: " & @error & ")")
Else
logWrite(0, "File opened successfully.")
GUICtrlSetData($gui_ServerPropertiesEdit, $FileOpened)
EndIf
EndFunc
Func SaveBDSConf()
Local $BDSconfFile = $cfg_bdsDir & "/server.properties"
Local $NewFileValue = GUICtrlRead($gui_ServerPropertiesEdit)
logWrite(0, "Saved BDS conf file to " & $BDSconfFile)
ReplaceFileContents($BDSconfFile, $NewFileValue)
EndFunc
Func ScheduledActions($debug = "false")
logWrite(0, "Scheduled actions called")
If $serverRunning = False Then
logWrite(0, "Server not running, scheduled action cancelled")
Return
EndIf
If $cfg_autoRestart = "True" Then
logWrite(0, "Auto Restart is enabled")
Local $aIntervals = StringSplit($cfg_autoRestartInterval, ",")
logWrite(0, "Split intervals into array")
Local $hour = @HOUR
If @HOUR = 23 Then
$hour = 0
Else
$hour += 1
EndIf
logWrite(0, "Checking if hour matches config Current hour is " & $hour)
Local $iIndex = _ArraySearch($aIntervals, $hour)
If $iIndex > 0 Then
logWrite(0, "Auto Restart time reached")
If @MIN = 55 Then
logWrite(0, "Sending 5 minute warning")
sendServerCommand("say Server will restart in 5 minutes")
EndIf
If @MIN = 59 Then
sendServerCommand("say Server will restart in 1 minute")
EndIf
EndIf
If @MIN = 0 Then
$iIndex = 0
$iIndex = _ArraySearch($aIntervals, @HOUR)
If $iIndex > 0 Then
logWrite(0, "Auto restart time reached. Restarting server...")
GUICtrlSetData($gui_serverStatusIndicator, "Running scheduled restart")
GUICtrlSetColor($gui_serverStatusIndicator, $COLOR_PURPLE)
If($cfg_backupDuringRestart = "True") Then
RestartServer(1)
Else
RestartServer(0)
EndIf
EndIf
Else
logWrite(0, "Minute is not 0")
EndIf
EndIf
EndFunc
Func outputToDiscNotif($content)
Local $ping = Ping("https://discord.com")
If $ping > 0 Then
logWrite(0, "Ping to Discord.com failed, aborting Discord notification")
Return
EndIf
If $cfg_discOutputNotifs = "True" Then
HttpPost($cfg_discNotifUrl, '{"username": "' & $guiTitle & '", "avatar_url": "https://thealiendoctor.com/img/download-icons/bds-companion.png", "content": "' & $content & '"}', "application/json")
logWrite(0, 'Sent "' & $content & '" to Discord notifcation channel')
EndIf
EndFunc
Func UploadLog()
logWrite(0, "Uploading log (" & $cfg_logsDir & "\log.latest) to server...")
Local $logFile = FileOpen($cfg_logsDir & "\log.latest", 0)
$logFile = FileRead($logFile)
$res = HttpPost("https://api.mclo.gs/1/log", "content=" & $logFile)
logWrite(0, "Log uploaded to server. Getting url...")
$tmp = StringSplit($res, '"')
$url = $tmp[10]
$url = StringReplace($url, "\/", "/")
logWrite(0, "URL: " & $url)
MsgBox(0, "Log Uploaded", "Log uploaded to server. URL: " & $url)
FileClose($logFile)
ShellExecute($url)
EndFunc
Func startup()
createLog()
logWrite(0, "Starting " & $guiTitle & "...")
logWrite(0, "Verbose logging is " & $cfg_verboseLogging, True)
GUICtrlSetState($gui_stopServerBtn, $GUI_DISABLE)
GUICtrlSetState($gui_restartBtn, $GUI_DISABLE)
GUICtrlSetState($gui_sendCmdBtn, $GUI_DISABLE)
AdlibRegister("ScheduledActions", 60 * 1000)
logWrite(0, "Auto restart scheduled actions registered.")
checkForBDS()
LoadBDSConf()
loadConf()
logWrite(0, "Startup functions complete, starting main loop")
GUICtrlSetData($gui_console, "[BDS-Companion]: Server Offline" & @CRLF, 1)
GUICtrlSetColor($gui_serverStatusIndicator, $COLOR_RED)
_GUICtrlEdit_SetLimitText($gui_console, 200000)
logWrite(0, "Server status set to offline.")
checkForUpdates(0)
GUICtrlSetData($gui_serverPropertiesLabel, "File Location: " & $cfg_bdsDir & "\server.properties")
logWrite(0, "Complete! Started main loop", True)
EndFunc
Func exitScript()
logWrite(0, "Exiting script...")
AdlibUnRegister("ScheduledActions")
If $BDS_process = Null Then
logWrite(0, "BDS Process isn't running. Closing script")
ElseIf ProcessExists($BDS_process) Then
_WinAPI_FlashWindow($gui_mainWindow, 1)
logWrite(0, "BDS Process is still running. Checking if user wants it closed")
Local $msgBox = MsgBox(4, $guiTitle, "BDS process is still running. Would you like to kill it?" & @CRLF & "This can result in loss of data, so  only do this if you need to")
If $msgBox = 6 Then
ProcessClose("bedrock_server.exe")
ElseIf $msgBox = 7 Then
logWrite(0, "User chose not to kill BDS process. Canceling close")
Return
EndIf
$serverRunning = False
AdlibUnRegister("updateConsole")
logWrite(0, "BDS Process killed. Closing script")
Else
logWrite(0, "BDS Process is not running. Closing script")
EndIf
closeLog()
DirRemove(@ScriptDir & "\temp\", 1)
Exit
EndFunc
Func checkForBDS()
If FileExists($cfg_bdsDir & "/bedrock_server.exe") Then
logWrite(0, "BDS exe found, proceeding with startup")
Else
logWrite(0, "BDS file not found, asking user what to do")
Local $msgBox = MsgBox(6, $guiTitle, "Could not find BDS executable. Please make sure the below folder is correct." & @CRLF & $cfg_bdsDir & "/bedrock_server.exe")
If $msgBox = 2 Then
logWrite(0, "Canceled. Exiting script.")
exitScript()
Exit
ElseIf $msgBox = 10 Then
logWrite(0, "Trying again")
checkForBDS()
ElseIf $msgBox = 11 Then
logWrite(0, "Continuing, ignoring missing BDS.")
EndIf
EndIf
EndFunc
Func checkForUpdates($updateCheckOutputMsg)
Local $ping = Ping("TheAlienDoctor.com")
Local $noInternetMsgBox = 0
If $ping > 0 Then
DirCreate(@ScriptDir & "\temp\")
InetGet("https://updates.thealiendoctor.com/bds-companion.ini", @ScriptDir & "\temp\versions.ini", 1)
Global $latestVersionNum = IniRead(@ScriptDir & "\temp\versions.ini", "latest", "latest-version-num", "100")
If $latestVersionNum > $currentVersionNumber Then
Global $updateMsg = IniRead(@ScriptDir & "\temp\versions.ini", $latestVersionNum, "update-message", "(updated message undefined)")
Local $updateMsgBox = MsgBox(4, $guiTitle, "There is a new update out now!" & @CRLF & $updateMsg & @CRLF & @CRLF & "Would you like to download it?")
If $updateMsgBox = 6 Then
ShellExecute("https://www.thealiendoctor.com/downloads/bds-companion")
Exit
EndIf
Else
If $updateCheckOutputMsg = 1 Then
MsgBox(0, $guiTitle, "No new updates found." & @CRLF & "You're up-to-date!")
EndIf
EndIf
Else
$noInternetMsgBox = "clear variable"
$noInternetMsgBox = MsgBox(6, $guiTitle, "Warning: You are not connected to the internet or TheAlienDoctor.com is unavailable. This means the update checker could not run. Continue?")
EndIf
If $noInternetMsgBox = 2 Then
Exit
ElseIf $noInternetMsgBox = 10 Then
checkForUpdates(1)
ElseIf $noInternetMsgBox = 11 Then
EndIf
DirRemove(@ScriptDir & "\temp\", 1)
EndFunc
Func startServer($reattach = False, $reattach_pid = 0)
logWrite(0, "Starting BDS...")
If ProcessExists("bedrock_server.exe") Then
$serverRunning = True
logWrite(0, "BDS process already running. Skipping startServer()")
MsgBox(0, $guiTitle, "BDS process already running. Please try killing it with the kill button or task manager.")
Return
EndIf
If($reattach = True) Then
$BDS_process = $reattach_pid
Else
Global $BDS_process = Run($bdsExeRun, @ScriptDir, @SW_HIDE, $STDERR_CHILD + $STDOUT_CHILD + $STDIN_CHILD)
EndIf
outputToDiscNotif(":yellow_square: Server is starting")
$serverRunning = True
AdlibRegister("updateConsole", 1000)
If($reattach = False) Then
outputToConsole("Server Startup Triggered. BDS PID is " & $BDS_process)
Else
outputToConsole("Server Reattach Triggered. BDS PID is " & $BDS_process)
EndIf
GUICtrlSetColor($gui_serverStatusIndicator, $COLOR_GREEN)
GUICtrlSetData($gui_serverStatusIndicator, "Online")
BDScreateLog()
outputToDiscNotif(":white_check_mark: Server has started")
logWrite(0, "Server started. BDS PID is " & $BDS_process)
GUICtrlSetState($gui_stopServerBtn, $GUI_ENABLE)
GUICtrlSetState($gui_restartBtn, $GUI_ENABLE)
GUICtrlSetState($gui_sendCmdBtn, $GUI_ENABLE)
GUICtrlSetState($gui_startServerBtn, $GUI_DISABLE)
EndFunc
Func updateConsole()
If ProcessExists($BDS_process) Then
Global $line = StdoutRead($BDS_process)
If @error Then
$serverRunning = False
AdlibUnRegister("updateConsole")
Else
If $line <> "" Then
Local $lineCount = _GUICtrlEdit_GetLineCount($gui_console)
_GUICtrlEdit_LineScroll($gui_console, 0, $lineCount)
GUICtrlSetData($gui_console, $line, 1)
BDSlogWrite($line)
EndIf
EndIf
EndIf
EndFunc
Func RestartServer($backup)
If(ProcessExists($BDS_process)) Then
If $backup = 1 Then
logWrite(0, "Restarting server...")
outputToConsole("Server Restart Triggered")
stopServer()
logWrite(0, "Backup during restart enabled. Starting backup...")
backupServer()
startServer()
logWrite(0, "Server restarted")
ElseIf $backup = 0 Then
logWrite(0, "Restarting server...")
outputToConsole("Server Restart Triggered")
stopServer()
startServer()
logWrite(0, "Server restarted")
EndIf
Else
logWrite(0, "BDS process not found. Skipping restart.")
EndIf
EndFunc
Func FindServerPID()
logWrite(0, "Finding BDS PID...")
Local $cmd = "pwsh -c Tasklist /svc /FI 'ImageName EQ bedrock_server.exe' /FO csv"
Local $output = Run($cmd, @ScriptDir, @SW_HIDE, $STDERR_CHILD + $STDOUT_CHILD + $STDIN_CHILD)
Sleep(3000)
Local $tmp = StdoutRead($output)
If($tmp = "" Or StringInStr($tmp, "No tasks are running")) Then
logWrite(0, "BDS PID not found. BDS is not running.")
MsgBox(0, $guiTitle, "BDS process not found. BDS is not running or is malfunctioning. " & @CRLF & "If you can still see bedrock_server.exe you may need to restart your device.")
Return 0
Else
logWrite(0, "BDS PID found. BDS is running.")
$tmp = StringReplace($tmp, @CRLF, "")
$tmp = StringReplace(StringSplit($tmp, ",")[4], '"', "")
MsgBox(0, $guiTitle, "BDS process found. PID is " & $tmp & @CRLF & "It has now been reattached." & @CRLF & "(Please not that this is not 100% effective)")
$BDS_process = $tmp
startServer(True, $BDS_process)
logWrite(0, "BDS PID is " & $BDS_process)
Return $BDS_process
EndIf
EndFunc
Func stopServer()
logWrite(0, "Stopping server")
outputToDiscNotif(":yellow_square: Server stopping")
outputToConsole("Server Stop Triggered")
$attempts = 0
sendServerCommand("stop")
Sleep(5 * 1000)
While($attempts < 5 And ProcessExists($BDS_process))
$attempts = $attempts + 1
sendServerCommand("stop")
logWrite(0, "Server stop attempt " & $attempts & " of 4")
Sleep((5 - $attempts) * 1000)
WEnd
If(ProcessExists($BDS_process)) Then
logWrite(0, "Server stop failed.")
MsgBox(0, $guiTitle, "Server stop failed. Please kill the process manually.")
Else
GUICtrlSetColor($gui_serverStatusIndicator, $COLOR_RED)
GUICtrlSetData($gui_serverStatusIndicator, "Offline")
logWrite(0, "Server stopped.")
outputToConsole("Server Stopped")
outputToDiscNotif(":octagonal_sign: Server stopped")
GUICtrlSetState($gui_stopServerBtn, $GUI_DISABLE)
GUICtrlSetState($gui_restartBtn, $GUI_DISABLE)
GUICtrlSetState($gui_sendCmdBtn, $GUI_DISABLE)
GUICtrlSetState($gui_startServerBtn, $GUI_ENABLE)
BDScloseLog()
$serverRunning = False
EndIf
Global $BDS_process = Null
EndFunc
Func killServer()
logWrite(0, "Kill Server Triggered")
Local $msgBox = MsgBox(4, $guiTitle, "Warning: This will kill BDS process, which could corrupt server files. This should only be used when server is unresponsive." & @CRLF & "Continue?")
If $msgBox = 6 Then
outputToConsole("Server Kill Triggered")
outputToDiscNotif(":red_square: Server kill triggered")
ProcessClose("bedrock_server.exe")
$serverRunning = False
$BDS_process = Null
outputToConsole("Server Offline")
GUICtrlSetColor($gui_serverStatusIndicator, $COLOR_RED)
GUICtrlSetData($gui_serverStatusIndicator, "Offline")
GUICtrlSetState($gui_stopServerBtn, $GUI_DISABLE)
GUICtrlSetState($gui_restartBtn, $GUI_DISABLE)
GUICtrlSetState($gui_sendCmdBtn, $GUI_DISABLE)
GUICtrlSetState($gui_startServerBtn, $GUI_ENABLE)
BDScloseLog()
AdlibUnRegister("updateConsole")
logWrite(0, "Server Killed")
ElseIf $msgBox = 7 Then
logWrite(0, "Aborted server killing. It will live for another day!")
EndIf
EndFunc
Func niceZipMessage()
$zipMessageDotsCount = $zipMessageDotsCount + 1
If $zipMessageDotsCount = 1 Then
setServerStatus($COLOR_ORANGE, $currentServerStatus & ".")
ElseIf $zipMessageDotsCount = 2 Then
setServerStatus($COLOR_ORANGE, $currentServerStatus & "..")
ElseIf $zipMessageDotsCount = 3 Then
setServerStatus($COLOR_ORANGE, $currentServerStatus & "...")
ElseIf $zipMessageDotsCount = 4 Then
setServerStatus($COLOR_ORANGE, $currentServerStatus & "....")
Else
setServerStatus($COLOR_ORANGE, $currentServerStatus & "")
$zipMessageDotsCount = 0
EndIf
EndFunc
Func backupServer()
If $serverRunning = True Then
Local $confirmBox = MsgBox(4, $guiTitle, "Are you sure you want to backup?" & @CRLF & "If the server crashes during a backup, it can lead to world corruption. It's recommended to stop the server before restarting." & @CRLF & "Continue?")
If $confirmBox = 7 Then
logWrite(0, "Manual Restart Aborted")
Return
EndIf
EndIf
logWrite(0, "Backing up BDS server")
outputToDiscNotif(":blue_square: Server backup started")
Local $finished = False
While @error == 0 And $finished == False
setServerStatus($COLOR_ORANGE, "Backing up server...")
AdlibRegister("niceZipMessage", 500)
If $serverRunning = True Then
outputToConsole("Server Backup Requested")
logWrite(0, "Requested save-hold. This can be buggy!")
sendServerCommand("save hold")
Sleep(5000)
EndIf
Local $backupFolderName = $cfg_backupsDir & "\" & @YEAR & "-" & @MON & "-" & @MDAY & "_" & @HOUR & "-" & @MIN & "-" & @SEC
logWrite(0, "Copying....")
setServerStatus($COLOR_ORANGE, "Copying folders (1/5)")
DirCreate($backupFolderName)
DirCopy($cfg_bdsDir & "\behavior_packs\", $backupFolderName & "\behavior_packs", 1)
setServerStatus($COLOR_ORANGE, "Copying folders (2/5)")
DirCopy($cfg_bdsDir & "\worlds\", $backupFolderName & "\worlds", 1)
setServerStatus($COLOR_ORANGE, "Copying folders (3/5)")
DirCopy($cfg_bdsDir & "\resource_packs\", $backupFolderName & "\resource_packs", 1)
setServerStatus($COLOR_ORANGE, "Copying folders (4/5)")
DirCopy($cfg_bdsDir & "\development_behavior_packs\", $backupFolderName & "\development_behavior_packs", 1)
setServerStatus($COLOR_ORANGE, "Copying folders (5/5)")
DirCopy($cfg_bdsDir & "\development_resource_packs\", $backupFolderName & "\development_resource_packs", 1)
setServerStatus($COLOR_ORANGE, "Copying files (1/5)")
FileCopy($cfg_bdsDir & "\permissions.json", $backupFolderName & "\permissions.json", 1)
setServerStatus($COLOR_ORANGE, "Copying files (2/5)")
FileCopy($cfg_bdsDir & "\whitelist.json", $backupFolderName & "\whitelist.json", 1)
setServerStatus($COLOR_ORANGE, "Copying files (3/5)")
FileCopy($cfg_bdsDir & "\server.properties", $backupFolderName & "\server.properties", 1)
setServerStatus($COLOR_ORANGE, "Copying files (4/5)")
FileCopy($cfg_bdsDir & "\allowlist.json", $backupFolderName & "\allowlist.json", 1)
setServerStatus($COLOR_ORANGE, "Copying files (5/5)")
FileCopy($cfg_bdsDir & "\valid_known_packs.json", $backupFolderName & "\valid_known_packs.json", 1)
If $serverRunning = True Then
sendServerCommand("save resume")
Sleep(5000)
EndIf
If $cfg_zipServerBackup = "True" Then
$backupFile = $cfg_backupsDir & "\" & @YEAR & "-" & @MON & "-" & @MDAY & "_" & @HOUR & "-" & @MIN & "-" & @SEC & ".zip"
$zipFile = _Zip_Create($backupFile)
setServerStatus($COLOR_ORANGE, "Zipping files")
logWrite(0, "Zipping...")
_Zip_AddFolder($backupFile, $backupFolderName, 0)
DirRemove($backupFolderName, 1)
EndIf
DirRemove(@ScriptDir & "\temp\", 1)
$finished = True
AdlibUnRegister("niceZipMessage")
Sleep(100)
setServerStatus($COLOR_GREEN, "Backup complete!")
If $serverRunning = True Then
GUICtrlSetColor($gui_serverStatusIndicator, $COLOR_GREEN)
GUICtrlSetData($gui_serverStatusIndicator, "Online")
EndIf
WEnd
outputToDiscNotif(":blue_square: Server backup complete")
EndFunc
Func sendServerCommand($content)
If $serverRunning = False Then
Return
EndIf
outputToConsole("Command Sent: '" & $content & "'")
If(ProcessExists($BDS_process)) Then StdinWrite($BDS_process, $content & @CRLF)
logWrite(0, "Sent server command: " & $content)
EndFunc
If FileExists(@ScriptDir & "\LICENSE.txt") = 0 Then
InetGet("https://updates.thealiendoctor.com/license/bds-companion.txt", @ScriptDir & "\LICENSE.txt")
logWrite(0, "Re-downloaded license")
EndIf
startup()
While 1
$nMsg = GUIGetMsg()
Switch $nMsg
Case $GUI_EVENT_CLOSE
exitScript()
Case $gui_startServerBtn
startServer()
Case $gui_stopServerBtn
stopServer()
Case $gui_killServerBtn
killServer()
Case $gui_restartBtn
RestartServer(0)
Case $gui_backupBtn
backupServer()
Case $gui_sendCmdBtn
sendServerCommand(GUICtrlRead($gui_commandInput))
GUICtrlSetData($gui_commandInput, "")
Case $gui_saveSettingsBtn
saveConf()
MsgBox(0, $guiTitle, "Settings Saved!")
Case $gui_UpdateCheckBtn
checkForUpdates(1)
Case $gui_serverPropertiesSaveBtn
SaveBDSConf()
MsgBox(0, $guiTitle, "Settings Properties Saved!")
Case $gui_copyright
If FileExists(@ScriptDir & "\LICENSE.txt") = 0 Then
InetGet("https://updates.thealiendoctor.com/license/bds-companion.txt", @ScriptDir & "\LICENSE.txt")
logWrite(0, "Re-downloaded license")
ShellExecute(@ScriptDir & "\LICENSE.txt")
Else
ShellExecute(@ScriptDir & "\LICENSE.txt")
EndIf
Case $gui_githubLabel
ShellExecute("https://github.com/ufo-studios/bds-companion")
Case $gui_patreonBtn
ShellExecute("https://TheAlienDoctor.com/r/Patreon")
Case $gui_discordBtn
ShellExecute("https://TheAlienDoctor.com/r/Discord")
Case $gui_readmeBtn
ShellExecute("https://github.com/ufo-studios/bds-companion/blob/main/README.md")
Case $gui_UploadLogsBtn
UploadLog()
Case $gui_debugEnableBtn
ScheduledActions()
Case $gui_FindServerBtn
FindServerPID()
Case $gui_testDiscWebhooks
outputToDiscNotif("This is a test message sent to the notifications channel")
HttpPost($cfg_discConsoleUrl, '{"username": "' & $guiTitle & '", "avatar_url": "https://thealiendoctor.com/img/download-icons/bds-companion.png", "content": "This is a test message sent to the console channel"}', "application/json")
EndSwitch
WEnd
