#!/bin/bash

# Ortak kütüphaneyi içe aktar
source "$(dirname "$0")/common.sh"

# Modül başlığını göster
module_start "Hash Tespiti (Identifier)"

print_info "Analiz edilecek hash (şifreli metin) girin:"
read -p "$(echo -e ${YELLOW}"Hash: "${NC})" hash_string

if [ -z "$hash_string" ]; then
    print_error "Giriş boş olamaz!"
    exit 1
fi

length=${#hash_string}
print_header "Hash Analizi"
print_item "$KEY" "Giriş" "$hash_string"
print_item "$MAGNIFIER" "Uzunluk" "$length karakter"
echo

print_section "Olası Algoritmalar"

found=false

# Basit uzunluk bazlı tespit
case $length in
    32)
        print_item "$TARGET" "MD5" "Çok Yüksek İhtimal"
        print_item "$INFO_MARK" "NTLM" "Olası"
        found=true
        ;;
    40)
        print_item "$TARGET" "SHA-1" "Çok Yüksek İhtimal"
        print_item "$INFO_MARK" "MySQL v5" "Olası"
        found=true
        ;;
    56)
        print_item "$TARGET" "SHA-224" "Yüksek İhtimal"
        found=true
        ;;
    64)
        print_item "$TARGET" "SHA-256" "Çok Yüksek İhtimal"
        found=true
        ;;
    96)
        print_item "$TARGET" "SHA-384" "Yüksek İhtimal"
        found=true
        ;;
    128)
        print_item "$TARGET" "SHA-512" "Çok Yüksek İhtimal"
        print_item "$INFO_MARK" "Whirlpool" "Olası"
        found=true
        ;;
esac

# Karakter seti kontrolü (Bcrypt vb.)
if [[ "$hash_string" == "\$2"* ]]; then
    print_item "$TARGET" "Bcrypt" "Kesin"
    found=true
elif [[ "$hash_string" == "\$1\$"* ]]; then
    print_item "$TARGET" "MD5-Crypt" "Kesin"
    found=true
elif [[ "$hash_string" == "\$5\$"* ]]; then
    print_item "$TARGET" "SHA-256 Crypt" "Kesin"
    found=true
elif [[ "$hash_string" == "\$6\$"* ]]; then
    print_item "$TARGET" "SHA-512 Crypt" "Kesin"
    found=true
fi

if [ "$found" = false ]; then
    print_warning "Yaygın bir hash formatı ile eşleşmedi."
    echo "Uzunluk veya format standart dışı olabilir."
    echo "Hash türü analiz araçları (hashid, hash-identifier) kullanmanızı öneririm."
fi

module_end
