

#Enable PPTP Server:


/interface pptp-server server set authentication=mschap1,mschap2 default-profile=default-encryption enabled=yes


#Create PPTP User:


/ppp secret add name=myvpnuser password=mypassword service=pptp

#Enable L2TP Server:


/interface l2tp-server server set default-profile=default-encryption enabled=yes


#Create L2TP User:


/ppp secret add name=myvpnuser password=mypassword service=l2tp

#IPsec Configuration:


/ip ipsec proposal add auth-algorithms=sha1 enc-algorithms=aes-256-cbc lifetime=1h name=proposal1

#Create IPsec Peer:


/ip ipsec peer add address=0.0.0.0/0 exchange-mode=main-l2tp nat-traversal=yes

#Create IPsec Policy:

/ip ipsec policy add dst-address=0.0.0.0/0 proposal=proposal1 sa-dst-address=your_public_ip src-address=0.0.0.0/0

#Create IPsec Identity:


/ip ipsec identity add auth-method=pre-shared-key secret=your_shared_secret

#OpenVPN Configuration:


/system package update install
/system package install openvpn



#Generate Certificates:


/certificate add name=myvpn-cert common-name=myvpn
/certificate sign myvpn-cert

#Create OpenVPN Profile:


/interface ovpn-server server set certificate=myvpn-cert default-profile=default-encryption enabled=yes


#Create OpenVPN User:

/ppp secret add name=myvpnuser password=mypassword profile=default-encryption service=ovpn

#Configure NAT:


/ip firewall nat add action=masquerade chain=srcnat out-interface-list=WAN
Replace "WAN" with your WAN interface name.

#Configure Firewall Rules:


/ip firewall filter add action=accept chain=input in-interface-list=WAN protocol=udp dst-port=500,1701,4500
/add action=accept chain=input in-interface-list=WAN protocol=ipsec-esp



#Adjust MTU (if needed):


/interface pppoe-client set [find] mrru=1600


#Check Active VPN Connections:

/ppp active 


