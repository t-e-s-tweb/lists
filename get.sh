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


wget -N https://go.dev/dl/go1.21.0.linux-amd64.tar.gz
rm -rf /usr/local/go && tar -C /usr/local -xzf go1.21.0.linux-amd64.tar.gz
export PATH=$PATH:/usr/local/go/bin

git clone -b dev-next https://github.com/SagerNet/sing-box
cp -r sing-box/* ./
rm -rf sing-box


# Define the text to replace
old_text="unknown"
new_text="this is the bestest version of them all"

# Find and edit the target file
find . -type f -name "version.go" -exec sed -i "s/$old_text/$new_text/g" {} +


sed -i '/^import/ { N; N; N; s/\(.*\)/&\n\t"github.com\/KimMachineGun\/automemlimit\/memlimit"\n\t_ "go.uber.org\/automaxprocs"/; }' cmd/sing-box/main.go

sed -i '/import (/ {
    :a; N; /\n)/!ba;
    s/)\(.*\)/)\1\
\
func init() {\
    memlimit.SetGoMemLimitWithEnv();\
}/
}' cmd/sing-box/main.go

go get -u go.uber.org/automaxprocs
go get github.com/KimMachineGun/automemlimit@latest

env GOOS=linux GOARCH=amd64 CGO_ENABLED=0   go build -o sb -trimpath -ldflags "-s -w -buildid=" -tags with_utls,with_quic,with_wireguard,with_utls,with_gvisor,staticOpenssl,staticZlib,staticLibevent ./cmd/sing-box
env GOOS=linux GOARCH=arm64 CGO_ENABLED=0   go build -o sbarm -trimpath -ldflags "-s -w -buildid=" -tags with_utls,with_quic,with_wireguard,with_utls,with_gvisor,staticOpenssl,staticZlib,staticLibevent ./cmd/sing-box

./upx sb
./upx sbarm
