# Firefox Magnet Mime Handler
Magnet link mime handler for Firefox, that forwards them to a local or remote transmission server

How to use:
- Download the mimehandler directory to your (windows) system
- In firefox, go to options, general, scroll down to applications and look for the entry for content type 'magnet'.
- On the right side, click the drop down list and select 'use other'. A 'select helper application' dialog will pop up
- In the dialog, click 'Browse' and select 'mimehandler.bat'. The selection filter in the file dialog only shows .exe files by default, so to make the batch file visible type *.bat
- Close the options page
- Now when you click a magnet link, the script will ask for the address, port, username and password of your transmission server
- Those settings will be saved in %userprofile%\mime_magnet_config.json . To reconfigure the magnet mime handler, just delete that file.
