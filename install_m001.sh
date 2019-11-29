#!bin/bass
date=`date +%Y%m%d`
dir=/root/Scripts

######Disable Selinux
DropSelinux()
{
echo "SELINUX=disabled" > /etc/selinux/config; echo "SELINUXTYPE=targeted" >> /etc/selinux/config; setenforce 0
}

######Add Port Iptables "3122,10050"
AddPortIptables()
{
cp $dir/iptables.txt /etc/sysconfig/iptables
service iptables restart
}

######Config Port SSH port 3122
ConfigSSH()
{
cp /etc/ssh/sshd_config /etc/ssh/sshd_config.$date
echo > /etc/ssh/sshd_config
cp $dir/config_ssh.txt /etc/ssh/sshd_config
service sshd restart
}

######Config monitor zabbix agent
Zabbix_Agent()
{
rpm --import http://repo.zabbix.com/RPM-GPG-KEY-ZABBIX
rpm -ivh http://repo.zabbix.com/zabbix/3.2/rhel/6/x86_64/zabbix-release-3.2-1.el6.noarch.rpm
yum install zabbix-agent -y
#cp /etc/zabbix/zabbix_agentd.conf /etc/zabbix/zabbix_agentd.conf.$date
echo > /etc/zabbix/zabbix_agentd.conf
cp $dir/zabbix_agentd.conf /etc/zabbix/zabbix_agentd.conf
echo "Vui long nhap IP Zabbix_Client can monitor: "
read ip_zabbix
echo "Hostname=$ip_zabbix" >> /etc/zabbix/zabbix_agentd.conf 
service zabbix-agent start
chkconfig zabbix-agent on
}

######Change password root
Change_Pass()
{
#echo "linuxpassword" | passwd --stdin linuxuser
echo "tKdVd#%GVfIp*1ey#&Wx" | passwd --stdin root
}


######################
#	 Run Function	 #	
######################
Change_Pass
DropSelinux
AddPortIptables
ConfigSSH
Zabbix_Agent
