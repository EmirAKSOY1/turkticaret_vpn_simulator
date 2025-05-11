# Türkticaret VPN Simulator

Bu proje, Türkticaret VPN uygulaması Case Study için geliştirilmiş bir Flutter uygulamasıdır.

## Özellikler

- VPN bağlantı simülasyonu
- Kullanıcı kimlik doğrulama
- Modern ve kullanıcı dostu arayüz
- Launcher icon
- Launcher name
- Tema desteği
- Tema değişikliği
- APK Dosyası
- Sayfa geçişleri arasında aniamsyon
- Connecting ve disconnecting animasyonları
- Bağlantı Hızı animasyonları

## Gereksinimler

- Flutter SDK (3.0.0 veya üzeri)
- Dart SDK (3.0.0 veya üzeri)

## Kurulum

1. Projeyi klonlayın:
```bash
git clone https://github.com/EmirAKSOY1/turkticaret_vpn_simulator
cd turkticaret_vpn_simulator
```

2. Bağımlılıkları yükleyin:
```bash
flutter pub get
```

3. Firebase yapılandırması:
   - Firebase Console'dan yeni bir proje oluşturun
   - Android ve iOS uygulamalarını projeye ekleyin
   - Firebase yapılandırma dosyalarını ilgili platform klasörlerine ekleyin
   - Firebase Authentication'ı etkinleştirin

4. Uygulamayı çalıştırın:
```bash
flutter run
```
5. Veya buradan direkt apk dosyasını indirebilirsiniz:
   https://drive.google.com/file/d/1OZKTFNx48vcj8IKe_kvYYCdeGLQhwtp9/view?usp=drive_link


### Proje Yapısı

```
lib/
  ├── controllers/    # GetX controllers
  ├── models/        # Veri modelleri ve mock data
  ├── services/      # Servis katmanı
  └── views/        # Ekranlar
```

### Kullanılan Teknolojiler

- Flutter - UI framework
- GetX - State management ve routing
- Firebase - Kimlik doğrulama ve backend servisleri
- Flutter SVG - SVG görüntü desteği
- Google Fonts - Özel yazı tipleri

### Kullanılan Paketler

  - get: ^4.6.6 
  - flutter_svg: ^2.0.9
  - google_fonts: ^6.1.0
  - intl: ^0.19.0
  - firebase_core: ^3.13.0
  - firebase_auth: ^5.5.3

