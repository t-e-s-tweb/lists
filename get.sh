#!/bin/bash


wget -N https://go.dev/dl/go1.20.4.linux-amd64.tar.gz
rm -rf /usr/local/go && tar -C /usr/local -xzf go1.20.4.linux-amd64.tar.gz
export PATH=$PATH:/usr/local/go/bin

wget -N https://github.com/upx/upx/releases/download/v4.0.2/upx-4.0.2-amd64_linux.tar.xz -O upx.tar.xz
tar xf upx.tar.xz
export PATH=$PATH:~/upx-4.0.2-amd64_linux

git clone https://github.com/SagerNet/sing-box
cp -r sing-box/* ./
rm -rf sing-box


# Define the text to replace
old_text="unknown"
new_text="this is the bestest version of them all"

# Find and edit the target file
find . -type f -name "version.go" -exec sed -i "s/$old_text/$new_text/g" {} +


sed -i '/^import/ { N; N; N; s/\(.*\)/&\n\t"github.com\/KimMachineGun\/automemlimit\/memlimit"\n\t_ "go.uber.org\/automaxprocs"/; }' cmd/sing-box/main.go

sed -i '/func main/ i\
\
func init() {\
\tmemlimit.SetGoMemLimitWithProvider(memlimit.Limit(128*1024*1024), 0.7);\
}' cmd/sing-box/main.go

go get -u go.uber.org/automaxprocs
go get github.com/KimMachineGun/automemlimit@latest

env GOOS=linux GOARCH=amd64 CGO_ENABLED=0   go build -o sb -trimpath -ldflags "-s -w -buildid=" -tags with_utls,with_quic,with_wireguard,with_utls,with_gvisor,staticOpenssl,staticZlib,staticLibevent ./cmd/sing-box
upx sb
env GOOS=linux GOARCH=arm64 CGO_ENABLED=0   go build -o sbarm -trimpath -ldflags "-s -w -buildid=" -tags with_utls,with_quic,with_wireguard,with_utls,with_gvisor,staticOpenssl,staticZlib,staticLibevent ./cmd/sing-box
upx sbarm
