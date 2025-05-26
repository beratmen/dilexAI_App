import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // .env dosyasını yükle
  await dotenv.load();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'dilexAI App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const DilekceYazmaEkrani(title: 'dilexAI App'),
      debugShowCheckedModeBanner: false,
    );
  }
}

class DilekceYazmaEkrani extends StatefulWidget {
  const DilekceYazmaEkrani({super.key, required this.title});

  final String title;

  @override
  State<DilekceYazmaEkrani> createState() => _DilekceYazmaEkraniState();
}

class _DilekceYazmaEkraniState extends State<DilekceYazmaEkrani> {
  final TextEditingController _dilekceController = TextEditingController();
  final TextEditingController _baslikController = TextEditingController();
  final TextEditingController _adSoyadController = TextEditingController();
  final TextEditingController _adresController = TextEditingController();
  final TextEditingController _kurumController = TextEditingController();
  final TextEditingController _konuController = TextEditingController();

  bool _isLoading = false;
  final String _apiKey = dotenv.env['GEMINI_API_KEY'] ?? '';

  @override
  void dispose() {
    _dilekceController.dispose();
    _baslikController.dispose();
    _adSoyadController.dispose();
    _adresController.dispose();
    _kurumController.dispose();
    _konuController.dispose();
    super.dispose();
  }

  Future<String> _generateDilekceWithAI() async {
    if (_apiKey.isEmpty) {
      return 'API anahtarı bulunamadı. Lütfen .env dosyasını kontrol edin.';
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final model = GenerativeModel(
        model: 'gemini-1.5-pro',
        apiKey: _apiKey,
      );

      final prompt = '''
      Aşağıdaki bilgilere göre resmi bir dilekçe metni oluştur:
      
      Gönderilen Kurum: ${_kurumController.text}
      Konu: ${_konuController.text}
      Dilekçe Başlığı: ${_baslikController.text}
      
      Dilekçeyi resmi dilekçe formatında hazırla. Giriş, gelişme ve sonuç şeklinde, 
      nazik ve saygılı bir dilde oluştur. "Gereğini arz ederim." ifadesiyle sonlandır.
      ''';

      final content = [Content.text(prompt)];
      final response = await model.generateContent(content);

      setState(() {
        _isLoading = false;
      });

      return response.text ?? 'Dilekçe metni oluşturulamadı.';
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      return 'Bir hata oluştu: $e';
    }
  }

