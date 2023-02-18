#Requires AutoHotkey v2.0

; If run again, skips the dialog box and replaces the old instance.
#SingleInstance Force

; Prevents the script from exiting automatically when its last
; thread completes, allowing it to stay running in an idle state.
Persistent

; SoundVolumeCommandLine console application from NirSoft is
; needed to control audio device. Put it in the same
; directory with the script or install it with Scoop.
; https://www.nirsoft.net/utils/sound_volume_command_line.html

; Set default audio device to non-spatial sound
Run "svcl.exe /SetSpatial `"DefaultRenderDevice`" `"`"", , "Hide"

; Create the tray menu.
Tray := A_TrayMenu

; Open Dolby Access or DTS Sound Unbound by one click.
Tray.ClickCount := 1

; Icon's tooltip text, which is displayed when the mouse hovers over it.
A_IconTip := "Spatial Audio Switcher"

; Delete default tray icon objects.
Tray.Delete

; Set tray menu's icon.
TraySetIcon "icon.png"

; Set Disabled state, shall be called as 1& to 
; change it as spatial audio state changes.
Tray.Add "Disabled", Disabled
	Disabled(*)
	{
	}

; Add an option to disable spatial audio.
Tray.Add "&Disable Spatial Audio", Disable
Tray.SetIcon "&Disable Spatial Audio", "disable.png"
	Disable(*)
	{
	Run "svcl.exe /SetSpatial `"DefaultRenderDevice`" `"`"", , "Hide"
	TraySetIcon "icon.png"
	Tray.Rename "1&", "Disabled"
	Tray.SetIcon "Disabled", ""
	Tray.Add "Disabled", Disabled
	Tray.Disable "&Disable Spatial Audio"
	}
Tray.Disable "&Disable Spatial Audio"

; Seperator.
Tray.Add

; Create a sub-menu to control Spatial Audio.
; Windows Sonic for Headphones, Dolby Atmos
; for Headphones and DTS Headphone:X is supported.
Select := Menu()
	Select.Add "Dolby Atm&os for Headphones", DolbyAtmosEnable
	Select.SetIcon "Dolby Atm&os for Headphones", "dolby.png"
		DolbyAtmosEnable(*)
		{
		Run "svcl.exe /SetSpatial `"DefaultRenderDevice`" `"Dolby Atmos`"", , "Hide"
		TraySetIcon "dolby.png"
		Tray.Enable "&Disable Spatial Audio"
		Tray.Enable "1&"
		Tray.Rename "1&", "Dolby Atm&os for Headphones"
		Tray.SetIcon "Dolby Atm&os for Headphones", "dolby.png"
		Tray.Add "Dolby Atm&os for Headphones", DolbyAccess
			DolbyAccess(*)
			{
			Run "explorer.exe shell:appsFolder\DolbyLaboratories.DolbyAccess_rz1tebttyb220!App"
			}
		}
	Select.Add "DTS Headphone:&X", DTSEnable
	Select.SetIcon "DTS Headphone:&X", "dts.png"
		DTSEnable(*)
		{
		Run "svcl.exe /SetSpatial `"DefaultRenderDevice`" `"DTS`"", , "Hide"
		TraySetIcon "dts.png"
		Tray.Enable "2&"
		Tray.Enable "1&"
		Tray.Rename "1&", "DTS Headphone:&X"
		Tray.SetIcon "DTS Headphone:&X", "dts.png"
		Tray.Add "DTS Headphone:&X", DTSSoundUnbound
			DTSSoundUnbound(*)
			{
			Run "explorer.exe shell:appsFolder\DTSInc.DTSSoundUnbound_t5j2fzbtdg37r!App"
			}
		}
	Select.Add "Windows &Sonic for Headphones", SonicEnable
	Select.SetIcon "Windows &Sonic for Headphones", "sonic.png"
		SonicEnable(*)
		{
		Run "svcl.exe /SetSpatial `"DefaultRenderDevice`" `"{b53d940c-b846-4831-9f76-d102b9b725a0}`"", , "Hide"
		TraySetIcon "sonic.png"
		Tray.Enable "&Disable Spatial Audio"
		Tray.Enable "1&"
		Tray.Rename "1&", "Windows Sonic for Headphones"
		Tray.SetIcon "Windows Sonic for Headphones", "sonic.png"
		Tray.Add "Windows Sonic for Headphones", Disabled
		}
		
; Add the sub-menu to control Spatial Audio.
Tray.Add "&Spatial Audio", Select

; Create a sub-menu to open sound settings.
Settings := Menu()
	Settings.Add "&Advanced", Advanced
		Advanced(*)
		{
		Run "SoundVolumeView.exe"
		}
	Settings.Add "&Modern", Modern
		Modern(*)
		{
		Run "ms-settings:sound"
		}
	Settings.Add "&Traditional", Traditional
		Traditional(*)
		{
		Run "control mmsys.cpl sounds"
		}
; Add the sub-menu to open sound settings
Tray.Add "&Audio Settings", Settings

; Create a sub-menu to control speaker configuration
; between Stereo, 5.1 and 7.1. Defaults to Stereo.
Configuration := Menu()
	Configuration.Add "&Stereo", Stereo
		Stereo(*)
		{
		Run "svcl.exe /SetSpeakersConfig `"DefaultRenderDevice`" 0x3 0x3 0x3", , "Hide"
		Configuration.Check "&Stereo"
		Configuration.Uncheck "&Five-point One"
		Configuration.Uncheck "S&even-point One"
		}
	Configuration.Add "&Five-point One", FivePointOne
		FivePointOne(*)
		{
		Run "svcl.exe /SetSpeakersConfig `"DefaultRenderDevice`" 0x3f 0x3f 0x3f", , "Hide"
		Configuration.Uncheck "&Stereo"
		Configuration.Check "&Five-point One"
		Configuration.Uncheck "S&even-point One"
		}
	Configuration.Add "S&even-point One", SevenPointOne
		SevenPointOne(*)
		{
		Run "svcl.exe /SetSpeakersConfig `"DefaultRenderDevice`" 0x63f 0x63f 0x63f", , "Hide"
		Configuration.Uncheck "&Stereo"
		Configuration.Uncheck "&Five-point One"
		Configuration.Check "S&even-point One"
		}
; Add the sub-menu to control speaker configuration and set to Stereo.
Tray.add "Speaker &Configuration", Configuration
Run "svcl.exe /SetSpeakersConfig `"DefaultRenderDevice`" 0x3 0x3 0x3", , "Hide"
Configuration.Check "&Stereo"

; Add a shortcut to open Windows Volume Mixer to control application volumes.
Tray.Add "&Volume Mixer", Volume
	Volume(*)
	{
	Run "ms-settings:apps-volume"
	}

; Make the first line default.
Tray.Default := "1&"

; Seperator.
Tray.Add

; Windows + Alt + S shortcut can be used to open
; the tray menu below the mouse pointer.
#!s::Tray.Show

; Function to reload the Spatial Audio Switcher.
; Also disables spatial audio and sets to Stereo.
Tray.Add "&Reload", Restart
	Restart(*)
	{
	Reload
	}

; Function to exit the Spatial Audio Switcher.
; Also disables spatial audio and sets to Stereo
Tray.Add "&Exit", Exit
	Exit(*)
	{
	Run "svcl.exe /SetSpatial `"DefaultRenderDevice`" `"`"", , "Hide"
	Run "svcl.exe /SetSpeakersConfig `"DefaultRenderDevice`" 0x3 0x3 0x3", , "Hide"
	Sleep 0
	ExitApp
	}