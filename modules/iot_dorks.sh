#!/bin/bash

# Ortak kütüphaneyi içe aktar
source "$(dirname "$0")/common.sh"

# Modül başlığını göster
module_start "IoT & Cihaz Arama (Dorks)"

print_info "Hedef IP, Domain veya Organizasyon İsmi:"
read -p "$(echo -e ${YELLOW}"Hedef: "${NC})" target

if [ -z "$target" ]; then
    print_error "Hedef boş olamaz!"
    exit 1
fi

print_header "IoT İstihbarat Linkleri: $target"
echo "Aşağıdaki bağlantılar Shodan ve Censys üzerinde hedefe ait cihazları arar."
echo

# Shodan Dorks
print_section "Shodan Search"
print_item "$MAGNIFIER" "Genel Arama" "https://www.shodan.io/search?query=$target"
print_item "$MAGNIFIER" "Hostname Araması" "https://www.shodan.io/search?query=hostname:\"$target\""
print_item "$MAGNIFIER" "Organizasyon Araması" "https://www.shodan.io/search?query=org:\"$target\""

# Censys
print_section "Censys Search"
print_item "$MAGNIFIER" "Censys Hosts" "https://search.censys.io/search?resource=hosts&q=$target"

# ZoomEye
print_section "ZoomEye Search"
print_item "$MAGNIFIER" "ZoomEye" "https://www.zoomeye.org/searchResult?q=$target"

echo
print_warning "Bu servisleri kullanmak için üyelik girişi yapmanız gerekebilir."
module_end
