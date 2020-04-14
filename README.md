# Balena deployable OpenAg Brain
This project links in the OpenAg brain software and makes it deployable utilizing [Balena.io](https://www.balena.io/) for easy management of devices.

# How to pull all the code for this project
There is a top level project with the balena / docker setup stuff and the brain is saved as a git 'submodule', which is just a tag of a repo at a certain point.
```bash
cd ~
git clone https://github.com/OpenAgInitiative/openag-brain-balena.git
cd openag-brain-balena
git submodule update --init --recursive
```

# Install balena CLI
https://www.balena.io/docs/reference/cli/
```bash
npm install balena-cli -g --production --unsafe-perm
```

# Create a balena account
https://www.balena.io/cloud
Then build a test application, download the image, flash a device.

# Push an application to your device on the balena cloud
```bash
cd ~/openag-brain-balena
balena login
balena push <app name - rob you used 'test'>
```

# Docs
https://www.balena.io/docs/
https://www.balena.io/docs/reference/cli/
look up supervisor API

# SSH to your Host OS or docker image running on your balena cloud device
https://www.balena.io/docs/learn/develop/local-mode/#ssh-into-the-running-app-container-or-host-os
1. In the balena cloud page, navigate to your device.
2. In the button bar there is a drop list (to the right of reboot, restart, blink).
3. In the drop list, chose "enable local mode" and the device will reconfigure itself.
4. `sudo balena local scan`
5. From the output pick out the <short UUID>.local hostname.
6. `sudo balena local ssh f0b4960.local`  will give you the choice of app or host.

# Access the docker image permanent file system
The app file system (in docker image) is in this dir if you are in the supervisor (Host OS):
`/mnt/data/docker/volumes/XXXXXXX_resin-data/_data`

# Connecting to the RPi console from OSX
Buy: 
- https://www.adafruit.com/product/954
Install: 
- https://learn.adafruit.com/adafruits-raspberry-pi-lesson-5-using-a-console-cable/software-installation-mac
Run:
- `screen /dev/cu.usbserial 115200`


