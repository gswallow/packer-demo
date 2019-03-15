Packer demo
===========

This Git repository is (hopefully) helpful if you've never used [Packer][packer].  Packer is a tool you can use to
create VMware templates, AWS AMIs, Vagrant boxes, and other "gold-image" artifacts.

What's most important about Packer is that it's an "Infrastructure-as-Code" tool.  By using Packer properly, with a
version control system and a CI/CD platform, you can predictably create *trusted* images.  There are two primary 
benefits to using packer: you shorten the time to delivery for your infrastructure (most things are pre-baked), and 
you eliminate random errors or discrepancies you'd encounter if you were still bulding VMs by hand (even following a script).

## Comparable practices

Maybe your organization is still porting "gold images" forward. You know the drill:

1. clone a VM from template.  Maybe rename the VM if it's going to do something special like have Perl installed.  Yes, really.
1. customize or patch the new VM by logging in with the organizational root password, and run commands by hand.
1. shut down the VM and convert it back to a template.

This is a model for failure.  First, you have no version control mecahnisms where you can roll back, or at least assign blame.
Second, you have introduced many avenues for human error.

Or, maybe you've gone completely the opposite direction and you only use vanilla EC2 instances.  The procedure here is:

1. fire up the new EC2 instance.  Maybe you do this by hand or maybe AWS Autoscaling does this for you.
1. set up user-data to kick off Chef/Puppet/Ansible pull/Salt/etc.

This is also a model for failure, in at least two ways.  First, bootstrapping new instances with a confiruation managemnt
system is slow.  Second, continually configuring your boxes is highly susceptible to transient, network-related failures.

Proper use of Packer mitigates these failures.  Combined with a test platform, you can create predictable boxes at
regular intervals, cutting down on bootstrap time.

## What will we do today?

Today, we will build a Windows Server 2019 image.  For free, we will create a Vagrant box from it.  We will 
spin up the Vagrant box and show how easy it is to control the resulting Vagrant box.

We may also spin up a VMware template on a vSphere cluster.  VMware is not free,  but here's where the rubber hits 
the road.  By controlling your VMware templates as code, you can signficantly improve the predictability of how your 
machines run.  Note that Packer doesn't just work with VMware.  It works with major cloud providers, too.

## Building images is not easy

Packer is an easy tool to use, but the process of automating operating system installs is NOT easy.  While you're working
with Packer, you will encounter many quirks with each OS installer.  You will also probably encounter many quirks with 
different hypervisors, and even cloud providers.

## Prerequisites

To go through the simplest demo in this tutorial, you need:

- [Oracle VirtualBox][oracle virtualbox]
- [Packer][packer-download]
- [Vagrant][vagrant]

On OS X, install with [homebrew][brew]:

```bash
brew cask install virtualbox
brew install packer
brew cask install vagrant
```

## Simple How-To

Currently, there's a single directory that demonstrates how to spin up Windows Server 2019 from an eval ISO 
image.  Assuming you have virtualbox and packer installed, change into the `windows_2019` directory and build the 
`local.json` template:

```bash
cd windows_2019
packer build -var-file=local.vars local.json
```

Packer is going to fire up VirtualBox through its `vboxmanage` CLI tool, create a VM, map ISO images to it, 
dynamically create a floppy image and map that, and then boot the VM.  Because this demo focuses on Windows
VMs, the floppy image contains an "Autounattend.xml" file that will control the rest of the process.  What Packer 
sticks around for is an IP address.  Once it knows which IP address the VM is using, it will fire up its 
"communicator" to finish its job, and eventually shut down the VM using its communicator.

In this example, the communicator is Windows Remote Management, or WinRM.  Linux boxes use ssh.

## Windows Customization

An introduction to installing Windows in an unattended fashion (in fact, the introduction t
hat I used while creating this demo), is available [here][sheksha].  After reading the friendly 
introduction, it would be worth your time to read Microsoft's [unattended Windows setup reference][unattended ref] 
and the [Windows System Image Manager Technical Reference][wsim ref].

## Topics to cover

- Input variables and environment variables
- Builders (Virtualbox & vSphere)
  - VirtualBox
  - VMware
  - AWS
- Unattended install methods for different operating sytems
  - Autounattend.xml and WSIM
  - Red Hat Kickstart
  - Debian Installer
- Provisioners
- Communicators
- Post-processors
- Vagrant
  - vagrant boxes
  - vagrant init
  - vagrant up
  - vagrant destroy
  - vagrant ssh
  - vagrant rdp
  - vagrant winrm
  - vagrant plugins

## Vagrant Boxes

Vagrantfile.tpl

## VMware vSphere
https://github.com/jetbrains-infra/packer-builder-vsphere

[brew]: https://brew.sh
[packer]: https://packer.io
[packer-download]: https://packer.io/downloads.html
[sheksha]: https://sheska.com/how-to-create-an-automated-install-for-windows-server-2019/
[oracle virtualbox]: https://www.virtualbox.org/wiki/Downloads
[unattended ref]: https://docs.microsoft.com/en-us/windows-hardware/customize/desktop/unattend/
[wsim ref]: https://docs.microsoft.com/en-us/windows-hardware/customize/desktop/wsim/windows-system-image-manager-technical-reference
[vagrant]: https://www.vagrantup.com/downloads.html
