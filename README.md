Packer demo
===========

This Git repository is (hopefully) helpful if you've never used [Packer][packer].  Packer is a tool you can use to
create VMware templates, AWS AMIs, Vagrant boxes, and other "gold-image" artifacts.

What's most important about Packer is that it's an "Infrastructure-as-Code" tool.  By using Packer properly, with a
version control system and a CI/CD platform, you can predictably create *trusted* images.  There are two primary 
benefits to using packer: you shorten the time to delivery for your infrastructure (most of the heavy lifting is
pre-baked), and you eliminate random errors or discrepancies you'd encounter if you were still building VMs by 
hand (even following, or copy-pasting, a script).

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

## Vagrant Boxes

Vagrantfile.tpl

## VMware vSphere
https://github.com/jetbrains-infra/packer-builder-vsphere

[brew]: https://brew.sh
[debian-installer-ref]: https://help.ubuntu.com/18.04/installation-guide/amd64/apb.html
[kickstart-ref]: https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/7/html/installation_guide/chap-kickstart-installations
[packer]: https://packer.io
[packer-builders]: https://packer.io/docs/builders/index.html
[packer-communicators]: https://www.packer.io/docs/templates/communicator.html
[packer-download]: https://packer.io/downloads.html
[packer-postprocessors]: https://www.packer.io/docs/post-processors/index.html
[packer-provisioners]: https://packer.io/docs/provisioners/index.html
[sheksha]: https://sheska.com/how-to-create-an-automated-install-for-windows-server-2019/
[oracle virtualbox]: https://www.virtualbox.org/wiki/Downloads
[unattended ref]: https://docs.microsoft.com/en-us/windows-hardware/customize/desktop/unattend/
[wsim ref]: https://docs.microsoft.com/en-us/windows-hardware/customize/desktop/wsim/windows-system-image-manager-technical-reference
[vagrant]: https://vagrantup.com
[vagrant-download]: https://www.vagrantup.com/downloads.html
