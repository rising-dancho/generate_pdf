import 'package:flutter/material.dart';
import 'package:invoice_app/data.dart';
import 'package:pdf/pdf.dart';
// import 'package:printing/printing.dart';
import 'dart:typed_data';
import 'invoice_generator.dart'; // Import your generated invoice code
import 'package:file_picker/file_picker.dart';
import 'dart:io';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Invoice',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const InvoicePage(),
    );
  }
}

class InvoicePage extends StatefulWidget {
  const InvoicePage({super.key});

  @override
  InvoicePageState createState() => InvoicePageState();
}

class InvoicePageState extends State<InvoicePage> {
  Future<void> _saveInvoice() async {
    final pageFormat = PdfPageFormat.a4;
    final customData = CustomData();

    final Uint8List pdf = await generateInvoice(pageFormat, customData);

    final String? selectedPath = await FilePicker.platform.getDirectoryPath();

    if (selectedPath != null) {
      final file = File('$selectedPath/invoice.pdf');
      await file.writeAsBytes(pdf);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invoice saved successfully!')),
      );
    } else {
      // User canceled the picker
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('File save cancelled.')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Invoice Generator')),
      body: Center(
        child: ElevatedButton(
          onPressed: _saveInvoice,
          child: const Text('Generate Invoice'),
        ),
      ),
    );
  }
}
