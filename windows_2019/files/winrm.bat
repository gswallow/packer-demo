@echo off
rem Set up WinRM
cmd.exe /c winrm quickconfig -q 
cmd.exe /c winrm quickconfig -transport:http
cmd.exe /c winrm set winrm/config @{MaxTimeoutms="1800000"}
cmd.exe /c winrm set winrm/config/winrs @{MaxMemoryPerShellMB="300"}
cmd.exe /c winrm set winrm/config/service/auth @{Basic="true"}
cmd.exe /c winrm set winrm/config/service @{AllowUnencrypted="true"}
cmd.exe /c winrm set winrm/config/service @{MaxConcurrentOperationsPerUser="150"}
cmd.exe /c winrm set winrm/config/winrs @{MaxShellsPerUser="100"}
cmd.exe /c winrm set winrm/config/winrs @{MaxProcessesPerShell="100"}

rem Enable ping and WinRM ports
cmd.exe /c netsh advfirewall firewall set rule name="File and Printer Sharing (Echo Request - ICMPv4-In)" new enable=yes
cmd.exe /c netsh advfirewall firewall set rule name="Remote Desktop (TCP-In)" new enable=yes
cmd.exe /c netsh advfirewall firewall set rule group="remote administration" new enable=yes
cmd.exe /c netsh advfirewall firewall add rule name="WinRM HTTP (TCP-In)" protocol=TCP dir=in localport=5985 action=allow
cmd.exe /c netsh advfirewall firewall add portopening TCP 5985 "Port 5985"
cmd.exe /c netsh advfirewall firewall add portopening TCP 5986 "Port 5986"

rem Disable the network discovery dialogue on login
cmd.exe /c reg add "HKLM\SYSTEM\CurrentControlSet\Control\Network\NewNetworkWindowOff" /f
cmd.exe /c netsh advfirewall firewall set rule group="Network Discovery" new enable=yes

rem Relax the powershell execution policy
cmd.exe /c powershell.exe -Command "Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Force"

rem Configure NTP
cmd.exe /c sc config w32time start= auto

rem Enable WinRM
cmd.exe /c sc config winrm start= auto
