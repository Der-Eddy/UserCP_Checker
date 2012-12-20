#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <File.au3>
#include <Crypt.au3>
#Include <String.au3>

HotKeySet("{ESC}", "_Exit")
HotKeySet("{ENTER}", "_Crypt")

$file = @ScriptDir & "\UserCP Checker.exe"
$password = "0cb2a1bd939faeb6ebb028e7356668e1"
$staerke = "2"

Global $szDrive, $szDir, $szFName, $szExt

$iFile = FileOpen($file, 16)
$filename = _PathSplit($file, $szDrive, $szDir, $szFName, $szExt)
$date = FileGetTime($file, 1)
$date2 = FileGetTime($file, 0)
$md5 = _Crypt_HashFile($file, $CALG_MD5)
$md5 = StringReplace($md5, "0x", "")
$sha1 = _Crypt_HashFile($file, $CALG_SHA1)
$sha1 = StringReplace($sha1, "0x", "")
$size = Round((FileGetSize($file) / 1024))  & " Kilobyte"
$size2 = Round((FileGetSize($file) / 1048576), 2) & " Megabyte"
FileClose($File)

Opt("GUIOnEventMode", 1)

$Form1 = GUICreate("UserCP Developter Tool", 449, 195)
GUISetOnEvent($GUI_EVENT_CLOSE, "_Exit")
GUICtrlCreateTab(8, 8, 435, 180)
GUICtrlCreateTabItem("File Info")
$Label1 = GUICtrlCreateLabel("Dateiname:", 16, 40, 58, 17)
$Input1 = GUICtrlCreateInput($filename[3] & $filename[4], 112, 37, 321, 21, $ES_READONLY)
$Label2 = GUICtrlCreateLabel("Erstellt am:", 16, 64, 55, 17)
$Input2 = GUICtrlCreateInput($date[3] & ":" & $date[4] & ":" & $date[5] & "  " & $date[2] & "." & $date[1] & "." & $date[0], 112, 61, 321, 21, $ES_READONLY)
$Label2 = GUICtrlCreateLabel("Verändert am:", 16, 88, 55, 17)
$Input2 = GUICtrlCreateInput($date2[3] & ":" & $date2[4] & ":" & $date2[5] & "  " & $date2[2] & "." & $date2[1] & "." & $date2[0], 112, 85, 321, 21, $ES_READONLY)
$Label2 = GUICtrlCreateLabel("md5 hash:", 16, 112, 55, 17)
$Input2 = GUICtrlCreateInput(StringLower($md5), 112, 109, 321, 21, $ES_READONLY)
$Label2 = GUICtrlCreateLabel("sha1 hash:", 16, 136, 55, 17)
$Input2 = GUICtrlCreateInput(StringLower($sha1), 112, 133, 321, 21, $ES_READONLY)
$Label2 = GUICtrlCreateLabel("Größe:", 16, 160, 55, 17)
$Input2 = GUICtrlCreateInput($size2 & " | " & $size, 112, 157, 321, 21, $ES_READONLY)

GUICtrlCreateTabItem("Crypter")
$Label3 = GUICtrlCreateLabel("Link:", 16, 40, 58, 17)
$Input3 = GUICtrlCreateInput("", 112, 37, 321, 21)
$Label4 = GUICtrlCreateLabel("Crypt:", 16, 64, 58, 17)
$Input4 = GUICtrlCreateInput("", 112, 61, 321, 21)
GUICtrlCreateButton("De-/EnCrypt", 50, 110, 100)
GUICtrlSetOnEvent(-1, "_Crypt")
GUICtrlCreateButton("Copy", 300, 110, 100)
GUICtrlSetOnEvent(-1, "_Clip")
GUISetState(@SW_SHOW)

While 1
	Sleep(100)
WEnd

Func _Crypt()
	If GUICtrlRead($Input3) = "" and GUICtrlRead($Input4) = "" Then
		MsgBox(64, "Fehler", "Beide Inputs sind leer!")
	Else
		If GUICtrlRead($Input4) = "" Then
			If StringInStr(GUICtrlRead($Input3), ".exe") Then
				GUICtrlSetData($Input4, _StringEncrypt(1, GUICtrlRead($Input3), $password, $staerke))
			Else
				$spaceInput3 = BinaryToString(InetRead(GUICtrlRead($Input3), 1))
				$spaceInput3 = StringRegExp($spaceInput3, 'kNO = "(.*?)";', 1)
				GUICtrlSetData($Input4, _StringEncrypt(1, $spaceInput3[0], $password, $staerke))
				GUICtrlSetData($Input3, $spaceInput3[0])
			EndIf
		EndIf
		If GUICtrlRead($Input3) = "" Then
			$spaceInput4 = StringReplace(GUICtrlRead($Input4), " ", "")
			If StringInStr(_StringEncrypt(0, $spaceInput4, $password, $staerke), ".exe") Then
			GUICtrlSetData($Input3, _StringEncrypt(0, $spaceInput4, $password, $staerke))
			Else
				$spaceInput4 = BinaryToString(InetRead(_StringEncrypt(0, $spaceInput4, $password, $staerke), 1))
				$spaceInput4 = StringRegExp($spaceInput4, 'kNO = "(.*?)";', 1)
				GUICtrlSetData($Input3, $spaceInput4[0])
			EndIf
		EndIf
	EndIf
EndFunc

Func _Clip()
	ClipPut(GUICtrlRead($Input4))
EndFunc

Func _Exit()
	Exit
EndFunc