#!/bin/bash

# Ortak kütüphaneyi içe aktar
source "$(dirname "$0")/common.sh"

# Modül başlığını göster
module_start "Robots.txt Analizi"

print_info "Hedef domain:"
read -p "$(echo -e ${YELLOW}"Domain: "${NC})" domain

if ! validate_domain "$domain"; then
    print_error "Geçersiz domain formatı!"
    exit 1
fi

print_header "Robots.txt Analizi: $domain"

robots_url="https://$domain/robots.txt"
print_info "Dosya indiriliyor: $robots_url"
echo

if command -v curl &> /dev/null; then
    robots_content=$(curl -s -L "$robots_url")
    
    # İçerik kontrolü (HTML dönmüşse soft 404 olabilir)
    if echo "$robots_content" | grep -qi "<html"; then
        print_error "Robots.txt geçerli değil (HTML yanıtı döndü)."
        exit 1
    elif [ -z "$robots_content" ]; then
        print_error "Dosya boş veya erişilemiyor."
        exit 1
    fi
    
    print_section "Sitemap (Site Haritaları)"
    echo "$robots_content" | grep -i "Sitemap:" | while read -r line; do
        echo -e "${GREEN}$line${NC}"
    done
    
    print_section "Disallow (Yasaklı/Gizli Dizinler)"
    # Sadece Disallow satırlarını al, yorumları temizle
    echo "$robots_content" | grep -i "Disallow:" | while read -r line; do
        path=$(echo "$line" | cut -d: -f2 | xargs) # xargs trim yapar
        if [[ "$path" == "/" ]]; then
             echo -e "${RED}$line${NC} (Tüm site engelli)"
        elif [[ "$path" == "" ]]; then
             echo -e "${GREEN}$line${NC} (Hiçbir şey engelli değil)"
        else
             echo -e "${YELLOW}$line${NC}"
        fi
    done
    
    echo
    print_info "İpucu 'Disallow' edilen dizinler genellikle admin panelleri veya özel dosyalardır."

else
    print_error "Curl bulunamadı."
fi

module_end
