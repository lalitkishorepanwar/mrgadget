#!/bin/bash

# Ortak kütüphaneyi içe aktar
source "modules/common.sh"

# Wordlists klasörünü kontrol et ve yoksa oluştur
if [ ! -d "wordlists" ]; then
  mkdir -p wordlists
  print_success "Wordlists klasörü oluşturuldu."
fi

# Bağımlılık kontrolü
if ! command -v curl &> /dev/null; then
    # Sessizce devam et veya uyar
    :
fi

function show_banner() {
  clear
  echo
  echo -e "${CYAN}╔══════════════════════════════════════════════════════════════════════════╗${NC}"
  echo -e "${CYAN}║${RED}  ███╗   ███╗██████╗     ${GREEN}██████╗  █████╗ ██████╗  ██████╗ ███████╗████████╗${CYAN} ║${NC}"
  echo -e "${CYAN}║${RED}  ████╗ ████║██╔══██╗   ${GREEN}██╔════╝ ██╔══██╗██╔══██╗██╔════╝ ██╔════╝╚══██╔══╝${CYAN} ║${NC}"
  echo -e "${CYAN}║${RED}  ██╔████╔██║██████╔╝   ${GREEN}██║  ███╗███████║██║  ██║██║  ███╗█████╗     ██║   ${CYAN} ║${NC}"
  echo -e "${CYAN}║${RED}  ██║╚██╔╝██║██╔══██╗   ${GREEN}██║   ██║██╔══██║██║  ██║██║   ██║██╔══╝     ██║   ${CYAN} ║${NC}"
  echo -e "${CYAN}║${RED}  ██║ ╚═╝ ██║██║  ██║   ${GREEN}╚██████╔╝██║  ██║██████╔╝╚██████╔╝███████╗   ██║   ${CYAN} ║${NC}"
  echo -e "${CYAN}║${RED}  ╚═╝     ╚═╝╚═╝  ╚═╝    ${GREEN}╚═════╝ ╚═╝  ╚═╝╚═════╝  ╚═════╝ ╚══════╝   ╚═╝   ${CYAN} ║${NC}"
  echo -e "${CYAN}╚══════════════════════════════════════════════════════════════════════════╝${NC}"
  echo -e "                 ${YELLOW}⚡ ULTIMATE OSINT FRAMEWORK v2.0 ⚡${NC}"
  echo -e "                   ${WHITE}-- Enterprise Intelligence Edition --${NC}"
  echo -e "                          ${ORANGE}Coded by p0is0n3r404${NC}"
  echo
}

