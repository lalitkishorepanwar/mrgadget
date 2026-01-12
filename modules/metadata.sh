#!/bin/bash

# Ortak kütüphaneyi içe aktar
source "$(dirname "$0")/common.sh"

# Modül başlığını göster
module_start "Metadata (Exif) Analizi"

print_info "Analiz edilecek dosyanın tam yolunu girin (veya sürükleyip bırakın):"
read -p "$(echo -e ${YELLOW}"Dosya: "${NC})" file_path

# Tırnak işaretlerini temizle (sürükle bırak yapınca gelebilir)
file_path="${file_path%\"}"
file_path="${file_path#\"}"

if [ ! -f "$file_path" ]; then
    print_error "Dosya bulunamadı: $file_path"
    exit 1
fi

print_header "Metadata Analizi: $(basename "$file_path")"

# Exiftool kontrolü
if command -v exiftool &> /dev/null; then
    print_info "Exiftool ile analiz ediliyor..."
    echo
    
    # Exiftool çıktısını renklendir ve filtrele
    exiftool "$file_path" | while read -r line; do
        tag=$(echo "$line" | cut -d: -f1 | xargs)
        value=$(echo "$line" | cut -d: -f2- | xargs)
        
        # Önemli etiketleri vurgula
        if [[ "$tag" == *"GPS"* ]]; then
            print_item "$WORLD" "$tag" "$value"
        elif [[ "$tag" == *"Make"* || "$tag" == *"Model"* ]]; then
             print_item "$TARGET" "$tag" "$value"
        elif [[ "$tag" == *"Date"* || "$tag" == *"Time"* ]]; then
             print_item "$KEY" "$tag" "$value"
        else
            echo -e "${CYAN}$tag${NC}: $value"
        fi
    done

else
    print_warning "Exiftool bulunamadı!"
    echo "Daha basit bir analiz (file komutu) yapılıyor..."
    echo
    file "$file_path"
    echo
    print_info "Tam analiz için 'exiftool' kurmanızı öneririm."
    echo "Windows için: https://exiftool.org/"
    echo "Linux: sudo apt install libimage-exiftool-perl"
fi

module_end
