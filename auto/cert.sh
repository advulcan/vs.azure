# ca key
ipsec pki --gen --outform pem > ca.key.pem

#2.2基于私钥签名一个CA证书
ipsec pki --self --in ca.key.pem --dn "C=com, O=myvpn, CN=VPN CA" --ca --lifetime 3650 --outform pem > ca.cert.pem

#2.3生成服务器私钥
ipsec pki --gen --outform pem > server.pem

#2.4从服务器私钥中提取公钥</h3> 
ipsec pki --pub --in server.pem --outform pem > server.pub.pem

#2.5用CA证书签发服务器证书</h3> 
ipsec pki --issue --lifetime 3600 --cacert ca.cert.pem --cakey ca.key.pem --in server.pub.pem --dn "C=com, O=myvpn, CN=az.ssroot.com" --san="az.ssroot.com" --flag serverAuth --flag ikeIntermediate --outform pem > server.cert.pem

#<p>ps:需要注意的是az.ssroot.com要替换成你的服务器域名或者服务器IP&#xff0c;需要对应否则连接时会出现错误。</p> 
#2.6生成客户端私钥</h3> 
ipsec pki --gen --outform pem > client.pem

#2.7从客户端私钥中提取出公钥
ipsec pki --pub --in client.pem --outform pem > client.pub.pem

#2.8用CA证书签发客户端证书
ipsec pki --issue --lifetime 1200 --cacert ca.cert.pem --cakey ca.key.pem --in client.pub.pem --dn "C=com, O=myvpn, CN=client" --outform pem > client.cert.pem

#这里需要注意DN值中的前俩个参数应与2.5中保持一致