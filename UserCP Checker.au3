#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=.\epvp.ico
#AutoIt3Wrapper_Compression=4
#AutoIt3Wrapper_UseUpx=n
#AutoIt3Wrapper_Res_Description=UserCP Checker for Elitepvpers
#AutoIt3Wrapper_Res_Fileversion=2.3.1.0
#AutoIt3Wrapper_Res_LegalCopyright=by Der-Eddy
#AutoIt3Wrapper_Res_Language=1031
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <GUIConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#Include <String.au3>
#Include <Array.au3>
#Include <Crypt.au3>
#include <GDIPlus.au3>
#Include <GuiButton.au3>
#Include <File.au3>
#include "Include\_Growl.au3" ; Danke an 0xcafebabe von autoitscript.com
#include "Include\GetHWID.au3" ; Danke an KillerDeluxe
#include "Include\WebTcp.au3" ; Danke an AMrK von autoitbot.de
#include "Include\Misc.au3" ; Gescnittene Version von Misc.au3

#region Log GUI
$log = "Starte Tool ..."
$GUIlog = GUICreate("Log", 300, 120, -1, -1, $WS_DLGFRAME)
$labellog = GUICtrlCreateEdit($log, 10, 10, 278, 78, BitOR($ES_READONLY, $ES_NOHIDESEL))
GUISetState(@SW_SHOW)
#endregion

; Hotkeys
;HotKeySet("{ESC}", "_Exit")
Local $dll32 = DllOpen("user32.dll")
AdlibRegister("_hotkey", 250)

; Variablen
Global $epvp1, $epvp1_, $epvp_1, $epvp2, $epvp2_, $epvp_2, $epvp3, $epvp3_, $epvp_3, $epvp4, $epvp4_, $epvp_4, $epvp44, $epvp5, $epvp5_, $epvp_5, $epvp55, $epvp6, $epvp_6, $epvp66, $epvp_7, $epvp_77, $epvp_8, $epvp_88, $epvp_9, $epvp_99
Global $GUI1, $GUI1_, $Input1, $Input1_, $Input2, $Input2_, $Checkbox1, $Checkbox1_, $Form1, $Form2, $Label1, $Label2, $Labelsafe, $Button1, $Button2, $Form3, $Labeli, $Labela, $Update, $GUI2, $noti, $forum, $about, $settings, $topic, $combo, $combo2
Global $bID, $bPW, $PWs, $source, $Benutzer, $pass, $sUsername, $sUserpassMD5, $oHTTP, $Source_n, $pic, $Pic, $hBmp, $image, $name, $group, $password, $t, $t2, $oWebTCP, $bLoggedIn, $name, $hwid, $i, $skip, $version2, $down, $growlid, $rungrowl, $gstring, $notification
Global $a1[2], $a2[2], $a3[2], $a3[2], $a4[2], $a5[2], $a6[2], $a7[2], $a8[2], $a9[2], $a10[2], $a11[2], $a12[2], $a13[2], $a14[2], $a15[2], $a16[2], $a17[2], $a18[2]
Global $dUrl, $dText, $dPath, $downgui, $prozentold, $Prozent, $dProgress, $ddownload, $LabelProzent, $Labelspeed, $Labelcopy, $timer, $size
Global $Tray, $Trayb, $Traye, $Trayf, $Trayi, $Trayt, $Trayu
Global $notifications[1][1] = [["Notifcation"]]
Global $soundfiles[10], $sounds[1]
Global $skip[19], $prem2[1], $long2[1]
Global $version = "2.3.1"
Global $prem = "XIII"
Global $long = "XXV"
Global $uDebug = False ; Bei True wird gefragt ob man die neueste Version runterladen möchte
Global Const $STM_SETIMAGE = 0x0172
Global Const $_hwid = _GetHWID()
Global Const $passwort = _StringReverse(_GetHWID())
Global Const $passwort2 = "0cb2a1bd939faeb6ebb028e7356668e1"
Global Const $starke = "2"
Global Const $temp = @AppDataDir & "\UserCP\"
Global Const $sound = @AppDataDir & "\UserCP\Sounds\"
Global Const $file = @AppDataDir & "\UserCP\data.ini"
Global Const $dataid = @AppDataDir & "\UserCP\IDs.ini"

; Modes
Opt("GUIOnEventMode", 1)
Opt("MustDeclareVars", 1)
Opt("TrayMenuMode",3)
Opt("TrayOnEventMode",1)
Opt("GUICloseOnESC",1)
Opt("GUIEventOptions",1)

; Installiert alles in ein Temporäres Verzeichnis
$log = "Installiere Inhalt in tmp Verzeichnis ..." & @CRLF & $log
GUICtrlSetData($labellog, $log)
DirCreate($temp)
FileInstall(".\epvp.png", $temp & "epvp.png")
FileInstall(".\IDs.ini", $dataid)
FileInstall(".\epvp.ico", $temp & "epvp.ico")
DirCreate($sound)
FileInstall(".\Sounds\Beep 1.wav", $sound & "Beep 1.wav")
FileInstall(".\Sounds\Beep 2.wav", $sound & "Beep 2.wav")
FileInstall(".\Sounds\Blop.wav", $sound & "Blop.wav")
FileInstall(".\Sounds\Button.wav", $sound & "Button.wav")

; Traymenü
$Tray = TrayCreateItem("Benachrichtungen")
TrayItemSetOnEvent(-1,"Tray")
$Trayt = TrayCreateItem("Themen")
TrayItemSetOnEvent(-1,"Trayt")
$Trayf = TrayCreateItem("Foren")
TrayItemSetOnEvent(-1,"Trayf")
$Traye = TrayCreateItem("Einstellungen")
TrayItemSetOnEvent(-1,"Traye")
$Trayi = TrayCreateItem("Info")
TrayItemSetOnEvent(-1,"Trayi")
TrayCreateItem("")
$Trayu = TrayCreateItem("Keine Überprüfung ...")
TrayCreateItem("")
$Trayb = TrayCreateItem("Beenden")
TrayItemSetOnEvent(-1,"_Exit")
TraySetIcon($temp & "epvp.ico")

; WebTCP starten
$log = "Starte TCP Dienst ..." & @CRLF & $log
GUICtrlSetData($labellog, $log)
_WebTcp_Startup()

; Versionscheck
;If FileExists(@ScriptDir & "\Update.exe") Then FileDelete(@ScriptDir & "\Update.exe")
$log = "Suche nach neueren Version ..." & @CRLF & $log
GUICtrlSetData($labellog, $log)
$Source_n = BinaryToString(InetRead("http://www.elitepvpers.com/forum/blogs/984054-der-eddy/8076-usercp-checker.html", 1))
If @error <> 0 Then
	MsgBox(48, "Error", "Es konnte keine Verbindung zu Elitepvpers aufgebaut werden!")
	Exit 1
EndIf
$version2 = StringRegExp($Source_n, "&lt;Version&gt;(.*?)&lt;/Version&gt;", 1)
$down = StringRegExp($Source_n, "-->&lt;Download&gt;(.*?)&lt;/Download&gt;", 1)
$prem2 = StringRegExp($Source_n, "&lt;Prem&gt;(.*?)&lt;/Prem&gt;", 1)
$long2 = StringRegExp($Source_n, "&lt;Long&gt;(.*?)&lt;/Long&gt;", 1)
$prem = $prem2[0]
$long = $long2[0]

