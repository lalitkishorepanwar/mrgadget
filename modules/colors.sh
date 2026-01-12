#!/bin/bash

# Renk tanımları (Modüller tarafından kullanılacak)
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
NC='\033[0m' # No Color (Rengi sıfırla)
BG_BLUE='\033[44m'
BG_RED='\033[41m'
BG_GREEN='\033[42m'
BG_BLACK='\033[40m'
BOLD='\033[1m'
UNDERLINE='\033[4m'
BLINK='\033[5m'

# Renkli simgeler
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

# Renkli kutular ve headerlara yardımcı fonksiyonlar
function print_header() {
    local text="$1"
    echo -e "${BLUE}${BOLD}⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯ ${WHITE}${text}${BLUE} ⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯${NC}"
}

function print_success() {
  local text="$1"
  # Windows'ta renk desteği için özel kontrol
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

# Modüllerin hoş görünmesi için başlık ve alt kısım fonksiyonları
function module_start() {
    local module_name="$1"
    clear
    echo
    echo -e "${CYAN}${BOLD}MR.GADGET - $module_name${NC}"
    echo -e "${BLUE}${BOLD}════════════════════════════════════════════════════════════════════${NC}"
    echo
}

function module_end() {
    local report_file="$1"
    echo
    echo -e "${BLUE}${BOLD}════════════════════════════════════════════════════════════════════${NC}"
    echo -e "${GREEN}✅ İşlem tamamlandı!${NC}"
    
    if [ ! -z "$report_file" ]; then
        echo -e "${YELLOW}📋 Rapor dosyası: ${UNDERLINE}$report_file${NC}"
    fi
    
    echo
} 