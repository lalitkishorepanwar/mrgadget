#!/bin/bash

# Ortak kütüphaneyi içe aktar
source "$(dirname "$0")/common.sh"

# Modül başlığını göster
module_start "Wayback Machine Arşivi"

print_info "Arşivini kontrol etmek istediğiniz domain:"
read -p "$(echo -e ${YELLOW}"Domain: "${NC})" domain

if ! validate_domain "$domain"; then
    print_error "Geçersiz domain formatı!"
    exit 1
fi

print_header "Wayback Machine: $domain"
print_info "Internet Archive (Archive.org) sorgulanıyor..."
echo

if command -v curl &> /dev/null; then
    # Archive.org Availability API
    api_url="https://archive.org/wayback/available?url=$domain"
    
    response=$(curl -s "$api_url")
    
    # Basit JSON parsing (grep/cut ile, jq bağımlılığı olmasın diye)
    # Örnek yanıt: {"url": "example.com", "archived_snapshots": {"closest": {"status": "200", "available": true, "url": "http://web.archive.org/...", "timestamp": "..."}}}
    
    available=$(echo $response | grep -o '"available": true')
    
    if [ ! -z "$available" ]; then
        archive_url=$(echo $response | grep -o '"url": "[^"]*' | cut -d'"' -f4 | head -1)
        timestamp=$(echo $response | grep -o '"timestamp": "[^"]*' | cut -d'"' -f4 | head -1)
        
        # Timestamp formatla (YYYYMMDDHHMMSS -> YYYY-MM-DD)
        formatted_date="${timestamp:0:4}-${timestamp:4:2}-${timestamp:6:2}"
        
        print_success "Arşiv bulundu!"
        print_item "$KEY" "Son Arşiv Tarihi" "$formatted_date"
        print_item "$WORLD" "Arşiv Linki" "$archive_url"
        echo
        print_info "Tüm arşivi görmek için: https://web.archive.org/web/*/$domain"
    else
        print_warning "Bu domain için arşiv kaydı bulunamadı veya API yanıt vermedi."
    fi
else
    print_error "Curl bulunamadı."
fi

module_end
