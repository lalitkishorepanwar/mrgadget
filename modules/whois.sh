#!/bin/bash

# Ortak kütüphaneyi içe aktar
source "$(dirname "$0")/common.sh"

# Modül başlığını göster
module_start "Whois Sorgusu"

print_info "Whois sorgusu için domain girin:"
read -p "$(echo -e ${YELLOW}"Domain: "${NC})" domain

# Validasyon
if ! validate_domain "$domain"; then
    print_error "Geçersiz domain formatı!"
    exit 1
fi

print_header "Whois Sorgusu: $domain"

# Whois sorgusu yap
print_info "Domain sahibi bilgileri kontrol ediliyor..."
echo

if command -v whois &> /dev/null; then
  whois $domain
elif [[ "$OSTYPE" == "msys" || "$OSTYPE" == "win32" ]]; then
  print_warning "Yerel 'whois' komutu bulunamadı, çevrimiçi API deneniyor..."
  curl -L -s "https://whois.verisign-grs.com/whois/$domain"
else
  print_error "Whois komutu bulunamadı."
fi

module_end