If NOT IsArray($down) Then
	MsgBox(64, "Error", "Fehler beim auslesen der neuesten Version" & @CRLF & "Script wird weiter ausgeführt!")
	$version2[0] = $version
	$down[0] = "E74579AB3E45D395BCEC6CCAD2CB5B0DD41C1A25C5452AB57CE70247CCF65A92F156EDE4D6B6126AEFA801424F925015F857F043741A63A6D9E73CBDD1576D20FD136CD836C420D1D3F8CED43034A8FF13785323674B4EF64443DE4BE44BDFFEC02DB4E5"
EndIf
Const $download = _StringEncrypt(0, StringReplace($down[0], "  ", ""), $passwort2, $starke)
If @Compiled = 0 And $version2[0] <> $version Then $version = $version & " Preview"

If $version2[0] <> $version And @Compiled = 1 Or $uDebug = True Then
	$Update = GUICreate("Update", 335, 95, -1, -1, BitOR($WS_MINIMIZEBOX, $WS_SYSMENU))
	GUISetOnEvent($GUI_EVENT_CLOSE, "_Exit")
	GUICtrlCreateLabel("Es gibt ein Update für den UserCP Checker!", 10, 10, 500, 35)
	GUICtrlSetFont(-1, 12)
	GUICtrlCreateButton("Download", 40, 35, 89, 25, $BS_DEFPUSHBUTTON)
	GUICtrlSetOnEvent(-1, "Download")
	GUICtrlCreateButton("Ignorieren", 200, 35, 89, 25)
	GUICtrlSetOnEvent(-1, "Ignore")
	GUISetState(@SW_HIDE, $GUIlog)
	GUISetState(@SW_SHOW, $Update)
	Do
		Sleep (1)
	Until $GUI2 = 1
EndIf

#region GUI1 ; GUI 1
$Form1 = GUICreate("Elitepvpers Zugangsdaten", 246, 170, -1, -1, BitOR($WS_MINIMIZEBOX, $WS_SYSMENU))
GUISetOnEvent($GUI_EVENT_CLOSE, "_Exit")
$Label1 = GUICtrlCreateLabel("Benutzername:", 16, 16, 75, 17)
$Label2 = GUICtrlCreateLabel("Passwort:", 16, 40, 50, 17)
$Input1 = GUICtrlCreateInput("", 96, 13, 137, 21)
$Input2 = GUICtrlCreateInput("", 96, 38, 137, 21, $ES_PASSWORD)
$Labeli = GUICtrlCreateLabel("Deine HWID: (?)", 16, 65, 100, 17)
GUICtrlSetCursor(-1, 4)
GUICtrlSetTip(-1, "Solltest du Premium User oder Moderator sein ist es empfehlenswert die Hardware ID einzutragen" & @LF & 'Einfach auf "Profil bearbeiten" bzw. "Edit Your Details" und ganz nach unten scrollen und dort kannst du sie dann eintragen' & @LF & "Die HWID wird auch zum verschlüsseln deines Passwortes benutzt wenn du es speicherst", "HWID", 1, 1)
$Labela = GUICtrlCreateLabel("Profil bearbeiten", 138, 66, 100, 17)
GUICtrlSetTip(-1, "Ganz unten eintragen")
GUICtrlSetOnEvent(-1, "Profil")
GUICtrlSetFont(-1, 8, 800, 4)
GUICtrlSetColor(-1, 0x0000FF)
GUICtrlSetCursor(-1, 0)
GUICtrlCreateInput($_hwid, 16, 85, 215, 21, BitOR($ES_READONLY, $ES_CENTER))
$Checkbox1 = GUICtrlCreateCheckbox("Passwort speichern?", 16, 113, 129, 17)
GUICtrlSetState(-1, $GUI_CHECKED)
$Button1 = GUICtrlCreateButton("OK", 144, 110, 89, 25, $BS_DEFPUSHBUTTON)
GUICtrlSetOnEvent(-1, "Eintrag")
HotKeySet("{ENTER}", "Eintrag")
GUISetState(@SW_HIDE)
#endregion

If NOT FileExists($file) Then
	$log = "Überprüfe HWID ..." & @CRLF & $log
	GUICtrlSetData($labellog, $log)
	$hwid = BinaryToString(InetRead("http://www.elitepvpers.de/api/hwid.php?hash=" & $_hwid, 1))
	$name = StringRegExp($hwid, '<username>(.*?)</username>', 1)
	$group = StringRegExp($hwid, '<usergroup>(.*?)</usergroup>', 1)
	If $name[0] = "" Then
		MsgBox(48, "Fehler", "HWID ist falsch oder nicht angegeben", 10)
	EndIf
	GUISetState(@SW_HIDE, $GUIlog)
	GUISetState(@SW_SHOW, $Form1)
	GUICtrlSetData($Input1, $name[0])
	Do
		Sleep (1)
	Until $GUI1 = 1
Else
	GUIDelete($Form1)
	$log = "Überprüfe HWID ..." & @CRLF & $log
	GUICtrlSetData($labellog, $log)
	$oHTTP = ObjCreate("winhttp.winhttprequest.5.1")
	$oHTTP.Open("GET","http://www.elitepvpers.de/api/hwid.php?hash=" & IniRead($file, "Benutzerdaten", "HWID", ""))
	$oHTTP.Send()
	$hwid = $oHTTP.Responsetext
	$group = _StringBetween($hwid, "<usergroup>", "</usergroup>")
	IniWrite($file, "Benutzerdaten", "Group", $group[0])
EndIf

If IniRead($file, "Benutzerdaten", "ID", "") = "" Then
	MsgBox(48, "Error", "Einstellungsdatei ist fehlerhaft!" & @CRLF & $file & " wird nun gelöscht und das Tool beendet")
	FileDelete($file)
	Exit 2
EndIf

If IniRead($file, "Benutzerdaten", "PW", "0") = 0 Then
	$password = InputBox("Password Abfrage", "Bitte geben sie Ihr Elitepvpers Passwort ein!", "", "*", Default, 130)
	If @error = 1 Then
		MsgBox(48, "Error", "Sie haben kein Passwort eingegeben!")
		Exit 2
	EndIf
Else
	$password = _StringEncrypt(0, IniRead($file, "Benutzerdaten", "PW", ""), $passwort, $starke)
EndIf

#region GUI2 ; GUI 2
$Form2 = GUICreate("UserCP Checker", 350, 325)
GUISetOnEvent($GUI_EVENT_CLOSE, "_Exit")
GUISetOnEvent($GUI_EVENT_MINIMIZE, "_Tray")
$Button2 = GUICtrlCreateButton("Speichern und starten", 50, 290, 250, 25, $WS_GROUP)
GUICtrlSetOnEvent(-1, "Save")
GUICtrlCreateTab(12, 12, 330, 270)
$noti = GUICtrlCreateTabItem("Benachrichtungen")
$epvp1_ = GUICtrlCreateCheckbox("Neue Private Nachrichten", 25, 40)
$epvp2_ = GUICtrlCreateCheckbox("Neue Profilnachrichten", 25, 65)
$epvp3_ = GUICtrlCreateCheckbox("Neue Freundschaftsanfragen", 25, 90)
$epvp4_ = GUICtrlCreateCheckbox("Einstellungen beim nächsten Start anzeigen", 25, 115)
;GUICtrlSetState(-1, $GUI_DISABLE)
GUICtrlCreateLabel("In einem Intervall von ", 30, 140)
$epvp5_ = GUICtrlCreateInput(IniRead($file, "Benachrichtungen", "Time", "60"), 137, 137, 42)
GUICtrlSetLimit(-1, 3)
GUICtrlCreateUpdown($epvp5_)
GUICtrlSetLimit(-1, 999, 10)
GUICtrlCreateLabel(" sec. suchen", 182, 140)

$topic = GUICtrlCreateTabItem("Themen")
Switch IniRead($file, "Benutzerdaten", "Group", "Level One")
	Case "Moderators", "Global Moderators", "Co-Administrators", "Administrators", "Premium Users"
