#!/bin/bash

# Ortak kütüphaneyi içe aktar
source "$(dirname "$0")/common.sh"

# Modül başlığını göster
module_start "Kripto Cüzdan Takibi"

echo -e "${YELLOW}Cüzdan Türü:${NC}"
echo -e "1) Bitcoin (BTC)"
echo -e "2) Ethereum (ETH)"
echo
read -p "$(echo -e ${GREEN}"Seçim: "${NC})" crypto_type

print_info "Cüzdan Adresini Girin:"
read -p "$(echo -e ${YELLOW}"Adres: "${NC})" address

if [ -z "$address" ]; then
    print_error "Adres boş olamaz!"
    exit 1
fi

print_header "Bakiye Sorgulama"

if command -v curl &> /dev/null; then
    
    if [ "$crypto_type" == "1" ]; then
        # Blockchain.info API (Ücretsiz, Rate limitli)
        print_info "Bitcoin ağı sorgulanıyor..."
        response=$(curl -s "https://blockchain.info/q/addressbalance/$address")
        
        # Hata kontrolü (API bazen HTML hata döner)
        if [[ "$response" =~ ^[0-9]+$ ]]; then
            # Satoshi to BTC
            balance=$(awk "BEGIN {print $response/100000000}")
            print_item "$KEY" "Toplam Bakiye" "$balance BTC"
            print_item "$MAGNIFIER" "Detaylı Takip" "https://www.blockchain.com/btc/address/$address"
        else
            print_error "Sorgu başarısız veya geçersiz adres."
        fi

    elif [ "$crypto_type" == "2" ]; then
        # Etherscan için API Key gerekir, web scraping zor.
        # Kullanıcıyı yönlendirmek daha sağlam.
        print_info "Ethereum ağı (Web Linki)..."
        print_item "$MAGNIFIER" "Etherscan Adres" "https://etherscan.io/address/$address"
        print_warning "ETH API'si için anahtar gerektiğinden, doğrudan tarayıcıda açmanız önerilir."
    fi

else
    print_error "Curl bulunamadı."
fi

module_end
