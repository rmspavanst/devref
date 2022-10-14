$ sudo dnf install -y epel-release
$ sudo dnf update
$ sudo dnf install ansible -y
$ ansible --version
$ pip install pywinrm (for windows host)


Create a new user called ansible and assign it to sudo group
$ adduser ansible
 $ passwd ansible
 $ usermod -aG wheel ansible
 
Login as ansible and allow sudo access without password for the login user in Remote Machine for Ansible to run any root commands
$ su ansible
$ echo "$(whoami) ALL=(ALL) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/$(whoami)

Preparing Debian 10 Remote Machine
$ sudo adduser ansible
$ sudo usermod -aG sudo ansible #add to sudo group
$ getent group sudo #check the member of sudo group
sudo:x:27:kwyong,ansible

$ su ansible
$ echo "$(whoami) ALL=(ALL) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/$(whoami)

Prepare SSH Key
Stitch to ansible and generate a new SSH key to be deployed to remote machine

$ su ansible
$ ssh-keygen
$ ssh-copy-id ansible@ipaddr

# SSH Agent to avoid typing password for private key file
$ ssh-agent $SHELL
$ ssh-add #Enter your password for Private Key
$ ssh ansible@debian.aventis.dev # no password is required now


Create an Ansible Inventory File in /home/ansible
$ nano hosts

[debian]
debian.aventis.dev ansible_user=ansible
[centos]
192.168.1.114 ansible_user=ansible

List all hosts defined
$ ansible -i hosts --list-hosts all

Verify the hosts are active with PING
$ ansible -i hosts -m ping all


Verify PowerShell, .NET and set up WinRM
-----------------------------------------

1. verify PowerShell version

Get-Host | Select-Object Version

2. verify .NET version

Get-ChildItem 'HKLM:\SOFTWARE\Microsoft\NET Framework Setup\NDP' -Recurse | Get-ItemProperty -Name version -EA 0 | Where { $_.PSChildName -Match '^(?!S)\p{L}'} | Select PSChildName, version

3. Verify WinRM not-configured

winrm get winrm/config/Service

4. Setup WinRM

[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$url = "https://raw.githubusercontent.com/ansible/ansible/devel/examples/scripts/ConfigureRemotingForAnsible.ps1"
$file = "$env:temp\ConfigureRemotingForAnsible.ps1"
(New-Object -TypeName System.Net.WebClient).DownloadFile($url, $file)
powershell.exe -ExecutionPolicy ByPass -File $file

5. Verify WinRM configured

winrm get winrm/config/Service
winrm get winrm/config/Winrs
winrm enumerate winrm/config/Listener


inventory:
------------

[windows]
windows10 ansible_host=192.168.0.59
[windows:vars]
ansible_user=ansible
ansible_password=SuperSecurePassword123@
ansible_port=5986
ansible_connection=winrm
ansible_winrm_transport=basic
ansible_winrm_server_cert_validation=ignore


win_ping.yml
------------
---
- name: win_ping module demo
  hosts: windows
  become: false
  gather_facts: false
  tasks:
    - name: test connection
      ansible.windows.win_ping: