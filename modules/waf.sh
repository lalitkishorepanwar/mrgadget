#!/bin/bash

# Ortak kütüphaneyi içe aktar
source "$(dirname "$0")/common.sh"

# Modül başlığını göster
module_start "WAF & Güvenlik Duvarı Tespiti"

print_info "Hedef domain'i girin:"
read -p "$(echo -e ${YELLOW}"Domain: "${NC})" domain

if ! validate_domain "$domain"; then
    print_error "Geçersiz domain formatı!"
    exit 1
fi

print_header "WAF Analizi: $domain"
print_info "Web Application Firewall (WAF) izleri aranıyor..."
echo

# 1. HTTP Header Kontrolü
print_section "HTTP Header Analizi"

if command -v curl &> /dev/null; then
    # Headerları çek
    headers=$(curl -s -I -L "https://$domain")
    
    # Cloudflare
    if echo "$headers" | grep -qi "cf-ray"; then
        print_item "$SHIELD" "Cloudflare" "Tespit Edildi (cf-ray header)"
    elif echo "$headers" | grep -qi "server: cloudflare"; then
        print_item "$SHIELD" "Cloudflare" "Tespit Edildi (Server header)"
    fi
    
    # Akamai
    if echo "$headers" | grep -qi "akamai"; then
        print_item "$SHIELD" "Akamai" "Tespit Edildi"
    fi
    
    # AWS CloudFront
    if echo "$headers" | grep -qi "x-amz-cf-id"; then
        print_item "$SHIELD" "AWS CloudFront" "Tespit Edildi"
    elif echo "$headers" | grep -qi "cloudfront"; then
        print_item "$SHIELD" "AWS CloudFront" "Tespit Edildi"
    fi
    
    # Incapsula
    if echo "$headers" | grep -qi "incapsula"; then
        print_item "$SHIELD" "Incapsula" "Tespit Edildi"
    fi

    # Sucuri
    if echo "$headers" | grep -qi "sucuri"; then
        print_item "$SHIELD" "Sucuri" "Tespit Edildi"
    fi
    
    echo -e "${GRAY}Header kontrolü tamamlandı.${NC}"
else
    print_error "Curl bulunamadı, header analizi atlanıyor."
fi
echo

# 2. DNS CNAME Kontrolü
print_section "DNS CNAME Kontrolü"
echo -e "${GRAY}DNS kayıtlarında WAF izleri aranıyor...${NC}"

if command -v nslookup &> /dev/null; then
    cname_output=$(nslookup -type=cname $domain 2>&1)
    
    if echo "$cname_output" | grep -qi "cloudflare"; then
        print_item "$SHIELD" "Cloudflare" "CNAME kaydında bulundu"
    elif echo "$cname_output" | grep -qi "akamai"; then
        print_item "$SHIELD" "Akamai" "CNAME kaydında bulundu"
    elif echo "$cname_output" | grep -qi "cloudfront"; then
        print_item "$SHIELD" "AWS CloudFront" "CNAME kaydında bulundu"
    else
        echo -e "${YELLOW}CNAME üzerinden belirgin bir WAF tespit edilemedi.${NC}"
    fi
fi

echo
print_info "Not: Bu pasif bir taramadır. Kesin sonuç için 'wafw00f' gibi araçlar önerilir."

module_end
