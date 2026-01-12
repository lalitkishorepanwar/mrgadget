#!/bin/bash

# Ortak kütüphaneyi içe aktar
source "$(dirname "$0")/common.sh"

# Modül başlığını göster
module_start "Port Tarama"

print_info "Port taraması için IP adresi veya domain girin."
read -p "$(echo -e ${YELLOW}"Hedef: "${NC})" target

# Girdi Doğrulama (IP veya Domain olabilir)
if ! validate_ip "$target" && ! validate_domain "$target"; then
    print_error "Geçersiz hedef! Lütfen geçerli bir IP veya Domain girin."
    exit 1
fi

print_header "Port Taraması Başlatılıyor: $target"

# IP adresini belirleme
print_info "Erişilebilirlik kontrol ediliyor..."

if [[ "$OSTYPE" == "msys" || "$OSTYPE" == "win32" ]]; then
  ping -n 1 $target | findstr "Pinging"
else
  ping -c 1 $target | grep "PING"
fi
echo

# Nmap kullanarak tarama (eğer kuruluysa)
if command -v nmap &> /dev/null; then
    print_info "Nmap tespit edildi, gelişmiş tarama yapılıyor..."
    print_section "Yaygın Portlar Taraması (Nmap)"
    
    # Yaygın 20 portu tara
    nmap -T4 -F $target 2>&1
    echo
    
    # Servis tespiti
    print_info "Servis tespiti yapılıyor..."
    print_section "Servis Tespiti"
    nmap -T4 -sV -F --version-intensity 0 $target 2>&1
    echo
    
else
    print_warning "Nmap bulunamadı. Alternatif basit tarama kullanılıyor."
    
    # Alternatif basit port tarama (timeout ve /dev/tcp kullanarak)
    print_info "Basit port tarama yapılıyor..."
    print_section "Yaygın Portlar (TCP Connect)"
    
    # Yaygın portların listesi
    PORTS="21 22 23 25 53 80 110 115 139 143 443 445 993 995 1723 3306 3389 5900 8080 8443"
    
    # Tek satırda ilerleme göstermek için
    echo -n "Taranıyor: "
    
    for port in $PORTS; do
        # Windows uyumluluğu için
        if [[ "$OSTYPE" == "msys" || "$OSTYPE" == "win32" ]]; then
            # PowerShell ile port kontrolü
            if powershell -Command "(New-Object System.Net.Sockets.TcpClient).ConnectAsync('$target', $port).Wait(500)" 2>/dev/null; then
                echo -e -n "${GREEN}$port ${NC}"
                # Açık portları hemen alt satıra yazmak yerine bitince toplu da yazabiliriz
                # ama anlık feedback daha iyi
                # Buraya bir şey yazmıyoruz, sadece yeşil port numarası
            else
                echo -n "."
            fi
        else
            # Linux/Unix/Mac için /dev/tcp (bash özelliği) kullanarak kontrol
            timeout 0.5 bash -c "echo >/dev/tcp/$target/$port" 2>/dev/null
            if [ $? -eq 0 ]; then
                echo -e -n "${GREEN}$port ${NC}"
            else
                 echo -n "."
            fi
        fi
    done
    echo 
fi

module_end