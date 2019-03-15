Packer demo
===========

Prerequisites: 
- [Oracle VirtualBox][oracle virtualbox]
- [Packer][packer]
- [Vagrant][vagrant]

On OS X, install with [homebrew][brew]:

```bash
brew cask install virtualbox
brew install packer
brew cask install vagrant
```

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
[packer]: https://packer.io/downloads.html
[sheksha]: https://sheska.com/how-to-create-an-automated-install-for-windows-server-2019/
[oracle virtualbox]: https://www.virtualbox.org/wiki/Downloads
[unattended ref]: https://docs.microsoft.com/en-us/windows-hardware/customize/desktop/unattend/
[wsim ref]: https://docs.microsoft.com/en-us/windows-hardware/customize/desktop/wsim/windows-system-image-manager-technical-reference
[vagrant]: https://www.vagrantup.com/downloads.html
