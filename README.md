Igloo Linux Script
==================

A script that uploads screenshots to a configured [igloo server](https://github.com/ThePengwin/igloo). 
Copied and modified from my puush-linux script

What does it need?
------------------
You need 4 things to make it work
- scrot
- notify-send - to send messages to your desktop
- xclip - to put your url onto your clipboard for you
- curl

Setting up
----------
To make it work
- get the script
- add it to your path (or anywhere easy to call)
- make it executable
- create a file in your home dir called .igloo.conf
- Create a keyboard shortcut in your desktop environment to call it how you want. (See options)

Sample .igloo.conf
------------------

```bash
IGLOO_SERVER='Url to the /up command'
IGLOO_KEY='yourkeyhere'
```

Options!
--------
With no arguments, the script acts like you called it with -dj

### Window modes
- -w - window mode - get the current selected window
- -s - select mode - Select an area by dragging the cursor over it (uses screen's -s switch)
- -d - desktop mode - Get the desktop (used to be f, but eventually f will be for a file upload)

### Image modes
- -p save as PNG
- -j save as jpeg