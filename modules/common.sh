#!/bin/bash

# Renk tanımları
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
ORANGE='\033[0;91m'
LIGHT_GREEN='\033[1;32m'
LIGHT_BLUE='\033[1;34m'
LIGHT_PURPLE='\033[1;35m'
NC='\033[0m' # No Color
BG_BLUE='\033[44m'
BG_RED='\033[41m'
BG_GREEN='\033[42m'
BG_BLACK='\033[40m'
BOLD='\033[1m'
UNDERLINE='\033[4m'
BLINK='\033[5m'

# Simgeler
CHECK_MARK="${GREEN}✓${NC}"
CROSS_MARK="${RED}✗${NC}"
INFO_MARK="${BLUE}ℹ${NC}"
WARNING_MARK="${YELLOW}⚠${NC}"
ROCKET="${CYAN}🚀${NC}"
MAGNIFIER="${YELLOW}🔍${NC}"
SHIELD="${GREEN}🛡️${NC}"
TARGET="${RED}🎯${NC}"
WORLD="${BLUE}🌐${NC}"
KEY="${YELLOW}🔑${NC}"

# Yardımcı Fonksiyonlar

function print_header() {
    local text="$1"
    echo -e "${BLUE}${BOLD}⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯ ${WHITE}${text}${BLUE} ⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯${NC}"
}

function print_success() {
  local text="$1"
  if [[ "$OSTYPE" == "msys" || "$OSTYPE" == "win32" ]]; then
    echo " [✓] $text"
  else
    echo -e " ${CHECK_MARK} ${GREEN}${text}${NC}"
  fi
}

function print_error() {
  local text="$1"
  if [[ "$OSTYPE" == "msys" || "$OSTYPE" == "win32" ]]; then
    echo " [✗] $text"
  else
    echo -e " ${CROSS_MARK} ${RED}${text}${NC}"
  fi
}

function print_info() {
    local text="$1"
    echo -e " ${INFO_MARK} ${LIGHT_BLUE}${text}${NC}"
}

function print_warning() {
    local text="$1"
    echo -e " ${WARNING_MARK} ${YELLOW}${text}${NC}"
}

function print_section() {
    local text="$1"
    echo -e "${MAGENTA}${BOLD}$text${NC}"
}

function print_module_header() {
    local text="$1"
    echo
    echo -e "${BG_BLUE}${WHITE}${BOLD} $text ${NC}"
    echo -e "${BLUE}${BOLD}════════════════════════════════════════════════════════════════════${NC}"
    echo
}

function print_item() {
    local icon="$1"
    local title="$2"
    local desc="$3"
    echo -e " $icon ${CYAN}${BOLD}$title${NC} - $desc"
}

function module_start() {
    local module_name="$1"
    clear
    echo
    echo -e "${CYAN}${BOLD}MR.GADGET - $module_name${NC}"
    echo -e "${BLUE}${BOLD}════════════════════════════════════════════════════════════════════${NC}"
    echo
}

function module_end() {
    echo
    echo -e "${BLUE}${BOLD}════════════════════════════════════════════════════════════════════${NC}"
    echo -e "${GREEN}✅ İşlem tamamlandı!${NC}"
    echo
}

# --- Yeni Eklenen Güvenlik ve Kontrol Fonksiyonları ---

function check_dependencies() {
    local dependencies=("$@")
    local missing_deps=0

    for dep in "${dependencies[@]}"; do
        if ! command -v "$dep" &> /dev/null; then
             # Windows kontrolü: command -v bazen .exe uzantısız çalışmayabilir, bir de where ile deneyelim
             if [[ "$OSTYPE" == "msys" || "$OSTYPE" == "win32" ]]; then
                 if ! where "$dep" &> /dev/null; then
                     print_error "$dep bulunamadı."
                     missing_deps=1
                 fi
             else
                 print_error "$dep bulunamadı."
                 missing_deps=1
             fi
        fi
    done

    if [ $missing_deps -eq 1 ]; then
        print_warning "Bazı bağımlılıklar eksik. Uygulama tam fonksiyonel çalışmayabilir."
        echo
        read -p "$(echo -e ${YELLOW}${BOLD}"Devam etmek istiyor musunuz? (E/h): "${NC})" choice
        if [[ "$choice" == "h" || "$choice" == "H" ]]; then
            exit 1
        fi
    fi
}

function validate_domain() {
    local domain="$1"
    # Basit domain regex kontrolü
    if [[ "$domain" =~ ^([a-zA-Z0-9](([a-zA-Z0-9-]){0,61}[a-zA-Z0-9])?\.)+[a-zA-Z]{2,}$ ]]; then
        return 0
    else
        print_error "Geçersiz domain formatı: $domain"
        return 1
    fi
}

function validate_ip() {
    local ip="$1"
    # IPv4 regex kontrolü
    if [[ "$ip" =~ ^([0-9]{1,3}\.){3}[0-9]{1,3}$ ]]; then
        # Her oktetin 0-255 arasında olduğunu detaylı kontrol etmek bash'de biraz uzun, 
        # şimdilik formatı basitçe kontrol ediyoruz.
        return 0
    else
        print_error "Geçersiz IP adresi formatı: $ip"
        return 1
    fi
}

function validate_input_safe() {
    local input="$1"
    # Tehlikeli karakterleri kontrol et (; | & $ ` > <)
    if [[ "$input" =~ [IT;\|\&\$\`\>\<] ]]; then
        print_error "Güvenlik uyarısı: Geçersiz karakterler tespit edildi."
        return 1
    fi
    return 0
}