  Future<void> _pdfOlusturVeYazdir() async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.SizedBox(height: 40),
              pw.Center(
                child: pw.Text(
                  _kurumController.text.toUpperCase(),
                  style: pw.TextStyle(
                      fontWeight: pw.FontWeight.bold, fontSize: 14),
                ),
              ),
              pw.SizedBox(height: 20),
              pw.Center(
                child: pw.Text(
                  _baslikController.text.toUpperCase(),
                  style: pw.TextStyle(
                      fontWeight: pw.FontWeight.bold, fontSize: 12),
                ),
              ),
              pw.SizedBox(height: 20),
              pw.Text(_dilekceController.text),
              pw.SizedBox(height: 20),
              pw.Text("Gereğini arz ederim."),
              pw.SizedBox(height: 10),
              pw.Text(DateTime.now().toString().substring(0, 10)),
              pw.SizedBox(height: 20),
              pw.Align(
                alignment: pw.Alignment.bottomRight,
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.end,
                  children: [
                    pw.Text(_adSoyadController.text),
                    pw.SizedBox(height: 5),
                    pw.Text(_adresController.text),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }

  Future<void> _dilekcePaylas() async {
    final dilekceMetni = _olusturDilekceMetni();
    final tempDir = await getTemporaryDirectory();
    final file = File('${tempDir.path}/dilekce.txt');
    await file.writeAsString(dilekceMetni);

    await Share.shareXFiles(
      [XFile(file.path)],
      text: 'dilexAI App ile oluşturulmuş dilekçem',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Row(
          children: [
            Image.asset(
              'assets/app-logo.png',
              height: 40,
              fit: BoxFit.contain,
            ),
            const SizedBox(width: 8),
            Text(widget.title),
          ],
        ),
        actions: [
          // Yazdırma butonu
          IconButton(
            icon: const Icon(Icons.print),
            onPressed: _pdfOlusturVeYazdir,
            tooltip: 'Yazdır',
          ),
          // Paylaşma butonu
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: _dilekcePaylas,
            tooltip: 'Paylaş',
          ),
          // Kaydetme butonu
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Dilekçe kaydedildi')),
              );
            },
            tooltip: 'Kaydet',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Logo ve başlık bölümü
                  Center(
                    child: Column(
                      children: [
                        Image.asset(
                          'assets/app-logo.png',
                          height: 120,
                          fit: BoxFit.contain,
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'dilexAI App',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Dilekçelerinizi hızlı ve kolay bir şekilde oluşturun',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),

                  // Kişisel bilgiler bölümü
                  Card(
                    elevation: 2,
                    margin: const EdgeInsets.only(bottom: 16),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Kişisel Bilgiler',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 16),
                          TextField(
                            controller: _adSoyadController,
                            decoration: const InputDecoration(
                              labelText: 'Ad Soyad',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.person),
                            ),
                          ),
                          const SizedBox(height: 12),
                          TextField(
                            controller: _adresController,
                            maxLines: 2,
                            decoration: const InputDecoration(
                              labelText: 'Adres',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.home),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Dilekçe bilgileri bölümü
                  Card(
                    elevation: 2,
                    margin: const EdgeInsets.only(bottom: 16),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Dilekçe Bilgileri',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          TextField(
                            controller: _kurumController,
                            decoration: const InputDecoration(
                              labelText: 'Dilekçe Gönderilecek Kurum',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.business),
                            ),
                          ),
                          const SizedBox(height: 12),
                          TextField(
                            controller: _baslikController,
                            decoration: const InputDecoration(
                              labelText: 'Dilekçe Başlığı',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.title),
                            ),
                          ),
                          const SizedBox(height: 12),
                          TextField(
                            controller: _konuController,
                            decoration: const InputDecoration(
                              labelText: 'Dilekçe Konusu',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.topic),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Dilekçe metni bölümü
                  Card(
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Dilekçe Metni',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              ElevatedButton.icon(
                                onPressed: () async {
                                  final generatedText =
                                      await _generateDilekceWithAI();
                                  setState(() {
                                    _dilekceController.text = generatedText;
                                  });
                                },
                                icon: const Icon(Icons.auto_awesome),
                                label: const Text('AI ile Oluştur'),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          TextField(
                            controller: _dilekceController,
                            maxLines: 10,
                            decoration: const InputDecoration(
                              hintText:
                                  'Dilekçenizi buraya yazınız veya AI ile oluşturunuz...',
                              border: OutlineInputBorder(),
                              alignLabelWithHint: true,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Dilekçeyi oluştur
          final dilekceMetni = _olusturDilekceMetni();
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Dilekçe Önizleme'),
              content: SingleChildScrollView(
                child: Text(dilekceMetni),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Kapat'),
                ),
                TextButton(
                  onPressed: _pdfOlusturVeYazdir,
                  child: const Text('Yazdır'),
                ),
                TextButton(
                  onPressed: () {
                    _dilekcePaylas();
                    Navigator.pop(context);
                  },
                  child: const Text('Paylaş'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Dilekçe oluşturuldu')),
                    );
                  },
                  child: const Text('Kaydet'),
                ),
              ],
            ),
          );
        },
        label: const Text('Dilekçe Oluştur'),
        icon: const Icon(Icons.create),
      ),
    );
  }

  String _olusturDilekceMetni() {
    final tarih = DateTime.now();
    final tarihStr = '${tarih.day}.${tarih.month}.${tarih.year}';

    return '''
${_kurumController.text.toUpperCase()} MÜDÜRLÜĞÜNE

${_baslikController.text.toUpperCase()}

${_dilekceController.text}

Gereğini arz ederim.
$tarihStr

${_adSoyadController.text}
${_adresController.text}
''';
  }
}
