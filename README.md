# Firefox Magnet Mime Handler
Magnet link mime handler for Firefox, that forwards them to a local or remote transmission server

Prerequisites:
- windows OS
- Firefox
- Powershell 5 or higher

How to use:
- Download the mimehandler directory to your (windows) system. It contains four files: __install.ps1__, __magnet_add.ps1__, __mimehandler.bat__ and __mimehandler.ps1__
- Since you downloaded these scripts from the internet, windows will mark them as unsafe to run. To fix this, right click every file, select properties, and at the bottom of the properties screen check the '__unblock__' checkmark, then click '__apply__'
![Alt text](unblock.png?raw=true "Unblock checkmark")
- Right-click __install.ps1__ and select __Run with powershell__. This will edit your firefox mime types and add a link between magnet urls and the scripts. To see these modifications in firefox, go to options, general, scroll down to applications and look for the entry for content type '**magnet**'.
- Now when you click a magnet link for the first time, the script will ask for the address, port, username and password of your transmission server. **NOTE: make sure you enter the user/pass of the transmission remote control server, NOT your windows username and password**.
- Those settings will be saved in **%userprofile%\mime_magnet_config.json** (which typically expands to **c:\users\yourname\mime_magnet_config.json**). To reconfigure your transmission server details next time you click a magnet link, just delete that file.

How it works:
- __install.ps1__ edits your firefox __handlers.json__ file to add a mime type handler for magnet links
- clicking a magnet links in firefox will launch __mimehandler.bat__, which in turn will start the powershell script __mimehandler.ps1__
- __mimehandler.ps1__ checks if it was a correct magnet link and launches __magnet_add.ps1__
- __magnet_add.ps1__ calls the transmission remote control server using the json api
