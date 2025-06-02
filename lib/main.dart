import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Load .env file
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
      home: const PetitionScreen(title: 'dilexAI App'),
      debugShowCheckedModeBanner: false,
    );
  }
}

class PetitionScreen extends StatefulWidget {
  const PetitionScreen({super.key, required this.title});

  final String title;

  @override
  State<PetitionScreen> createState() => _PetitionScreenState();
}

class _PetitionScreenState extends State<PetitionScreen> {
  final TextEditingController _petitionController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _institutionController = TextEditingController();
  final TextEditingController _subjectController = TextEditingController();

  bool _isLoading = false;

  @override
  void dispose() {
    _petitionController.dispose();
    _titleController.dispose();
    _fullNameController.dispose();
    _addressController.dispose();
    _institutionController.dispose();
    _subjectController.dispose();
    super.dispose();
  }

  Future<String> _generatePetitionWithAI() async {
    // API key check - return message since API key has been removed
    setState(() {
      _isLoading = false;
    });
    return 'API key has been removed. Please configure your API key to use this feature.';
  }

  Future<void> _generatePdfAndPrint() async {
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
                  _institutionController.text.toUpperCase(),
                  style: pw.TextStyle(
                      fontWeight: pw.FontWeight.bold, fontSize: 14),
                ),
              ),
              pw.SizedBox(height: 20),
              pw.Center(
                child: pw.Text(
                  _titleController.text.toUpperCase(),
                  style: pw.TextStyle(
                      fontWeight: pw.FontWeight.bold, fontSize: 12),
                ),
              ),
              pw.SizedBox(height: 20),
              pw.Text(_petitionController.text),
              pw.SizedBox(height: 20),
              pw.Text("Respectfully submitted."),
              pw.SizedBox(height: 10),
              pw.Text(DateTime.now().toString().substring(0, 10)),
              pw.SizedBox(height: 20),
              pw.Align(
                alignment: pw.Alignment.bottomRight,
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.end,
                  children: [
                    pw.Text(_fullNameController.text),
                    pw.SizedBox(height: 5),
                    pw.Text(_addressController.text),
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

  Future<void> _sharePetition() async {
    final petitionText = _generatePetitionText();
    final tempDir = await getTemporaryDirectory();
    final file = File('${tempDir.path}/petition.txt');
    await file.writeAsString(petitionText);

    await Share.shareXFiles(
      [XFile(file.path)],
      text: 'My petition generated with dilexAI App',
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
          // Print button
          IconButton(
            icon: const Icon(Icons.print),
            onPressed: _generatePdfAndPrint,
            tooltip: 'Print',
          ),
          // Share button
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: _sharePetition,
            tooltip: 'Share',
          ),
          // Save button
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Petition saved')),
              );
            },
            tooltip: 'Save',
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
                  // Logo and title section
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
                          'Create your petitions quickly and easily',
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

                  // Personal information section
                  Card(
                    elevation: 2,
                    margin: const EdgeInsets.only(bottom: 16),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Personal Information',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 16),
                          TextField(
                            controller: _fullNameController,
                            decoration: const InputDecoration(
                              labelText: 'Full Name',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.person),
                            ),
                          ),
                          const SizedBox(height: 12),
                          TextField(
                            controller: _addressController,
                            maxLines: 2,
                            decoration: const InputDecoration(
                              labelText: 'Address',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.home),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Petition details section
                  Card(
                    elevation: 2,
                    margin: const EdgeInsets.only(bottom: 16),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Petition Details',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          TextField(
                            controller: _institutionController,
                            decoration: const InputDecoration(
                              labelText: 'Institution to Send Petition',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.business),
                            ),
                          ),
                          const SizedBox(height: 12),
                          TextField(
                            controller: _titleController,
                            decoration: const InputDecoration(
                              labelText: 'Petition Title',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.title),
                            ),
                          ),
                          const SizedBox(height: 12),
                          TextField(
                            controller: _subjectController,
                            decoration: const InputDecoration(
                              labelText: 'Petition Subject',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.topic),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Petition text section
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
                                'Petition Text',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              ElevatedButton.icon(
                                onPressed: () async {
                                  final generatedText =
                                      await _generatePetitionWithAI();
                                  setState(() {
                                    _petitionController.text = generatedText;
                                  });
                                },
                                icon: const Icon(Icons.auto_awesome),
                                label: const Text('Generate with AI'),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          TextField(
                            controller: _petitionController,
                            maxLines: 10,
                            decoration: const InputDecoration(
                              hintText:
                                  'Write your petition here or generate with AI...',
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
          // Create the petition
          final petitionText = _generatePetitionText();
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Petition Preview'),
              content: SingleChildScrollView(
                child: Text(petitionText),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Close'),
                ),
                TextButton(
                  onPressed: _generatePdfAndPrint,
                  child: const Text('Print'),
                ),
                TextButton(
                  onPressed: () {
                    _sharePetition();
                    Navigator.pop(context);
                  },
                  child: const Text('Share'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Petition created')),
                    );
                  },
                  child: const Text('Save'),
                ),
              ],
            ),
          );
        },
        label: const Text('Create Petition'),
        icon: const Icon(Icons.create),
      ),
    );
  }

  String _generatePetitionText() {
    final now = DateTime.now();
    final dateStr = '${now.day}.${now.month}.${now.year}';

    return '''
${_institutionController.text.toUpperCase()} DIRECTORATE

${_titleController.text.toUpperCase()}

${_petitionController.text}

Respectfully submitted.
$dateStr

${_fullNameController.text}
${_addressController.text}
''';
  }
}
