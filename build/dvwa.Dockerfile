FROM debian:11
COPY ./data/dvwa/ /var/www/html/
RUN apt update && \
apt -y upgrade && \
DEBIAN_FRONTEND=noninteractive apt -yq install git lsb-release curl openssh-server apache2 libapache2-mod-php dialog php php-gd php-mysql && \
(echo "sshpassword"; echo "sshpassword") | passwd && \
curl -so wazuh-agent-4.3.10.deb https://packages.wazuh.com/4.x/apt/pool/main/w/wazuh-agent/wazuh-agent_4.3.10-1_amd64.deb && \
WAZUH_MANAGER='wazuh-manager.lab' WAZUH_AGENT_GROUP='default' dpkg -i ./wazuh-agent-4.3.10.deb && \
update-rc.d wazuh-agent defaults 95 10 && \
curl -so splunkforwarder-9.0.4-de405f4a7979-linux-2.6-amd64.deb "https://download.splunk.com/products/universalforwarder/releases/9.0.4/linux/splunkforwarder-9.0.4-de405f4a7979-linux-2.6-amd64.deb" && \
dpkg -i splunkforwarder-9.0.4-de405f4a7979-linux-2.6-amd64.deb && \
/opt/splunkforwarder/bin/splunk add user admin -role Admin -password splunkpassword --no-prompt --accept-license --answer-yes && \
sed -i "s/allow_url_include = Off/allow_url_include = On/g" /etc/php/*/apache2/php.ini && \
sed -i "s/PYTHONHTTPSVERIFY=0/PYTHONHTTPSVERIFY=1/g" /opt/splunkforwarder/etc/splunk-launch.conf && \
sed -i "s/SPLUNK_OS_USER=splunk/SPLUNK_OS_USER=root/g" /opt/splunkforwarder/etc/splunk-launch.conf && \
sed -i "s/#PermitRootLogin prohibit-password/PermitRootLogin yes/g" /etc/ssh/sshd_config && \
cd /var/www/html/ && \
tar -xf git.tar.gz && \
chmod 777 config/ hackable/uploads/ && \
rm -rf /wazuh-agent-4.3.10.deb /splunkforwarder-9.0.4-de405f4a7979-linux-2.6-amd64.deb /var/www/html/index.html /var/www/html/git.tar.gz
