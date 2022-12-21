# File that installs nginx, and sets it up to have a custome header
$doc_root = "/var/www/html"

exec { 'apt-get update':
  command => '/usr/bin/apt-get update',
}

package { 'nginx':
  ensure  => "installed",
  require => Exec['apt-get update'],
}

file { $doc_root:
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

file { "$doc_root/404.html":
  ensure  => "present",
  content => "Ceci n'est pas une page",
  require => File[$doc_root],
}

file { "/etc/nginx/sites-available/default":
  ensure => "present",
  content => "server {
    listen 80;
    listen [::]:80 default_server;
    add_header X-Served-By $trusted['hostname'];
    root   /var/www/html;
    index  index.html index.htm;

    location /redirect_me {
      return 301 https://www.youtube.com/watch?v=QH2-TGUlwu4;
    }

    error_page 404 /404.html;
    location /404 {
      root /var/www/html;
      internal;
    }
  }",
  notify => Service['nginx'],
  require => Package['nginx'],
}

service { 'nginx':
  ensure => running,
  enable => true,
}
