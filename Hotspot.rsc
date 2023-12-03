#Hotspot

#Configuring a hotspot on MikroTik involves several steps, and it typically allows you to provide 
#controlled internet access to users, often in public places like cafes or hotels

#Configure  Hotspot

/ip hotspot profile
set [ find default=yes ] html-directory=flash/hotspot
/ip hotspot

add name=hotspot1 interface=ether1 address-pool=hotspot-dhcp disabled=no


#Configure  DHCP Server for  Hotspot
/ip pool
add name=hotspot-dhcp ranges=192.168.88.10-192.168.88.254

/ip dhcp-server
add name=hotspot-dhcp interface=hotspot1 address-pool=hotspot-dhcp disabled=no


#Create  Bridge for  Hotspot

/interface bridge
add name=bridge-hotspot
/interface bridge port
add bridge=bridge-hotspot interface=ether1
add bridge=bridge-hotspot interface=hotspot1


#Enable  Hotspot Service

/ip address
add address=192.168.88.1/24 interface=bridge-hotspot



#Set Up IP Address Bridge
/ip address
add address=192.168.88.1/24 interface=bridge-hotspot

#Configure NAT for Hotspot

/ip firewall nat
add chain=srcnat action=masquerade out-interface=ether1


#Customize Hotspot Settings


/ip hotspot
set hotspot1 name=myhotspot ssid=myssid


#Save Configuration
/system reboot






