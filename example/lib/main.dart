import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:tamil_pdf_shaper/tamil_pdf_shaper.dart';

void main() {
  runApp(const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: TamilPdfExample()
  ));
}

class TamilPdfExample extends StatelessWidget {
  const TamilPdfExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tamil PDF Shaper Demo'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: PdfPreview(
        build: (format) => _generatePdf(format),
        // Simple UI customization for the previewer
        loadingWidget: const Center(child: CircularProgressIndicator()),
      ),
    );
  }

  Future<Uint8List> _generatePdf(PdfPageFormat format) async {
    final pdf = pw.Document();

    // 1. Load the font from the package (Singleton)
    final tamilFont = await TamilPdfFont.load();

    // 2. Sample Content
    const String title = "மதிப்பீடு (Estimate)";
    const String poem = '''
உவவுமதி உருவின் ஓங்கல் வெண்குடை
நிலவுக் கடல் வரைப்பின் மண்ணகம் நிழற்ற,
ஏம முரசம் இழுமென முழங்க...
''';

    // 3. Create the PDF Page
    pdf.addPage(
      pw.Page(
        pageFormat: format,
        theme: pw.ThemeData.withFont(
          base: tamilFont, // Apply the Tamil font globally to the page
        ),
        build: (context) {
          return pw.Center(
            child: pw.Column(
              mainAxisAlignment: pw.MainAxisAlignment.center,
              children: [
                pw.Text(
                  title.toTamilPdf, // Apply the .toTamilPdf extension
                  style: const pw.TextStyle(fontSize: 40),
                ),
                pw.SizedBox(height: 20),
                pw.Text(
                  poem.toTamilPdf, // Apply the .toTamilPdf extension
                  textAlign: pw.TextAlign.center,
                  style: const pw.TextStyle(fontSize: 20),
                ),
                pw.Divider(),
                pw.Text(
                  "This PDF was generated using the tamil_pdf_shaper package.",
                  style: const pw.TextStyle(fontSize: 12, color: PdfColors.grey),
                )
              ],
            ),
          );
        },
      ),
    );

    return pdf.save();
  }
}