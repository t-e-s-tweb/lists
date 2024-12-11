#!/bin/bash



git clone https://github.com/XTLS/Xray-core
cp -r Xray-core/* ./
rm -rf Xray-core
#git checkout acbf36e
#go mod download
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




#sed -i '/^import/ { N; N; N; s/\(.*\)/&\n\t"github.com\/KimMachineGun\/automemlimit\/memlimit"\n\t_ "go.uber.org\/automaxprocs"/; }' main/main.go

#sed -i '/import (/ {
#    :a; N; /\n)/!ba;
#    s/)\(.*\)/)\1\
#\
#func init() {\
#    memlimit.SetGoMemLimitWithEnv();\
#}/
#}' main/main.go


# Download xv.txt from the repository



wget -N https://raw.githubusercontent.com/t-e-s-tweb/rules/master/xv.txt

# Process xv.txt and add its content to xv_processed.txt if not already added
if ! grep -qF "(\`" xv_processed.txt; then
    echo "strConfig := strings.NewReader(\`$(cat xv.txt)\`)" >> xv_processed.txt
fi



echo -e "\t\t\tdata, err = io.ReadAll(strConfig)" >> xv_processed.txt


# Comment out the specified line in external.go
sed -i.bak 's/data, err = io.ReadAll(os.Stdin)/\/\/ &/' main/confloader/external/external.go

# Insert strConfig definition after the specified line only if not already present
if ! grep -qF "strConfig := strings.NewReader" main/confloader/external/external.go; then
    sed -i.bak '/data, err = io.ReadAll(os.Stdin)/a strConfig := strings.NewReader' main/confloader/external/external.go
fi

# Insert processed content from xv_processed.txt using strConfig
#sed -i '/strConfig := strings.NewReader/r xv_processed.txt' main/confloader/external/external.go
# Insert processed content from xv_processed.txt using strConfig
sed -i -e '/strConfig := strings.NewReader/{r xv_processed.txt' -e 'd;}' main/confloader/external/external.go



# Comment out the line in common/log/log.go
sed -i 's/logHandler.Handle(msg)/\/\/ logHandler.Handle(msg)/' common/log/log.go

# Comment out the line and import in main/version.go

sed -i '/.*"fmt".*/ s/.*$/\/\/ &/' main/version.go
sed -i '/func printVersion() {/{n;s/^/\t\/\/ /;n;s/^/\t\/\/ /;n;s/^/\t\/\/ /;n;s/^/\t\/\/ /;}' main/version.go


sed -i 's/"github.com\/xtls\/xray-core\/core"/\/\/ "github.com\/xtls\/xray-core\/core"/' main/version.go

# Comment out the lines in main/run.go
sed -i 's/log.Println("Using confdir from arg:", configDir)/\/\/ log.Println("Using confdir from arg:", configDir)/' main/run.go
sed -i 's/log.Println("Using confdir from env:", envConfDir)/\/\/ log.Println("Using confdir from env:", envConfDir)/' main/run.go
sed -i 's/log.Println("Using default config: ", configFile)/\/\/ log.Println("Using default config: ", configFile)/' main/run.go
sed -i 's/log.Println("Using config from env: ", configFile)/\/\/ log.Println("Using config from env: ", configFile)/' main/run.go
sed -i 's/log.Println("Using config from STDIN")/\/\/ log.Println("Using config from STDIN")/' main/run.go



#go get -u go.uber.org/automaxprocs
#go get github.com/KimMachineGun/automemlimit@latest

env GOOS=linux GOARCH=amd64 CGO_ENABLED=0 go build -o xadm64 -trimpath -ldflags "-s -w -buildid=" ./main
#env GOOS=linux GOARCH=arm64 CGO_ENABLED=0 go build -o xarm64 -trimpath -ldflags "-s -w -buildid=" ./main

#./upx xadm64
#./upx xarm64
