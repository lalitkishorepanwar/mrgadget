#!/bin/bash

# Ortak kütüphaneyi içe aktar
source "$(dirname "$0")/common.sh"

# Modül başlığını göster
module_start "Telefon Numarası Analizi"

print_info "Telefon numarasını girin (Örn: +905551234567 veya 5551234567):"
read -p "$(echo -e ${YELLOW}"Tel No: "${NC})" phone

# Temizlik (Boşlukları ve tireleri kaldır)
phone_clean=$(echo "$phone" | tr -d ' -')

if [ -z "$phone_clean" ]; then
    print_error "Numara boş olamaz!"
    exit 1
fi

print_header "Numara Analizi: $phone_clean"

# Basit operatör tahmini (Türkiye için örnek)
if [[ "$phone_clean" == *53* ]]; then
    print_item "$TARGET" "Olası Operatör (TR)" "Turkcell"
elif [[ "$phone_clean" == *54* ]]; then
    print_item "$TARGET" "Olası Operatör (TR)" "Vodafone"
elif [[ "$phone_clean" == *55* ]]; then
    print_item "$TARGET" "Olası Operatör (TR)" "Turk Telekom"
else
    print_item "$INFO_MARK" "Operatör" "Bilinmiyor / Yabancı"
fi

echo
print_section "Tersine Arama (Reverse Lookup) Linkleri"
echo "Aşağıdaki servislerde numara kime ait kontrol edebilirsiniz:"
echo

# Google Dork
print_item "$MAGNIFIER" "Google Search" "https://www.google.com/search?q=\"$phone_clean\""

# WhatsApp Direct
print_item "$MAGNIFIER" "WhatsApp Profil" "https://wa.me/$phone_clean"

# Truecaller (Web)
print_item "$MAGNIFIER" "Truecaller" "https://www.truecaller.com/search/tr/$phone_clean"

# Sync.me
print_item "$MAGNIFIER" "Sync.me" "https://sync.me/search/?number=$phone_clean"

module_end
