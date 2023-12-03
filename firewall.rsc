
#Firewall Rules
/ip firewall export

#Create a Basic Firewall Rule

/ip firewall filter
/add chain=forward action=accept in-interface=LAN-INTERFACE out-interface=WAN-INTERFACE connection-state=established,related

#Add NAT Rules

/ip firewall nat add chain=srcnat action=masquerade out-interface=WAN-INTERFACE

#Add Additional Rules

/ip firewall filter add chain=forward action=accept in-interface=WAN-INTERFACE out-interface=LAN-INTERFACE protocol=tcp dst-port=80

#Deny Inbound Traffic

/ip firewall filter
/add chain=input action=drop


#Save Changes

/system backup save

#Reboot
/system reboot




# firewall rules to monitor traffic:


/ip firewall filter add chain=forward action=log log-prefix="FORWARD-LOG: " in-interface=LAN-INTERFACE out-interface=WAN-INTERFACE

#Port Forwarding

/ip firewall nat add chain=dstnat action=dst-nat in-interface=WAN-INTERFACE protocol=tcp dst-port=80 to-addresses=INTERNAL-SERVER-IP to-ports=80

#Traffic Limit the upload/download speed for specific traffic:


/queue simple add max-limit=2M/2M name=LAN-LIMIT target=LAN-INTERFACE

#View active connections:

/ip firewall connection print

#Dynamic Address List

/ip firewall address-list add list=blocklist address=10.0.0.0/24


#Block incoming ICMP requests 


/ip firewall filter add chain=input action=drop protocol=icmp

#Layer 7 Protocol Matching

/ip firewall layer7-protocol add name=block-p2p regexp="^(MMS|PPSTREAM|SOPCAST)"
/ip firewall filter add chain=forward action=drop layer7-protocol=block-p2p

#Rate limite  for specific traffic:


/ip firewall filter add chain=forward action=limit connection-state=new in-interface=LAN-INTERFACE protocol=tcp dst-port=80 limit=50/5s,10

#VLAN Filtering

/interface vlan add interface=LAN-INTERFACE vlan-id=10 name=vlan10
/ip firewall filter add chain=forward action=accept in-interface=vlan10 out-interface=WAN-INTERFACE connection-state=established,related
