# Packaging instructions

In general, you can mostly follow the instructions from the Ubuntu package
ubuntu-packaging-guide-html. It's best to install that guide as a package on
an Ubuntu system, for the online version is severly broken with most content
missing right now.

## Environment Setup

For setting up the build environment the packages from ubuntu-packaging-guide
are not quite sufficient. Instead of

```
sudo apt install gnupg pbuilder ubuntu-dev-tools apt-file
```

you will need

```
sudo apt install gnupg pbuilder ubuntu-dev-tools apt-file debhelper dh-python
```

This is because the cloud-init package needs dh-python to build.

You should also set up the pbuilder-dist utility's chroot image while you are
at it:

```
pbuilder-dist noble create  # 24.04 LTS
```

If needed, you can set it up for older Ubuntu versions as well:

```
pbuilder-dist jammy create  # 22.04 LTS
pbuilder-dist focal create  # 20.04 LTS
```

## Acquiring package sources

To build the
cloud-init package we need its source first. With this command we'll get the
launchpad sources for Ubuntu 24.04 LTS (noble)

```
pull-lp-source cloud-init noble
```

Just like with pbuilder, you'll need to pull the sources for other releases as
well if you want to build packages for these:

```
pull-lp-source cloud-init jammy
pull-lp-source cloud-init focal
```

At the time of this writing, Ubuntu 24.04 had `cloud-init-24.2` so we'll get a
`cloud-init-24.2/` directory among other things. Before we cd to this directory,
we'll need to turn the CloudCIX fork of cloud-init into a patch we can apply to
the package:

```
git clone https://www.github.com/CloudCIX/cloud-init.git --branch cloudcix_ds
(cd cloud-init; git diff main > ../cloudcix_ds.patch)
```

One could also cherry pick individual commits but we've got so many this would
turn into quite a bit of make-work. Now that we have the patch we can apply it:

```
cd cloud-init-24.2/
add-patch ../cloudcix_ds.patch
```

Note: Make sure you have the `DEBEMAIL` and `DEBFULLNAME` environment variables
set.  Otherwise you'll get two nag messages about them being unset

The `add-patch` step may fail due to merge conflicts. Luckily this isn't the
case right now but if it happens you are going to have to mess with `quilt(1)`.

add-patch will open an editor with a freshly created change log entry. In that
entry, bump the `-ubuntu` component of the version number by one and modify the
`[DESCRIBE CHANGES HERE]` bit to say something more useful. Here's what my
changelog for 24.2 and the preceding upstream version looked:

```
cloud-init (24.2-0ubuntu2~24.04.2) UNRELEASED; urgency=medium

* debian/patches/cloudcix_ds.patch: add CloudCIX data source

 -- Johannes Grassler <info@computer-grassler.de>  Wed, 21 Aug 2024 19:51:45 +0000

cloud-init (24.2-0ubuntu1~24.04.2) noble; urgency=medium

  * Declare breaks on the python3-minimal version that is affected by the
    py3clean failure when using alternate character set (LP: #2075337)

 -- Benjamin Drung <bdrung@ubuntu.com>  Wed, 07 Aug 2024 20:54:01 +0200

cloud-init (24.2-0ubuntu1~24.04.1) noble; urgency=medium
```

It's not strictly neccessary to have a higher version number than the latest
available from upstream but it saves you an extra apt-get remove. With the
change log done you can test, prepare and build the package:

```
debuild -S -d -us -uc
pbuilder-dist noble build ../cloud-init_24.2-0ubuntu2~24.04.2.dsc
```

Note that the version of the `.dsc` file matches the one from the change log. The
finished package will be found here:

```
~/pbuilder/noble_result/cloud-init_24.2-0ubuntu2~24.04.2_all.deb
```

For Ubuntu 22.04 and 20.04 the build looks similar:

```
# 22.04
debuild -S -d -us -uc
pbuilder-dist jammy build ../cloud-init_24.2-0ubuntu2~22.04.1.dsc

# 20.04
debuild -S -d -us -uc
pbuilder-dist focal build ../cloud-init_24.2-0ubuntu2~20.04.1.dsc
```

The resulting packages will again be found under `~/pbuilder`

```
~/pbuilder/jammy_result/cloud-init_24.2-0ubuntu2~22.04.1_all.deb
~/pbuilder/focal_result/cloud-init_24.2-0ubuntu2~20.04.1_all.deb
```

Please note that version numbers are going to change as upstream packages
progress.
