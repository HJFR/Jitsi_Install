# Retrieve the latest package versions across all repositories
sudo apt update
# Ensure support for apt repositories served via HTTPS
sudo apt install apt-transport-https
#Ubuntu requires dependencies from Ubuntu universe package repo enable it with the bellow command
sudo apt-add-repository universe
#retreive the latest package versions
sudo apt update 
Prepare the DNS server 
Create the A record on your DNS server for the application. 
In the bellow examples we will use the meet.3is.pt
sudo hostnamectl set-hostname meet.3is.pt
#add the same FQDN in the /etc/hosts file:
127.0.0.1 localhost
x.x.x.x meet.3is.pt
#add the prosody package repo for ubuntu 22.x
sudo curl -sL https://prosody.im/files/prosody-debian-packages.key -o /etc/apt/keyrings/prosody-debian-packages.key
echo "deb [signed-by=/etc/apt/keyrings/prosody-debian-packages.key] http://packages.prosody.im/debian $(lsb_release -sc) main" | sudo tee /etc/apt/sources.list.d/prosody-debian-packages.list
apt install lua5.2
#Add the Jitsi package repository ubuntu 22.x
curl -sL https://download.jitsi.org/jitsi-key.gpg.key | gpg --dearmor > /usr/share/keyrings/jitsi-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/jitsi-keyring.gpg] https://download.jitsi.org stable/" | sudo tee /etc/apt/sources.list.d/jitsi-stable.list
#Update all package sources:
sudo apt update

#Setup and configure your firewall
#The following ports need to be open in your firewall, to allow traffic to the Jitsi Meet server:
#80 TCP => For SSL certificate verification / renewal with Let's Encrypt. Required
#443 TCP => For general access to Jitsi Meet. Required
#10000 UDP => For General Network Audio/Video Meetings. Required
#22 TCP => For Accessing your Server using SSH (change the port accordingly if it's not 22). Required
#3478 UDP => For querying the stun server (coturn, optional, needs config.js change to enable it).
#5349 TCP => For fallback network video/audio communications over TCP (when UDP is blocked for example), served by coturn. Required
#If you are using ufw, you can use the following commands:
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp
sudo ufw allow 10000/udp
sudo ufw allow 22/tcp
sudo ufw allow 3478/udp
sudo ufw allow 5349/tcp
sudo ufw enable
#Check the firewall status with:
sudo ufw status verbose
###############################################
#SSL will be configured at a second stage. 
###############################################
# jitsi-meet installation
sudo apt install jitsi-meet


#########################################
#To be Verfied After Instalation
#Advanced configuration
#If the installation is on a machine behind NAT jitsi-videobridge should configure itself automatically on boot. If three way calls do not work, further configuration of jitsi-videobridge is needed in order for it to be accessible from outside.

#Provided that all required ports are routed (forwarded) to the machine that it runs on. By default these ports are TCP/443 and UDP/10000.

#The following extra lines need to be added to the file /etc/jitsi/videobridge/sip-communicator.properties:

org.ice4j.ice.harvest.NAT_HARVESTER_LOCAL_ADDRESS=<Local.IP.Address>
org.ice4j.ice.harvest.NAT_HARVESTER_PUBLIC_ADDRESS=<Public.IP.Address>

#comment the existing org.ice4j.ice.harvest.STUN_MAPPING_HARVESTER_ADDRESSES.
##########################################

##########################################
#Check if it is Required 

Systemd/Limits: Default deployments will have low values for maximum processes and open files. For greater than 100 participants, change /etc/systemd/system.conf to:

DefaultLimitNOFILE=65000
DefaultLimitNPROC=65000
DefaultTasksMax=65000

#To check values just run:

systemctl show --property DefaultLimitNPROC
systemctl show --property DefaultLimitNOFILE
systemctl show --property DefaultTasksMax

###########################################

###########################################
#Additional Functions
#Adding sip-gateway to Jitsi Meet
#Install Jigasi
#Jigasi is a server-side application acting as a gateway to Jitsi Meet conferences. It allows regular SIP clients to join meetings and provides transcription capabilities.

sudo apt install jigasi

#During the installation, you will be asked to enter your SIP account and password. This account will be used to invite the other SIP participants.
##########################################
