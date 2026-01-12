#!/bin/bash

# Ortak kütüphaneyi içe aktar
source "$(dirname "$0")/common.sh"

# Modül başlığını göster
module_start "MAC Adresi Sorgulama"

print_info "MAC Adresini girin (Örn: 00:50:56:XX:XX:XX):"
read -p "$(echo -e ${YELLOW}"MAC: "${NC})" mac

if [ -z "$mac" ]; then
    print_error "MAC adresi boş olamaz!"
    exit 1
fi

print_header "MAC Analizi: $mac"

if command -v curl &> /dev/null; then
    # macvendors.co API kullanımı
    print_info "Veritabanı sorgulanıyor..."
    response=$(curl -s "https://macvendors.co/api/$mac")
    
    # Basitçe result'ı çekmeye çalışalım (JSON parsing olmadan grep ile zor ama deneyelim)
    # JSON cevabı: {"result":{"company":"VMware, Inc.","mac_prefix":"00:50:56","address":"..."}}
    
    company=$(echo "$response" | grep -o '"company":"[^"]*' | cut -d'"' -f4)
    address=$(echo "$response" | grep -o '"address":"[^"]*' | cut -d'"' -f4)
    
    if [ ! -z "$company" ]; then
        print_item "$TARGET" "Üretici Firma" "$company"
        if [ ! -z "$address" ]; then
            print_item "$WORLD" "Adres" "$address"
        fi
    else
        print_warning "MAC adresi bulunamadı veya limit aşıldı."
        echo "API Yanıtı: $response"
    fi

else
    print_error "Curl bulunamadı."
fi

module_end