$epvp1 = GUICtrlCreateCheckbox("Der längste e*pvp [PREMIUM] Thread " & $prem, 25, 40)
$t2 = "65"
	Case Else
$t2 = "40"
EndSwitch
$epvp2 = GUICtrlCreateCheckbox("Der längste e*pvp Thread " & $long, 25, $t2)
$epvp3 = GUICtrlCreateCheckbox("Funny Pics III", 25, $t2 + 25)
$epvp4 = GUICtrlCreateCheckbox(" ", 25, $t2 + 50)
$epvp44 = GUICtrlCreateInput(IniRead($file, "Themen", "Check1", ""), 42, $t2 + 52, 250)
$epvp5 = GUICtrlCreateCheckbox(" ", 25, $t2 + 75)
$epvp55 = GUICtrlCreateInput(IniRead($file, "Themen", "Check2", ""), 42, $t2 + 77, 250)
$epvp6 = GUICtrlCreateCheckbox(" ", 25, $t2 + 100)
$epvp66 = GUICtrlCreateInput(IniRead($file, "Themen", "Check3", ""), 42, $t2 + 102, 250)

$forum = GUICtrlCreateTabItem("Foren")
Switch IniRead($file, "Benutzerdaten", "Group", "Level One")
	Case "Banned Users"
		MsgBox(64, "Banned", "Du bist in Elitepvpers gebannt! Dieses Tool schließt sich automatisch")
		Exit 0
	Case "Moderators", "Global Moderators", "Co-Administrators", "Administrators"
$epvp_1 = GUICtrlCreateCheckbox("Mod. Main", 25, 40)
$epvp_2 = GUICtrlCreateCheckbox("Complaint Area", 25, 65)
$epvp_3 = GUICtrlCreateCheckbox("Premium Main", 25, 90)
$t = "115"
	Case "Premium Users"
$epvp_3 = GUICtrlCreateCheckbox("Premium Main", 25, 40)
$t = "65"
	Case Else
$t = "40"
EndSwitch
$epvp_4 = GUICtrlCreateCheckbox("Main", 25, $t)
$epvp_5 = GUICtrlCreateCheckbox("Minecraft", 25, $t + 25)
$epvp_6 = GUICtrlCreateCheckbox("Terraria", 25, $t + 50)
$epvp_7 = GUICtrlCreateCheckbox(" ", 25, $t + 75)
$epvp_77 = GUICtrlCreateInput(IniRead($file, "Foren", "Check1", ""), 42, $t + 77, 250)
$epvp_8 = GUICtrlCreateCheckbox(" ", 25, $t + 100)
$epvp_88 = GUICtrlCreateInput(IniRead($file, "Foren", "Check2", ""), 42, $t + 102, 250)
$epvp_9 = GUICtrlCreateCheckbox(" ", 25, $t + 125)
$epvp_99 = GUICtrlCreateInput(IniRead($file, "Foren", "Check3", ""), 42, $t + 127, 250)

$settings = GUICtrlCreateTabItem("Einstellungen")
$Label1 = GUICtrlCreateLabel("Benutzername:", 26, 46, 75, 17)
$Label2 = GUICtrlCreateLabel("Passwort:", 26, 70, 50, 17)
$Input1_ = GUICtrlCreateInput("", 106, 43, 137, 21)
$Input2_ = GUICtrlCreateInput("", 106, 68, 137, 21, $ES_PASSWORD)
$Checkbox1_ = GUICtrlCreateCheckbox("Passwort speichern?", 26, 102, 129, 17)
$Labelsafe = GUICtrlCreateLabel("", 200, 430)
GUICtrlCreateButton("Konfigurationsdatei öffnen", 30, 130)
GUICtrlSetOnEvent(-1, "data")
GUICtrlCreateButton("Konfigurationsdatei löschen", 180, 130)
GUICtrlSetOnEvent(-1, "datadelete")
GUICtrlSetTip(-1, "Das Tool muss dafür neu gestartet werden!")
GUICtrlCreateLabel("Pfad: ", 30, 170)
GUICtrlSetCursor(-1, 0)
GUICtrlSetOnEvent(-1, "Path")
GUICtrlCreateInput($temp, 70, 166, 245, -1, $ES_READONLY)
GUICtrlCreateLabel("Sound: ", 30, 198)
$combo = GUICtrlCreateCombo("Keiner", 70, 195, 190)

$sounds = _FileListToArray($sound, "*.wav")
For $i = 1 To $sounds[0]
	$soundfiles = StringRegExp($sounds[$i], "(.*?).wav", 1)
	GUICtrlSetData($combo, $soundfiles[0], IniRead($file, "Benutzerdaten", "Sound", "Keiner"))
Next
GUICtrlCreateButton("Play", 265, 193, 50)
GUICtrlSetOnEvent(-1, "sound")

GUICtrlCreateLabel("Benachrichtigungen über: ", 30, 225)
$combo2 = GUICtrlCreateCombo("Tray", 157, 222, 158)
GUICtrlSetData(-1, "Growl", IniRead($file, "Benutzerdaten", "Notification", "Tray"))

$about = GUICtrlCreateTabItem("Info")
;GUICtrlSetState(-1, $GUI_SHOW)
GUICtrlSetData($labellog, "Initialisiere GDI+ ..." & @CRLF & $log)
$pic = GUICtrlCreatePic("", 20, 35)
_GDIPlus_Startup ()
$image = _GDIPlus_ImageLoadFromFile($temp & "epvp.png")
$hBmp = _GDIPlus_BitmapCreateHBITMAPFromBitmap($image)
GUICtrlSendMsg($Pic, $STM_SETIMAGE, 0, $hBmp)
GUICtrlCreateLabel("UserCP Checker", 125, 55, 200, 200)
GUICtrlSetFont(-1, 20, 500, 0)
GUICtrlCreateLabel("Version: " & $version, 126, 90, 200, 200)
GUICtrlSetFont(-1, 8,5, 500, 0)
GUICtrlSetColor(-1, 0x555555)
GUICtrlCreateLabel("Aktuelle Version: " & $version2[0], 126, 105, 200, 200)
GUICtrlSetFont(-1, 8,5, 500, 0)
GUICtrlSetColor(-1, 0x555555)
GUICtrlCreateLabel("Erstellt von ", 25, 130, 200, 200)
GUICtrlCreateLabel("Der-Eddy", 80, 130, 200, 200)
GUICtrlSetFont(-1, 8,5, 600, 0)
GUICtrlSetColor(-1, 0x008000)
GUICtrlCreateLabel(" mit AutoIt", 125, 130, 200, 200)
GUICtrlCreateLabel("Danke an: ", 25, 145, 200, 200)
GUICtrlCreateLabel("Killerdeluxe", 77, 145, 200, 200)
GUICtrlSetFont(-1, 8,5, 600, 0)
GUICtrlSetColor(-1, 0x008000)
GUICtrlCreateLabel("(HWID UDF)", 133, 145, 200, 200)
GUICtrlCreateLabel("Shadow992", 77, 160, 200, 200)
GUICtrlSetFont(-1, 8,5, 600, 0)
GUICtrlSetColor(-1, 0x008000)
GUICtrlCreateLabel("(TCP Verbindung / Ungenutzt)", 137, 160, 200, 200)
GUICtrlCreateLabel("AMrK", 77, 175, 200, 200)
GUICtrlSetFont(-1, 8,5, 600, 0)
GUICtrlSetColor(-1, 0x3495B4)
GUICtrlCreateLabel("(WebTCP UDF / AutoItBot.de)", 107, 175, 200, 200)
GUICtrlCreateLabel("0xcafebabe (Growl UDF / AutoItscript.com)", 77, 190, 300, 200)
GUICtrlCreateLabel("eukalyptus", 77, 205, 200, 200)
GUICtrlSetFont(-1, 8,5, 600, 0)
GUICtrlSetColor(-1, 0x880011)
GUICtrlCreateLabel("(Another AutoIt PreProcessor / AutoIt.de)", 132, 205, 200, 200)
GUICtrlCreateLabel("Kevin", 77, 220, 200, 200)
GUICtrlSetFont(-1, 8,5, 600, 0)
GUICtrlSetColor(-1, 0x0099FF)
GUICtrlCreateLabel("(Tester)", 107, 220, 200, 200)
GUICtrlCreateLabel("Sunary", 77, 235, 200, 200)
GUICtrlSetFont(-1, 8,5, 600, 0)
GUICtrlSetColor(-1, 0x0099FF)
GUICtrlCreateLabel("(Tester)", 113, 235, 200, 200)
GUICtrlCreateLabel("Corex'", 77, 250, 200, 200)
GUICtrlSetFont(-1, 8,5, 600, 0)
GUICtrlSetColor(-1, 0x008000)
GUICtrlCreateLabel("(Tester)", 108, 250, 200, 200)
GUICtrlCreateLabel("Marcoly (Foren IDs)", 77, 265, 200, 200)

