https://medium.com/@JohnFoderaro/how-to-set-up-a-local-linux-environment-with-vagrant-163f0ba4da77


https://github.com/patrickdlee/vagrant-examples


https://medium.com/design-and-tech-co/end-to-end-automated-environment-with-vagrant-ansible-docker-jenkins-and-gitlab-32bb91fbee40


https://computingforgeeks.com/how-to-install-vagrant-on-centos-rhel-linux/

https://computingforgeeks.com/run-centos-8-vm-using-vagrant-on-kvm-virtualbox-vmware-parallels/






vagrant up (o turn your VM on, navigate to the directory with your Vagrantfile)
vagrant ssh
vagrant suspend (to pause your VM, navigate to the directory with your Vagrantfile)
vagrant halt (To turn your VM off, navigate to the directory with your Vagrantfile)
vagrant destroy (To destroy your VM, navigate to the directory with your Vagrantfile)
vagrant reload
vagrant resume




vagrant init centos/8 --minimal

Hyper-V:

Vagrant.configure("2") do |config|
  config.vm.box = "centos/8"
  config.vm.network "forwarded_port", guest: 80, host: 8080

  config.vm.provider "hyperv" do |hyperv|
    hyperv.memory = 2048
    hyperv.cpus = 2
  end
end

vagrant up --provider=hyperv

===============================================================================================
Vagrant.configure("2") do |config|
  config.vm.box = "jasonc/centos8"
  
  config.vm.define "test1" do |test1|
    test1.vm.hostname = "test1"
    test1.vm.network "private_network", ip: "10.9.8.5"
  end

  config.vm.define "test2" do |test2|
    test2.vm.hostname = "test2"
    test2.vm.network "private_network", ip: "10.9.8.6"
  end
end

=================================================================================================

Vagrant.configure("2") do |config|
  config.vm.box = "bento/rockylinux-9"

  config.vm.define "node1" do |node1|
    node1.vm.hostname = "node1"
    node1.vm.network "public_network"
    node1.vm.provider "hyperv" do |hyperv|
      hyperv.memory = 2048
      hyperv.cpus = 1
    end

    # Add three extra HDDs with specified sizes
    hdd_sizes = [2, 3, 4] # Sizes in gigabytes

    hdd_sizes.each_with_index do |size, index|
      node1.vm.provider "hyperv" do |disk|
        disk.customize [
          'modifyvm', :id, '--hdd', "node1_disk#{index + 1}.vhdx",
          '--size', size * 1024 # Convert GB to MB
        ]
      end
    end

    node1.vm.provision "shell", inline: <<-SHELL
      echo 'root:root' | chpasswd
      sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
      sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config
      systemctl restart sshd
    SHELL
  end
end