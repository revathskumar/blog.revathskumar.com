---
layout: post
title: "PHP : Deploy Yii app using capistrano"
excerpt: "PHP : Deploy Yii app using capistrano"
date: 2015-05-15 00:00:00 IST
updated: 2015-05-15 00:00:00 IST
categories: php
tags: php, yii, capistrano
---

When I was Rails developer I used to deploy using capistrano with a single command 

```sh
cap production deploy
```

But when I came to PHP development, the old FTP drag and drop welcomed me and I was like WTF?. I couldn't agree to this since It takes too much of time of development. So i decided to setup capistrano for my Yii project.

Since I was a ruby developer all the ruby and cap setup was already there in my laptop. But I need to install these things in server.

## Setting up server

### Installing ruby, git and capistrano

Fist step to setting up server for cap deployment is install ruby and git. I usually install ruby using [Ruby Version Manager (rvm)](http://rvm.io). It helps me to manage the ruby versions.

```sh
apt-get install -y build-essential git-core libyaml-dev 
 
gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
curl -L get.rvm.io | bash -s stable
 
source /home/lookup/.rvm/scripts/rvm
rvm reload
rvm install 2.2.2
 
gem install capistrano --no-ri --no-rdoc
```

#### Add a usergroup and user for deployment.

After installing ruby and git, we need to add a new usergroup and user for deployment and give appropriate permissions for the deployment directory. I used the default `/var/www` directory for the deployment.

```sh
sudo addgroup www # create a new usergroup
sudo adduser deploy # create a new user
sudo adduser deploy www # add deploy user to www group
```
Since apache will run as `www-data` user we need to add `www-data` to our newly created user group.

```sh
sudo adduser www-data www
```

Now we need to give appropriate permission for the usergroup.

```sh
# open /etc/sudoers
deploy ALL=(ALL:ALL) ALL
 
# Set the ownership of the folder to members of `www` group
sudo chown -R :www  /var/www
 
# Set folder permissions recursively
sudo chmod -R g+rwX /var/www
 
# Ensure permissions will affect future sub-directories etc.
sudo chmod g+s /var/www
```

Now our server is ready for deployment. Next we need to setup our project.

## Setting up Yii project for cap deployment

Yii uses different config files for `cli` app (`console.php`) and `web` app (`main.php`). We need to unify the common configuration into one file. So we will create a `config.php` and `require` it in both `main.php` and `console.php`. 

```php
<?php
# config.php
$config = array();

$db_name = 'sample';
$db_host = 'localhost';
$db_user = 'root';
$db_pass = '';

$config = array(
  'adminEmail' => 'admin@example.com',
  'statusEmails' => array('admin@example.com', 'team@example.com'),
  'accessToken' => '',
);

?>
```

`$config` is used for custom configuration values. Since I don't want `git` to show configuration file as changes during development, I renamed `config.php` to `config.php.example` and added `config.php` to `.gitignore`. So when I start development I will copy `config.php.example` to `config.php` and fill in the local configuration values. 

Now add `.gitkeep` file to `assets/` and `protected/runtime/` folder and add to git. This will make sure the folders exists on when capistrano pull code from git repository.

### Configure capistrano

Next step is to configure capistrano for the deployment. If you don't have ruby and capistrano in you local machine install those bu following the same steps we used to setup server. Initialize capistrano in the project directory using 

```sh
cap init
```

It will create a `config` directory along with configuration files. In `config/deploy.rb` update the appropriate values for `:application`, `:repo_url` and `:deploy_to` settings.

```ruby
set :application, 'project'
set :repo_url, 'git@github.com:example/project.git'

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, '/var/www/example'
```

The default values for linked_directories will be set for rails so we removed those and set for Yii application.

```ruby
# Default value for linked_dirs is []
set :linked_dirs, fetch(:linked_dirs, []).push('assets/','protected/runtime')
```

Now we need to specify the production and staging server in the appropriate config file.
In `config/deploy/production.rb` set the production server ip or domain name.

```ruby
server 'example.com', user: 'deploy', roles: %w{app}

role :app, %w{deploy@example.com}
```

and for staging, update `config/deploy/staging.rb` same as we did for production.

```ruby
server 'staging.example.com', user: 'deploy', roles: %w{app}

role :app, %w{deploy@staging.example.com}
```

The basic setup for the deployment of our Yii app is ready. but thats not enough we need to update the production and staging configuration on server for respective deployments.

In rails we used to put the configuration in the shared folder and symlink to current deployment. This doesn't work in Yii application. It will throw an path error if you try to do so. So we need to upload the production configuration directly to current deployment.

### Custom rake task to upload configuration.

For uploading production and staging configuration first we need them separately in our development machine. I put my production configuration in `protected/config/config-production.php` and added to `.gitignore` so I won't add those to git by mistake. Same way for staging I put staging configuration in `protected/config/config-staging.php` and added to `.gitignore`.

In order to upload the configuration, we need to write the custom rake task. The `cap init` command have created `lib/capistrano/tasks` folder for it.

```ruby
# lib/capistrano/tasks/custom.rake
namespace :db_access do
  desc 'Copy production config.php from local workstation'
  task :copy_production => :production do
    on roles :app do
      upload! 'protected/config/config-production.php', "#{release_path}/protected/config/config.php"
    end
  end

  task :copy_staging => :staging do
    on roles :app do
      upload! 'protected/config/config-staging.php', "#{release_path}/protected/config/config.php"
    end
  end
end
```
This task will upload our configuration to appropriate serves into the path `/protected/config/config.php`. Now we need to tell capistrano to run this task after deployment is finished. To do this in `config/deploy/production.rb` add the following line 

```ruby
after 'deploy:finishing', 'db_access:copy_production'
```

and for staging add the following line in `config/deploy/staging.rb`. 

```ruby
after 'deploy:finishing', 'db_access:copy_staging'
```

### Run Database migration

So now we have the production configuration along with db credentials are in place. Now it time for database migration. Yii supports running migration from commandline using `yiic migrate` command. Now we need to run it on server using a custom rake task. so we will add

```ruby
  task :migrate do
    on roles :app do
      execute "#{release_path}/protected/yiic migrate --interactive=0"
    end
  end
```
in `lib/capistrano/tasks/custom.rake` with in `:db_access` namespace. now our `custom.rake` will look like 

```ruby
# lib/capistrano/tasks/custom.rake
namespace :db_access do
  desc 'Copy production config.php from local workstation'
  task :copy_production => :production do
    on roles :app do
      upload! 'protected/config/config-production.php', "#{release_path}/protected/config/config.php"
    end
  end

  task :copy_staging => :staging do
    on roles :app do
      upload! 'protected/config/config-staging.php', "#{release_path}/protected/config/config.php"
    end
  end

  task :migrate do
    on roles :app do
      execute "#{release_path}/protected/yiic migrate --interactive=0"
    end
  end
end
```

So our task is ready. Now we need to run soon after our configuration uploading of respective server finishes. To do that in production server add

```ruby
after 'deploy:copy_production', 'db_access:migrate'
```

in `config/deploy/production.rb` and for staging server add 

```ruby
after 'deploy:copy_staging', 'db_access:migrate'
```

in `config/deploy/staging.rb`. 

Done. We just finished the whole setup and ready to deploy our Yii application with capistrano. Now you can run

```sh
cap production deploy
```

for deploying production server and 

```sh
cap staging deploy
```

for deploying application in staging server.