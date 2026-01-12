# ⚡ MR.GADGET - Ultimate OSINT Framework

![Banner](https://img.shields.io/badge/Status-Active-green) ![Version](https://img.shields.io/badge/Version-2.0-blue) ![License](https://img.shields.io/badge/License-MIT-orange)

**MR.GADGET**, siber güvenlik uzmanları, araştırmacılar ve meraklılar için geliştirilmiş, **Bash tabanlı** kapsamlı bir Açık Kaynak İstihbarat (OSINT) aracıdır. Karmaşık istihbarat süreçlerini tek bir çatı altında toplar ve **25+ modülü** ile profesyonel analiz imkanı sunar.

> **"Hedefini Tanı, Güvenliğini Sağla"** - _Enterprise Intelligence Edition_

---

## 🚀 Özellikler

Bu araç **5 Ana Uzmanlık Alanına** göre yapılandırılmıştır:

### 👤 1. Dijital Kimlik & Sızıntı (Identity)

- **Sızıntı Kontrolü:** E-posta adreslerinin sızdırıldığı veritabanlarını (HaveIBeenPwned API) kontrol eder.
- **Telefon Analizi:** Numara operatör tahmini ve tersine arama (Reverse Lookup) linkleri üretir.
- **Sosyal Medya & Whois:** Kullanıcı adı ve alan adı sahiplik taraması.

### 🏢 2. Teknik Altyapı (Infrastructure)

- **Ağ Analizi:** Port tarama, WAF (Güvenlik Duvarı) tespiti ve SSL sertifika analizi.
- **Domain İstihbaratı:** Detaylı DNS kayıtları, Subdomain keşfi ve IP konumu.

### 🌐 3. Web İstihbaratı (Web Recon)

- **Web Analizi:** CMS (WordPress, Joomla vb.) tespiti.
- **Arşiv Tarama:** Wayback Machine ile silinmiş sayfaları görüntüleme.
- **Güvenlik:** Robots.txt analizi ve HTTP Güvenlik Header puanlaması.

### 💰 4. Finans & IoT (Special Intelligence)

- **Kripto Takip:** Bitcoin cüzdan bakiyelerini ve işlem geçmişini sorgular.
- **IoT Arama:** Shodan ve Censys "dork"ları ile savunmasız cihazları (Kamera, Sunucu) bulur.
- **MAC Sorgu:** Cihazların üretici firmasını fiziksel adresinden (MAC) tespit eder.

### 🛠️ 5. Forensics & Araçlar

- **Metadata (Exif):** Fotoğraflardaki gizli GPS ve cihaz bilgilerini çıkarır.
- **Kripto Araçları:** Base64, Hex, Rot13 şifreleme ve çözme.
- **Link Analizi:** Kısaltılmış linklerin (bit.ly vb.) gerçek hedefini çözer.

---

## 📦 Kurulum

### Gereksinimler

Bu araç **Linux** (Kali, Ubuntu, Debian) ve **Windows (Git Bash / WSL)** üzerinde çalışır.
Temel bağımlılıklar: `curl`, `whois`, `bind-tools` (nslookup), `grep`.

### İndirme ve Çalıştırma

```bash
# Repoyu klonlayın
git clone https://github.com/p0is0n3r404/mrgadget.git

# Dizine girin
cd mrgadget

# Çalıştırma izni verin
chmod +x main.sh modules/*.sh

# Aracı başlatın
./main.sh
```

---

## 📸 Ekran Görüntüleri

_(Buraya aracın çalışırkenki ekran görüntülerini ekleyebilirsiniz)_

---

## ⚠️ Yasal Uyarı

Bu araç **sadece eğitim ve yasal güvenlik testleri** amacıyla geliştirilmiştir.

- Kötü niyetli kullanımlardan doğacak sorumluluk tamamen kullanıcıya aittir.
- Yetkiniz olmayan sistemlerde tarama yapmayınız.

---

## 👨‍💻 Geliştirici

**Coded by p0is0n3r404**

Projeye katkıda bulunmak veya hata bildirmek için [Issues](https://github.com/p0is0n3r404/mrgadget/issues) sayfasını kullanabilirsiniz.
