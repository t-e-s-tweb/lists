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


curl -sLo go.tar.gz https://go.dev/dl/go1.21.1.linux-amd64.tar.gz
rm -r /usr/local/go
tar -C /usr/local -xzf go.tar.gz
rm go.tar.gz
echo -e "export PATH=$PATH:/usr/local/go/bin" > /etc/profile.d/go.sh
source /etc/profile.d/go.sh


curl -sLo zig.tar.xz https://ziglang.org/builds/zig-linux-x86_64-0.12.0-dev.670+19a82ffdb.tar.xz
tar -C /usr/local -xvf zig.tar.xz
rm zig.tar.xz
echo -e "export PATH=$PATH:/usr/local/zig-linux-x86_64-0.12.0-dev.670+19a82ffdb" > /etc/profile.d/zig.sh
source /etc/profile.d/zig.sh

git clone -b dev-next https://github.com/SagerNet/sing-box
#git clone -b 1.5.rc5 https://github.com/MatsuriDayo/sing-box
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

#env GOOS=linux GOARCH=amd64 CGO_ENABLED=0   go build -o sb -trimpath -ldflags "-s -w -buildid=" -tags with_utls,with_quic,with_wireguard,with_utls,with_gvisor,staticOpenssl,staticZlib,staticLibevent ./cmd/sing-box
#env GOOS=linux GOARCH=arm64 CGO_ENABLED=0   go build -o sbarm -trimpath -ldflags "-s -w -buildid=" -tags with_utls,with_quic,with_wireguard,with_utls,with_gvisor,staticOpenssl,staticZlib,staticLibevent ./cmd/sing-box
env CGO_ENABLED="1" GOOS=linux GOARCH=arm64 CC="zig cc -target aarch64-linux-musl" CXX="zig c++ -target aarch64-linux-musl" go build -o sbarm -trimpath -ldflags "-s -w -linkmode external -buildid=" -tags with_utls,with_quic,with_wireguard,with_utls,with_gvisor,staticOpenssl,staticZlib,staticLibevent ./cmd/sing-box
env CGO_ENABLED="1" GOOS=linux GOARCH=amd64 CC="zig cc -target x86_64-linux-musl" CXX="zig c++ -target x86_64-linux-musl" go build -o sb -trimpath -ldflags "-s -w -linkmode external -buildid=" -tags with_utls,with_quic,with_wireguard,with_utls,with_gvisor,staticOpenssl,staticZlib,staticLibevent ./cmd/sing-box

#./upx sb
#./upx sbarm