# Ana Döngü
while true; do
  show_banner
  
  # KATEGORİ 1: DİJİTAL KİMLİK
  echo -e "${WHITE}${BG_BLUE} 👤 DİJİTAL KİMLİK & SIZINTI (IDENTITY) ${NC}"
  echo -e "${YELLOW}[${CYAN}1${YELLOW}]${NC}  ${WHITE}Sosyal Medya Analizi${NC}   ${GRAY}- Kullanıcı adı taraması${NC}"
  echo -e "${YELLOW}[${CYAN}2${YELLOW}]${NC}  ${WHITE}E-posta Analizi${NC}        ${GRAY}- Mail format ve sunucu${NC}"
  echo -e "${YELLOW}[${CYAN}3${YELLOW}]${NC}  ${WHITE}Telefon Analizi${NC}        ${GRAY}- Operatör ve tersine arama${NC}"
  echo -e "${YELLOW}[${CYAN}4${YELLOW}]${NC}  ${WHITE}Sızıntı (Breach) Kontrol${NC}${GRAY}- HaveIBeenPwned sorgusu${NC}"
  echo -e "${YELLOW}[${CYAN}5${YELLOW}]${NC}  ${WHITE}Whois Sorgusu${NC}          ${GRAY}- Kişi/Kurum sahipliği${NC}"

  echo
  # KATEGORİ 2: TEKNİK ALTYAPI
  echo -e "${WHITE}${BG_BLUE} 🏢 TEKNİK & ALTYAPI (INFRASTRUCTURE) ${NC}"
  echo -e "${YELLOW}[${CYAN}6${YELLOW}]${NC}  ${WHITE}Domain Analizi${NC}"
  echo -e "${YELLOW}[${CYAN}7${YELLOW}]${NC}  ${WHITE}Detaylı DNS Analizi${NC}"
  echo -e "${YELLOW}[${CYAN}8${YELLOW}]${NC}  ${WHITE}Subdomain Tarama${NC}"
  echo -e "${YELLOW}[${CYAN}9${YELLOW}]${NC}  ${WHITE}Port Tarama${NC}"
  echo -e "${YELLOW}[${CYAN}10${YELLOW}]${NC} ${WHITE}WAF & Güvenlik Duvarı${NC}"
  echo -e "${YELLOW}[${CYAN}11${YELLOW}]${NC} ${WHITE}SSL Sertifika Analizi${NC}"

  echo
  # KATEGORİ 3: WEB & İÇERİK
  echo -e "${WHITE}${BG_BLUE} 🌐 WEB İSTİHBARATI (WEB RECON) ${NC}"
  echo -e "${YELLOW}[${CYAN}12${YELLOW}]${NC} ${WHITE}CMS & Teknoloji Tespiti${NC}"
  echo -e "${YELLOW}[${CYAN}13${YELLOW}]${NC} ${WHITE}Web Arşivi (Wayback)${NC}"
  echo -e "${YELLOW}[${CYAN}14${YELLOW}]${NC} ${WHITE}Robots.txt & Sitemap${NC}"
  echo -e "${YELLOW}[${CYAN}15${YELLOW}]${NC} ${WHITE}HTML Yorum Kazıyıcı${NC}"
  echo -e "${YELLOW}[${CYAN}16${YELLOW}]${NC} ${WHITE}Güvenlik Puanı (Headers)${NC}"

  echo
  # KATEGORİ 4: FİNANS & IoT
  echo -e "${WHITE}${BG_BLUE} 💰 FİNANS, IoT & KONUM (SPECIAL) ${NC}"
  echo -e "${YELLOW}[${CYAN}17${YELLOW}]${NC} ${WHITE}Kripto Cüzdan Takibi${NC}"
  echo -e "${YELLOW}[${CYAN}18${YELLOW}]${NC} ${WHITE}IoT Cihaz Arama (Shodan)${NC}"
  echo -e "${YELLOW}[${CYAN}19${YELLOW}]${NC} ${WHITE}IP Konum (GeoIP)${NC}"
  echo -e "${YELLOW}[${CYAN}20${YELLOW}]${NC} ${WHITE}MAC Adresi Sorgulama${NC}"

  echo
  # KATEGORİ 5: FORENSICS & ARAÇLAR
  echo -e "${WHITE}${BG_BLUE} 🛠️ FORENSICS & ARAÇLAR ${NC}"
  echo -e "${YELLOW}[${CYAN}21${YELLOW}]${NC} ${WHITE}Metadata (Exif) Analizi${NC}"
  echo -e "${YELLOW}[${CYAN}22${YELLOW}]${NC} ${WHITE}Hash Tespiti${NC}"
  echo -e "${YELLOW}[${CYAN}23${YELLOW}]${NC} ${WHITE}Kripto Kodlayıcı (Enc/Dec)${NC}"
  echo -e "${YELLOW}[${CYAN}24${YELLOW}]${NC} ${WHITE}Link Takipçisi (Unshortener)${NC}"
  echo -e "${YELLOW}[${CYAN}25${YELLOW}]${NC} ${WHITE}Google Dorking${NC}"
  echo -e "${YELLOW}[${CYAN}26${YELLOW}]${NC} ${WHITE}IP İtibar (Reputation)${NC}"
  
  echo
  echo -e "${RED}[27] ÇIKIŞ${NC}"
  echo
  echo -e "${BLUE}────────────────────────────────────────────────────────────────────────${NC}"
  read -p "$(echo -e ${GREEN}"Seçiminiz: "${NC})" secim

  case $secim in
    # Kategori 1
    1) bash modules/social.sh ;;
    2) bash modules/email.sh ;;
    3) bash modules/phone.sh ;;
    4) bash modules/breach_check.sh ;;
    5) bash modules/whois.sh ;;
    
    # Kategori 2
    6) bash modules/domain.sh ;;
    7) bash modules/dns_analysis.sh ;;
    8) bash modules/subdomain.sh ;;
    9) bash modules/portscan.sh ;;
    10) bash modules/waf.sh ;;
    11) bash modules/ssl.sh ;;
    
    # Kategori 3
    12) bash modules/cms.sh ;;
    13) bash modules/wayback.sh ;;
    14) bash modules/robots.sh ;;
    15) bash modules/comments.sh ;;
    16) bash modules/security_headers.sh ;;
    
    # Kategori 4
    17) bash modules/crypto_wallet.sh ;;
    18) bash modules/iot_dorks.sh ;;
    19) bash modules/geoip.sh ;;
    20) bash modules/mac_lookup.sh ;;

    # Kategori 5
    21) bash modules/metadata.sh ;;
    22) bash modules/hash_id.sh ;;
    23) bash modules/crypto.sh ;;
    24) bash modules/unshorten.sh ;;
    25) bash modules/dorking.sh ;;
    26) bash modules/reputation.sh ;;
    
    27) 
        echo -e "${YELLOW}Enterprise sürüm kapatılıyor... İyi günler!${NC}"
        exit 0 
        ;;
    *) 
        echo -e "${RED}Hatalı seçim!${NC}"
        sleep 1
        ;;
  esac

  echo
  echo -e "${GRAY}Ana menüye dönmek için [ENTER] tuşuna basın...${NC}"
  read
done
