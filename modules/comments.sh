#!/bin/bash

# Ortak kütüphaneyi içe aktar
source "$(dirname "$0")/common.sh"

# Modül başlığını göster
module_start "HTML Yorum Kazıyıcı"

print_info "Hedef URL (http/https dahil veya hariç):"
read -p "$(echo -e ${YELLOW}"URL: "${NC})" url

# URL formatlama
if [[ ! "$url" =~ ^http ]]; then
    url="https://$url"
fi

print_header "Yorum Analizi: $url"
print_info "Sayfa kaynağı indiriliyor ve taranıyor..."
echo

if command -v curl &> /dev/null; then
    # Kaynağı indir
    content=$(curl -s -L "$url")
    
    if [ -z "$content" ]; then
        print_error "Siteye erişilemedi veya boş yanıt döndü."
        exit 1
    fi
    
    print_section "Bulunan Yorumlar (<!-- ... -->)"
    
    # Grep ile HTML yorumlarını yakala (Basit regex, multiline zor olabilir grep ile ama dener)
    # Perl regex (grep -P) daha iyidir ama portable olmayabilir.
    # Sed veya awk ile daha temiz çekelim.
    
    # Yorumları satır satır ayıklamaya çalış
    echo "$content" | grep -o '<!--.*-->' | while read -r comment; do
        # Çok uzun yorumları kısalt
        if [ ${#comment} -gt 100 ]; then
            display="${comment:0:97}..."
        else
            display="$comment"
        fi
        
        # Renkli çıktı
        echo -e "${CYAN}$display${NC}"
        
        # Hassas kelime kontrolü
        if echo "$comment" | grep -qiE "password|admin|todo|key|auth|token|debug"; then
             echo -e "  ${RED}└─ [!] HASSAS BİLGİ OLABİLİR${NC}"
        fi
    done
    
    # Hiç yorum yoksa
    if ! echo "$content" | grep -q '<!--'; then
        print_warning "Hiç HTML yorumu bulunamadı."
    fi

else
    print_error "Curl bulunamadı."
fi

module_end
