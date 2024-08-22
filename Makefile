.PHONY: clean
  
overlay_noble:=$(shell find overlays/noble/)
overlay_focal:=$(shell find overlays/focal/)
overlay_jammy:=$(shell find overlays/jammy/)

# FIXME: adjust this path and/or run build as root straight away
HOME_PATH:=/home/grassler

keys_path:=${HOME_PATH}/.ssh/authorized_keys 
deb_noble:=${HOME_PATH}/pbuilder/noble_result/cloud-init_24.2-0ubuntu2~24.04.2_all.deb

IMAGES=focal-server-cloudimg-amd64-cloudcix.img \
       focal-server-cloudimg-amd64-cloudcix-raw.img \
       jammy-server-cloudimg-amd64-cloudcix.img \
       jammy-server-cloudimg-amd64-cloudcix-raw.img \
       noble-server-cloudimg-amd64-cloudcix.img \
       noble-server-cloudimg-amd64-cloudcix-raw.img

overlays:
	mkdir -p overlays/focal
	mkdir -p overlays/noble
	mkdir -p overlays/jammy

focal-server-cloudimg-amd64-cloudcix-raw.img: focal-server-cloudimg-amd64.img overlays $(overlay_focal) ${keys_path} ${deb_focal} setup-scripts/focal.sh
	qemu-img convert -O raw $< $@
	install -D -o root ${deb_focal} -t overlays/focal/root/
	install -D -o root ${keys_path} -t overlays/focal/root/.ssh/
	bin/overlayimage $@ overlays/focal
	bin/chrootscript $@ setup-scripts/focal.sh

focal-server-cloudimg-amd64-cloudcix.img: focal-server-cloudimg-amd64-cloudcix-raw.img
	qemu-img convert -O qcow2 $< $@


jammy-server-cloudimg-amd64-cloudcix-raw.img: jammy-server-cloudimg-amd64.img overlays $(overlay_jammy) ${keys_path} ${deb_jammy}} setup-scripts/jammy.sh
	qemu-img convert -O raw $< $@
	install -D -o root ${deb_jammy} -t overlays/jammy/root/
	install -D -o root ${keys_path} -t overlays/jammy/root/.ssh/
	bin/overlayimage $@ overlays/jammy
	bin/chrootscript $@ setup-scripts/jammy.sh

jammy-server-cloudimg-amd64-cloudcix.img: jammy-server-cloudimg-amd64-cloudcix-raw.img
	qemu-img convert -O qcow2 $< $@


noble-server-cloudimg-amd64-cloudcix-raw.img: noble-server-cloudimg-amd64.img overlays $(overlay_noble) ${keys_path} ${deb_noble} setup-scripts/noble.sh
	qemu-img convert -O raw $< $@
	install -D -o root ${deb_noble} -t overlays/noble/root/
	install -D -o root ${keys_path} -t overlays/noble/root/.ssh/
	bin/overlayimage $@ overlays/noble
	bin/chrootscript $@ setup-scripts/noble.sh

noble-server-cloudimg-amd64-cloudcix.img: noble-server-cloudimg-amd64-cloudcix-raw.img
	qemu-img convert -O qcow2 $< $@


clean:
	rm -f $(IMAGES)

focal-server-cloudimg-amd64-stick.img: focal-server-cloudimg-amd64-install.img
