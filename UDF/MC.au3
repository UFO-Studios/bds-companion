#include <File.au3>

Func _MC_ListFolders($dir)
    Local $FolderArray[]
    Local $hSearch = FileFindFirstFile($dir)
    While 1
        Local $sFile = FileFindNextFile($hSearch)
        If @error Then ExitLoop
    
        ; Check if the file is actually a directory
        If StringInStr(FileGetAttrib($sFile), "D") Then
            _ArrayAdd($FolderArray, FileGetAttrib($sFile))            
        EndIf
    WEnd
    return $FolderArray
EndFunc

;~ Func _MC_ListPacks($PackDir)
;~     Local $FolderArray = _MC_ListFolders($PackDir)
;~     For $i In $FolderArray
        
;~     Next
;WIP