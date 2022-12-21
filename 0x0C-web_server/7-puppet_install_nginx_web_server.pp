# File that installs nginx, and sets it up to have a custome header
$doc_root = "/var/www/html"

exec { 'apt-get update':
  command => '/usr/bin/apt-get update',
}

package { 'nginx':
  ensure  => "installed",
  require => Exec['apt-get update'],
}

file { ["/var/www/","/var/www/html"]:
  ensure => "directory",
  owner  => "www-data",
  group  => "www-data",
  mode   => "0644",
}

file { "$doc_root/index.html":
  ensure  => "present",
  content => "Hello World!",
  require => File[$doc_root],
}

file { "/etc/nginx/sites-available/default":
  ensure => "present",
  content => "server {
    listen 80;
    listen [::]:80 default_server;
    root   /var/www/html;
    index  index.html index.htm;

    location /redirect_me {
      return 301 https://www.youtube.com/watch?v=QH2-TGUlwu4;
    }
  }",
  notify => Service['nginx'],
  require => Package['nginx'],
}

service { 'nginx':
  ensure => running,
  enable => true,
}
