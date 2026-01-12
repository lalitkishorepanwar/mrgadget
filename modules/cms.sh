#!/bin/bash

# Ortak kütüphaneyi içe aktar
source "$(dirname "$0")/common.sh"

# Modül başlığını göster
module_start "CMS & Teknoloji Tespiti"

print_info "Hedef domain (http/https olmadan):"
read -p "$(echo -e ${YELLOW}"Domain: "${NC})" domain

if ! validate_domain "$domain"; then
    print_error "Geçersiz domain formatı!"
    exit 1
fi

print_header "Teknoloji Analizi: $domain"

target_url="https://$domain"

if ! command -v curl &> /dev/null; then
    print_error "Curl bulunamadı!"
    exit 1
fi

print_info "Siteye bağlanılıyor ve parmak izleri aranıyor..."
echo

# 1. Server Header Kontrolü
print_section "Sunucu Bilgileri"
server_header=$(curl -s -I -L "$target_url" -A "Mozilla/5.0" | grep -i "Server:")

if [ ! -z "$server_header" ]; then
    echo -e "${CYAN}$server_header${NC}" | sed 's/Server: //'
else
    print_warning "Sunucu başlığı gizlenmiş."
fi
echo

# 2. Meta Tag Generator Kontrolü (CMS Tespiti için en basit yol)
print_section "CMS Tespiti (Meta Tags)"
# Sayfa kaynağını çek
page_content=$(curl -s -L "$target_url" -A "Mozilla/5.0")

generator=$(echo "$page_content" | grep -i "<meta name=\"generator\"" | cut -d'"' -f4)

if [ ! -z "$generator" ]; then
    print_item "$CHECK_MARK" "Meta Generator" "$generator"
else
    print_info "Meta generator etiketi bulunamadı."
fi

# 3. Yaygın CMS Yolu Kontrolleri
print_section "Yaygın CMS Dosya Kontrolleri"
echo -e "${GRAY}Belirli dosyalar kontrol ediliyor...${NC}"

# WordPress
wp_check=$(curl -s -o /dev/null -I -w "%{http_code}" "$target_url/wp-login.php")
if [[ "$wp_check" == "200" ]]; then
    print_item "$TARGET" "WordPress" "Tespit Edildi (/wp-login.php aktif)"
fi

# Joomla
joomla_check=$(curl -s -o /dev/null -I -w "%{http_code}" "$target_url/administrator/")
if [[ "$joomla_check" == "200" ]]; then
    print_item "$TARGET" "Joomla" "Tespit Edildi (/administrator/ aktif)"
fi

# Drupal
drupal_check=$(curl -s -o /dev/null -I -w "%{http_code}" "$target_url/CHANGELOG.txt")
if [[ "$drupal_check" == "200" ]]; then
     # İçeriği de kontrol etmek lazım ama basitçe
     print_item "$TARGET" "Drupal" "Olası (/CHANGELOG.txt erişilebilir)"
fi

# 4. Powered-By Header
print_section "X-Powered-By Header"
powered_by=$(curl -s -I -L "$target_url" | grep -i "X-Powered-By")
if [ ! -z "$powered_by" ]; then
    echo -e "${CYAN}$powered_by${NC}"
else
    print_info "X-Powered-By başlığı bulunamadı."
fi

module_end
