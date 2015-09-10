# Rails with Capistrano

A sample application to demonstrate deployment of Capistrano driven Rails apps in [Dockbit](https://dockbit.com). The guide below describes how to prepare a target server and also may be used as a starter kit for running Rails applications in a single server environment. It is built upon [Ubuntu 14.04](http://releases.ubuntu.com/14.04/) with the following components:

* [Unicorn](http://unicorn.bogomips.org/) Web server with an init script and zero-downtime configuration
* [Nginx](http://nginx.org/) Proxy with a production like settings and optional SSL
* [Log rotation](http://www.linuxcommand.org/man_pages/logrotate8.html) with sane defaults
* [Capistrano](http://capistranorb.com/) recipes for Rails applications

## Preparing target server

### Update server info

Open [config/deploy/production.rb](./config/deploy/production.rb) and ```set :host_name``` to FQDN of your target server.

### Create deployment user

	useradd deployer -m -s /bin/bash
	passwd deployer # Remember password, you'll need it later
	echo 'deployer ALL=NOPASSWD: ALL' >> /etc/sudoers
	su - deployer

### Install dependencies

	sudo apt-get -y update
	sudo apt-get -y install nginx git-core curl zlib1g-dev build-essential libssl-dev libreadline-dev libyaml-dev libsqlite3-dev sqlite3 libxml2-dev libxslt1-dev libcurl4-openssl-dev python-software-properties libffi-dev

### Install Javascript Runtime

	sudo add-apt-repository -y ppa:chris-lea/node.js
	sudo apt-get -y update
	sudo apt-get -y install nodejs

### Install Rbenv

	cd
	git clone git://github.com/sstephenson/rbenv.git .rbenv
	echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bash_profile
	echo 'eval "$(rbenv init -)"' >> ~/.bash_profile

	git clone git://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build
	echo 'export PATH="$HOME/.rbenv/plugins/ruby-build/bin:$PATH"' >> ~/.bash_profile
	source ~/.bash_profile

### Install Ruby and Bundler

	rbenv install -v 2.2.2
	rbenv global 2.2.2
	gem install bundler --no-ri --no-rdoc
	rbenv rehash

### Set up credentials

Finally, you need to provide Rails secret key base as an environment variable. Run this command from within your Rails application on your machine:
	
	echo "export SECRET_KEY_BASE=\"$(bundle exec rake secret)\"" | ssh deployer@FQDN_OF_YOUR_SERVER 'cat >> ~/.bash_profile'

You now have a target server and can proceed adding it to your deployment pipeline in Dockbit.

## License

See the [LICENSE](LICENSE.md) file for license rights and limitations (MIT).

