#!/bin/bash

# Ortak kütüphaneyi içe aktar
source "$(dirname "$0")/common.sh"

# Modül başlığını göster
module_start "Subdomain Tarama"

print_info "Ana domain girin (örn: example.com):"
read -p "$(echo -e ${YELLOW}"Domain: "${NC})" domain

if ! validate_domain "$domain"; then
    print_error "Geçersiz domain formatı!"
    exit 1
fi

print_header "Subdomain Taraması: $domain"

# Wordlist kontrolü - Daha kapsamlı liste
WORDLIST="wordlists/subdomains.txt"

# Eğer wordlist yoksa veya çok kısaysa (eski test verisi) yeniden oluştur
line_count=0
if [ -f "$WORDLIST" ]; then
    line_count=$(wc -l < "$WORDLIST")
fi

if [ ! -f "$WORDLIST" ] || [ "$line_count" -lt 50 ]; then
    if [ ! -d "wordlists" ]; then mkdir -p wordlists; fi
    print_info "Kapsamlı wordlist oluşturuluyor..."
    cat > "$WORDLIST" << EOF
www
mail
remote
blog
webmail
server
ns1
ns2
ns3
ns4
smtp
secure
vpn
api
dev
staging
test
app
admin
portal
docs
shop
store
support
status
crm
erp
beta
demo
payment
dashboard
panel
account
my
client
login
ftp
files
media
static
cdn
img
images
video
assets
cloud
autodiscover
autoconfig
imap
pop
pop3
mobile
m
en
tr
auth
register
subscribe
payment
gateway
secure
db
database
sql
mysql
monitor
zabbix
nagios
cacti
jenkins
gitlab
git
svn
devops
internal
intra
corp
hr
careers
jobs
test1
test2
stage
preprod
prod
web
frontend
backend
graphql
rest
soap
xml
json
ws
wss
chat
meet
voice
video
stream
live
tv
radio
press
news
rss
feed
atom
sitemap
robots
law
legal
policy
terms
privacy
about
contact
help
faq
wiki
kb
knowledge
forum
community
social
facebook
twitter
instagram
linkedin
youtube
google
apple
android
ios
windows
linux
ubuntu
deb
rpm
download
get
buy
sell
market
cart
basket
checkout
order
billing
invoice
finance
marketing
sales
tech
it
ops
sysadmin
root
admin1
admin2
administrator
manager
director
ceo
cto
cfo
coo
user
member
guest
public
private
secret
hidden
backup
old
new
bak
tmp
temp
cache
proxy
router
switch
firewall
gw
net
lan
wan
wifi
wlan
hotspot
guest-wifi
printer
cam
camera
cctv
dvr
nvr
security
alarm
access
door
gate
office
home
remote-access
partner
vendor
affiliate
reseller
agent
broker
dealer
distributor
supplier
manufacturer
brand
product
service
solution
project
campaign
event
webinar
seminar
conference
expo
show
fair
festival
concert
party
club
group
team
staff
employee
student
teacher
faculty
alumni
parent
family
friend
EOF
    print_success "Wordlist güncellendi (${line_count} -> ~170 kayıt)."
else
    print_info "Mevcut wordlist kullanılıyor."
fi

print_section "DNS Tabanlı Keşif"

echo "- NS Kayıtları:"
nslookup -type=ns $domain | grep -v "Server:" | grep -v "Address:" 
echo "- MX Kayıtları:"
nslookup -type=mx $domain | grep -v "Server:" | grep -v "Address:"

print_section "Wordlist Tabanlı Tarama (Brute Force)"
echo "Tarama yapılıyor, lütfen bekleyin..."

total_found=0

while read subdomain; do
    if [ -z "$subdomain" ]; then continue; fi
    full_domain="${subdomain}.${domain}"
    
    # DNS kontrolü
    if nslookup $full_domain > /dev/null 2>&1; then
        echo -e "${GREEN}[+] Bulundu: $full_domain${NC}"
        total_found=$((total_found + 1))
    fi
done < "$WORDLIST"

echo
print_success "Toplam $total_found subdomain bulundu."

module_end