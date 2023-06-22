######################################
# auto setup l2tp/ipsec
# tested on vultr ubuntu20.4. login as root
#wget http://ssroot.com:8081/auto/run.sh
#sed -i 's/\r//' run.sh
#chmod +x run.sh
#sudo ./run.sh
#v 0.1 - draft version to setup lib/service/nat/config
######################################

#0. prepare scripts
echo "[INFO]Downloading config"
# mkdir tmp
# cd tmp
# wget -q http://ssroot.com:8081/auto/1.txt
# wget -q http://ssroot.com:8081/auto/2.txt
# wget -q http://ssroot.com:8081/auto/3.txt
# wget -q http://ssroot.com:8081/auto/4.txt
# wget -q http://ssroot.com:8081/auto/5.txt
# sed -i 's/\r//' *txt
# cd ..

#1. install 
echo "[INFO]installing software"
echo "installing software"
sudo apt-get update
sudo apt install -y net-tools
sudo apt-get install -y strongswan
sudo apt-get install -y xl2tpd
echo "installed software"
echo "[INFO]installed software"

#2. setting up
echo "[INFO]setting config"
#F_CONF="."
F_CONF="/etc"
F_IPSEC_CONF=$F_CONF"/ipsec.conf"
F_IPSEC_PSK=$F_CONF"/ipsec.secrets"
F_L2TP_CONF=$F_CONF"/xl2tpd/xl2tpd.conf"
F_L2TP_OPTION=$F_CONF"/ppp/options.xl2tpd"
F_PPP_PASS=$F_CONF"/ppp/chap-secrets"
echo $F_IPSEC_CONF
echo $F_IPSEC_PSK 
echo $F_L2TP_CONF 
echo $F_L2TP_OPTION
if [ ! -d $F_CONF/xl2tpd ];then
echo "[ERROR]creating folder. Have you install xl2tpd?"
mkdir $F_CONF/xl2tpd
else
echo "[INFO]folder exists" $F_CONF/ppp
fi
if [ ! -d $F_CONF/ppp ];then
echo "[ERROR]creating folder. Have you install ppp?"
mkdir $F_CONF/ppp
else
echo "[INFO]folder exists" $F_CONF/xl2tpd
fi

mv -b tmp/1.txt $F_IPSEC_CONF
mv -b tmp/2.txt $F_IPSEC_PSK
mv -b tmp/3.txt $F_L2TP_CONF
mv -b tmp/4.txt $F_L2TP_OPTION
mv -b tmp/5.txt $F_PPP_PASS
echo "[INFO]config done"
#3 start
echo '[INFO]start ipsec'
ipsec restart
echo '[INFO]started ipsec'
systemctl enable ipsec
ipsec restart
echo '[INFO]added ipsec auto start'
echo '[INFO]start xl2tpd'
service xl2tpd restart
echo '[INFO]started ipsec'
systemctl enable xl2tpd
echo '[INFO]added xl2tpd auto start'
#4 network and nat
echo '[INFO]ip4 forward'
echo "#Added by auto deploy " `date` >>/etc/sysctl.conf
echo "net.ipv4.ip_forward = 1" >>/etc/sysctl.conf
sysctl -p
echo '[INFO]nat'
iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
echo '[INFO]All done, checking listen port'
netstat -anltu |grep 500
netstat -anltu |grep 1701