# dilexAI App - Yapay Zeka Destekli Dilekçe Hazırlama Uygulaması

dilexAI App, yapay zeka teknolojisiyle resmi dilekçe oluşturmayı kolaylaştıran bir Flutter uygulamasıdır. Google'ın Gemini-1.5-Pro modeli kullanılarak geliştirilen bu uygulama, kullanıcıların kısa bir açıklama girerek profesyonel bir dilekçe metni oluşturmasına olanak tanır.

## Özellikler

- **Yapay Zeka ile Dilekçe Oluşturma**: Gemini API kullanarak metinleri otomatik oluşturma
- **Kişiselleştirilebilir Dilekçe Şablonları**: Ad, soyad, adres ve kurum bilgilerini ekleyebilme
- **PDF Formatında Çıktı**: Dilekçeleri profesyonel PDF belgesi olarak yazdırabilme
- **Paylaşım Özellikleri**: Oluşturulan dilekçeleri doğrudan diğer uygulamalarla paylaşabilme
- **Kullanıcı Dostu Arayüz**: Kolay kullanım için tasarlanmış modern UI

## Teknolojiler ve Kütüphaneler

- Flutter framework (SDK >= 3.0.0)
- Google Generative AI API (Gemini-1.5-Pro)
- PDF oluşturma ve yazdırma için `pdf` ve `printing` paketleri
- Dosya paylaşımı için `share_plus` paketi
- Çevre değişkenleri için `flutter_dotenv`

## Kurulum

1. Projeyi klonlayın:
```bash
git clone https://github.com/kullaniciadi/dilexai_app.git
cd dilexai_app
```

2. Bağımlılıkları yükleyin:
```bash
flutter pub get
```

3. [`.env`](.env ) dosyası oluşturun ve Gemini API anahtarınızı ekleyin:
```
GEMINI_API_KEY=sizin_api_anahtariniz
```

4. Uygulamayı çalıştırın:
```bash
flutter run
```

## Kullanım

1. Kişisel bilgilerinizi (ad, soyad, adres) girin
2. Dilekçe bilgilerini (kurum, başlık, konu) girin
3. "AI ile Oluştur" butonuna tıklayın veya dilekçenizi manuel olarak yazın
4. "Dilekçe Oluştur" butonuna basarak önizleme yapın
5. Dilekçenizi yazdırın, paylaşın veya kaydedin

## Ekran Görüntüleri

Uygulama ekran görüntüleri buraya eklenecek.

## Lisans

Bu proje MIT lisansı altında lisanslanmıştır.

## İletişim

Sorularınız için beratmen9@gmail.com adresine e-posta gönderebilirsiniz.