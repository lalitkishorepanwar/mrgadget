#!/bin/bash

# Ortak kütüphaneyi içe aktar
source "$(dirname "$0")/common.sh"

# Modül başlığını göster
module_start "Sızıntı Kontrolü (Breach Check)"

print_info "Kontrol edilecek E-posta adresini girin:"
read -p "$(echo -e ${YELLOW}"E-posta: "${NC})" email

if [[ ! "$email" =~ ^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$ ]]; then
    print_error "Geçersiz E-posta formatı!"
    exit 1
fi

print_header "Sızıntı Analizi: $email"
print_info "Doğrudan API sorgusu yerine güvenli arama linkleri oluşturuluyor..."
echo

# HaveIBeenPwned (Link)
print_item "$MAGNIFIER" "HaveIBeenPwned" "https://haveibeenpwned.com/account/$email"

# DeHashed (Link)
print_item "$MAGNIFIER" "DeHashed Search" "https://dehashed.com/search?query=$email"

# LeakCheck (Link)
print_item "$MAGNIFIER" "LeakCheck.io" "https://leakcheck.io/search?type=email&query=$email"

echo
print_warning "Not: Ücretsiz API kısıtlamaları nedeniyle, en doğru sonuç için"
echo "yukarıdaki linkleri tarayıcıda açarak kontrol etmeniz önerilir."
echo
print_info "Otomatik Link Açma (Windows):"
echo -e "Linkleri açmak ister misiniz? (E/H)"
read -p "$(echo -e ${GREEN}"Seçim: "${NC})" open_links

if [[ "$open_links" =~ ^[Ee]$ ]]; then
    start "https://haveibeenpwned.com/account/$email" 2>/dev/null
    start "https://leakcheck.io/search?type=email&query=$email" 2>/dev/null
fi

module_end
