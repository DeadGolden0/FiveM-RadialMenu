# Preview
https://streamable.com/ct8i3

# Description
This mod adds the following:

- Multiple options can be added into the menu.
- Works for all jobs by adding which jobs can use which options when the menu is open.
- Triggers client events which can be in other resources making it easy to setup with other scripts.
- Easy to use via keybind to access the menu.
- This is for the radial menu only and not the other scripts' events which are opening in the video.

# How to use
- Press the keybind for the menu (default: "F3") and hold.
- Move the mouse over to the option and click with your left mouse button.
- This will either do the action you use to do or open another sub menu.

# Installation
Add to folder '[esx]'
Write 'start np-menu' in your server.cfg

# Installation
To add your own events or jobs to this make the event you wish into a client event.
Then write the event name in where you want it to trigger it in the config file.

To add a job check to an option so only certain jobs will see it add the following to the return
    return (PlayerData.job.name == 'police' and not isDead)
- Replace 'police' with your desired job.


#LICENSE
This mod was modified by Reload with the intention to distribute.
He and he alone reserves the right to sell this script. Reload does not give permission
for resale but does give permission to alter/ edit the script for your own personal use.