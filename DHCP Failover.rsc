


#Dynamic Host Configuration Protocol (DHCP) Failover

#This project ensures DHCP service redundancy on MikroTik routers. Configuring failover enhances network stability,
 #allowing seamless #IP address assignment even if one DHCP server fails. 






# DHCP Failover
#Access MikroTik CLI for Both Routers
#Configure DHCP Servers


#Router 1 (Primary DHCP Server)
/ip dhcp-server add name=dhcp-primary interface=ether1 address-pool=pool1 lease-time=1d

/ip pool add name=pool1 ranges=192.168.1.2-192.168.1.254

/ip dhcp-server network add address=192.168.1.0/24 gateway=192.168.1.1 dns-server=8.8.8.8

#Router 2 (Secondary DHCP Server)
/ip dhcp-server
add name=dhcp-secondary interface=ether1 address-pool=pool1 lease-time=1d

/ip pool add name=pool1 ranges=192.168.1.2-192.168.1.254

/ip dhcp-server network
add address=192.168.1.0/24 gateway=192.168.1.1 dns-server=8.8.8.8


#Configure DHCP Failover
#Router 1 (Primary DHCP Server)

/ip dhcp-server
set [find name=dhcp-primary] authoritative=after-2sec-delay

/ip dhcp-server network
set [find address=192.168.1.0/24] failover-mode=standalone

/ip dhcp-server
add name=dhcp-secondary interface=ether1 address-pool=pool1 lease-time=1d

/ip dhcp-server network
add address=192.168.1.0/24 gateway=192.168.1.1 dns-server=8.8.8.8

/ip dhcp-server
set [find name=dhcp-secondary] failover-address=192.168.1.2
set [find name=dhcp-secondary] failover-port=519

/ip dhcp-server network
set [find address=192.168.1.0/24] failover-mode=balanced
set [find address=192.168.1.0/24] failover-peer=192.168.1.2


#Router 2 (Secondary DHCP Server)


/ip dhcp-server
set [find name=dhcp-secondary] authoritative=after-2sec-delay

/ip dhcp-server network
set [find address=192.168.1.0/24] failover-mode=standalone

/ip dhcp-server
add name=dhcp-primary interface=ether1 address-pool=pool1 lease-time=1d

/ip dhcp-server network
add address=192.168.1.0/24 gateway=192.168.1.1 dns-server=8.8.8.8

/ip dhcp-server
set [find name=dhcp-primary] failover-address=192.168.1.1
set [find name=dhcp-primary] failover-port=519

/ip dhcp-server network
set [find address=192.168.1.0/24] failover-mode=balanced
set [find address=192.168.1.0/24] failover-peer=192.168.1.1


#failover port default is 519
#Test 
/log print
