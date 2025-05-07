import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:spendee/utils/ticket_parser.dart';
import 'package:provider/provider.dart';
import '../providers/wallet_provider.dart';
import 'package:spendee/models/transaction.dart';
import 'package:spendee/models/transaction_type.dart';

class TicketScannerScreen extends StatefulWidget {
  const TicketScannerScreen({super.key});

  @override
  State<TicketScannerScreen> createState() => _TicketScannerScreenState();
}

class _TicketScannerScreenState extends State<TicketScannerScreen> {
  File? _image;
  String _rawText = '';
  double? _detectedAmount;
  bool _isLoading = false;

  final TextEditingController _nameController = TextEditingController();

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.camera);

    if (picked != null) {
      setState(() {
        _image = File(picked.path);
        _isLoading = true;
        _rawText = '';
        _detectedAmount = null;
      });

      final inputImage = InputImage.fromFilePath(picked.path);
      final recognizer = TextRecognizer();
      final result = await recognizer.processImage(inputImage);
      recognizer.close();

      final rawText = result.text;
      final parsedAmount = TicketParser.extractTotalFromText(rawText);

      if (parsedAmount == null) {
        if (mounted) {
          showDialog(
            context: context,
            builder: (_) => AlertDialog(
              title: const Text('Monto no detectado'),
              content: const Text('No se pudo encontrar un total en el ticket. Asegúrate de que esté legible y que incluya palabras como \"Total\" o \"Subtotal\".'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('OK'),
                ),
              ],
            ),
          );
        }
      }

      setState(() {
        _rawText = rawText;
        _detectedAmount = parsedAmount;
        _isLoading = false;
      });
    }
  }

  void _saveTransaction() {
    if (_detectedAmount != null) {
      final description = _nameController.text.trim().isEmpty ? 'ticket' : _nameController.text.trim();

      context.read<WalletProvider>().addTransaction(
        description,
        Transaction(
          id: DateTime.now().toString(),
          amount: _detectedAmount!,
          category: 'Ticket',
          date: DateTime.now(),
          type: TransactionType.expense,
          description: description,
        ),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('✅ Gasto agregado desde el ticket'),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Escanear Ticket')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              onPressed: _pickImage,
              icon: const Icon(Icons.camera_alt),
              label: const Text('Tomar Foto'),
            ),
            const SizedBox(height: 20),
            if (_isLoading) const CircularProgressIndicator(),
            if (_image != null && !_isLoading) ...[
              Image.file(_image!, height: 200),
              const SizedBox(height: 20),
              Text(_rawText, style: const TextStyle(fontSize: 14)),
              const SizedBox(height: 20),
              if (_detectedAmount != null)
                Column(
                  children: [
                    Text(
                      'Total detectado: \$${_detectedAmount!.toStringAsFixed(2)}',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    TextField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: 'Nombre del gasto (opcional)',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 10),
                    const SizedBox(height: 10),
                    ElevatedButton.icon(
                      onPressed: _saveTransaction,
                      icon: const Icon(Icons.check),
                      label: const Text('Guardar como gasto'),
                    )
                  ],
                ),
            ],
          ],
        ),
      ),
    );
  }
}
