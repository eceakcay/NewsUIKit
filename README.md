# 📰 NewsApp (UIKit)

NewsApp, **UIKit** kullanılarak geliştirilmiş modern bir iOS haber uygulamasıdır.  
Uygulama, **News API** üzerinden güncel haberleri listeler; **gerçek API tabanlı arama**,  
**pagination**, **loading & error state**, **bildirim izni** gibi gerçek dünya ihtiyaçlarını karşılar.

Bu proje, **UIKit + MVVM mimarisi** öğrenmek ve uygulamak amacıyla geliştirilmiştir.

---

## 🚀 Özellikler

- 📰 Güncel haber akışı (News API)
- 🔍 Gerçek API tabanlı arama (search endpoint)
- ⏬ Pagination (infinite scroll)
- ⏳ Loading göstergesi (spinner)
- ❌ Error & Empty State UI
- 🖼️ Haber görselleri (Kingfisher)
- 🔔 Bildirim izni yönetimi (UserNotifications)
- ⚙️ Settings ekranı (Navbar ile)
- 🧭 UINavigationController tabanlı akış

---

## 🧠 Mimari

Uygulama **MVVM (Model–View–ViewModel)** mimarisiyle geliştirilmiştir.

### 📦 Model
- `Article`
- `NewsResponse`

Sadece veri yapıları içerir, iş mantığı barındırmaz.

---

### 🧠 ViewModel
- `HomeViewModel`

Sorumluluklar:
- API çağrılarını yönetmek
- Pagination state yönetimi
- Search state yönetimi
- Loading / Error durumlarını View’a bildirmek

ViewModel, **ViewController’ı doğrudan tanımaz**.  
Delegate pattern kullanır ve `weak` referans ile memory leak önlenir.

---

### 🖥 View (UIKit)
- `HomeViewController`
- `SettingsViewController`
- `ArticleCell`
- `StateView`

Sorumluluklar:
- UI çizimi
- Kullanıcı etkileşimini almak
- ViewModel’e yalnızca **niyet** bildirmek

> ViewController **API çağırmaz** ve **iş mantığı içermez**.

---

## 🌐 Network Katmanı

- `URLSession` kullanılarak geliştirilmiştir
- Apple’ın native ve güvenli network çözümü tercih edilmiştir
- Network işlemleri `NetworkManager` üzerinden soyutlanmıştır

### Kullanılan Endpoint’ler
- `top-headlines` → Ana haber akışı
- `everything` → Arama (Search)

---

## 🛠 Kullanılan Teknolojiler

- Swift
- UIKit
- URLSession
- MVVM
- UITableView
- UINavigationController
- UserNotifications
- Kingfisher

---

## 🔔 Bildirimler

Uygulama, kullanıcıdan bildirim izni almak için  
**UserNotifications framework**’ünü kullanır.

> Bu projede gerçek push notification gönderimi yoktur.  
> Amaç, izin yönetimi ve sistem entegrasyonunu göstermektir.

---

## 📂 Proje Yapısı (Özet)

NewsApp
├── Core
│ ├── Network
│ ├── UI
│ └── Constants
├── Features
│ ├── Home
│ └── Settings
├── Models
└── Resources

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
- UIKit öğrenmek isteyenler için
- MVVM mimarisini anlamak isteyenler için
- Gerçek hayata yakın bir iOS uygulama örneği sunmak için

geliştirilmiştir.

---

## 👤 Geliştirici

**Ece Akçay**  
iOS Developer (UIKit / Swift)

---

## 📄 Lisans

Bu proje eğitim amaçlı geliştirilmiştir.  
Serbestçe incelenebilir ve geliştirilebilir.
