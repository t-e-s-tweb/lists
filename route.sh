curl https://raw.githubusercontent.com/hagezi/dns-blocklists/main/wildcard/ultimate.txt > a.txt
curl https://raw.githubusercontent.com/hagezi/dns-blocklists/main/wildcard/tif.txt >> a.txt
sed '/#/d; s/^\*//' a.txt
