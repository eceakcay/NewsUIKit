# 📰 NewsApp (UIKit) - Modern iOS News Client

NewsApp, **UIKit** ve **MVVM** mimarisi kullanılarak geliştirilmiş, Apple News standartlarında bir kullanıcı deneyimi sunan modern bir iOS haber uygulamasıdır. Uygulama, **News API** üzerinden küresel haberleri gerçek zamanlı olarak çeker ve gelişmiş arama, kategori ve okuma özelliklerini barındırır.



---

## ✨ Öne Çıkan Özellikler

- **Modern Card UI:** `UITableView` (Inset Grouped) stili ile derinlik algısı yüksek, modern kart tasarımı.
- **🌓 Manuel & Otomatik Dark Mode:** Sistem ayarlarıyla tam uyumlu veya uygulama içinden kontrol edilebilir Karanlık Mod desteği.
- **🔍 Gelişmiş Arama:** API tabanlı, performans odaklı "Everything" endpoint entegrasyonu.
- **📳 Haptic Feedback:** Kullanıcı etkileşimlerini güçlendiren dokunsal geri bildirimler (`UISelectionFeedbackGenerator`).
- **🔄 Akıllı Yenileme:** "Pull-to-Refresh" ve sonsuz kaydırma (Infinite Scroll/Pagination) desteği.
- **🖼️ Efektif Görsel Yönetimi:** Kingfisher ile asenkron görsel yükleme, cache yönetimi ve "fade" geçiş efektleri.
- **⚙️ Gelişmiş Ayarlar:** İkonlarla zenginleştirilmiş, gruplandırılmış sistem tarzı ayarlar ekranı.
- **📲 Bildirim Yönetimi:** `UserNotifications` ile modern bildirim izni isteme ve yönetme akışı.

---

## 🧠 Mimari: MVVM (Model-View-ViewModel)

Proje, kodun okunabilirliğini ve test edilebilirliğini artıran **MVVM** mimarisi ile inşa edilmiştir.



### 📦 Katmanlar

- **Model:** `Article` ve `NewsResponse` (Decodable veri yapıları).
- **View (UIKit):** UI bileşenleri **Programmatic Auto Layout** kullanılarak kodla oluşturulmuştur (Storyboards kullanılmamıştır).
- **ViewModel:** İş mantığını, API koordinasyonunu ve görünüm durumlarını (Loading/Error/Success) yönetir.
- **Network Layer:** `URLSession` tabanlı, generic ve ölçeklenebilir bir ağ katmanı.

---

## 🌓 Karanlık Mod (Dark Mode)

Uygulama, Apple'ın **Semantic Colors** (label, systemBackground vb.) standartlarını kullanır. Bu sayede sadece renkler değil, gölgeler ve kontrast oranları da modlar arası geçişte otomatik olarak optimize edilir.



---

## 🛠 Kullanılan Teknolojiler

- **Dil:** Swift 5.x
- **UI Framework:** UIKit (Programmatic UI)
- **Networking:** URLSession
- **Image Caching:** [Kingfisher](https://github.com/onevcat/Kingfisher)
- **Local Storage:** UserDefaults
- **Feedback:** UISelectionFeedbackGenerator

---

## 📂 Proje Yapısı

```text
NewsApp
├── Core
│   ├── Network         # Generic NetworkManager ve API tanımları
│   ├── Theme           # Renk paleti ve global stil sabitleri (Indigo Theme)
├── Features
│   ├── Home            # Ana akış, Search ve Pagination mantığı
│   ├── Detail          # Okuma deneyimi, WebView linkleme ve Paylaşım
│   └── Settings        # Karanlık Mod ve Bildirim ayarları
├── Components          # Custom ArticleCell, StateView (Empty/Error states)
└── Models              # API veri modelleri
```

---

## ▶️ Kurulum

1. Projeyi klonla
2. Xcode ile aç
3. `NetworkConstants.swift` içine kendi **News API Key**’ini ekle
4. Uygulamayı çalıştır (`Cmd + R`)

> News API: https://newsapi.org

---

## 📌 Geliştirme Notları

- Search işlemi **local filtreleme değildir**
- Gerçek API search + pagination kullanılmıştır
- ViewController sade tutulmuştur
- Access control (`private`, `private(set)`) bilinçli kullanılmıştır
- Memory leak önlemek için `weak delegate` tercih edilmiştir

---

## 🎯 Amaç

Bu proje:
- **Access Control:** Kod içinde private ve final anahtar kelimeleri kullanılarak encapsulation prensiplerine uyulmuştur.
- **Memory Management:** [weak self] kullanımı ile "Retain Cycle" oluşumu engellenmiş ve bellek sızıntıları önlenmiştir.
- **Clean Code:** Görünüm bileşenleri (UI Components) closure bazlı tanımlanarak viewDidLoad kalabalığı önlenmiştir.

---

## 👤 Geliştirici

**Ece Akçay**  
iOS Developer (UIKit / Swift)

---

## 📄 Lisans

Bu proje eğitim amaçlı geliştirilmiştir.  
Serbestçe incelenebilir ve geliştirilebilir.