#region Abfragen ; If-Abfragen für das GUI
$log = "Lese Konfigurationen aus ..." & @CRLF & $log
GUICtrlSetData($labellog, $log)
If IniRead($file, "Benachrichtungen", "Epvp1", "4") <> 4 Then
	GUICtrlSetState($epvp1_, $GUI_CHECKED)
EndIf
If IniRead($file, "Benachrichtungen", "Epvp2", "4") <> 4 Then
	GUICtrlSetState($epvp2_, $GUI_CHECKED)
EndIf
If IniRead($file, "Benachrichtungen", "Epvp3", "4") <> 4 Then
	GUICtrlSetState($epvp3_, $GUI_CHECKED)
EndIf
If IniRead($file, "Benachrichtungen", "EoE", "4") <> 4 Then
	GUICtrlSetState($epvp4_, $GUI_CHECKED)
EndIf
If IniRead($file, "Foren", "M. Main", "4") <> 4 Then
	GUICtrlSetState($epvp_1, $GUI_CHECKED)
EndIf
If IniRead($file, "Foren", "CA", "4") <> 4 Then
	GUICtrlSetState($epvp_2, $GUI_CHECKED)
EndIf
If IniRead($file, "Foren", "P. Main", "4") <> 4 Then
	GUICtrlSetState($epvp_3, $GUI_CHECKED)
EndIf
If IniRead($file, "Foren", "Main", "4") <> 4 Then
	GUICtrlSetState($epvp_4, $GUI_CHECKED)
EndIf
If IniRead($file, "Foren", "Minecraft", "4") <> 4 Then
	GUICtrlSetState($epvp_5, $GUI_CHECKED)
EndIf
If IniRead($file, "Foren", "Terraria", "4") <> 4 Then
	GUICtrlSetState($epvp_6, $GUI_CHECKED)
EndIf
If NOT IniRead($file, "Foren", "Check1", "") = "" Then
	GUICtrlSetState($epvp_7, $GUI_CHECKED)
EndIf
If NOT IniRead($file, "Foren", "Check2", "") = "" Then
	GUICtrlSetState($epvp_8, $GUI_CHECKED)
EndIf
If NOT IniRead($file, "Foren", "Check3", "") = "" Then
	GUICtrlSetState($epvp_9, $GUI_CHECKED)
EndIf
If IniRead($file, "Themen", "P. Longest", "4") <> 4 Then
	GUICtrlSetState($epvp1, $GUI_CHECKED)
EndIf
If IniRead($file, "Themen", "Longest", "4") <> 4 Then
	GUICtrlSetState($epvp2, $GUI_CHECKED)
EndIf
If IniRead($file, "Themen", "Funny", "4") <> 4 Then
	GUICtrlSetState($epvp3, $GUI_CHECKED)
EndIf
If NOT IniRead($file, "Themen", "Check1", "") = "" Then
	GUICtrlSetState($epvp4, $GUI_CHECKED)
EndIf
If NOT IniRead($file, "Themen", "Check2", "") = "" Then
	GUICtrlSetState($epvp5, $GUI_CHECKED)
EndIf
If NOT IniRead($file, "Themen", "Check3", "") = "" Then
	GUICtrlSetState($epvp6, $GUI_CHECKED)
EndIf

GUIDelete($GUIlog)

If IniRead($file, "Benachrichtungen", "EoE", "4") = 1 Then
	Ueberpruefung()
Else
	GUISetState(@SW_SHOW)
EndIf
#endregion
#endregion

$Benutzer = IniRead($file, "Benutzerdaten", "ID", "default")

$pass = StringLower(StringTrimLeft(_Crypt_HashData($password, $CALG_MD5), 2))

;Save()

While 1 ; Hauptschleife
	Sleep(100)
WEnd

; Funtionen
Func Tray()
	GUISetState(@SW_SHOW, $GUI2)
	GUISetState(@SW_RESTORE, $GUI2)
	GUICtrlSetState($noti, $GUI_SHOW)
	$image = _GDIPlus_ImageLoadFromFile($temp & "epvp.png")
	$hBmp = _GDIPlus_BitmapCreateHBITMAPFromBitmap($image)
	GUICtrlSendMsg($Pic, $STM_SETIMAGE, 0, $hBmp)
	_while()
EndFunc ;==>Tray

Func Trayt()
	GUISetState(@SW_SHOW, $GUI2)
	GUISetState(@SW_RESTORE, $GUI2)
	GUICtrlSetState($forum, $GUI_SHOW)
	$image = _GDIPlus_ImageLoadFromFile($temp & "epvp.png")
	$hBmp = _GDIPlus_BitmapCreateHBITMAPFromBitmap($image)
	GUICtrlSendMsg($Pic, $STM_SETIMAGE, 0, $hBmp)
	_while()
EndFunc ;==>Trayt

Func Trayf()
	GUISetState(@SW_SHOW, $GUI2)
	GUISetState(@SW_RESTORE, $GUI2)
	GUICtrlSetState($topic, $GUI_SHOW)
	$image = _GDIPlus_ImageLoadFromFile($temp & "epvp.png")
	$hBmp = _GDIPlus_BitmapCreateHBITMAPFromBitmap($image)
	GUICtrlSendMsg($Pic, $STM_SETIMAGE, 0, $hBmp)
	_while()
EndFunc ;==>Trayf

Func Traye()
	GUISetState(@SW_SHOW, $GUI2)
	GUISetState(@SW_RESTORE, $GUI2)
	GUICtrlSetState($settings, $GUI_SHOW)
	$image = _GDIPlus_ImageLoadFromFile($temp & "epvp.png")
	$hBmp = _GDIPlus_BitmapCreateHBITMAPFromBitmap($image)
	GUICtrlSendMsg($Pic, $STM_SETIMAGE, 0, $hBmp)
	_while()
EndFunc ;==>Traye

Func Trayi()
	GUISetState(@SW_SHOW, $GUI2)
	GUISetState(@SW_RESTORE, $GUI2)
	GUICtrlSetState($about, $GUI_SHOW)
	$image = _GDIPlus_ImageLoadFromFile($temp & "epvp.png")
	$hBmp = _GDIPlus_BitmapCreateHBITMAPFromBitmap($image)
	GUICtrlSendMsg($Pic, $STM_SETIMAGE, 0, $hBmp)
	_while()
