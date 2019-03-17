# Firefox Magnet Mime Handler
Magnet link mime handler for Firefox, that forwards them to a local or remote transmission server

Prerequisites:
- windows OS
- Firefox
- Powershell 5 or higher

How to use:
- Download the mimehandler directory to your (windows) system. It contains four files: __install.ps1__, __magnet_add.ps1__, __mimehandler.bat__ and __mimehandler.ps1__
- Right-click __install.ps1__ and select __Run with powershell__. This will edit your firefox mime types and add a link between magnet urls and the scripts. To see these modifications in firefox, go to options, general, scroll down to applications and look for the entry for content type '**magnet**'.
- Now when you click a magnet link for the first time, the script will ask for the address, port, username and password of your transmission server. **NOTE: make sure you enter the user/pass of the transmission remote control server, NOT your windows username and password**.
- Those settings will be saved in **%userprofile%\mime_magnet_config.json** (which typically expands to **c:\users\yourname\mime_magnet_config.json**). To reconfigure your transmission server details next time you click a magnet link, just delete that file.
