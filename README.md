# 📝 dilexAI App - Yapay Zeka Destekli Dilekçe Hazırlama Uygulaması

![Version](https://img.shields.io/badge/version-1.0.0-blue)
![Flutter](https://img.shields.io/badge/Flutter-3.0.0+-blue)
![License](https://img.shields.io/badge/license-MIT-green)

## 🚀 Proje Hakkında

dilexAI App, yapay zeka teknolojisiyle resmi dilekçe oluşturmayı kolaylaştıran modern bir Flutter uygulamasıdır. Google'ın Gemini-1.5-Pro modeli kullanılarak geliştirilen bu uygulama, kullanıcıların kısa bir açıklama girerek profesyonel bir dilekçe metni oluşturmasına olanak tanır. Kullanıcı dostu arayüzü ve güçlü özellikleriyle dilekçe yazma sürecini basitleştirir ve hızlandırır.

## ✨ Özellikler

- 🤖 **Yapay Zeka ile Dilekçe Oluşturma**: Gemini API kullanarak metinleri otomatik oluşturma
- 🔄 **Kişiselleştirilebilir Şablonlar**: Ad, soyad, adres ve kurum bilgilerini kolayca ekleyebilme
- 📃 **PDF Formatında Çıktı**: Dilekçeleri profesyonel PDF belgesi olarak yazdırabilme
- 📤 **Paylaşım Özellikleri**: Oluşturulan dilekçeleri doğrudan diğer uygulamalarla paylaşabilme
- 🎨 **Kullanıcı Dostu Arayüz**: Material Design 3 ile tasarlanmış modern UI
- 📱 **Çoklu Platform Desteği**: iOS, Android, web ve masaüstü platformlarında çalışabilme

## 🛠️ Kullanılan Teknolojiler

### 📱 Uygulama Geliştirme
- **Flutter Framework** (SDK >= 3.0.0) - Çoklu platform desteği için
- **Dart Programlama Dili** - Modern ve güçlü nesne yönelimli dil
- **Material Design 3** - Kullanıcı arayüzü için güncel tasarım sistemi

### 🧠 Yapay Zeka
- **Google Generative AI API** (Gemini-1.5-Pro) - Yapay zeka destekli metin üretimi

### 📄 Belge İşleme
- **pdf** ve **printing** paketleri - PDF oluşturma ve yazdırma işlemleri
- **share_plus** - Dosya paylaşımı işlemleri
- **path_provider** - Dosya yönetimi

### 🔐 Güvenlik
- **flutter_dotenv** - Çevre değişkenleri ve API anahtarları yönetimi

## 📋 Kurulum

1. **Projeyi Klonlayın**:
   ```bash
   git clone https://github.com/beratmen/dilexAI_App.git
   cd dilexAI_App
   ```

2. **Bağımlılıkları Yükleyin**:
   ```bash
   flutter pub get
   ```

3. **API Anahtarı Yapılandırması**:
   - Bir `.env` dosyası oluşturun (kök dizinde)
   - Aşağıdaki formatı kullanarak API anahtarınızı ekleyin:
     ```
     GEMINI_API_KEY=your_api_key_here
     ```
   - API anahtarınızı [Google AI Studio](https://makersuite.google.com/app/apikey) üzerinden edinebilirsiniz

4. **Uygulamayı Çalıştırın**:
   ```bash
   flutter run
   ```

## 📱 Kullanım

1. **Kişisel Bilgiler**: Ad, soyad ve adres bilgilerinizi girin
2. **Dilekçe Bilgileri**: Dilekçenin gönderileceği kurumu, başlığı ve konuyu belirtin
3. **Yapay Zeka Desteği**: "AI ile Oluştur" butonuna tıklayarak dilekçe metnini otomatik olarak oluşturun veya manuel olarak yazın
4. **Önizleme**: "Dilekçe Oluştur" butonuna basarak dilekçenizi önizleyin
5. **İşlemler**: Dilekçenizi yazdırın, paylaşın veya kaydedin

## 🔮 Gelecek Sürümlerde Eklenecek Özellikler

- 🌐 **Çevrim Dışı Çalışma Modu**: İnternet bağlantısı olmadan çalışabilme
- 🗃️ **Dilekçe Kütüphanesi**: Oluşturulan dilekçeleri saklama ve düzenleme
- 🔍 **Gelişmiş Metin Düzenleme**: Zengin metin düzenleme seçenekleri
- 🖌️ **Özel Şablonlar**: Kullanıcı tanımlı şablonlar oluşturabilme
- 🔒 **Bulut Senkronizasyonu**: Verilerinizi cihazlar arasında senkronize etme
- 🌙 **Karanlık Mod**: Göz yorgunluğunu azaltan karanlık tema desteği
- 🔔 **Bildirim Sistemi**: Önemli dilekçeler için hatırlatıcılar
- 🔄 **Dilekçe Takip Sistemi**: Gönderilen dilekçelerin durumunu takip etme

## 💡 Gelecekte Kullanılabilecek Teknolojiler

- **Firebase**: Kullanıcı kimlik doğrulama ve veritabanı entegrasyonu
- **Flutter Bloc/Provider**: Durum yönetimi için gelişmiş mimari
- **Hive/SQLite**: Yerel veri depolama için veritabanı çözümleri
- **Biometric Authentication**: Biyometrik kimlik doğrulama (parmak izi, yüz tanıma)
- **Cloud Firestore**: Gerçek zamanlı veritabanı desteği
- **Google ML Kit**: Cihaz üzerinde yapay zeka işlemleri
- **Connectivity Plus**: Ağ bağlantı durumu izleme
- **Lottie**: Etkileyici animasyonlar için
- **GetX/Riverpod**: Alternatif durum yönetimi çözümleri

## 📸 Ekran Görüntüleri

*Uygulama ekran görüntüleri yakında eklenecek.*

## 📄 Lisans

Bu proje MIT lisansı altında lisanslanmıştır. Daha fazla bilgi için [LICENSE](LICENSE) dosyasına bakın.

## 👨‍💻 Geliştirici

**Berat MEN**
- 📧 Email: beratmen9@gmail.com
- 🌐 GitHub: [github.com/beratmen](https://github.com/beratmen)

## 🙏 Teşekkürler

- Google'ın Gemini API'si için Google ekibine
- Flutter ekosistemini geliştiren herkese
- Bu projeye katkı sağlayan tüm geliştiricilere

---

⭐️ Bu projeyi beğendiyseniz yıldız vermeyi unutmayın! ⭐️