#!/bin/sh
dpkg -i --auto-deconfigure /root/cloud-init_24.2-0ubuntu2~24.04.2_all.deb
cat <<EOF > /etc/cloud/cloud.cfg.d/90_dpkg.cfg
# to update this file, run dpkg-reconfigure cloud-init
datasource_list: [ NoCloud, ConfigDrive, OpenNebula, DigitalOcean, Azure, AltCloud, OVF, MAAS, GCE, OpenStack, CloudSigma, SmartOS, Bigstep, Scaleway, AliYun, Ec2, CloudCIX, CloudStack, Hetzner, IBMCloud, Oracle, Exoscale, RbxCloud, UpCloud, VMware, Vultr, LXD, NWCS, Akamai, WSL, None ]
EOF
