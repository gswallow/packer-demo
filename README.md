Packer demo
===========

## Slides

Slides are available [here][slides].  As of today (3/15/2019), this repository is a heavy work in progress.  Stay tuned.

## This repository

This Git repository is (hopefully) helpful if you've never used [Packer][packer].  Packer is a tool you can use to
create VMware templates, AWS AMIs, Vagrant boxes, and other "gold-image" artifacts.

What's most important about Packer is that it's an "Infrastructure-as-Code" tool.  By using Packer properly, with a
version control system and a CI/CD platform, you can predictably create *trusted* images.  There are two primary 
benefits to using packer: you shorten the time to delivery for your infrastructure (most of the heavy lifting is
pre-baked), and you eliminate random errors or discrepancies you'd encounter if you were still building VMs by 
hand (even following, or copy-pasting, a script).

You don't need Git to use this repository.  You can mash the "Clone or Download" button, and choose to download it to your local machine.  I'm a mac user, so working on Mac or Linux is going to be a huge help.  If you work in Windows, feel free to submit a pull request with instructions for Windows users.

## Building images is not easy

Packer is an easy tool to use, but the process of automating operating system installs is **NOT** easy.  While you're working with Packer, you will encounter many quirks with each OS installer.  You will also probably encounter many quirks with different hypervisors, and even cloud providers as you go along.

Each operating sytem has its own method of unattended install.  The most common ones are:

- Microsoft's [unattended Windows setup][unattended ref] and the [Windows System Image Manager Technical Reference][wsim ref]
- Red Hat's [kickstart][kickstart-ref]
- Debian's [debian-installer][debian-installer-ref]

## What will we do today?

Today, we will build a Windows Server 2019 image.  For free, we will create a [Vagrant][vagrant] box from it.  We will 
spin up the Vagrant box and demonstrate how easy it is to control the resulting Vagrant box.

We may also spin up a VMware template on a vSphere cluster.  VMware is not free,  but here's where the rubber hits 
the road.  By controlling your VMware templates as code, you can signficantly improve the predictability of how your 
machines run.  Note that Packer doesn't just work with VMware.  It works with major cloud providers, too.

## Prerequisites

To go through the simplest demo in this tutorial, you need:

- [Oracle VirtualBox][oracle virtualbox]
- [Packer][packer-download]
- [Vagrant][vagrant-download]
- Microsoft's [remote desktop][rdp] client

On OS X, install with [homebrew][brew]:

```bash
brew cask install virtualbox
brew install packer
brew cask install vagrant
```

## Simple How-To

Currently, there's a single example that demonstrates how to spin up Windows Server 2019 from an evaluation ISO 
image.  Assuming you have virtualbox and packer installed, change into the `windows_2019` directory and build the 
`local.json` template:

```bash
cd windows_2019
packer build -var-file=local.vars local.json
```

Packer is going to fire up VirtualBox through its `vboxmanage` CLI tool, create a VM, map the ISO image to it, 
dynamically create a floppy image and map that, and then boot the VM.  

The act of attaching ISO images and floppy drives is handled through a Packer [builder][packer-builders].  Builders
exist for several hypervisors including VirtualBox, VMware, vSphere, AWS EC2, and others.  Each hypervisor has 
its own ways of getting started.

The vFAT-formatted floppy image contains an `Autounattend.xml` file.  Windows installer uses this file to answer
questions during the install.  What Packer sticks around for is an IP address and a Windows Remote Management
service listening on TCP port 5986.  Once it knows which IP address the VM is using, it will fire up its 
[communicator][packer-communicators] to run additional scripts (called [provisioners][packer-provisioners]), 
shut down the built VM, and process the resulting artifact with a [post-processor][packer-postprocessors].

A post-processor does things like create Vagrant boxes from OVA/OVF formatted virtual machines, convert VMware
VMs to template, import images to Amazon Web Services or Google Cloud Platform, and so on.

This machine will take some time to build.  The ISO to download is 4.2 GB in size, and then there's the process
of installing and configuring Windows.  With luck, you'll get a Vagrant box from Packer.  There's a local-shell
provisioner at the end of the build that tells you how to use the Vagrant box.

## Running the Vagrant box

On a mac, `vagrant rdp` is buggy.  Be warned :)

```bash
cd $HOME
mkdir demo
cd demo
vagrant init windows2019
vagrant up
vagrant winrm -c 'dir C:/windows/'
vagrant rdp
vagrant destroy -f
```

## Where next?

See if you can use the [powershell][powershell] provisioner to install [bginfo][bginfo] on your own copy of the local packer template.

## VMware vSphere

This demo is intended for an audience with a sizeable VMware vSphere infrastructure.  To build VM images on vSphere, we use Jetbrains's [packer-builder-vsphere][jetbrains] plugins.

Using these plugins, you would set your `VSPHERE_USERNAME` and `VSPHERE_PASSWORD` environment variables, then supply a
variables file that specifies all of your vSphere settings, including the vCenter server, the locations of your ISO and flloppy images, the networks on which you'll launch your new VM, etc.  Obviously, this file should never be checked into 
Git:

```bash
export VSPHERE_USERNAME=vmware_dude
read -s VSPHERE_PASSWORD
# my super secret password
export VSPHERE_PASSWORD
packer build -var-file=$HOME/vsphere.vars vsphere.json
```

vSphere will create a new VM, attach the Windows installer ISO to it, attach a floppy image containing an Autounattend.xml file to it (see the floppy.sh script in this repository), and go through an unattended install.  Note that you must install VMware Tools for this builder to succeed.  ESXi relies on VMware Tools to report your VM's IP address back to Packer.

[bginfo]: https://docs.microsoft.com/en-us/sysinternals/downloads/bginfo
[brew]: https://brew.sh
[debian-installer-ref]: https://help.ubuntu.com/18.04/installation-guide/amd64/apb.html
[jetbrains]: https://github.com/jetbrains-infra/packer-builder-vsphere
[kickstart-ref]: https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/7/html/installation_guide/chap-kickstart-installations
[packer]: https://packer.io
[packer-builders]: https://packer.io/docs/builders/index.html
[packer-communicators]: https://www.packer.io/docs/templates/communicator.html
[packer-download]: https://packer.io/downloads.html
[packer-postprocessors]: https://www.packer.io/docs/post-processors/index.html
[packer-provisioners]: https://packer.io/docs/provisioners/index.html
[powershell]: https://packer.io/docs/provisioners/powershell.html
[sheksha]: https://sheska.com/how-to-create-an-automated-install-for-windows-server-2019/
[oracle virtualbox]: https://www.virtualbox.org/wiki/Downloads
[rdp]: https://itunes.apple.com/us/app/microsoft-remote-desktop-10/id1295203466?mt=12
[slides]: https://docs.google.com/presentation/d/1uoXa6XaKrI61iCpGVJoVLqVg_lH619hgjw1Nz-S0YkQ/edit?usp=sharing
[unattended ref]: https://docs.microsoft.com/en-us/windows-hardware/customize/desktop/unattend/
[wsim ref]: https://docs.microsoft.com/en-us/windows-hardware/customize/desktop/wsim/windows-system-image-manager-technical-reference
[vagrant]: https://vagrantup.com
[vagrant-download]: https://www.vagrantup.com/downloads.html
