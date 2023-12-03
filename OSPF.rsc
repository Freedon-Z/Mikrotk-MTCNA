#OSPF Configuration

/routing ospf instance
/set [ find default=yes ] distribute-default=always-as-type-1 router-id=1.1.1.1


#Add OSPF networks:

/routing ospf network
/add area=backbone network=192.168.1.0/24
/add area=backbone network=10.0.0.0/24

#Configure OSPF authentication:

/routing ospf area set 0 authentication=md5 authentication-key=password

#BGP Configuration

/routing bgp instance set default as=65001 router-id=2.2.2.2
Replace 65001 with your own Autonomous System (AS) number and 2.2.2.2 with a unique Router ID.

#Add BGP peers:

/routing bgp peer
/add remote-address=3.3.3.3 remote-as=65002
/add remote-address=4.4.4.4 remote-as=65003
Replace 3.3.3.3, 4.4.4.4 with the IP addresses of your BGP neighbors and adjust AS numbers accordingly.

#Configure BGP authentication:
/routing bgp peer set 0 password=password

#Redistribute OSPF routes into BGP:

/routing bgp network add network=192.168.1.0/24 synchronize-choices=route-map

#Redistribute BGP routes into OSPF:

/routing ospf redistribute add redistribute-bgp-connected=yes redistribute-connected:admin=yes
This command redistributes BGP routes into OSPF.

#Save Configuration
/system backup save name=backup

#Verification

/routing ospf neighbor print
/routing ospf route print
/routing bgp peer print
/routing bgp advertisements print
