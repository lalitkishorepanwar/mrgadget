#!/bin/bash

# Ortak kütüphaneyi içe aktar
source "$(dirname "$0")/common.sh"

# Modül başlığını göster
module_start "Link Takipçisi (Unshortener)"

print_info "Kısaltılmış veya şüpheli URL'yi girin:"
read -p "$(echo -e ${YELLOW}"URL: "${NC})" url

if [ -z "$url" ]; then
    print_error "URL boş olamaz!"
    exit 1
fi

print_header "Link Analizi Başlatılıyor"
print_item "$MAGNIFIER" "Hedef" "$url"
echo

if command -v curl &> /dev/null; then
    print_info "Yönlendirmeler izleniyor..."
    
    # Curl ile sadece headerları alıp Location bilgisini takip et
    # -I: Head only, -L: Follow redirects, -w: write out effective url
    
    final_url=$(curl -s -o /dev/null -I -w "%{url_effective}" -L "$url")
    
    if [ "$final_url" != "$url" ]; then
        print_success "Link çözüldü!"
        print_item "$TARGET" "Orijinal Link" "$url"
        print_item "$CHECK_MARK" "Gittiği Adres" "$final_url"
        
        # Güvenlik Kontrolü (Basit)
        if [[ "$final_url" == *".exe"* || "$final_url" == *".zip"* || "$final_url" == *".scr"* ]]; then
             echo
             print_warning "Dikkat! Bu link doğrudan bir dosyaya gidiyor olabilir."
        fi
    else
        print_warning "Hiçbir yönlendirme algılanmadı veya link zaten açık."
        print_item "$INFO_MARK" "Sonuç" "$final_url"
    fi

else
    print_error "Curl bulunamadı."
fi

module_end
