curl -LJ https://raw.githubusercontent.com/hagezi/dns-blocklists/main/domains/pro.plus.txt > 2.txt
curl -LJ https://raw.githubusercontent.com/ShadowWhisperer/BlockLists/master/RAW/Scam >> 2.txt
curl -LJ https://raw.githubusercontent.com/ShadowWhisperer/BlockLists/master/RAW/Malware >> 2.txt
curl -LJ https://raw.githubusercontent.com/ShadowWhisperer/BlockLists/master/RAW/Cryptocurrency >> 2.txt
curl -LJ https://raw.githubusercontent.com/ShadowWhisperer/BlockLists/master/RAW/Ads >> 2.txt
curl -LJ https://github.com/shahidcodes/firebog-ticked-list/releases/latest/download/ads.txt >> 2.txt
sed -i '/^#/d' 2.txt
sed -i 's/ .*//' 2.txt
gawk -i inplace '{gsub(/^[[:space:]]+|[[:space:]]+$/, ""); if (length > 0) print $0 }' 2.txt
sed -i 's/#.*//' 2.txt
input_file="2.txt"
output_file="blocklist.txt"
regex_output_file="regexblock.txt"

awk '!/^#/ {
    if ($0 ~ /\*/) {
        gsub(/\./, "\\.", $0);
        gsub(/\*/, ".*", $0);
        if ($0 != "") {
            print "/" $0 "/" > "'$regex_output_file'";
        }
    } else {
        if ($0 != "") {
            print $0 > "'$output_file'";
        }
    }
}' "$input_file"

echo "Regular expressions with / at start and end have been generated and saved to $regex_output_file"
echo "Remaining lines have been saved to $output_file"



curl -LJ https://raw.githubusercontent.com/ShadowWhisperer/BlockLists/master/Whitelists/Whitelist > 1.txt
curl -LJ https://raw.githubusercontent.com/anudeepND/whitelist/master/domains/whitelist.txt >> 1.txt
curl -LJ https://raw.githubusercontent.com/dnswarden/blocklist-staging/main/whitelist/tinylist.txt >> 1.txt
curl -LJ https://raw.githubusercontent.com/dnswarden/blocklist-staging/main/whitelist/whitelistcommon.txt >> 1.txt
curl -LJ https://raw.githubusercontent.com/hagezi/dns-blocklists/main/whitelist.txt >> 1.txt
sed -i '/^#/d' 1.txt
sed -i 's/ .*//' 1.txt
gawk -i inplace '{gsub(/^[[:space:]]+|[[:space:]]+$/, ""); if (length > 0) print $0 }' 1.txt
sed -i 's/#.*//' 1.txt
input_file="1.txt"
output_file="whitelist.txt"
regex_output_file="regexwhite.txt"

awk '!/^#/ {
    if ($0 ~ /\*/) {
        gsub(/\./, "\\.", $0);
        gsub(/\*/, ".*", $0);
        if ($0 != "") {
            print "/" $0 "/" >> "'$regex_output_file'";
        }
    } else {
        if ($0 != "") {
            print $0 >> "'$output_file'";
        }
    }
}' "$input_file"

echo "Regular expressions with / at start and end have been generated and saved to $regex_output_file"
echo "Remaining lines have been saved to $output_file"





regex_output_file1="regexblock.txt"
regex_output_file2="regexwhite.txt"
input_file="config.yml"

awk -v regex1="$(sed 's/\\/\\\\/g' "$regex_output_file1" 2>/dev/null)" -v regex2="$(sed 's/\\/\\\\/g' "$regex_output_file2" 2>/dev/null)" '
    /^      - \|/ && !inserted {
        inserted = 1
        print
        if (regex1) {
            while (getline line < "'"$regex_output_file1"'") {
                print "        " line
            }
            close("'"$regex_output_file1"'")
        }
        next
    }
    /^      - \|/ && inserted {
        print
        if (regex2) {
            while (getline line < "'"$regex_output_file2"'") {
                print "        " line
            }
            close("'"$regex_output_file2"'")
        }
        next
    }
    { print }
' "$input_file" > temp_file && mv temp_file config.yml && echo "Processed regex lines have been inserted in $input_file"
