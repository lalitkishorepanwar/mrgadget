#!/bin/bash

# Ortak kütüphaneyi içe aktar
source "$(dirname "$0")/common.sh"

module_start "Detaylı DNS Analizi"

print_info "Domain girin:"
read -p "$(echo -e ${YELLOW}"Domain: "${NC})" domain

if ! validate_domain "$domain"; then
    print_error "Geçersiz domain formatı!"
    exit 1
fi

print_header "DNS Analizi Başlatılıyor: $domain"

# Dig kontrolü
use_dig=false
if command -v dig &> /dev/null; then
    use_dig=true
    print_success "Dig aracı bulundu. Detaylı analiz yapılıyor."
else
    print_warning "Dig aracı bulunamadı, nslookup kullanılacak. Çıktılar sınırlı olabilir."
fi

# Önemli kayıt türleri
dns_record_types=("A" "AAAA" "CNAME" "MX" "NS" "TXT" "SOA" "SRV")

print_info "DNS kayıtları sorgulanıyor..."

for record_type in "${dns_record_types[@]}"; do
    echo -e "${MAGENTA}--- $record_type Kayıtları ---${NC}"
    echo -e "${CYAN}"
    
    if [ "$use_dig" = true ]; then
        dig $domain $record_type +noall +answer
    else
        # Nslookup çıktısını çok fazla filtrelemeden göster
        nslookup -type=$record_type $domain | grep -v "Server:" | grep -v "Address:" | grep -v "Non-authoritative"
    fi
    echo -e "${NC}"
done

# DNSSEC Kontrolü
if [ "$use_dig" = true ]; then
    print_section "DNSSEC Kontrolü"
    echo -e "${CYAN}"
    dig $domain DNSKEY +dnssec +short
    echo -e "${NC}"
fi

module_end