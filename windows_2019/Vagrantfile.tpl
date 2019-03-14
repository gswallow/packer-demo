Vagrant.configure("2") do |config|
  config.vm.box = "windows2019"
  config.vm.guest = :windows
  config.vm.network "forwarded_port", guest: 3389, host: 3389, auto_correct: true
  config.vm.communicator = "winrm"
  config.winrm.username = "Administrator"
  config.winrm.password = "ChangeM3!!!"
  config.vm.provider "virtualbox" do |vb|
    vb.gui = false
    vb.cpus = 2
    vb.memory = "2048"
  end
end