EndFunc ;==>Trayi

Func _Tray()
	GUISetState(@SW_HIDE)
EndFunc ;==>_Tray

Func Eintrag() ; Speichert Einloggdaten nach erstem Aufrufen
	$bID = GUICtrlRead($Input1)
	$bPW = GUICtrlRead($Input2)
	$PWs = GUICtrlRead($Checkbox1)
	IniWrite($file, "Benutzerdaten", "ID", $bID)
	If $PWs = 1 Then
		IniWrite($file, "Benutzerdaten", "PW", _StringEncrypt(1, $bPW, $passwort, $starke))
	Else
		IniWrite($file, "Benutzerdaten", "PW", 0)
	EndIf
	IniWrite($file, "Benutzerdaten", "HWID", $_hwid)
	IniWrite($file, "Benutzerdaten", "Group", $group[0])
	GUIDelete($Form1)
	GUISetState(@SW_SHOW, $GUIlog)
	HotKeySet("{ENTER}")
	$GUI1 = 1
EndFunc ;==>Eintrag

Func Profil() ; Öffnet Profileinstellungen
	ShellExecute("http://www.elitepvpers.com/forum/profile.php?do=editprofile")
EndFunc ;==>Profil

Func Path() ; Öffnet Pfad für die temporären Daten
	ShellExecute($temp)
EndFunc ;==>Patch

Func Download() ; Öffnet  Link für den Download einer neuen Version
	GUIDelete()
	_download($download, $temp & "\UserCP Checker.exe", "Downloade UserCP Checker ...")
	FileInstall(".\Update\Update.exe", @ScriptDir & "\Update.exe")
	Run(@ScriptDir & "\Update.exe")
	Exit 2
EndFunc ;==>Download

Func Ignore() ; Ignoriert neue Version
	GUIDelete($Update)
	GUISetState(@SW_SHOW, $GUIlog)
	$GUI2 = 1
EndFunc ;==>Ignore

Func data() ; Öffnet Einstellungsdatei
	MsgBox(64, "Erweiterte Einstellungen", "Diese Datei bitte nur ändern wenn man wirklich Ahnung davon hat!", 10)
	Run("notepad.exe " & $file)
EndFunc ;==>date

Func datadelete() ; Löscht Einstellungsdatei
	FileDelete($file)
	Exit
EndFunc ;==>datedelete

Func sound() ; Spielt ausgewählten Sound ab
	If GUICtrlRead($combo) <> "Keiner" Then SoundPlay($sound & GUICtrlRead($combo) & ".wav", 0)
EndFunc ;==>sound

Func _while()
	While 1
		Sleep (1000)
	WEnd
EndFunc ;==>_while

Func Save() ; Speichert alle Änderungen
	IniWrite($file, "Benachrichtungen", "Epvp1", GUICtrlRead($epvp1_))
	IniWrite($file, "Benachrichtungen", "Epvp2", GUICtrlRead($epvp2_))
	IniWrite($file, "Benachrichtungen", "Epvp3", GUICtrlRead($epvp3_))
	IniWrite($file, "Benachrichtungen", "EoE", GUICtrlRead($epvp4_))
	IniWrite($file, "Benachrichtungen", "Time", GUICtrlRead($epvp5_))
	IniWrite($file, "Foren", "M. Main", GUICtrlRead($epvp_1))
	IniWrite($file, "Foren", "CA", GUICtrlRead($epvp_2))
	IniWrite($file, "Foren", "P. Main", GUICtrlRead($epvp_3))
	IniWrite($file, "Foren", "Main", GUICtrlRead($epvp_4))
	IniWrite($file, "Foren", "Minecraft", GUICtrlRead($epvp_5))
	IniWrite($file, "Foren", "Terraria", GUICtrlRead($epvp_6))
	IniWrite($file, "Foren", "Check1", GUICtrlRead($epvp_77))
	IniWrite($file, "Foren", "Check2", GUICtrlRead($epvp_88))
	IniWrite($file, "Foren", "Check3", GUICtrlRead($epvp_99))
	IniWrite($file, "Themen", "P. Longest", GUICtrlRead($epvp1))
	IniWrite($file, "Themen", "Longest", GUICtrlRead($epvp2))
	IniWrite($file, "Themen", "Funny", GUICtrlRead($epvp3))
	IniWrite($file, "Themen", "Check1", GUICtrlRead($epvp44))
	IniWrite($file, "Themen", "Check2", GUICtrlRead($epvp55))
	IniWrite($file, "Themen", "Check3", GUICtrlRead($epvp66))
	If GUICtrlRead($Input2_) <> "" And GUICtrlRead($Input1_) <> "" Then
		IniWrite($file, "Benutzerdaten", "ID", GUICtrlRead($Input1_))
		If GUICtrlRead($Checkbox1_) = 1 Then
			IniWrite($file, "Benutzerdaten", "PW", _StringEncrypt(1, GUICtrlRead($Input2_), $passwort, $starke))
		Else
			IniWrite($file, "Benutzerdaten", "PW", 0)
		EndIf
	EndIf
	IniWrite($file, "Benutzerdaten", "Sound", GUICtrlRead($combo))
	IniWrite($file, "Benutzerdaten", "Notification", GUICtrlRead($combo2))
	If GUICtrlRead($combo2) = "Growl" Then Growl()
	Ueberpruefung()
EndFunc ;==>Save

