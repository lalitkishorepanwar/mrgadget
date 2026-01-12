#!/bin/bash

# Ortak kütüphaneyi içe aktar
source "$(dirname "$0")/common.sh"

# Modül başlığını göster
module_start "Domain Analizi"

print_module_header "Domain Analizi"

print_info "Hedef domain bilgisi gerekiyor."
read -p "$(echo -e ${YELLOW}"Domain adresini girin: "${NC})" domain

# Girdi Doğrulama
if ! validate_domain "$domain"; then
    print_error "Lütfen geçerli bir domain adresi girin. (Örn: google.com)"
    exit 1
fi

print_header "Domain Analizi Başlatılıyor"
print_item "$MAGNIFIER" "Hedef" "$domain"
echo

# IP adresi tespiti
print_section "IP Adresi Tespiti"

# Ping ile IP bulma
# Windows ping çıktısı farklı olabilir, ancak direkt göstermek en iyisi
if [[ "$OSTYPE" == "msys" || "$OSTYPE" == "win32" ]]; then
    ping -n 1 $domain | findstr /i "Pinging reply"
else
    ping -c 1 $domain | head -n 2
fi
echo

# DNS kayıtları kontrolü
print_section "DNS Kayıtları Kontrolü"

# A kaydı
echo -e "${YELLOW}${BOLD}DNS A Kayıtları:${NC}"
echo -e "${CYAN}"
if command -v dig &> /dev/null; then
    dig $domain A +short
else
    nslookup -type=a $domain | grep -v "Server:" | grep -v "Address:" | grep -v "Name:"
fi
echo -e "${NC}"

# NS kaydı
echo -e "${YELLOW}${BOLD}DNS NS (Name Server) Kayıtları:${NC}"
echo -e "${CYAN}"
if command -v dig &> /dev/null; then
    dig $domain NS +short
else
    nslookup -type=ns $domain | grep -v "Server:" | grep -v "Address:"
fi
echo -e "${NC}"

# MX kaydı
echo -e "${YELLOW}${BOLD}DNS MX (Mail Server) Kayıtları:${NC}"
echo -e "${CYAN}"
if command -v dig &> /dev/null; then
    dig $domain MX +short
else
    nslookup -type=mx $domain | grep -v "Server:" | grep -v "Address:"
fi
echo -e "${NC}"

# TXT kaydı
echo -e "${YELLOW}${BOLD}DNS TXT Kayıtları:${NC}"
echo -e "${CYAN}"
if command -v dig &> /dev/null; then
    dig $domain TXT +short
else
    # Nslookup TXT kaydı özellikle Windows'ta çok satırlı ve karmaşık olabilir.
    # Filtrelemeyi kaldırıp ham çıktının temizlenmiş halini gösterelim.
    nslookup -type=txt $domain | grep -v "Server:" | grep -v "Address:" | grep -v "Non-authoritative"
fi
echo -e "${NC}"

# HTTP header bilgileri
print_section "HTTP Header Bilgileri"

if command -v curl &> /dev/null || where curl &> /dev/null; then
    print_info "HTTP başlıkları kontrol ediliyor..."
    
    # Tüm başlıkları göster, sadece gereksizleri çıkar
    if [[ "$OSTYPE" == "msys" || "$OSTYPE" == "win32" ]]; then
        curl -I -s "https://$domain" 2> nul
    else
        curl -I -s "https://$domain" 2>/dev/null
    fi
  
else
    print_error "curl komutu bulunamadı. HTTP header bilgileri alınamadı."
fi

# Modül bitişini göster
module_end
