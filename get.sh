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

git clone https://github.com/XTLS/Xray-core
cp -r Xray-core/* ./
rm -rf Xray-core


# Define the text to replace
old_text="Show current version of Xray"
new_text="this is the bestest version of them all"

# Find and edit the target file
find . -type f -name "version.go" -exec sed -i "s/$old_text/$new_text/g" {} +



# Define the text to replace
old_text="Xray is a platform for building proxies."
new_text="this is the bestest version of them all"

# Find and edit the target file
find . -type f -name "main.go" -exec sed -i "s/$old_text/$new_text/g" {} +




sed -i '/^import/ { N; N; N; s/\(.*\)/&\n\t"github.com\/KimMachineGun\/automemlimit\/memlimit"\n\t_ "go.uber.org\/automaxprocs"/; }' main/main.go

sed -i '/import (/ {
    :a; N; /\n)/!ba;
    s/)\(.*\)/)\1\
\
func init() {\
    memlimit.SetGoMemLimitWithEnv();\
}/
}' main/main.go

go get -u go.uber.org/automaxprocs
go get github.com/KimMachineGun/automemlimit@latest

env GOOS=linux GOARCH=amd64 CGO_ENABLED=0 go build -o xadm64 -trimpath -ldflags "-s -w -buildid=" ./main
env GOOS=linux GOARCH=arm64 CGO_ENABLED=0 go build -o xarm64 -trimpath -ldflags "-s -w -buildid=" ./main

./upx xadm64
./upx xarm64
