#!/bin/bash

# Ortak kütüphaneyi içe aktar
source "$(dirname "$0")/common.sh"

# Modül başlığını göster
module_start "IP İtibar Kontrolü (Blacklist)"

print_info "Kontrol edilecek IP adresi veya domain girin:"
read -p "$(echo -e ${YELLOW}"Hedef: "${NC})" target

ip_address=""

# IP mi Domain mi?
if validate_ip "$target"; then
    ip_address=$target
elif validate_domain "$target"; then
    print_info "Domain çözümleniyor..."
    if [[ "$OSTYPE" == "msys" || "$OSTYPE" == "win32" ]]; then
        ip_address=$(ping -n 1 $target | findstr "Pinging" | grep -oE "\b([0-9]{1,3}\.){3}[0-9]{1,3}\b" | head -1)
    else
        ip_address=$(ping -c 1 $target | grep -oE "\b([0-9]{1,3}\.){3}[0-9]{1,3}\b" | head -1)
    fi
else
    print_error "Geçersiz giriş!"
    exit 1
fi

if [ -z "$ip_address" ]; then
    print_error "IP adresi bulunamadı."
    exit 1
fi

print_header "Reputation Kontrolü: $ip_address"

# IP'yi tersine çevir (örnek: 1.2.3.4 -> 4.3.2.1)
reversed_ip=$(echo $ip_address | awk -F. '{print $4"."$3"."$2"."$1}')

# Blacklistler
blacklists=(
    "zen.spamhaus.org"
    "b.barracudacentral.org"
    "bl.spamcop.net"
    "dnsbl.sorbs.net"
)

print_info "DNSBL veritabanları sorgulanıyor..."
echo

for bl in "${blacklists[@]}"; do
    query="${reversed_ip}.${bl}"
    
    # Lookup
    if nslookup $query > /dev/null 2>&1; then
        print_item "$CROSS_MARK" "$bl" "${RED}LİSTELENMİŞ (Blacklisted)${NC}"
    else
        print_item "$CHECK_MARK" "$bl" "${GREEN}Temiz${NC}"
    fi
done

echo
print_info "Not: Listelenmiş olması IP'nin spam veya zararlı aktivite için kullanıldığını gösterebilir."

module_end