Func Ueberpruefung()
	GUISetState(@SW_HIDE)
	TrayItemSetText($Trayu, "UserCP wird ausgelesen ...")
	TrayTip("Elitepvpers", "UserCP Checker wurde gestartet!", 10)
	While 1
	$notification = IniRead($file, "Benutzerdaten", "Notification", "Tray")
	$i = GUICtrlRead($epvp5_) * 1000
	$oWebTCP = _WebTcp_Create()
	$oWebTCP.Navigate("http://www.elitepvpers.com/")
	$bLoggedIn = _Login($oWebTCP)
	If $bLoggedIn Then $oWebTCP.Navigate("www.elitepvpers.com/forum/usercp.php?langid=2")
	$source = $oWebTCP.Body
	#cs
	If FileExists($temp & "\UserCP.html") Then
		FileMove($temp & "\UserCP.html", $temp & "\UserCP2.html", 1)
		FileWrite($temp & "\UserCP.html", $source)
		If FileGetSize($temp & "\UserCP.html") = FileGetSize($temp & "\UserCP2.html") Then
			$skip = 1
		Else
			$skip = 0
		EndIf
	Else
		FileWrite($temp & "\UserCP.html", $source)
	EndIf
	#ce
	TrayItemSetText($Trayu, "Überprüfung läuft ...")
	$a1 = StringRegExp($source, '"right"><a href="private.php" style="font-weight:bold">(.*?)</a>', 1)
	If GUICtrlRead($epvp1_) = 1 And IsArray($a1) = 1 And $a1[0] <> $skip[1] Then
		If GUICtrlRead($combo) <> "Keiner" Then SoundPlay($sound & GUICtrlRead($combo) & ".wav", 0)
		Switch $notification
		Case "Tray"
			If $a1[0] = 1 Then
				TrayTip("Elitepvpers", "Du hast 1 neue Private Nachricht erhalten!", 10, 1)
			Else
				TrayTip("Elitepvpers", "Du hast " & $a1[0] & " neue Private Nachrichten erhalten!", 10, 1)
			EndIf
		Case "Growl"
			If $a1[0] = 1 Then
				_GrowlNotify($growlid, $notifications[0][0], "Elitepvpers", "Du hast 1 neue Private Nachricht erhalten!")
			Else
				_GrowlNotify($growlid, $notifications[0][0], "Elitepvpers", "Du hast " & $a1[0] & " neue Private Nachrichten erhalten!")
			EndIf
		EndSwitch
		$skip[1] = $a1[0]
		Sleep (3000)
		$i -= 3000
	EndIf
	$a2 = StringRegExp($source, '#visitor_messaging">Neue Profilnachrichten</a><span class="normal">: ((.*?))</span>', 1)
	If GUICtrlRead($epvp2_) = 1 And IsArray($a2) = 1 And $a2[0] <> $skip[2] Then
		If GUICtrlRead($combo) <> "Keiner" Then SoundPlay($sound & GUICtrlRead($combo) & ".wav", 0)
		Switch $notification
		Case "Tray"
			If $a2[0] = "(1)" Then
				TrayTip("Elitepvpers", "Du hast 1 neue Profil Nachricht erhalten!", 10, 1)
			Else
				TrayTip("Elitepvpers", "Du hast " & $a2[0] & " neue Profil Nachrichten erhalten!", 10, 1)
			EndIf
		Case "Growl"
			If $a2[0] = "(1)" Then
				_GrowlNotify($growlid, $notifications[0][0], "Elitepvpers", "Du hast 1 neue Profil Nachricht erhalten!")
			Else
				_GrowlNotify($growlid, $notifications[0][0], "Elitepvpers", "Du hast " & $a2[0] & " neue Profil Nachrichten erhalten!")
			EndIf
		EndSwitch
		$skip[2] = $a3[0]
		Sleep (3000)
		$i -= 3000
	EndIf
	$a3 = StringRegExp($source, '"right"><a rel="nofollow" href="profile.php?do=buddylist#irc" style="font-weight:bold">(.*?)</a>', 1)
	If GUICtrlRead($epvp3_) = 1 And IsArray($a3) = 1 And $a3[0] <> $skip[3] Then
		If GUICtrlRead($combo) <> "Keiner" Then SoundPlay($sound & GUICtrlRead($combo) & ".wav", 0)
		Switch $notification
		Case "Tray"
			If $a3[0] = 1 Then
				TrayTip("Elitepvpers", "Du hast 1 neue Freundschaftsanfrage erhalten!", 10, 1)
			Else
				TrayTip("Elitepvpers", "Du hast " & $a3[0] & " neue Freundschaftsanfragen erhalten!", 10, 1)
			EndIf
		Case "Growl"
			If $a3[0] = 1 Then
				_GrowlNotify($growlid, $notifications[0][0], "Elitepvpers", "Du hast 1 neue Freundschaftsanfrage erhalten!")
			Else
				_GrowlNotify($growlid, $notifications[0][0], "Elitepvpers", "Du hast " & $a3[0] & " neue Freundschaftsanfragen erhalten!")
			EndIf
		EndSwitch
		$skip[3] = $a3[0]
		Sleep (3000)
		$i -= 3000
	EndIf
	$a4 = StringInStr($source, 'style="font-weight:bold">Der längste e*pvp [PREMIUM] Thread ' & $prem & '</a>', 2)
	If GUICtrlRead($epvp1) = 1 And $a4 <> 0 And $a4 <> $skip[4] Then
		If GUICtrlRead($combo) <> "Keiner" Then SoundPlay($sound & GUICtrlRead($combo) & ".wav", 0)
		Switch $notification
		Case "Tray"
			TrayTip("Elitepvpers", 'Es gibt neue Beiträge in "Der längste e*pvp [PREMIUM] Thread ' & $prem & '"!', 10, 1)
		Case "Growl"
			_GrowlNotify($growlid, $notifications[0][0], "Elitepvpers", Change('Es gibt neue Beiträge in "Der längste e*pvp [PREMIUM] Thread ' & $prem & '"!'))
		EndSwitch
		$skip[4] = $a4
		Sleep (3000)
		$i -= 3000
	EndIf
	$a5 = StringInStr($source, 'style="font-weight:bold">Der längste e*pvp Thread ' & $long & '</a>', 2)
	If GUICtrlRead($epvp2) = 1 And $a5 <> 0 And $a5 <> $skip[5] Then
		If GUICtrlRead($combo) <> "Keiner" Then SoundPlay($sound & GUICtrlRead($combo) & ".wav", 0)
		Switch $notification
		Case "Tray"
			TrayTip("Elitepvpers", 'Es gibt neue Beiträge in "Der längste e*pvp Thread ' & $long & '"!', 10, 1)
		Case "Growl"
			_GrowlNotify($growlid, $notifications[0][0], "Elitepvpers", Change('Es gibt neue Beiträge in "Der längste e*pvp Thread ' & $long & '"!'))
		EndSwitch
		$skip[5] = $a5
		Sleep (3000)
		$i -= 3000
	EndIf
	$a6 = StringInStr($source, 'style="font-weight:bold">Funny Pics III [Read 1st post!]</a>', 2)
	If GUICtrlRead($epvp3) = 1 And $a6 <> 0 And $a6 <> $skip[6] Then
		If GUICtrlRead($combo) <> "Keiner" Then SoundPlay($sound & GUICtrlRead($combo) & ".wav", 0)
		Switch $notification
		Case "Tray"
			TrayTip("Elitepvpers", 'Es gibt neue Beiträge in "Funny Pics III"!', 10, 1)
		Case "Growl"
			_GrowlNotify($growlid, $notifications[0][0], "Elitepvpers", Change('Es gibt neue Beiträge in "Funny Pics"!'))
		EndSwitch
		$skip[6] = $a6
		Sleep (3000)
		$i -= 3000
	EndIf
	$a7 = StringInStr($source, 'style="font-weight:bold">' & GUICtrlRead($epvp44) & '</a>', 2)
	If GUICtrlRead($epvp4) = 1 And $a7 <> 0 And $a7 <> $skip[7] Then
		If GUICtrlRead($combo) <> "Keiner" Then SoundPlay($sound & GUICtrlRead($combo) & ".wav", 0)
		Switch $notification
		Case "Tray"
			TrayTip("Elitepvpers", 'Es gibt neue Beiträge in "' & GUICtrlRead($epvp44) & '"!', 10, 1)
		Case "Growl"
			_GrowlNotify($growlid, $notifications[0][0], "Elitepvpers", Change('Es gibt neue Beiträge in "' & GUICtrlRead($epvp44) & '"!'))
		EndSwitch
		$skip[7] = $a7
		Sleep (3000)
		$i -= 3000
	EndIf
	$a8 = StringInStr($source, 'style="font-weight:bold">' & GUICtrlRead($epvp55) & '</a>', 2)
	If GUICtrlRead($epvp5) = 1 And $a8 <> 0 And $a8 <> $skip[8] Then
		If GUICtrlRead($combo) <> "Keiner" Then SoundPlay($sound & GUICtrlRead($combo) & ".wav", 0)
		Switch $notification
		Case "Tray"
			TrayTip("Elitepvpers", 'Es gibt neue Beiträge in "' & GUICtrlRead($epvp55) & '"!', 10, 1)
		Case "Growl"
			_GrowlNotify($growlid, $notifications[0][0], "Elitepvpers", Change('Es gibt neue Beiträge in "' & GUICtrlRead($epvp55) & '"!'))
		EndSwitch
		$skip[8] = $a8
		Sleep (3000)
		$i -= 3000
	EndIf
	$a9 = StringInStr($source, 'style="font-weight:bold">' & GUICtrlRead($epvp66) & '</a>', 2)
	If GUICtrlRead($epvp6) = 1 And $a9 <> 0 And $a9 <> $skip[9] Then
		If GUICtrlRead($combo) <> "Keiner" Then SoundPlay($sound & GUICtrlRead($combo) & ".wav", 0)
		Switch $notification
		Case "Tray"
			TrayTip("Elitepvpers", 'Es gibt neue Beiträge in "' & GUICtrlRead($epvp66) & '"!', 10, 1)
		Case "Growl"
			_GrowlNotify($growlid, $notifications[0][0], "Elitepvpers", Change('Es gibt neue Beiträge in "' & GUICtrlRead($epvp66) & '"!'))
		EndSwitch
		$skip[9] = $a9
		Sleep (3000)
		$i -= 3000
	EndIf
	$a10 = StringInStr($source, 'src="http://www.elitepvpers.de/forum/images/bullet/statusicon/forum_new.gif" alt="" border="0" id="forum_statusicon_' & IniRead($dataid, "IDs", _StringEncrypt(1, "Mod. Main", $passwort2, 1), "999") & '" />', 2)
	If GUICtrlRead($epvp_1) = 1 And $a10 <> 0 And $a10 <> $skip[10] Then
		If GUICtrlRead($combo) <> "Keiner" Then SoundPlay($sound & GUICtrlRead($combo) & ".wav", 0)
		Switch $notification
		Case "Tray"
			TrayTip("Elitepvpers", 'Es gibt neue Themen in "Moderator Main"!', 10, 1)
		Case "Growl"
			_GrowlNotify($growlid, $notifications[0][0], "Elitepvpers", 'Es gibt neue Themen in "Moderator Main"!')
		EndSwitch
		$skip[10] = $a10
		Sleep (3000)
		$i -= 3000
	EndIf
	$a11 = StringInStr($source, 'src="http://www.elitepvpers.de/forum/images/bullet/statusicon/forum_new.gif" alt="" border="0" id="forum_statusicon_' & IniRead($dataid, "IDs", _StringEncrypt(1, "Complaint Area", $passwort2, 1), "999") & '" />', 2)
	If GUICtrlRead($epvp_2) = 1 And $a11 <> 0 And $a11 <> $skip[11] Then
		If GUICtrlRead($combo) <> "Keiner" Then SoundPlay($sound & GUICtrlRead($combo) & ".wav", 0)
		Switch $notification
		Case "Tray"
			TrayTip("Elitepvpers", 'Es gibt neue Themen in "Complaint Area"!', 10, 1)
		Case "Growl"
			_GrowlNotify($growlid, $notifications[0][0], "Elitepvpers", 'Es gibt neue Themen in "Complaint Area"!')
		EndSwitch
		$skip[11] = $a11
		Sleep (3000)
		$i -= 3000
	EndIf
	$a12 = StringInStr($source, 'src="http://www.elitepvpers.de/forum/images/bullet/statusicon/forum_new.gif" alt="" border="0" id="forum_statusicon_' & IniRead($dataid, "IDs", _StringEncrypt(1, "Premium Main", $passwort2, 1), "999") & '" />', 2)
	If GUICtrlRead($epvp_3) = 1 And $a12 <> 0 And $a12 <> $skip[12] Then
		If GUICtrlRead($combo) <> "Keiner" Then SoundPlay($sound & GUICtrlRead($combo) & ".wav", 0)
		Switch $notification
		Case "Tray"
			TrayTip("Elitepvpers", 'Es gibt neue Themen in "Premium Main"!', 10, 1)
		Case "Growl"
			_GrowlNotify($growlid, $notifications[0][0], "Elitepvpers", 'Es gibt neue Themen in "Premium Main"!')
		EndSwitch
		$skip[12] = $a12
		Sleep (3000)
		$i -= 3000
	EndIf
	$a13 = StringInStr($source, 'src="http://www.elitepvpers.de/forum/images/bullet/statusicon/forum_new.gif" alt="" border="0" id="forum_statusicon_' & IniRead($dataid, "IDs", _StringEncrypt(1, "Main", $passwort2, 1), "999") & '" />', 2)
	If GUICtrlRead($epvp_4) = 1 And $a13 <> 0 And $a13 <> $skip[13] Then
		If GUICtrlRead($combo) <> "Keiner" Then SoundPlay($sound & GUICtrlRead($combo) & ".wav", 0)
		Switch $notification
		Case "Tray"
			TrayTip("Elitepvpers", 'Es gibt neue Themen in "Main"!', 10, 1)
		Case "Growl"
			_GrowlNotify($growlid, $notifications[0][0], "Elitepvpers", 'Es gibt neue Themen in "Main"!')
		EndSwitch
		$skip[13] = $a13
		Sleep (3000)
		$i -= 3000
	EndIf
	$a14 = StringInStr($source, 'src="http://www.elitepvpers.de/forum/images/bullet/statusicon/forum_new.gif" alt="" border="0" id="forum_statusicon_' & IniRead($dataid, "IDs", _StringEncrypt(1, "Minecraft", $passwort2, 1), "999") & '" />', 2)
	If GUICtrlRead($epvp_5) = 1 And $a14 <> 0 And $a14 <> $skip[14] Then
		If GUICtrlRead($combo) <> "Keiner" Then SoundPlay($sound & GUICtrlRead($combo) & ".wav", 0)
		Switch $notification
		Case "Tray"
			TrayTip("Elitepvpers", 'Es gibt neue Themen in "Minecraft"!', 10, 1)
		Case "Growl"
			_GrowlNotify($growlid, $notifications[0][0], "Elitepvpers", 'Es gibt neue Themen in "Minecraft"!')
		EndSwitch
		$skip[14] = $a14
		Sleep (3000)
		$i -= 3000
	EndIf
	$a15 = StringInStr($source, 'src="http://www.elitepvpers.de/forum/images/bullet/statusicon/forum_new.gif" alt="" border="0" id="forum_statusicon_' & IniRead($dataid, "IDs", _StringEncrypt(1, "Terraria", $passwort2, 1), "999") & '" />', 2)
	If GUICtrlRead($epvp_6) = 1 And $a15 <> 0 And $a15 <> $skip[15] Then
		If GUICtrlRead($combo) <> "Keiner" Then SoundPlay($sound & GUICtrlRead($combo) & ".wav", 0)
		Switch $notification
		Case "Tray"
			TrayTip("Elitepvpers", 'Es gibt neue Themen in "Terraria"!', 10, 1)
		Case "Growl"
			_GrowlNotify($growlid, $notifications[0][0], "Elitepvpers", 'Terraria"!')
		EndSwitch
		$skip[15] = $a15
		Sleep (3000)
		$i -= 3000
	EndIf
	$a16 = StringInStr($source, 'src="http://www.elitepvpers.de/forum/images/bullet/statusicon/forum_new.gif" alt="" border="0" id="forum_statusicon_' & IniRead($dataid, "IDs", _StringEncrypt(1, GUICtrlRead($epvp_77), $passwort2, 1), "999") & '" />', 2)
	If GUICtrlRead($epvp_7) = 1 And $a16 <> 0 And $a16 <> $skip[16] Then
		If GUICtrlRead($combo) <> "Keiner" Then SoundPlay($sound & GUICtrlRead($combo) & ".wav", 0)
		Switch $notification
		Case "Tray"
			TrayTip("Elitepvpers", 'Es gibt neue Themen in "' & GUICtrlRead($epvp_77) & '"!', 10, 1)
		Case "Growl"
			_GrowlNotify($growlid, $notifications[0][0], "Elitepvpers", Change('Es gibt neue Themen in "' & GUICtrlRead($epvp_77) & '"!'))
		EndSwitch
		$skip[16] = $a16
		Sleep (3000)
		$i -= 3000
	EndIf
	$a17 = StringInStr($source, 'src="http://www.elitepvpers.de/forum/images/bullet/statusicon/forum_new.gif" alt="" border="0" id="forum_statusicon_' & IniRead($dataid, "IDs", _StringEncrypt(1, GUICtrlRead($epvp_88), $passwort2, 1), "999") & '" />', 2)
	If GUICtrlRead($epvp_8) = 1 And $a17 <> 0 And $a17 <> $skip[17] Then
		If GUICtrlRead($combo) <> "Keiner" Then SoundPlay($sound & GUICtrlRead($combo) & ".wav", 0)
		Switch $notification
		Case "Tray"
			TrayTip("Elitepvpers", 'Es gibt neue Themen in "' & GUICtrlRead($epvp_88) & '"!', 10, 1)
		Case "Growl"
			_GrowlNotify($growlid, $notifications[0][0], "Elitepvpers", Change('Es gibt neue Themen in "' & GUICtrlRead($epvp_88) & '"!'))
		EndSwitch
		$skip[17] = $a17
		Sleep (3000)
		$i -= 3000
	EndIf
	$a18 = StringInStr($source, 'src="http://www.elitepvpers.de/forum/images/bullet/statusicon/forum_new.gif" alt="" border="0" id="forum_statusicon_' & IniRead($dataid, "IDs", _StringEncrypt(1,GUICtrlRead($epvp_99), $passwort2, 1), "999") & '" />', 2)
	If GUICtrlRead($epvp_9) = 1 And $a18 <> 0 And $a18 <> $skip[18] Then
		If GUICtrlRead($combo) <> "Keiner" Then SoundPlay($sound & GUICtrlRead($combo) & ".wav", 0)
		Switch $notification
		Case "Tray"
			TrayTip("Elitepvpers", 'Es gibt neue Themen in "' & GUICtrlRead($epvp_99) & '"!', 10, 1)
		Case "Growl"
			_GrowlNotify($growlid, $notifications[0][0], "Elitepvpers", Change('Es gibt neue Themen in "' & GUICtrlRead($epvp_99) & '"!'))
		EndSwitch
		$skip[18] = $a18
		Sleep (3000)
		$i -= 3000
	EndIf
	;If $i < 0 Then $i = 0
	If $i < 10000 Then $i = 10000
	Sleep ($i)
	WEnd
