# BDS-UI (name pending)
A UI for MC Bedrock Dedicated server. Written in AutoIT

## Setup

Download the exe from the releases page, and move it to an empty folder. <br></br>
Extract a copy of MCBE's BDS to a folder named `BDS` within the folder the exe is in.<br></br>
Then double click the exe to open! 

Your folder should look like this:
``` plaintext
bds-ui/
    BDS-UI.exe
    BDS/
        bedrock_server.exe
        server.properties
        (and other BDS files)
```
(The location of BDS can be changed in settings, but this is the default)


## Features

### Server Management
![An image of BDS-UI's main page](https://github.com/UFO-Studios/bds-ui/assets/80964340/189e9689-f0dd-4a74-9af7-8046a814d4c9)

- 🔴 Red: Main server control buttons
- 🟠 Orange: The server status. E.G: Online, Offline or Backing up.
- 🔵 Blue: Server Output. Anything with `[BDS-UI]` is info from bds-ui, the rest is BDS's own output.

### Settings
 ![An image of BDS-UI's settings page](https://github.com/UFO-Studios/bds-ui/assets/80964340/bab98037-248d-4989-a943-6b3058dd9739)

- 🔴 Red: The Backup & Restart Settings. Note: Backup won't work without restart also being enabled
- 🟠 Orange: The time (in 24H) that BDS-UI will Restart/Backup. This is ignored if `Auto Restarts` is disabled
- 🟢 Green: The file paths. We recommend having them in the same folder (`D:/TAD/bds-ui` in the image, for example) for ease of use, but this is not needed
- 🔵 Blue: About. Shows info about your version of BDS-UI
- 🟣 Purple: Save settings button. Make sure you save before leaving the tab!

## Troubleshooting
- Q: My PC says this is a virus! A: Yup, that's because not many people have downloaded this exe, so windows (amongst others) don't yet trust it. The code is open source on Github, and you're welcome to check it!
- Q: It can't find (BDS, server.properties, ect) A: Check that the folder in settings matches the one with BDS in it, and restart BDS-UI.
- Q: Where can I get help? A: You can join our [Discord](https://thealiendoctor.com/r/Discord)! Make sure you have uploaded the logs using the `Upload Logs` button in the settings tab, and we'll be able to help you better!


## Credits
- [TheAlienDoctor](https://thealiendoctor.com) & [Niceygy](https://niceygylive.xyz): Main Devs
- FoxyNoTail: Inspired by his [MCBE play](https://foxynotail.com/tools/mcbe-play)
