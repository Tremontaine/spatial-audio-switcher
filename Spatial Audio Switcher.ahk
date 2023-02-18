#Requires AutoHotkey v2.0

;
; This is a simple AutoHotkey v2.0 tray application to change
; spatial audio formats, default formats, exclusivity and speaker
; configurations. It also has links to various connected applications.
;
; This very simple tray application wouldn't be possible without
; awesome applications of Nir Sofer, Chris Mallet and others.  
; So all thanks should go to them.
;
;
; SoundVolumeCommandLine console application from NirSoft is
; needed to control audio device. Download it and put it inside
; Resources directory.
; https://www.nirsoft.net/utils/sound_volume_command_line.html
;
; SoundVolumeView is the GUI version of SoundVolumeCommandLine.
; The scripts also provides a link to open it. Download it and put
; it inside Resources directory. But it is not necessary to use the script.
; https://www.nirsoft.net/utils/sound_volume_view.html
;

; If the script runs again, skip the dialog box and replace the old instance.
#SingleInstance Force

; Prevents the script from exiting automatically when its last
; thread completes, allowing it to stay running in an idle state.
Persistent

; Set default audio device to non-spatial sound, default 
; speaker configuration to stereo, default format to 16 Bit 44100 Hz
; and don't allow applications to take exclusive control of the device.
; Change the defaults as needed, you can learn about speaker configurations from here: 
; https://learn.microsoft.com/en-us/windows-hardware/drivers/audio/mapping-stream-formats-to-speaker-configurations
Run "Resources\svcl.exe /SetSpatial `"DefaultRenderDevice`" `"`"", , "Hide"
Run "Resources\svcl.exe /SetSpeakersConfig `"DefaultRenderDevice`" 0x3 0x3 0x3", , "Hide"
Run "Resources\svcl.exe /SetDefaultFormat `"DefaultRenderDevice`" 16 44100", , "Hide"
Run "Resources\svcl.exe /SetAllowExclusive `"DefaultRenderDevice`" 0", , "Hide"

; We are going to use two main tray menus. One simple and 
; quick one, and one with more options. Let us create them.

; This is the detailed tray menu. This will open with a right click 
; to the tray icon. We are also going to set its default icon and
; delete AutoHotkey's default tray items.
Tray := A_TrayMenu
TraySetIcon "Icons\icon.ico"
Tray.Delete

; This one is the simple menu to change the spatial audio
; formats, it will open with a left click to the tray icon.
SpatialMenu := Menu()

; Tooltip text, which is displayed when the mouse hovers over the tray icon.
A_IconTip := "Spatial Audio Switcher"

; Now, we will create the submenus we are going to be using.

	; This one is for the detailed tray menu. It will show a list
	; of the spatial audio formats that can be selected.
		Select := Menu()
		
	; This will create a submenu to open sound settings. 
	; This is for the detailed tray menu.
		Settings := Menu()
		
	; This will create a submenu to control exclusivity. 
	; This is for the detailed tray menu.
		Exclusivity := Menu()

	; This will create a submenu for the detailed tray menu to change default format of the device.
	; I have only added 16 bit 44100 Hz, 16 bit 48000 Hz, 16 bit 96000 Hz, 16 bit 192000 Hz,
	; 24 bit 44100 Hz, 24 bit 48000 Hz, 24 bit 96000 Hz, 24 bit 192000 Hz.
		DefaultFormat := Menu()
		
	; Now we will create a sub-menu to control speaker configurations
	; between Stereo, 5.1 and 7.1. This will stay in both tray menus.
		Configuration := Menu()
		
	; Finally we will create a submenu to open spatial audio apps,
	; Dolby Access and DTS Sound Unbound. This will only stay within 
	; the simple tray menu.
		SpatialApps := Menu()	

; Now, let's define the functions we are going to use.

	; First, an empty function.
		Empty(*)
		{
		}

	; Function to call the simple tray menu. This is going to be the default function.
		Spatial(*)
		{
		SpatialMenu.Show
		}

	; Function to disable spatial audio.
		Disable(*)
		{
		Run "Resources\svcl.exe /SetSpatial `"DefaultRenderDevice`" `"`"", , "Hide"
		TraySetIcon "Icons\icon.ico"
		Tray.Rename "1&", "Disabled"
		Tray.SetIcon "Disabled", ""
		Tray.Add "Disabled", Empty
		Tray.Disable "&Disable Spatial Audio"
		SpatialMenu.Disable "&Disable Spatial Audio"
		}
	
	; Function to enable Dolby Atmos for Headphones.
		DolbyAtmosEnable(*)
		{
		Run "Resources\svcl.exe /SetSpatial `"DefaultRenderDevice`" `"Dolby Atmos`"", , "Hide"
		TraySetIcon "Icons\dolby.ico"
		Tray.Enable "&Disable Spatial Audio"
		SpatialMenu.Enable "&Disable Spatial Audio"
		Tray.Enable "1&"
		Tray.Rename "1&", "Dolby Atm&os for Headphones"
		Tray.SetIcon "Dolby Atm&os for Headphones", "Icons\dolby.ico"
		Tray.Add "Dolby Atm&os for Headphones", DolbyAccess
		}
		
	; Function to run Dolby Access.
		DolbyAccess(*)
		{
		Run "explorer.exe shell:appsFolder\DolbyLaboratories.DolbyAccess_rz1tebttyb220!App"
		}

	; Function to enable DTS Headphone:X.
		DTSEnable(*)
		{
		Run "Resources\svcl.exe /SetSpatial `"DefaultRenderDevice`" `"DTS`"", , "Hide"
		TraySetIcon "Icons\dts.ico"
		Tray.Enable "&Disable Spatial Audio"
		SpatialMenu.Enable "&Disable Spatial Audio"
		Tray.Enable "1&"
		Tray.Rename "1&", "DTS Headphone:&X"
		Tray.SetIcon "DTS Headphone:&X", "Icons\dts.ico"
		Tray.Add "DTS Headphone:&X", DTSSoundUnbound
		}
		
	; Function to run DTS Sound Unbound.
		DTSSoundUnbound(*)
		{
		Run "explorer.exe shell:appsFolder\DTSInc.DTSSoundUnbound_t5j2fzbtdg37r!App"
		}
	
	; Function to enable Windows Sonic for Headphones.
		SonicEnable(*)
		{
		Run "Resources\svcl.exe /SetSpatial `"DefaultRenderDevice`" `"{b53d940c-b846-4831-9f76-d102b9b725a0}`"", , "Hide"
		TraySetIcon "Icons\sonic.ico"
		Tray.Enable "&Disable Spatial Audio"
		SpatialMenu.Enable "&Disable Spatial Audio"
		Tray.Enable "1&"
		Tray.Rename "1&", "Windows Sonic for Headphones"
		Tray.SetIcon "Windows Sonic for Headphones", "Icons\sonic.ico"
		Tray.Add "Windows Sonic for Headphones", Empty
		}
		
	; Function to run SoundVolumeView, our advanced sound device manager.
		Advanced(*)
		{
		Run "Resources\SoundVolumeView.exe"
		}
		
	; Function to open Windows' sound settings.
		Modern(*)
		{
		Run "ms-settings:sound"
		}

	; Function to open Windows' traditional sound settings.
		Traditional(*)
		{
		Run "control mmsys.cpl sounds"
		}
	
	; Function to open Windows' application volume mixer.		
		Volume(*)
		{
		Run "ms-settings:apps-volume"
		}
		
	; Function to allow applications to take exclusive control of the default device	.
		Exclusive(*)
		{
		Run "Resources\svcl.exe /SetAllowExclusive `"DefaultRenderDevice`" 1", , "Hide"
		Configuration.Check "&Exclusive"
		Configuration.Uncheck "&Not Exclusive"
		}
		
	; Function to not allow applications to take exclusive control of default device	.
		NonExclusive(*)
		{
		Run "Resources\svcl.exe /SetAllowExclusive `"DefaultRenderDevice`" 0", , "Hide"
		Exclusivity.Check "&Exclusive"
		Exclusivity.Uncheck "&Not Exclusive"
		}
		
	; Function to set the default speaker configuration to stereo.
		Stereo(*)
		{
		Run "Resources\svcl.exe /SetSpeakersConfig `"DefaultRenderDevice`" 0x3 0x3 0x3", , "Hide"
		Configuration.Check "&Stereo"
		Configuration.Uncheck "&Five-point One"
		Configuration.Uncheck "S&even-point One"
		}
		
	; Function to set the default speaker configuration to 5.1.
		FivePointOne(*)
		{
		Run "Resources\svcl.exe /SetSpeakersConfig `"DefaultRenderDevice`" 0x3f 0x3f 0x3f", , "Hide"
		Configuration.Uncheck "&Stereo"
		Configuration.Check "&Five-point One"
		Configuration.Uncheck "S&even-point One"
		}
	
	; Function to set the default speaker configuration to 7.1.
		SevenPointOne(*)
		{
		Run "Resources\svcl.exe /SetSpeakersConfig `"DefaultRenderDevice`" 0x63f 0x63f 0x63f", , "Hide"
		Configuration.Uncheck "&Stereo"
		Configuration.Uncheck "&Five-point One"
		Configuration.Check "S&even-point One"
		}
		
	; Function to set the default format to 16 bit, 44100 Hz.
		df1644(*)
		{
		Run "Resources\svcl.exe /SetDefaultFormat `"DefaultRenderDevice`" 16 44100", , "Hide"
		DefaultFormat.Check "16 Bit, 44100 Hz"
		DefaultFormat.Uncheck "16 Bit, 48000 Hz"
		DefaultFormat.Uncheck "16 Bit, 96000 Hz"
		DefaultFormat.Uncheck "16 Bit, 192000 Hz"
		DefaultFormat.Uncheck "24 Bit, 44100 Hz"
		DefaultFormat.Uncheck "24 Bit, 48000 Hz"
		DefaultFormat.Uncheck "24 Bit, 96000 Hz"
		DefaultFormat.Uncheck "24 Bit, 192000 Hz"
		}
		
	; Function to set the default format to 16 bit, 48000 Hz.
		df1648(*)
		{
		Run "Resources\svcl.exe /SetDefaultFormat `"DefaultRenderDevice`" 16 48000", , "Hide"
		DefaultFormat.Uncheck "16 Bit, 44100 Hz"
		DefaultFormat.Check "16 Bit, 48000 Hz"
		DefaultFormat.Uncheck "16 Bit, 96000 Hz"
		DefaultFormat.Uncheck "16 Bit, 192000 Hz"
		DefaultFormat.Uncheck "24 Bit, 44100 Hz"
		DefaultFormat.Uncheck "24 Bit, 48000 Hz"
		DefaultFormat.Uncheck "24 Bit, 96000 Hz"
		DefaultFormat.Uncheck "24 Bit, 192000 Hz"
		}
		
	; Function to set the default format to 16 bit, 96000 Hz.
		df1696(*)
		{
		Run "Resources\svcl.exe /SetDefaultFormat `"DefaultRenderDevice`" 16 96000", , "Hide"
		DefaultFormat.Uncheck "16 Bit, 44100 Hz"
		DefaultFormat.Uncheck "16 Bit, 48000 Hz"
		DefaultFormat.Check "16 Bit, 96000 Hz"
		DefaultFormat.Uncheck "16 Bit, 192000 Hz"
		DefaultFormat.Uncheck "24 Bit, 44100 Hz"
		DefaultFormat.Uncheck "24 Bit, 48000 Hz"
		DefaultFormat.Uncheck "24 Bit, 96000 Hz"
		DefaultFormat.Uncheck "24 Bit, 192000 Hz"
		}
		
	; Function to set the default format to 16 bit, 192000 Hz.
		df16192(*)
		{
		Run "Resources\svcl.exe /SetDefaultFormat `"DefaultRenderDevice`" 16 192000", , "Hide"
		DefaultFormat.Uncheck "16 Bit, 44100 Hz"
		DefaultFormat.Uncheck "16 Bit, 48000 Hz"
		DefaultFormat.Uncheck "16 Bit, 96000 Hz"
		DefaultFormat.Check "16 Bit, 192000 Hz"
		DefaultFormat.Uncheck "24 Bit, 44100 Hz"
		DefaultFormat.Uncheck "24 Bit, 48000 Hz"
		DefaultFormat.Uncheck "24 Bit, 96000 Hz"
		DefaultFormat.Uncheck "24 Bit, 192000 Hz"
		}
		
	; Function to set the default format to 24 bit, 44100 Hz.
		df2444(*)
		{
		Run "Resources\svcl.exe /SetDefaultFormat `"DefaultRenderDevice`" 24 44100", , "Hide"
		DefaultFormat.Uncheck "16 Bit, 44100 Hz"
		DefaultFormat.Uncheck "16 Bit, 48000 Hz"
		DefaultFormat.Uncheck "16 Bit, 96000 Hz"
		DefaultFormat.Uncheck "16 Bit, 192000 Hz"
		DefaultFormat.Check "24 Bit, 44100 Hz"
		DefaultFormat.Uncheck "24 Bit, 48000 Hz"
		DefaultFormat.Uncheck "24 Bit, 96000 Hz"
		DefaultFormat.Uncheck "24 Bit, 192000 Hz"
		}
	
	; Function to set the default format to 24 bit, 48000 Hz.
		df2448(*)
		{
		Run "Resources\svcl.exe /SetDefaultFormat `"DefaultRenderDevice`" 24 48000", , "Hide"
		DefaultFormat.Uncheck "16 Bit, 44100 Hz"
		DefaultFormat.Uncheck "16 Bit, 48000 Hz"
		DefaultFormat.Uncheck "16 Bit, 96000 Hz"
		DefaultFormat.Uncheck "16 Bit, 192000 Hz"
		DefaultFormat.Uncheck "24 Bit, 44100 Hz"
		DefaultFormat.Check "24 Bit, 48000 Hz"
		DefaultFormat.Uncheck "24 Bit, 96000 Hz"
		DefaultFormat.Uncheck "24 Bit, 192000 Hz"
		}
		
	; Function to set the default format to 24 bit, 96000 Hz.
		df2496(*)
		{
		Run "Resources\svcl.exe /SetDefaultFormat `"DefaultRenderDevice`" 24 96000", , "Hide"
		DefaultFormat.Uncheck "16 Bit, 44100 Hz"
		DefaultFormat.Uncheck "16 Bit, 48000 Hz"
		DefaultFormat.Uncheck "16 Bit, 96000 Hz"
		DefaultFormat.Uncheck "16 Bit, 192000 Hz"
		DefaultFormat.Uncheck "24 Bit, 44100 Hz"
		DefaultFormat.Uncheck "24 Bit, 48000 Hz"
		DefaultFormat.Check "24 Bit, 96000 Hz"
		DefaultFormat.Uncheck "24 Bit, 192000 Hz"
		}
		
	; Function to set the default format to 24 bit, 192000 Hz.
		df24192(*)
		{
		Run "Resources\svcl.exe /SetDefaultFormat `"DefaultRenderDevice`" 24 192000", , "Hide"
		DefaultFormat.Uncheck "16 Bit, 44100 Hz"
		DefaultFormat.Uncheck "16 Bit, 48000 Hz"
		DefaultFormat.Uncheck "16 Bit, 96000 Hz"
		DefaultFormat.Uncheck "16 Bit, 192000 Hz"
		DefaultFormat.Uncheck "24 Bit, 44100 Hz"
		DefaultFormat.Uncheck "24 Bit, 48000 Hz"
		DefaultFormat.Uncheck "24 Bit, 96000 Hz"
		DefaultFormat.Check "24 Bit, 192000 Hz"
		}
		
	; Function to reload the Spatial Audio Switcher.
	; It loads the default settings.
		Restart(*)
		{
		Reload
		}
		
	; Function to exit the Spatial Audio Switcher.
	; It loads the default settings first.
		Exit(*)
		{
		Run "Resources\svcl.exe /SetSpatial `"DefaultRenderDevice`" `"`"", , "Hide"
		Run "Resources\svcl.exe /SetSpeakersConfig `"DefaultRenderDevice`" 0x3 0x3 0x3", , "Hide"
		Run "Resources\svcl.exe /SetDefaultFormat `"DefaultRenderDevice`" 16 44100", , "Hide"
		Run "Resources\svcl.exe /SetAllowExclusive `"DefaultRenderDevice`" 0", , "Hide"		Sleep 0
		ExitApp
		}

; Now we will populate the menus.

	; First the detailed tray menu. This will open with a right click on the tray icon.
	
		; First is going to show the current state of spatial audio and change accordingly.
		; You can open the related app by clicking it.
		Tray.Add "Disabled", Empty

		; Second will be an option to disable spatial audio. Shall be greyed-out
		; when it is already disabled.
		Tray.Add "&Disable Spatial Audio", Disable
		Tray.SetIcon "&Disable Spatial Audio", "Icons\disable.ico"
		Tray.Disable "&Disable Spatial Audio"

		; A seperator.
		Tray.Add
		
		; Select submenu.
		Tray.Add "&Spatial Audio", Select
		Select.Add "Dolby Atm&os for Headphones", DolbyAtmosEnable
		Select.SetIcon "Dolby Atm&os for Headphones", "Icons\dolby.ico"
		Select.Add "DTS Headphone:&X", DTSEnable
		Select.SetIcon "DTS Headphone:&X", "Icons\dts.ico"
		Select.Add "Windows &Sonic for Headphones", SonicEnable
		Select.SetIcon "Windows &Sonic for Headphones", "Icons\sonic.ico"

		; Settings submenu.
		Tray.Add "&Audio Settings", Settings	
		Settings.Add "&Advanced", Advanced
		Settings.Add "&Modern", Modern
		Settings.Add "&Traditional", Traditional

		; Configuration submenu.
		Tray.Add "Speaker &Configuration", Configuration
		Configuration.Add "&Stereo", Stereo
		Configuration.Add "&Five-point One", FivePointOne
		Configuration.Add "S&even-point One", SevenPointOne
		
		; Default Format submenu.
		Tray.Add "Default &Format", DefaultFormat
		DefaultFormat.Add "16 Bit, 44100 Hz", df1644
		DefaultFormat.Add "16 Bit, 48000 Hz", df1648
		DefaultFormat.Add "16 Bit, 96000 Hz", df1696
		DefaultFormat.Add "16 Bit, 192000 Hz", df16192
		DefaultFormat.Add "24 Bit, 44100 Hz", df2444
		DefaultFormat.Add "24 Bit, 48000 Hz", df2448
		DefaultFormat.Add "24 Bit, 96000 Hz", df2496
		DefaultFormat.Add "24 Bit, 192000 Hz", df24192
		
		; Exclusivity submenu
		Tray.Add "&Exclusivity", Exclusivity
		Exclusivity.Add "&Exclusive", Exclusive
		Exclusivity.Add "&Not Exclusive", NonExclusive

		; Application Volume Mixer.
		Tray.Add "&Volume Mixer", Volume
			
		; A seperator.
		Tray.Add
		
		; An item to reload Spatial Audio Switcher
		; and reset all settings to their default.
		Tray.Add "&Reload", Restart
		
		; An item to quit Spatial Audio Switcher
		; and reset all settings to their default.
		Tray.Add "E&xit", Exit

	; Now the simple tray menu. This will open with a left click on the tray icon.
		
		; First will be an option to disable spatial audio. Shall be greyed-out
		; when it is already disabled.
		SpatialMenu.Add "&Disable Spatial Audio", Disable
		SpatialMenu.SetIcon "&Disable Spatial Audio", "Icons\disable.ico"
		SpatialMenu.Disable "&Disable Spatial Audio"
	
		; A seperator.
		SpatialMenu.Add
		
		; Now the selection between the spatial audio formats.
		SpatialMenu.Add "Dolby Atm&os for Headphones", DolbyAtmosEnable
		SpatialMenu.SetIcon "Dolby Atm&os for Headphones", "Icons\dolby.ico"
		SpatialMenu.Add "DTS Headphone:&X", DTSEnable
		SpatialMenu.SetIcon "DTS Headphone:&X", "Icons\dts.ico"
		SpatialMenu.Add "Windows &Sonic for Headphones", SonicEnable
		SpatialMenu.SetIcon "Windows &Sonic for Headphones", "Icons\sonic.ico"
		
		; A Seperator
		SpatialMenu.Add
		
		; Speaker configuration. This is important enough to stay
		; within the simple tray menu.
		SpatialMenu.Add "Speaker &Configuration", Configuration
		
		; Shortcuts to spatial audio applications.
		SpatialMenu.Add "&Applications", SpatialApps
		SpatialApps.Add "&Dolby Access", DolbyAccess
		SpatialApps.SetIcon "&Dolby Access", "Icons\dolby.ico"
		SpatialApps.Add "DTS Sound &Unbound", DTSSoundUnbound
		SpatialApps.SetIcon "DTS Sound &Unbound", "Icons\dts.ico"

; Now we will make tray menu show our default settings.
Exclusivity.Check "&Exclusive"
Exclusivity.Uncheck "&Not Exclusive"
Configuration.Check "&Stereo"
Configuration.Uncheck "&Five-point One"
Configuration.Uncheck "S&even-point One"
DefaultFormat.Check "16 Bit, 44100 Hz"
DefaultFormat.Uncheck "16 Bit, 48000 Hz"
DefaultFormat.Uncheck "16 Bit, 96000 Hz"
DefaultFormat.Uncheck "16 Bit, 192000 Hz"
DefaultFormat.Uncheck "24 Bit, 44100 Hz"
DefaultFormat.Uncheck "24 Bit, 48000 Hz"
DefaultFormat.Uncheck "24 Bit, 96000 Hz"
DefaultFormat.Uncheck "24 Bit, 192000 Hz"

; Now we will make the simple tray menu the default.
; This is needed to open it with one left click to the tray icon.
Tray.Add
Tray.Add "Spatial Audio Switcher", Spatial 
Tray.Default := "Spatial Audio Switcher"
Tray.Disable "Spatial Audio Switcher"
Tray.ClickCount := 1

; Windows + Alt + S shortcut can be used to open
; the simple tray menu below the mouse pointer.
#!s::SpatialMenu.Show

;
; END
;