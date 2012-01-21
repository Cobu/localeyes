# --- Install packages we need ---
package 'ntp'
package 'sysstat'
package 'nginx'
package 'mysql-server'
package 'mysql-client'
package 'libmysqlclient16-dev'
package 'locate'
package "curl"
package "git-core"
package "libbz2-dev"
package "geoip-database"
package "libgeoip1"
package "libpcre3-dev"
package "pdftk"
package "sendmail"
package "openssl"
package "xorg"
package 'xpdf-utils'

# --- Set host name ---
hostname = 'staging.localeyes.me'
rails_env = 'staging'

file '/etc/hostname' do
  content "#{hostname}\n"
end

service 'hostname' do
  action :restart
end

file '/etc/hosts' do
  content "127.0.0.1 localhost #{hostname}\n"
end

#bash "nginx" do
#  user "root"
#  config = <<-ME
#   --conf-path=/etc/nginx/nginx.conf \
#    --error-log-path=/var/log/nginx/error.log \
#    --pid-path=/var/run/nginx.pid \
#    --lock-path=/var/lock/nginx.lock \
#    --http-log-path=/var/log/nginx/access.log \
#    --with-http_dav_module \
#    --http-client-body-temp-path=/var/lib/nginx/body \
#    --with-http_ssl_module \
#    --http-proxy-temp-path=/var/lib/nginx/proxy \
#    --with-http_stub_status_module \
#    --http-fastcgi-temp-path=/var/lib/nginx/fastcgi \
#    --with-debug \
#    --with-http_flv_module
#  ME
#  code "wget http://nginx.org/download/nginx-1.0.5.tar.gz && tar zxvf nginx-1.0.5.tar.gz && cd nginx-1.0.5 && ./configure #{config} && make && make install"
#end
#template "/etc/init.d/nginx" do
#  source 'initd_nginx'
#end


bash "make deploy user" do
  user "root"
  code "useradd -d /home/deploy -s /bin/bash -G users -m deploy && mkdir /home/deploy/.ssh && chown deploy:deploy /home/deploy/.ssh && chmod 700  /home/deploy/.ssh"
  not_if "grep deploy /etc/passwd"
end

template "/etc/profile.d/bash.sh" do
  source 'bash.sh'
  variables(
    :rails_env => rails_env
  )
end

bash "make .ssh directory for root" do
  code "mkdir -p /root/.ssh"
end
bash "set permissions" do
  code "chmod 644 /etc/profile.d/bash.sh"
end

%w(root home/deploy).each do |location|
  cookbook_file "/#{location}/.ssh/github_rsa"
  cookbook_file "/#{location}/.ssh/github_rsa.pub"
  cookbook_file "/#{location}/.ssh/authorized_keys"
  cookbook_file "/#{location}/.ssh/known_hosts"
end

bash "make deploy app directory (var/www/localeyes)" do
  user "root"
  code "mkdir -p /var/www/localeyes && chown -R deploy:deploy /var/www/localeyes"
end

bash "install bundler gem" do
  user "root"
  code "gem install bundler --no-ri --no-rdoc"
end


template '/root/.ssh/config' do
  source 'ssh_config'
  variables(
    :home_dir => '/root'
  )
end

template '/home/deploy/.ssh/config' do
  source 'ssh_config'
  variables(
    :home_dir => '/home/deploy'
  )
end

bash "make deploy user files owned by deploy" do
  user "root"
  code "chown -R deploy:deploy /home/deploy/.ssh && chmod 700  /home/deploy/.ssh"
end

# --- Deploy a configuration file ---
# For longer files, when using 'content "..."' becomes too
# cumbersome, we can resort to deploying separate files:
cookbook_file '/etc/nginx/nginx.conf'

service 'nginx' do
  action :restart
end

### mongo db #####
execute 'apt-key adv --keyserver keyserver.ubuntu.com --recv 7F0CEB10' do
  user 'root'
end

execute "echo 'deb http://downloads-distro.mongodb.org/repo/ubuntu-upstart dist 10gen' >> /etc/apt/sources.list" do
  user 'root'
  not_if 'grep mongodb /etc/apt/sources.list'
end

execute 'apt-get update' do
  user 'root'
end

package 'mongodb-10gen'
