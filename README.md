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

# Building images

First, create the overlay directory structure:

```
make overlays
```

[There will be an error message from find - you can ignore it]

Now you can build your images:

```
sudo make focal-server-cloudimg-amd64-cloudcix.img
sudo make jammy-server-cloudimg-amd64-cloudcix.img
sudo make noble-server-cloudimg-amd64-cloudcix.img
```

If you want to force a build because make doesn't detect changes you made, you
can use the `clean` target:

```
sudo make clean noble-server-cloudimg-amd64-cloudcix.img
```

# Adding files to images

Just put them in the overlay directories and run `make` for the image you want
to build.
