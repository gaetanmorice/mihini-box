# Overview #

This project aimed to provide an easy way to set up a virtual machine running the [Mihini agent](http://www.eclipse.org/mihini/). To do so it relys on [Vagrant](http://www.vagrantup.com/) and [Puppet](https://puppetlabs.com/puppet/what-is-puppet/).

# Installation #

1. First you have to install Vagrant on your PC, please refer to Vagrant's [documentation](http://docs.vagrantup.com/v2/installation/index.html).

2. Then you have to install the default box (Ububtu Precise 32), using the folowing command:  `vagrant box add precise32 http://files.vagrantup.com/precise32.box`

3. You can now clone the project

4. In the project directory, type: `vagrant up` this will start the box and install the Mihini agent.

5. After this first install you have to restart the box, `vagrant halt`

If you want to uninstall the box, just use `vagrant destroy`, you can install it again with `vagrant up`

# Use #

Once it is installed, go in the project directory.

1. you can use `vagrant up` to restart the VM.

2. Connect to the box: `vagrant ssh`.

3. Once you are conencted, you can configure the agent through the local telnet connexion: `telnet localhost 2000`.

4. Use the agent.


# TODO #

* manage network of the VM (to create other boxes, to ease access from Koneki IDE, to access external M3DA servers).
* create a specific user for the agent.
* create a box for the M3DA server.
* improve the puppet script to properly handle daemons and git updates.
