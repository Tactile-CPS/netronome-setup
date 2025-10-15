# Netronome System Setup Guide

This guide provides a step-by-step procedure to set up the Netronome Agilio SmartNIC on an Ubuntu host.

## Prerequisites
- Hardware
	- Netronome Agilio CX 2x10GbE SmartNIC
	- Host system with PCIe slot
	- VT-x Virtualization support on Motherboard and CPU

## 1. New System Initialization
- OS configuration
	- Install Ubuntu 18.04 OS
		- The OS comes with Linux kernel 5.4 by default
	- Install kernel 4.15
	- Enable Virtualization support in the kernel
		```
		# Edit /etc/default/grub to have the following line
		GRUB_CMDLINE_LINUX_DEFAULT="quiet splash intel_iommu=on iommu=pt"
		```
	- Reboot the system and enable VT-x virtualization in Motherboard settings
	- Reboot to kernel 4.15
- Install Netronome packages
	- Get packages from official Netronome website
	- Install the packages
	- Install NFP oot driver
		- Replaces pre-loaded nfp driver from kernel

## 2. Environment Setup after every boot
These steps must be done after every system reboot to prepare the environment.
- Reload nfp module with P4 support
```
sudo modprobe -rv nfp
sudo modprobe -v nfp nfp_dev_cpp=1  # nfp_pf_netdev=0

# Check status
sudo /opt/netronome/bin/nfp-nffw status

## Output
# Execution success:
Firmware loaded: Yes/No
Debugger attached: No
...

# Execution failed:
Failed to open NFP device 0
nfp-nffw: Command 'status' failed
```
- Enable communication between NFP and host 
```
# Start NFP Run Time Environment (RTE) service
sudo systemctl start nfp-sdk6-rte.service
# Check status
sudo systemctl status nfp-sdk6-rte.service
```
```
# Execution success:
Active: failed (Result: core-dump)
Oct 14 19:03:56 zenlab pif_rte[2321]: Starting gRPC server.
Oct 14 19:03:56 zenlab pif_rte[2321]: [E] RTE: 2025-10-14 19:03:56.834 - nfp_pif.c:150: Invalid handl
Oct 14 19:03:56 zenlab pif_rte[2321]: terminate called without an active exception
Oct 14 19:03:56 zenlab systemd[1]: nfp-sdk6-rte.service: Main process exited, code=dumped, status=6/A
Oct 14 19:03:56 zenlab systemd[1]: nfp-sdk6-rte.service: Failed with result 'core-dump'.

# Execution failed:
Active: active (running)
Oct 14 19:04:48 zenlab pif_rte[2452]: Starting gRPC server.
Oct 14 19:04:48 zenlab pif_rte[2452]: Server listening on 0.0.0.0:50051
```

## 3. Running Programs
Once the environment is ready, use these steps to run your P4 programs
```
# Compile P4 program to generate firmware executable (nffw)
sudo /opt/netronome/p4/bin/nfp4build -o outputfile.nffw -p out_dir -4 basic-forward.p4 -l lithium --nfp4c_I /opt/netronome/p4/include/16/p4include/ --nfp4c_p4_version 16

# Load firmware to NFP
sudo /opt/netronome/p4/bin/rtecli design-load -f outputfile.nffw -p out_dir/pif_design.json

# Upload Match-Action Table (MAT) rules
./basic-forward-p4-rules.sh

# Check status by reading nfp-generated logs(optional)
tail -f /var/log/nfp-sdk6-rte.log
```