EndFunc ;==>Ueberpruefung

Func Change($gstring)
	$gstring = StringReplace($gstring, "ä", "ae")
	$gstring = StringReplace($gstring, "Ä", "Ae")
	$gstring = StringReplace($gstring, "ü", "ue")
	$gstring = StringReplace($gstring, "Ü", "Ue")
	$gstring = StringReplace($gstring, "ö", "oe")
	$gstring = StringReplace($gstring, "Ö", "Oe")
	Return $gstring
EndFunc ;==>Change

Func Growl(); Growl starten / registrieren
	If IniRead($file, "Benutzerdaten", "Notification", "Tray") = "Growl" Then
		If NOT ProcessExists("Growl.exe") Then
			$rungrowl = 1
			Run(@ProgramFilesDir & "\Growl for Windows\Growl.exe")
			If @error <> 0 Then
				MsgBox(48, "Error", "Growl ist nicht installiert!")
				IniWrite($file, "Benutzerdaten", "Notification", "Tray")
			EndIf
		EndIf
		Global $growlid=_GrowlRegister("UserCP Checker", $notifications, $temp & "epvp.png")
		ProcessClose("Growl.exe")
		Run(@ProgramFilesDir & "\Growl for Windows\Growl.exe")
		GUISetState(@SW_HIDE, $Form2)
	EndIf
