# Vagrant Ubuntu 14.04 Puppet Dropwizard

Simple example showing how to provision a Ubuntu 14.04 VM with Java Dropwizard application running as a service using Vagrant and Puppet.

Created and tested on Mac OSX 10.9.5, Vagrant 1.6.3, VirtualBox 4.3.6, otherwise using versions/boxes given in VagrantFile and Puppet config.


## Start

```
# Compile the dropwizard fat jar and copy into custom puppet module for deployment
./build_and_copy_to_puppet.sh
# Starts up VM and runs puppet to setup, downloading box if necessary
vagrant up
# Dropwizard Service should be accessible on http://192.168.33.10:8080, use postman to make a GET request to /user
```

Run local:

```
./run_local.sh
```


## Details

Used [puppetlabs-java](https://forge.puppetlabs.com/puppetlabs/java) v1.1.2 module to puppetize installing java, added using:

```
puppet module install puppetlabs-java  --modulepath puppet/modules
```

On the version of ubuntu box I had the java module failed due to missing dependencies and needed to run 'sudo apt-get update' to find them. I added this to the vagrant script using a shell provisioner, though a better solution would be either run in puppet before java class or directly include all packages.

I have created a custom module, dropwizard_service, to copy the dropwizard jar, config and upstart script to the server, then ensure the dropwizard service is running and will restart on changes to the jar or config.


## Possible improvements

* It would be better to package the jar and upstart script into a rpm or deb and install that way, and use hieradata to template and setup the config file or config overrides, gradle has a plugin to do this
* Should reuse the upstart script as a separate module to allow multiple dropwizard services
* Puppet takes a very long time to install java at the "Executing '/usr/bin/apt-get -q -y -o DPkg::Options::=--force-confold install openjdk-7-jre'" stage, not sure why
* Puppet tests!


## Notes

This is a bare bones example and does not include any security or configuration best practise, so do not use in production.

Any change to the puppet files requires you to run 'vagrant provision' to update.