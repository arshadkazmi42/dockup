# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|

  config.vm.network "forwarded_port", guest: 4000, host: 4000

  config.vm.box = "ubuntu/trusty64"
  config.vm.provision "shell", inline: <<-SHELL
    echo 'LC_ALL="en_US.UTF-8"'  >  /etc/default/locale
    cd /home/vagrant

    # Install Elixir
    wget http://packages.erlang-solutions.com/erlang-solutions_1.0_all.deb && sudo dpkg -i erlang-solutions_1.0_all.deb
    wget -qO- https://deb.nodesource.com/setup_6.x | sudo bash
    sudo apt-get update
    sudo apt-get install -y postgresql
    sudo apt-get install -y nodejs build-essential
    sudo apt-get install -y esl-erlang
    sudo apt-get install -y elixir

    sudo -u postgres createuser -s vagrant

    sudo apt-get install -y curl

    # Install docker
    curl -sSL https://get.docker.com/ | sh
    sudo usermod -aG docker vagrant

    # Install docker compose
    sudo sh -c "curl -L https://github.com/docker/compose/releases/download/1.7.1/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose"
    sudo chmod +x /usr/local/bin/docker-compose
  SHELL

end
