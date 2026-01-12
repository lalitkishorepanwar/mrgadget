#!/bin/bash

# Ortak kütüphaneyi içe aktar
source "$(dirname "$0")/common.sh"

# Modül başlığını göster
module_start "SSL Sertifikası Kontrolü"

print_info "Domain girin:"
read -p "$(echo -e ${YELLOW}"Domain: "${NC})" domain

# Validasyon
if ! validate_domain "$domain"; then
    print_error "Geçersiz domain formatı!"
    exit 1
fi

print_header "SSL Analizi: $domain"

# OpenSSL varlığını kontrol et
if command -v openssl &> /dev/null; then
    print_info "SSL sertifikası bilgileri alınıyor..."
    echo
    
    # Sertifikanın ana bilgilerini al
    print_section "Sertifika Özeti"
    timeout 10 openssl s_client -connect ${domain}:443 -servername ${domain} </dev/null 2>/dev/null | openssl x509 -noout -text | grep -E "Subject:|Issuer:|Not Before:|Not After :|DNS:"
    echo
    
    echo "** Sertifika Zinciri **"
    timeout 10 openssl s_client -connect ${domain}:443 -servername ${domain} </dev/null 2>/dev/null | grep -E "depth=|verify" | head -10
    echo
    
    echo "** Protokol ve Şifreleme Bilgileri **"
    timeout 10 openssl s_client -connect ${domain}:443 -servername ${domain} </dev/null 2>/dev/null | grep -E "Protocol|Cipher"
    echo
    
    # Sertifika geçerlilik kontrolü
    expiry_date=$(timeout 10 openssl s_client -connect ${domain}:443 -servername ${domain} </dev/null 2>/dev/null | openssl x509 -noout -enddate | cut -d= -f2)
    
    if [ ! -z "$expiry_date" ]; then
        print_success "Sertifika Tarihi: $expiry_date"
    else
        print_warning "Sertifika tarihi alınamadı."
    fi

else
    print_error "OpenSSL bulunamadı."
    echo "Lütfen OpenSSL kurun."
fi

module_end