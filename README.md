# Spatial Audio Switcher
This is a simple AutoHotkey v2.0 tray application to change spatial audio formats, default formats, exclusivity and speaker configurations. It also has links to various connected applications.

This very simple tray application wouldn't be possible without awesome work of Nir Sofer, Chris Mallet and others. So all thanks should go to them.

[SoundVolumeCommandLine](https://www.nirsoft.net/utils/sound_volume_command_line.html) console application from NirSoft is needed to control the audio device. Download it and put it inside Resources directory.

[SoundVolumeView](https://www.nirsoft.net/utils/sound_volume_view.html) is the GUI version of SoundVolumeCommandLine. The scripts also provides a link to open it. Download it and put it inside Resources directory. But it is not necessary to use the script.

To run the script you need to install [AutoHotkey v2](https://www.autohotkey.com/).

## Features

* Provides a menu to choose between Windows Sonic for Headphones, Dolby Atmos for Headphones, DTS Headphone:X or disable spatial audio.
* Provides a menu to easily access Dolby Access and DTS Sound Unbound.
* Provides a menu to easily access [SoundVolumeView](https://www.nirsoft.net/utils/sound_volume_view.html), Windows sound settings, and old style Windows sound settings.
* Provides a menu to set the default audio format.
* Provides a menu to set audio device exclusivity.
* Provides a menu to change speaker configurations between Stereo, 5.1 and 7.1.
* Provides a shortcut to open Windows Volume Mixer to control application volumes.
* Windows + Alt + S shortcut can be used to open the tray menu below the mouse pointer.
* Tray icon changes depending on which spatial audio format is in use.

The script is using two main tray menus. 

One of them is simple. It opens with one left click to the tray icon and is bound to the Windows + Alt + S shortcut. This is how it looks:

![dvuQEr.png](https://imgpile.com/images/dvuQEr.png)

The other is a more detailed tray menu. This one will open with a right click to the tray icon and includes various options to control your audio device. This is how it looks:

![dvu6Fc.png](https://imgpile.com/images/dvu6Fc.png)

<a href="https://www.flaticon.com/free-icons/turn-off" title="turn off icons">Turn off icons created by feen - Flaticon</a>

<a href="https://www.flaticon.com/free-icons/spatial" title="spatial icons">Spatial icons created by AbtoCreative - Flaticon</a>
