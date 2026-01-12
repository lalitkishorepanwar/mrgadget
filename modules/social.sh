#!/bin/bash

# Ortak kütüphaneyi içe aktar
source "$(dirname "$0")/common.sh"

# Modül başlığını göster
module_start "Sosyal Medya Analizi"

print_info "Hedef sosyal medya kullanıcı adını girin:"
read -p "$(echo -e ${YELLOW}"Kullanıcı adı: "${NC})" username

if [ -z "$username" ]; then
    print_error "Kullanıcı adı boş olamaz!"
    exit 1
fi

print_header "Sosyal Medya Analizi: $username"
print_info "Hesaplar için aktif kontrol yapılıyor (Bu işlem biraz sürebilir)..."
echo 

# User Agent tanımla (bot engellemesi için)
USER_AGENT="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36"

declare -A platforms
platforms=( 
    ["GitHub"]="https://github.com/$username"
    ["Instagram"]="https://instagram.com/$username"
    ["Twitter/X"]="https://twitter.com/$username"
    ["Facebook"]="https://facebook.com/$username"
    ["TikTok"]="https://tiktok.com/@$username"
    ["Pinterest"]="https://pinterest.com/$username"
    ["Reddit"]="https://reddit.com/user/$username"
    ["GitLab"]="https://gitlab.com/$username"
    ["Medium"]="https://medium.com/@$username"
    ["Vimeo"]="https://vimeo.com/$username"
    ["SoundCloud"]="https://soundcloud.com/$username"
    ["Bitbucket"]="https://bitbucket.org/$username"
    ["About.me"]="https://about.me/$username"
)

found_count=0

for platform in "${!platforms[@]}"; do
    url="${platforms[$platform]}"
    
    # İlerleme animasyonu gibi tek satırda yaz
    echo -ne "${YELLOW} Kontrol ediliyor: $platform...${NC}\r"
    
    # Curl ile kontrol et
    # -I: Header only, -L: Follow redirects, -s: Silent, -o: Output to null, -w: Write out http code
    if [[ "$OSTYPE" == "msys" || "$OSTYPE" == "win32" ]]; then
       # Windows curl bazen farklı davranabilir
       status_code=$(curl -s -o /dev/null -I -w "%{http_code}" -A "$USER_AGENT" "$url")
    else
       status_code=$(curl -s -o /dev/null -I -w "%{http_code}" -L -A "$USER_AGENT" "$url")
    fi
    
    # Sonuç analizi
    if [[ "$status_code" == "200" ]]; then
        print_item "$CHECK_MARK" "$platform" "$url"
        found_count=$((found_count + 1))
    elif [[ "$status_code" == "404" ]]; then
        # Bulunamadı - Göstermiyoruz veya silik gösterebiliriz
        # echo -e " ${CROSS_MARK} ${GRAY}$platform bulunamadı (${status_code})${NC}"
        :
    elif [[ "$status_code" == "429" ]]; then
         # Rate limit
         echo -e " ${WARNING_MARK} ${YELLOW}$platform (Çok fazla istek - Kontrol Edilemedi)${NC}"
    else
        # Diğer durumlar (302, 403 vb.) - Bazı siteler login'e atar (Instagram 302/200 dönebilir kararsız)
        # Şüpheli durum olarak işaretleyelim
        if [[ "$platform" == "Instagram" || "$platform" == "Facebook" || "$platform" == "Twitter/X" ]]; then
             # Bu platformlar genelde auth ister, kesin 404 dönmüyorsa var olabilir
             print_item "$WARNING_MARK" "$platform" "$url (Manuel Kontrol Önerilir - $status_code)"
             found_count=$((found_count + 1))
        fi
    fi
done

echo
echo -e "${GREEN}Toplam $found_count olası hesap bulundu.${NC}"

module_end
