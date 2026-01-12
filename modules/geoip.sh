#!/bin/bash

# Ortak kütüphaneyi içe aktar
source "$(dirname "$0")/common.sh"

# Modül başlığını göster
module_start "IP Konum Analizi"

print_info "IP Lokasyon analizi için IP adresi veya domain girin:"
read -p "$(echo -e ${YELLOW}"Hedef: "${NC})" target

ip_address=""
is_domain=false

# IP mi Domain mi kontrol et
if validate_ip "$target"; then
    ip_address=$target
    print_info "IP adresi algılandı: $ip_address"
else
    # Domain formatı kontrolü
    if validate_domain "$target"; then
        is_domain=true
        print_info "Domain algılandı, IP adresi çözümleniyor: $target"
        
        # IP Çözümleme
        if command -v host &> /dev/null; then
            ip_address=$(host $target | grep "has address" | head -1 | awk '{print $4}')
        elif [[ "$OSTYPE" == "msys" || "$OSTYPE" == "win32" ]]; then
            ip_address=$(nslookup $target | findstr "Address:" | awk "{print \$2}" | head -1)
        else
            ip_address=$(ping -c 1 $target | grep -oE "\b([0-9]{1,3}\.){3}[0-9]{1,3}\b" | head -1)
        fi
        
        if [ -z "$ip_address" ]; then
            print_error "IP adresi belirlenemedi."
            exit 1
        fi
        print_success "IP adresi bulundu: $ip_address"
    else
        print_error "Geçersiz giriş. Lütfen IP veya Domain girin."
        exit 1
    fi
fi

print_header "Lokasyon Analizi: $ip_address"

if [ "$is_domain" = true ]; then
    print_item "$MAGNIFIER" "Domain" "$target"
fi
print_item "$MAGNIFIER" "IP Adresi" "$ip_address"
echo

# API Sorgusu
if command -v curl &> /dev/null; then
    print_info "Servisten veri çekiliyor..."
    
    # Windows/Linux curl uyumluluğu için basit yöntem
    response=$(curl -s "http://ip-api.com/json/$ip_address?fields=status,message,country,countryCode,region,regionName,city,zip,lat,lon,timezone,isp,org,as,mobile,proxy,hosting")
    
    # Basitçe ekrana basılabilir veya parse edilebilir.
    # Burada daha temiz bir çıktı için parse edelim
    
    country=$(echo $response | grep -o '"country":"[^"]*' | cut -d'"' -f4)
    city=$(echo $response | grep -o '"city":"[^"]*' | cut -d'"' -f4)
    isp=$(echo $response | grep -o '"isp":"[^"]*' | cut -d'"' -f4)
    lat=$(echo $response | grep -o '"lat":[^,]*' | cut -d':' -f2)
    lon=$(echo $response | grep -o '"lon":[^,]*' | cut -d':' -f2)
    
    if [ ! -z "$country" ]; then
        print_item "$WORLD" "Ülke" "$country"
        print_item "$TARGET" "Şehir" "$city"
        print_item "$ROOT" "ISP" "$isp"
        print_item "$MAGNIFIER" "Konum" "$lat, $lon"
    else
        print_warning "Detaylı bilgi alınamadı. Ham yanıt:"
        echo "$response"
    fi

else
    print_error "Curl bulunamadı!"
    echo "Lütfen Curl kurun veya manuel kontrol edin."
fi

module_end