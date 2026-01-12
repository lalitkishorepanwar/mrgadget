#!/bin/bash

# Ortak kütüphaneyi içe aktar
source "$(dirname "$0")/common.sh"

# Modül başlığını göster
module_start "E-posta Analizi"

print_info "E-posta adresini girin:"
read -p "$(echo -e ${YELLOW}"E-posta: "${NC})" email

# E-posta Regex Kontrolü
regex="^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$"
if [[ ! $email =~ $regex ]]; then
    print_error "Geçersiz e-posta formatı!"
    exit 1
fi

domain=$(echo $email | cut -d "@" -f2)

print_header "E-posta Analizi: $email"

# E-posta domaini hakkında bilgi topla
print_info "Domain ($domain) analiz ediliyor..."
echo

# Mail sunucu bilgilerini topla
print_section "Mail Sunucuları (MX)"
echo -e "${CYAN}"
if command -v dig &> /dev/null; then
    dig $domain MX +short
else
    nslookup -type=mx $domain | grep -v "Server:" | grep -v "Address:" | grep -v "Non-authoritative"
fi
echo -e "${NC}"


# SPF Kayıtları
print_section "SPF Kayıtları"
echo -e "${CYAN}"
if command -v dig &> /dev/null; then
    dig $domain TXT +short | grep "spf"
else
    # Windows nslookup TXT çıktısı dağınık olabilir, grep ile spf yakalamaya çalışıyoruz
    # ama satır bölünmüşse yakalanamayabilir. O yüzden geniş bir çıktı verip kullanıcıya bırakmak daha güvenli olabilir.
    # Ancak SPF genelde "v=spf1" ile başlar.
    nslookup -type=txt $domain | grep "spf" 
    if [ $? -ne 0 ]; then
         echo "SPF kaydı grep ile bulunamadı, tüm TXT kayıtları aşağıdadır:"
         nslookup -type=txt $domain | grep -v "Server:" | grep -v "Address:"
    fi
fi
echo -e "${NC}"

# DMARC Kayıtları
print_section "DMARC Kayıtları"
echo -e "${CYAN}"
if command -v dig &> /dev/null; then
    dig _dmarc.$domain TXT +short
else
    nslookup -type=txt _dmarc.$domain | grep -v "Server:" | grep -v "Address:"
fi
echo -e "${NC}"

# Olası veri ihlalleri hakkında bilgi notu
print_item "$SHIELD" "Veri İhlali Kontrolü" "https://haveibeenpwned.com/account/$email"

module_end