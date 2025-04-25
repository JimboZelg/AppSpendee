import 'dart:typed_data';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:flutter/rendering.dart';
import 'dart:ui' as ui;
import 'package:path_provider/path_provider.dart';
import '../providers/wallet_provider.dart';
import '../models/transaction_type.dart';
import 'balance_pie_chart.dart';
import 'monthly_bar_chart.dart';

class FullReportButton extends StatelessWidget {
  const FullReportButton({super.key});

  Future<Uint8List> _captureWidgetAsImage(GlobalKey key) async {
    final boundary = key.currentContext!.findRenderObject() as RenderRepaintBoundary;
    final image = await boundary.toImage(pixelRatio: 3.0);
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    return byteData!.buffer.asUint8List();
  }

  Future<Uint8List> _generatePdf(BuildContext context) async {
    final walletProvider = Provider.of<WalletProvider>(context, listen: false);
    final transactions = walletProvider.transactions;
    final completedGoals = walletProvider.completedGoals;
    final totalIncome = walletProvider.totalIncome;
    final totalExpenses = walletProvider.totalExpenses;
    final totalSavings = totalIncome - totalExpenses;

    final pieKey = GlobalKey();
    final barKey = GlobalKey();

    final pieWidget = RepaintBoundary(key: pieKey, child: BalancePieChart());
    final barWidget = RepaintBoundary(key: barKey, child: MonthlyBarChart());

    final overlayEntry = OverlayEntry(
      builder: (_) => Material(
        type: MaterialType.transparency,
        child: Column(children: [pieWidget, barWidget]),
      ),
    );

    Overlay.of(context).insert(overlayEntry);
    await Future.delayed(const Duration(milliseconds: 500));

    final pieBytes = await _captureWidgetAsImage(pieKey);
    final barBytes = await _captureWidgetAsImage(barKey);
    overlayEntry.remove();

    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (context) => [
          pw.Header(level: 0, child: pw.Text("Reporte Financiero Spendee", style: pw.TextStyle(fontSize: 22))),
          pw.Text("Resumen General", style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
          pw.Bullet(text: "Ingresos: \$${totalIncome.toStringAsFixed(2)}"),
          pw.Bullet(text: "Gastos: \$${totalExpenses.toStringAsFixed(2)}"),
          pw.Bullet(text: "Ahorro: \$${totalSavings.toStringAsFixed(2)}"),
          pw.SizedBox(height: 16),
          pw.Text("Gráfica de Balance", style: pw.TextStyle(fontSize: 16)),
          pw.Image(pw.MemoryImage(pieBytes), height: 200),
          pw.SizedBox(height: 16),
          pw.Text("Gráfica Comparativa Mensual", style: pw.TextStyle(fontSize: 16)),
          pw.Image(pw.MemoryImage(barBytes), height: 250),
          pw.SizedBox(height: 16),
          pw.Text("Tabla de Transacciones", style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
          pw.Table.fromTextArray(
            headers: ['Fecha', 'Categoría', 'Monto', 'Tipo', 'Descripción'],
            data: transactions.map((tx) => [
              "${tx.date.day}/${tx.date.month}/${tx.date.year}",
              tx.category,
              "\$${tx.amount.toStringAsFixed(2)}",
              tx.type == TransactionType.income ? 'Ingreso' : 'Gasto',
              tx.description
            ]).toList(),
            cellStyle: pw.TextStyle(fontSize: 10),
            headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
          ),
          pw.SizedBox(height: 16),
          pw.Text("Metas Cumplidas", style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
          pw.Table.fromTextArray(
            headers: ['Nombre', 'Total Ahorrado', 'Frecuencia'],
            data: completedGoals.map((goal) => [
              goal.name,
              "\$${goal.currentAmount.toStringAsFixed(2)}",
              goal.frequency
            ]).toList(),
            cellStyle: pw.TextStyle(fontSize: 10),
            headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
          ),
        ],
      ),
    );

    return pdf.save();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton.icon(
        icon: const Icon(Icons.picture_as_pdf),
        label: const Text("Guardar Reporte en PDF"),
        style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo),
        onPressed: () async {
          final pdfBytes = await _generatePdf(context);
          final dir = await getExternalStorageDirectory();
          final path = '${dir!.path}/reporte_spendee.pdf';
          final file = File(path);
          await file.writeAsBytes(pdfBytes);

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('✅ Reporte guardado en: $path'),
              backgroundColor: Colors.green,
            ),
          );
        },
      ),
    );
  }
}
