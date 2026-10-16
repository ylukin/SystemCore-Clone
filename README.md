# SystemCore Clone

A simple Raspberry Pi–based project for running **CAN** or **CAN FD** interfaces.


## Required Software
The following software is required to create, flash, and use the SystemCore image.

### Raspberry Pi Imager
Used to flash the operating system image to a microSD card.
- https://www.raspberrypi.com/software/

### WPILib 2027.0.0-alpha-7
Install on your development computer (not the Pi). The example projects target this release.
- https://github.com/wpilibsuite/allwpilib/releases/tag/v2027.0.0-alpha-7

Alpha 7 also requires the FIRST Driver Station alpha 7 and Elastic alpha 9 or newer.

### SystemCore Base Image
This is the base os image used if you are preperaing or setting up your own image instead of using Bobcat's Prebuilt image.
Use the **beta** release and download the `limelightsystemcorebetacm5-*.zip` asset (the other assets are update payloads, the toolchain and kernel source).
- Tested target: [beta17 (233)](https://github.com/LimelightVision/systemcore-os-public/releases/tag/limelightosr-2027.0.0-beta17-233) - `limelightsystemcorebetacm5-limelightosr-2027.0.0-beta17.zip`
- All releases: https://github.com/LimelightVision/systemcore-os-public/releases

### CTRE Phoenix 6
The example projects use Phoenix 6 `26.70.0-alpha-2`, the 2027 build compatible with WPILib alpha 7.

### Canivore usb drivers
This two driver files neeeded for the canivore usb.
- https://ctre.download/files/systemcore/canivore-usb-kernel_1.18_aarch64.ipk
- https://ctre.download/files/systemcore/canivore-usb_1.16_aarch64.ipk


## Required Hardware
The following hardware that we have tested with 

### Raspberry Pi 5 4 GB
A standard Raspberry Pi 5 with 4GB of memory is as close to the specs as you will get.
- https://www.amazon.com/dp/B0FL21867J?ref=ppx_yo2ov_dt_b_fed_asin_title&th=1

### CAN HAT - NO FD
This is the exact hat that was purchased from amazon for this project that does not support FD. 
- https://www.amazon.com/dp/B087RJ6XGG?ref=ppx_yo2ov_dt_b_fed_asin_title

### CAN HAT - FD
This is the exact hat that was purchased from amazon for this project that supports CAN FD. 
- https://www.amazon.com/dp/B07YQTMQTR?ref=ppx_yo2ov_dt_b_fed_asin_title

## Documentation & Guides

#### CAN HAT Setup
Follow the instructions for configuring the standard CAN HAT.

- [CAN HAT Instructions](./no-fd/README.md)

#### CAN FD HAT Setup
Follow the instructions for configuring the CAN FD HAT.

- [CAN FD HAT Instructions](./fd/README.md)

#### SD Card Setup & Cloning
Instructions for preparing a new SD card or cloning an existing SystemCore installation.

- [Setup & Build Guide](./setup/README.md)

