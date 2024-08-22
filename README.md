# Purpose

The original purpose of these scripts/Makefiles is to build Ubuntu cloud images
with a modified cloud-init package to test drive the CloudCIX data source for
cloud-init. Please do come up with a myriad ways to use this code for other
purposes!

# Design and Contributions

This code is deliberately simple to make understanding and modifying it easy.
Please try not to add too much complexity when contributing. Thank you!

# Prerequisites

You need qemu-utils and make to run this:

```
apt-get install make qemu-utils
```

In order to build images, you need to put one or more of the following upstream
cloud images in this directory:

* focal-server-cloudimg-amd64.img
* jammy-server-cloudimg-amd64.img
* noble-server-cloudimg-amd64.img

# Building Images

First, create the overlay directory structure:

```
make overlays
```

[There will be an error message from find - you can ignore it]

Now you can build your images:

```
sudo -E make focal-server-cloudimg-amd64-cloudcix.img
sudo -E make jammy-server-cloudimg-amd64-cloudcix.img
sudo -E make noble-server-cloudimg-amd64-cloudcix.img
```

The -E option is needed because the Makefile uses the `$HOME` environment
variable to access SSH public keys and cloud-init packages. If you like you, can run
also run `make` as root straight away.

If you do not need/want either `authorized_keys` or a cloud-init package in the
image, modify the Makefile accordingly. If you want to force a build because
make doesn't detect changes you made, you can use the `clean` target:

```
sudo make clean noble-server-cloudimg-amd64-cloudcix.img
```

# Adding Files to Images

Just put them in the overlay directories and run `make` for the image you want
to build.

# Running Code in Images

There is a mechanism for running a chrooted script inside the modified image.
For each of the 3 supported Ubuntu versions (Focal, Jammy, Noble) the
corresponding script from `setup-scripts/` is run. The example scripts only
install the modified cloud-init package from the overlay directory. Depending
on what you need, you may have to modify these scripts and/or the Makefile
driving them.