EndFunc ;==>Growl

Func _Login($oWebTCP) ; Danke an AMrK von autoitbot.de
	$oWebTCP.Navigate("http://www.elitepvpers.com/forum/login.php?do=login", "vb_login_username="&$Benutzer&"&vb_login_password=&cookieuser=1&s=&securitytoken=guest&do=login&vb_login_md5password="&$pass&"&vb_login_md5password_utf="&$pass)
	;FileWrite(@ScriptDir & '\login.html', $oWebTCP.Body)
	If StringInStr($oWebTCP.Body, 'vBulletin-Systemmitteilung') Then
		Return False
	Else
		Return True
	EndIf
EndFunc ;==>_Login

Func _download($dUrl, $dPath, $dText = "Download ...")
	$size = InetGetSize($dUrl)
	If $size = 0 Then
		MsgBox(48, "Error", "Ausgewählte Datei existiert nicht oder ist fehlerhaft!")
		Exit 2
	EndIf
	$downgui = GUICreate("Downloading...", 396, 270, 195, 125, $WS_DLGFRAME)
	$dProgress = GUICtrlCreateProgress(16, 32, 362, 25)
	GUICtrlCreateLabel($dText, 16, 8, 265, 20)
	GUICtrlSetFont(-1, 11, 800, 0, "MS Sans Serif")
	$LabelProzent = GUICtrlCreateLabel("%", 16, 60, 268, 17)
	GUICtrlCreateLabel("Download von:", 16, 78, 76, 17)
	GUICtrlCreateLabel($dUrl, 16, 94)
	GUICtrlCreateLabel("Größe:", 16, 118, 36, 17)
	GUICtrlCreateLabel(Round($size / 1000, 2) & ' KiloBytes', 16, 134)
	GUICtrlCreateLabel("Bisher kopiert:", 16, 158, 71, 17)
	$Labelcopy = GUICtrlCreateLabel("", 16, 174, 277, 17)
	GUICtrlCreateLabel("Geschwindigkeit:", 16, 198, 85, 17)
	$Labelspeed = GUICtrlCreateLabel("", 16, 222, 277, 17)
	GUISetState(@SW_SHOW)
	$prozentold = 0
	$ddownload = InetGet($dUrl, $dPath, 0, 1)
	$timer = TimerInit()
	Do
		$Prozent = Round(InetGetInfo($ddownload,0) / $size * 100, 0)
		If $prozentold <> $Prozent Then
			If StringIsAlNum($Prozent) Then
				GUICtrlSetData($LabelProzent, $Prozent & '%')
				GUICtrlSetData($dProgress, $Prozent)
				$prozentold = $Prozent
			EndIf
		EndIf
		GUICtrlSetData($Labelcopy, Round(InetGetInfo($ddownload,0) / 1034, 2) & ' KiloBytes von ' & $size & ' KiloBytes')
		GUICtrlSetData($Labelspeed, Round((InetGetInfo($ddownload,0) / 1024) / (TimerDiff($timer) / 1024), 2) & ' kbytes/sek')
		Sleep (50)
	Until InetGetInfo($ddownload,2) = True
	Return 1
EndFunc ;==>_download

Func _hotkey()
	If _IsPressed("1B", $dll32) and _IsPressed("10", $dll32) Then _Exit() ; 1B = Esc / 10 = Shift
EndFunc ;==>_hoteky

Func _Exit()
	GUIDelete()
	_WinAPI_DeleteObject($hBmp)
	_GDIPlus_ImageDispose($image)
	_GDIPlus_Shutdown()
	_WebTcp_Shutdown()
	DllClose($dll32)
	If $rungrowl = 1 Then ProcessClose("Growl.exe")
	#cs
	Switch IniRead($file, "Benutzerdaten", "Notification", "Tray")
	Case "Growl"
		_GrowlNotify($growlid, $notifications[0][0], "Elitepvpers", "UserCP Checker wurde beendet!")
	Case "Tray"
		TrayTip("Elitepvpers", "UserCP Checker wurde beendet!", 10)
	EndSwitch
	#ce
	TrayTip("Elitepvpers", "UserCP Checker wurde beendet!", 10)
	Sleep (1500)
	Exit 0
EndFunc ;==>_Exit