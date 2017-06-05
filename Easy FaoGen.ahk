;Environment
	#singleinstance force ;Script can only be run as one instance. Good for testing.
	SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
	SendMode Input  ; Sets input to be instant.
	;Performance improvements
		#NoEnv ;No environmental variables, speeds up script. Disable if there are problems.
		SetBatchLines -1 ;Runs script as fast as possible, improves speed.
		ListLines Off ;Disables debugger, improves speed.

;Make sure the user drag n dropped a file on to this or it won't work.
	if 0 = 0 ;0 is the variable for if a file is dragged n dropped. The var 0 will be 1 if a file was dropped.
	{
		msgbox,,Doh!,You need to drag & drop a model on to this exe!`n`nExiting..
		exitapp
		}


;INI check
	Ifexist,FaoGenSettings.ini
	{
		fileread,Temp,FaoGenSettings.ini
		ifinstring,Temp,[settings] ;make sure the file actually contains shit we want.
			GoSub,LoadSettings
		Else
			gosub, SetDefaultVariableValues
	}
	Else
		gosub, SetDefaultVariableValues



;GUI
	Gui, Add, Button, x12 y170 w200 h30 gBakeButton, Bake Dat Shit!
	Gui, Add, Text, x12 y10 w60 h20 , Resolution:
	Gui, Add, Edit, x12 y30 w70 h20 vXRes, %XRes%
	Gui, Add, Text, x82 y30 w10 h20 , X
	Gui, Add, Edit, x92 y30 w70 h20 vYRes, %YRes%
	Gui, Add, Text, x12 y60 w70 h20 , Edge Padding
	Gui, Add, Edit, x12 y80 w70 h20 vEdgePadding, %EdgePadding%
	Gui, Add, Text, x12 y110 w70 h20 , Quality
	Gui, Add, Radio, x132 y110 w50 h20 vHighQuality Checked%HighQuality%, High
	Gui, Add, Radio, x82 y110 w50 h20 vLowQuality Checked%LowQuality%, Low
	Gui, Add, CheckBox, x12 y140 w200 h20 vAA Checked%AA%, AA? (can cause problems)
	Gui, Show, h210 w233, Faogen Quick Bake
Return

GuiClose:
gosub,SaveSettings
ExitApp

;Main
	BakeButton:
		gosub,SaveSettings
		if HighQuality
			Quality = 50
		else 
			Quality = 8
		if AA = 1
			msaa = -msaa 8
		Else
			msaa =
		Loop %0%  ; For each parameter (or file dropped onto a script):
		{
		    GivenPath := %A_Index%  ; Fetch the contents of the variable whose name is contained in A_Index.
		    Loop %GivenPath%, 1
		        LongPath = %A_LoopFileLongPath%
		 		  run "C:\Program Files\Faogen 3\faogenbatch.exe" -i "%LongPath%" gamma 1.0 %msaa%-q %Quality% -width %XRes% -height %YRes% -eflood %EdgePadding% 
		}
		return

;Subroutines
	LoadSettings:
		iniread,XRes,FaoGenSettings.ini,Settings,XRes
		iniread,YRes,FaoGenSettings.ini,Settings,YRes
		iniread,EdgePadding,FaoGenSettings.ini,Settings,EdgePadding
		iniread,HighQuality,FaoGenSettings.ini,Settings,HighQuality
		iniread,LowQuality,FaoGenSettings.ini,Settings,LowQuality
		iniread,AA,FaoGenSettings.ini,Settings,AA
		Return

	SaveSettings:
		gui,submit,nohide
		IniWrite,%XRes%,FaoGenSettings.ini,Settings,XRes
		IniWrite,%YRes%,FaoGenSettings.ini,Settings,YRes
		IniWrite,%EdgePadding%,FaoGenSettings.ini,Settings,EdgePadding
		IniWrite,%HighQuality%,FaoGenSettings.ini,Settings,HighQuality
		IniWrite,%LowQuality%,FaoGenSettings.ini,Settings,LowQuality
		IniWrite,%AA%,FaoGenSettings.ini,Settings,AA
		return

	SetDefaultVariableValues: ;if the inifile isnt found then make these values the default to use.
		Xres = 2048
		YRes = 2048
		EdgePadding = 16
		HighQuality = 1
		LowQuality = 0
		AA = 0
		return