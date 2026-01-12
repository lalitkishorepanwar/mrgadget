#!/bin/bash

# Ortak kütüphaneyi içe aktar
source "$(dirname "$0")/common.sh"

# Modül başlığını göster
module_start "Google Dorking"

print_info "Hedef domain veya anahtar kelime girin:"
read -p "$(echo -e ${YELLOW}"Hedef: "${NC})" target

if [ -z "$target" ]; then
    print_error "Hedef boş olamaz!"
    exit 1
fi

print_header "Google Dorking Sonuçları: $target"

# Fonksiyonla dork ekleme
function add_dork() {
    local title="$1"
    local dork="$2"
    # Sadece ekrana bas
    print_item "$MAGNIFIER" "$title" "$dork"
}

add_dork "Site içi arama" "site:$target"
add_dork "Dosya türü (PDF)" "site:$target filetype:pdf"
add_dork "Dosya türü (DOC)" "site:$target filetype:doc"
add_dork "Gizli dizinler" "site:$target intitle:index.of"
add_dork "Login sayfaları" "site:$target inurl:login"
add_dork "Config Dosyaları" "site:$target ext:xml | ext:conf | ext:cnf | ext:reg | ext:inf | ext:rdp | ext:cfg | ext:txt | ext:ora | ext:ini"
add_dork "SQL Hataları" "site:$target intext:\"sql syntax near\" | intext:\"syntax error has occurred\" | intext:\"incorrect syntax near\" | intext:\"unexpected end of SQL command\" | intext:\"Warning: mysql_connect()\" | intext:\"Warning: mysql_query()\" | intext:\"Warning: pg_connect()\""
add_dork "Açık Yönlendirmeler" "site:$target inurl:redir | inurl:url | inurl:redirect | inurl:return | inurl:src=http | inurl:r=http"

echo
print_info "Bu sorguları https://www.google.com adresinde kullanabilirsiniz."

module_end
