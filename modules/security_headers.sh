#!/bin/bash

# Ortak kütüphaneyi içe aktar
source "$(dirname "$0")/common.sh"

# Modül başlığını göster
module_start "Güvenlik Header Puanı"

print_info "Hedef domain:"
read -p "$(echo -e ${YELLOW}"Domain: "${NC})" domain

if ! validate_domain "$domain"; then
    print_error "Geçersiz domain formatı!"
    exit 1
fi

print_header "Header Güvenlik Karnesi: $domain"

target_url="https://$domain"

if ! command -v curl &> /dev/null; then
    print_error "Curl bulunamadı."
    exit 1
fi

# Headerları çek
headers=$(curl -s -I -L "$target_url")

# Puanlama değişkenleri
score=100
missing_headers=()
present_headers=()

# Kontrol listesi
# Header Adı | Puan Cezası

function check_header() {
    local header_name="$1"
    local penalty="$2"
    
    if echo "$headers" | grep -qi "$header_name"; then
        present_headers+=("$header_name")
        echo -e " ${CHECK_MARK} ${GREEN}$header_name${NC}"
    else
        score=$((score - penalty))
        missing_headers+=("$header_name")
        echo -e " ${CROSS_MARK} ${RED}$header_name${NC} (-$penalty puan)"
    fi
}

echo -e "${BOLD}Header Kontrolleri:${NC}"
echo "--------------------------------"

check_header "Strict-Transport-Security" 20   # HSTS
check_header "Content-Security-Policy" 25     # CSP (En kritiği)
check_header "X-Frame-Options" 15             # Clickjacking
check_header "X-Content-Type-Options" 10      # MIME sniffing
check_header "Referrer-Policy" 10             # Gizlilik
check_header "Permissions-Policy" 10          # Özellik izinleri
check_header "X-XSS-Protection" 10            # Eski ama hala geçerli

echo "--------------------------------"
echo

# Puan Hesabı ve Harf Notu
grade=""
color=""

if [ $score -ge 90 ]; then grade="A+"; color=$GREEN;
elif [ $score -ge 80 ]; then grade="A"; color=$GREEN;
elif [ $score -ge 70 ]; then grade="B"; color=$CYAN;
elif [ $score -ge 60 ]; then grade="C"; color=$YELLOW;
elif [ $score -ge 50 ]; then grade="D"; color=$ORANGE;
else grade="F"; color=$RED; fi

# Negatif puan düzeltmesi
if [ $score -lt 0 ]; then score=0; fi

print_section "SONUÇ KARNESİ"
echo -e " Güvenlik Puanı: ${color}${BOLD}$score / 100${NC}"
echo -e " Harf Notu     : ${color}${BOLD}$grade${NC}"

if [ ${#missing_headers[@]} -gt 0 ]; then
    echo
    print_warning "Eksik olan kritik güvenlik başlıkları risk oluşturabilir."
fi

module_end
