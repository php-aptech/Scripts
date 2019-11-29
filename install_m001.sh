#!bin/bass
date='date +%d%m%Y'
dir=root/Scripts
DropSelinux()
{
echo "SELINUX=disabled" > /etc/selinux/config; echo "SELINUXTYPE=targeted" >> /etc/selinux/config; setenforce 0
}
AddPortIptables()
{
cp $dir/iptables.txt /etc/sysconfig/iptables
service iptables restart
}
ConfigSSH()
{
cp /etc/ssh/sshd_config /etc/ssh/sshd_config.$date
echo > /etc/ssh/sshd_config
cp $dir/config_ssh.txt /etc/ssh/sshd_config
service sshd restart
}
Zabbix_Agent()
{
rpm --import http://repo.zabbix.com/RPM-GPG-KEY-ZABBIX
rpm -ivh http://repo.zabbix.com/zabbix/3.2/rhel/6/x86_64/zabbix-release-3.2-1.el6.noarch.rpm
yum install zabbix-agent -y
cp /etc/zabbix/zabbix_agentd.conf /etc/zabbix/zabbix_agentd.conf_$date
echo > /etc/zabbix/zabbix_agentd.conf
cp $dir/zabbix_agent.txt /etc/zabbix/zabbix_agentd.conf
service zabbix-agent start
chkconfig zabbix-agent on
}

DropSelinux
AddPortIptables
ConfigSSH
Zabbix_Agent

