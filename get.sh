#!/bin/bash


# URL for the UPX release
UPX_URL="https://github.com/upx/upx/releases/download/v4.1.0/upx-4.1.0-amd64_linux.tar.xz"

# Download UPX archive
echo "Downloading UPX..."
wget "$UPX_URL" -O upx.tar.xz

# Extract UPX archive
echo "Extracting UPX..."
tar -xvf upx.tar.xz

# Move UPX binary to current directory
mv upx-4.1.0-amd64_linux/upx .

# Remove extracted directory
rm -r upx-4.1.0-amd64_linux

# Provide executable permissions
chmod +x upx

echo "UPX is ready to use."


curl -sLo go.tar.gz https://go.dev/dl/go1.20.4.linux-amd64.tar.gz
rm -r /usr/local/go
tar -C /usr/local -xzf go.tar.gz
rm go.tar.gz
echo -e "export PATH=$PATH:/usr/local/go/bin" > /etc/profile.d/go.sh
source /etc/profile.d/go.sh

git clone https://github.com/cloudflare/cloudflared
cp -r cloudflared/* ./
rm -rf cloudflared


sed -i '/^import/ { N; N; N; s/\(.*\)/&\n\t"github.com\/KimMachineGun\/automemlimit\/memlimit"\n\t_ "go.uber.org\/automaxprocs"/; }' cmd/cloudflared/main.go

sed -i '/import (/ {
    :a; N; /\n)/!ba;
    s/)\(.*\)/)\1\
\
func init() {\
    memlimit.SetGoMemLimitWithEnv();\
}/
}' cmd/cloudflared/main.go



go get -u go.uber.org/automaxprocs
go get github.com/KimMachineGun/automemlimit/memlimit@latest
go mod vendor

#env GOOS=linux GOARCH=arm64 CGO_ENABLED=0  go build -o blockyarm64 -trimpath -ldflags "-s -w -buildid=" ./
env GOOS=linux GOARCH=amd64 CGO_ENABLED=0  go build -mod=mod -o cloudy -trimpath -ldflags "-s -w -buildid=" ./cmd/cloudflared
env GOOS=linux GOARCH=arm64 CGO_ENABLED=0  go build -mod=mod -o cloudyarm64 -trimpath -ldflags "-s -w -buildid=" ./cmd/cloudflared

#env GOOS=linux GOARCH=amd64 CGO_ENABLED=0   go build -o sdns -trimpath -ldflags "-s -w -buildid=" ./


#./upx cloudy
#./upx cloudyarm64
#./upx blockyarm64
