# MR.GADGET Kullanım Kılavuzu

![MR.GADGET](https://img.shields.io/badge/MR.GADGET-Açık%20Kaynak%20İstihbarat%20Aracı-blue)

## İçindekiler

1. [Giriş](#giriş)
2. [Kurulum](#kurulum)
3. [Başlarken](#başlarken)
4. [Modüller](#modüller)
   - [Domain Analizi](#domain-analizi)
   - [Sosyal Medya Analizi](#sosyal-medya-analizi)
   - [Google Dorking](#google-dorking)
   - [Whois Sorgusu](#whois-sorgusu)
   - [E-posta Analizi](#e-posta-analizi)
   - [SSL Sertifikası Kontrolü](#ssl-sertifikası-kontrolü)
   - [Port Tarama](#port-tarama)
   - [Subdomain Tarama](#subdomain-tarama)
   - [Detaylı DNS Analizi](#detaylı-dns-analizi)
   - [IP Konum Analizi](#ip-konum-analizi)
   - [HTML Rapor Oluşturma](#html-rapor-oluşturma)
5. [Raporlar](#raporlar)
6. [Sorun Giderme](#sorun-giderme)
7. [Sık Sorulan Sorular](#sık-sorulan-sorular)

## Giriş

MR.GADGET, açık kaynak istihbarat (OSINT) çalışmaları için geliştirilmiş kapsamlı bir komut satırı aracıdır. Bu araç, internet üzerinde hedef hakkında çeşitli bilgileri toplamak, analiz etmek ve raporlamak için tasarlanmıştır.

### Neden MR.GADGET?

- **Tek Çatı Altında Birçok Araç**: Farklı OSINT araçlarını ayrı ayrı kullanmak yerine, MR.GADGET ile tüm araçlara tek bir yerden erişebilirsiniz.
- **Kullanımı Kolay**: Renkli ve kullanıcı dostu arayüz ile kolayca navigasyon yapabilirsiniz.
- **Otomatik Raporlama**: Tüm bulgularınız otomatik olarak raporlanır ve istendiğinde HTML formatında dışa aktarılabilir.
- **Platformlar Arası Uyumluluk**: Windows, Linux ve macOS platformlarında çalışabilecek şekilde tasarlanmıştır.

## Kurulum

### Gereksinimler

- Bash kabuğu (Windows'ta Git Bash veya WSL)
- Curl
- Dig (İsteğe bağlı, daha detaylı DNS analizleri için)
- Nmap (İsteğe bağlı, daha kapsamlı port taramaları için)
- Whois (İsteğe bağlı, domain sahiplik bilgileri için)
- OpenSSL (İsteğe bağlı, SSL sertifika analizleri için)

### Hızlı Kurulum

1. Repoyu klonlayın:
   ```bash
   git clone https://github.com/kullanici/mr-gadget.git
   ```

2. Dizine gidin:
   ```bash
   cd mr-gadget
   ```

3. Ana script'i çalıştırma yetkisi verin:
   ```bash
   chmod +x main.sh
   ```

4. Uygulamayı başlatın:
   ```bash
   ./main.sh
   ```

## Başlarken

MR.GADGET'i başlattığınızda, renkli bir ana menü karşınıza çıkacaktır. Bu menüden kullanmak istediğiniz modülü seçebilirsiniz.

```
MR.GADGET - Açık Kaynak İstihbarat Aracı
────────────────────────────────────────────────────────────────────

 MENÜ SEÇENEKLERİ 

[1] Domain Analizi        - Domain hakkında temel bilgiler
[2] Sosyal Medya Analizi  - Sosyal medya hesaplarını ara
[3] Google Dorking        - Güçlü Google sorguları
...
```

## Modüller

### Domain Analizi

Bu modül, bir domain hakkında temel bilgileri toplar:
- IP adresi
- A, NS, MX ve TXT DNS kayıtları
- HTTP başlık bilgileri

#### Kullanım:
1. Ana menüden "1" seçeneğini seçin
2. Analiz etmek istediğiniz domain adresini girin (ör. example.com)
3. Sonuçlar ekranda gösterilir ve aynı zamanda "reports/domain_report.txt" dosyasına kaydedilir

### Sosyal Medya Analizi

Bu modül, belirli bir kullanıcı adını çeşitli sosyal medya platformlarında arayarak potansiyel hesapları tespit eder:
- Twitter/X
- Instagram
- LinkedIn
- GitHub
- Facebook
- TikTok

#### Kullanım:
1. Ana menüden "2" seçeneğini seçin
2. Aramak istediğiniz kullanıcı adını girin
3. Bağlantılar "reports/social_report.txt" dosyasına kaydedilir

### Google Dorking

Bu modül, hedef domain için çeşitli Google dorking sorguları oluşturur:
- Site içi arama 
- Dosya türü aramaları (PDF, DOC, XLS, vb.)
- Gizli dizinler
- Login sayfaları
- Potansiyel güvenlik açıkları

#### Kullanım:
1. Ana menüden "3" seçeneğini seçin
2. Domain veya anahtar kelime girin
3. Oluşturulan dork sorguları "reports/dorking_report.txt" dosyasına kaydedilir
4. Bu sorguları Google'da kullanarak daha fazla bilgi toplayabilirsiniz

### Whois Sorgusu

Bu modül, bir domain hakkında whois bilgilerini alarak kayıt tarihi, son kullanma tarihi, kayıt eden kişi/kurum gibi bilgilere erişim sağlar.

#### Kullanım:
1. Ana menüden "4" seçeneğini seçin
2. Domain adresini girin
3. Whois bilgileri "reports/whois_report.txt" dosyasına kaydedilir

### E-posta Analizi

Bu modül, bir e-posta adresini analiz ederek:
- E-posta domaini hakkında bilgi
- MX (mail sunucusu) kayıtları
- SPF ve DMARC kayıtları
- Olası veri ihlalleri hakkında notlar

#### Kullanım:
1. Ana menüden "5" seçeneğini seçin
2. Analiz etmek istediğiniz e-posta adresini girin
3. Sonuçlar "reports/email_report.txt" dosyasına kaydedilir

### SSL Sertifikası Kontrolü

Bu modül, bir web sitesinin SSL/TLS sertifikasını analiz eder:
- Sertifika bilgileri (süre, veren kurum, vb.)
- Sertifika zinciri
- SSL/TLS protokol ve şifreleme bilgileri

#### Kullanım:
1. Ana menüden "6" seçeneğini seçin
2. Domain adresini girin
3. SSL analizi "reports/ssl_report.txt" dosyasına kaydedilir

### Port Tarama

Bu modül, hedef IP veya domainde açık portları ve çalışan servisleri tespit eder:
- Yaygın portların (HTTP, SSH, FTP, vb.) durumu
- Tespit edilen servisler ve versiyonlar (nmap mevcutsa)

#### Kullanım:
1. Ana menüden "7" seçeneğini seçin
2. IP adresi veya domain girin
3. Tarama sonuçları "reports/portscan_report.txt" dosyasına kaydedilir

### Subdomain Tarama

Bu modül, bir ana domainin alt domainlerini (subdomain) keşfetmek için kullanılır:
- Wordlist tabanlı brute force tarama
- DNS kayıtları üzerinden subdomain tespiti
- Bulunan subdomainlerin listesi

#### Kullanım:
1. Ana menüden "8" seçeneğini seçin
2. Ana domain adresini girin
3. Bulunan subdomainler "reports/subdomain_report.txt" dosyasına kaydedilir

### Detaylı DNS Analizi

Bu modül, bir domain için kapsamlı DNS analizi sağlar:
- Tüm kayıt türleri (A, AAAA, CNAME, MX, NS, TXT, SOA, SRV, vb.)
- DNSSEC kontrolleri
- TTL (Time to Live) bilgileri

#### Kullanım:
1. Ana menüden "9" seçeneğini seçin
2. Domain adresini girin 
3. Detaylı DNS analizi "reports/dns_analysis_report.txt" dosyasına kaydedilir

### IP Konum Analizi

Bu modül, bir IP adresinin coğrafi konumunu belirlemeye yardımcı olur:
- Ülke, şehir, bölge bilgileri
- ISP ve organizasyon
- Zaman dilimi
- Enlem/boylam koordinatları

#### Kullanım:
1. Ana menüden "10" seçeneğini seçin
2. IP adresi veya domain girin
3. Konum bilgileri "reports/geoip_report.txt" dosyasına kaydedilir

### HTML Rapor Oluşturma

Bu modül, tüm oluşturulmuş raporları görsel olarak daha zengin HTML formatına dönüştürür:
- Tüm raporlar tek bir HTML dosyasında birleştirilir
- Okunması ve paylaşılması kolay format
- Otomatik olarak web tarayıcısında açılma

#### Kullanım:
1. Ana menüden "11" seçeneğini seçin
2. HTML rapor otomatik olarak oluşturulup "reports/html/" klasörüne kaydedilir
3. Rapor otomatik olarak web tarayıcısında açılır

## Raporlar

MR.GADGET, tüm analiz sonuçlarını otomatik olarak "reports/" klasörüne kaydeder. Her modül kendi rapor dosyasını oluşturur:

- `domain_report.txt` - Domain analiz raporu
- `social_report.txt` - Sosyal medya analiz raporu
- `dorking_report.txt` - Google dorking raporu
- `whois_report.txt` - Whois sorgu raporu
- `email_report.txt` - E-posta analiz raporu
- `ssl_report.txt` - SSL sertifika analiz raporu
- `portscan_report.txt` - Port tarama raporu
- `subdomain_report.txt` - Subdomain tarama raporu
- `dns_analysis_report.txt` - Detaylı DNS analiz raporu
- `geoip_report.txt` - IP konum analiz raporu

Ayrıca, HTML rapor oluşturma modülü ile tüm bu raporları tek bir HTML dosyasında birleştirebilirsiniz. HTML raporlar "reports/html/" klasöründe saklanır.

## Sorun Giderme

### Yaygın Sorunlar ve Çözümleri

1. **Bash Hatası Alıyorum**
   - Windows kullanıyorsanız Git Bash veya WSL (Windows Subsystem for Linux) kurulu olduğundan emin olun
   - Script'in başındaki shebang satırının `#!/bin/bash` olduğunu kontrol edin

2. **Komut Bulunamadı Hatası**
   - Curl, dig, nmap gibi harici araçları kullanabilmek için bunların sisteminizde yüklü olması gerekir
   - Eksik aracı yükleyin (örn. `apt install curl` veya `brew install dig`)

3. **Rapor Dosyası Oluşturulmuyor**
   - "reports" klasörünün yazma yetkisine sahip olduğunuzdan emin olun
   - Klasörü manuel olarak oluşturmayı deneyin: `mkdir -p reports`

4. **Modüller Çalışmıyor**
   - Modül dosyalarının çalıştırma yetkisine sahip olduğundan emin olun: `chmod +x modules/*.sh`
   - Modül dosya yollarının doğru olduğunu kontrol edin

## Sık Sorulan Sorular

### MR.GADGET yasal mı?

MR.GADGET, herkes için erişilebilen açık kaynaklı bilgileri toplar ve analiz eder. Ancak, herhangi bir bilgi toplama aracı gibi, başkalarının sistemlerine izinsiz erişim veya tarama yapma amacıyla kullanılmamalıdır. Hedef sistemler üzerinde tarama yapmadan önce gerekli izinleri aldığınızdan emin olun.

### Bu araç ne kadar güvenilir?

MR.GADGET, çeşitli açık kaynaklı araçlar ve API'ler kullanarak bilgi toplar. Sonuçların doğruluğu bu kaynakların kalitesine ve ulaşılabilirliğine bağlıdır. Her durumda, sonuçları doğrulamak için birden fazla kaynağı kontrol etmeniz önerilir.

### Rapor dosyalarımı nasıl paylaşabilirim?

"HTML Rapor Oluşturma" modülünü kullanarak (ana menüde 11. seçenek) tüm raporlarınızı tek bir HTML dosyasında birleştirebilirsiniz. Bu HTML dosyası, paylaşması kolay ve görsel olarak daha zengin bir formattır.

### Tüm özellikler ücretsiz mi?

Evet, MR.GADGET tamamen ücretsizdir ve açık kaynak kodludur. Bazı modüller üçüncü taraf API'lere (IP geolocation gibi) bağlıdır ve bu API'lerin kendi kullanım limitleri olabilir.

---

## Teşekkürler

MR.GADGET'i kullandığınız için teşekkür ederiz. Önerileriniz veya sorularınız için lütfen iletişime geçin veya GitHub üzerinde bir issue açın.

**MR.GADGET** - Hedefini Tanı, Güvenliğini Sağla 