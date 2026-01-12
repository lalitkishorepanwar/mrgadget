#!/bin/bash

# Ortak kütüphaneyi içe aktar
source "$(dirname "$0")/common.sh"

# Modül başlığını göster
module_start "Kripto Araçları (Encoder/Decoder)"

echo -e "${YELLOW}İşlem Seçin:${NC}"
echo -e "1) Base64 Encode"
echo -e "2) Base64 Decode"
echo -e "3) Hex Encode"
echo -e "4) Hex Decode"
echo -e "5) ROT13 (Caesar Cipher)"
echo
read -p "$(echo -e ${GREEN}"Seçim: "${NC})" choice

print_info "Metni girin:"
read -p "$(echo -e ${YELLOW}"Metin: "${NC})" text

if [ -z "$text" ]; then
    print_error "Metin boş olamaz!"
    exit 1
fi

print_header "Sonuç"

case $choice in
    1)
        encoded=$(echo -n "$text" | base64)
        print_item "$KEY" "Base64 Encoded" "$encoded"
        ;;
    2)
        decoded=$(echo -n "$text" | base64 -d 2>/dev/null)
        if [ $? -eq 0 ]; then
            print_item "$KEY" "Base64 Decoded" "$decoded"
        else
            print_error "Geçersiz Base64 formatı!"
        fi
        ;;
    3)
        # xxd veya od kullanılabilir, basitlik için hexdump
        encoded=$(echo -n "$text" | xxd -p | tr -d '\n')
        print_item "$KEY" "Hex Encoded" "$encoded"
        ;;
    4)
        # xxd reverse
        if command -v xxd &> /dev/null; then
            decoded=$(echo -n "$text" | xxd -r -p)
             print_item "$KEY" "Hex Decoded" "$decoded"
        else
            print_error "xxd aracı bulunamadı."
        fi
        ;;
    5)
        # tr komutu ile ROT13
        rotated=$(echo "$text" | tr 'A-Za-z' 'N-ZA-Mn-za-m')
        print_item "$KEY" "ROT13" "$rotated"
        ;;
    *)
        print_error "Geçersiz seçim."
        ;;
esac

echo
module_end
