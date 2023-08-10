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


wget -N https://go.dev/dl/go1.20.4.linux-amd64.tar.gz
rm -rf /usr/local/go && tar -C /usr/local -xzf go1.20.4.linux-amd64.tar.gz
export PATH=$PATH:/usr/local/go/bin

git clone https://github.com/0xERR0R/blocky
cp -r blocky/* ./
rm -rf blocky


sed -i '/^import/ { N; N; N; s/\(.*\)/&\n\t"github.com\/KimMachineGun\/automemlimit\/memlimit"\n\t_ "go.uber.org\/automaxprocs"/; }' main.go

sed -i '/func main/ i\
\
func init() {\
\tmemlimit.SetGoMemLimitWithProvider(memlimit.Limit(128*1024*1024), 0.7);\
}' main.go

go get -u go.uber.org/automaxprocs
go get github.com/KimMachineGun/automemlimit@latest

env GOOS=linux GOARCH=arm64 CGO_ENABLED=0  go build -o blockyarm64 -trimpath -ldflags "-s -w -buildid=" ./
env GOOS=linux GOARCH=amd64 CGO_ENABLED=0  go build -o blocky -trimpath -ldflags "-s -w -buildid=" ./

./upx blocky
./upx blockyarm64
