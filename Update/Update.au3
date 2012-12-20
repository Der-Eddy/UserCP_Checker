#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=..\epvp.ico
#AutoIt3Wrapper_Compression=4
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
If NOT ProcessExists("UserCP Checker.exe") Then
	FileDelete(@ScriptDir & "\UserCP Checker.exe")
	FileMove(@AppDataDir & "\UserCP\UserCP Checker.exe", @ScriptDir & "\UserCP Checker.exe")
	If @error = 1 Then
		TrayTip("Elitepvpers", "Ein Fehler beim updaten ist aufgetreten!", 5, 1)
	Else
		TrayTip("Elitepvpers", "Update erfolgreich installiert!", 5, 1)
	EndIf
	Sleep (3000)
	ShellExecute(@ComSpec, '/c ping 0.0.0.1 -n 1 -w 1000 & del "' & @ScriptFullPath & '"', @ScriptDir, 'open', @SW_HIDE)
EndIf
Exit 1