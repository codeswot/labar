import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:intl/intl.dart';

class WaybillPdfGenerator {
  static Future<void> generateAndDownload(Map<String, dynamic> data) async {
    final pdf = pw.Document();

    final waybillNumber = data['waybill_number'] ?? 'N/A';
    final destination = data['destination'] ?? 'N/A';
    final driverName = data['driver_name'] ?? 'N/A';
    final driverPhone = data['driver_phone'] ?? 'N/A';
    final vehicleNumber = data['vehicle_number'] ?? 'N/A';
    final itemName = data['item_name'] ?? 'N/A';
    final quantity = data['quantity'] ?? 0;
    final unit = data['unit'] ?? 'N/A';

    final warehouseName = data['warehouses']?['name'] ?? 'Warehouse';

    final dispatchDate = data['dispatch_date'] != null
        ? DateFormat('MMM dd, yyyy HH:mm')
            .format(DateTime.parse(data['dispatch_date']))
        : 'N/A';

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Padding(
              padding: const pw.EdgeInsets.all(32),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text('LABAR WAYBILL',
                          style: pw.TextStyle(
                              fontSize: 24,
                              fontWeight: pw.FontWeight.bold,
                              color: PdfColors.green800)),
                      pw.Text('Waybill #: $waybillNumber',
                          style: pw.TextStyle(
                              fontSize: 14, fontWeight: pw.FontWeight.bold)),
                    ],
                  ),
                  pw.SizedBox(height: 24),
                  pw.Divider(),
                  pw.SizedBox(height: 24),

                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Text('DISPATCH FROM',
                                style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.bold,
                                    fontSize: 12,
                                    color: PdfColors.grey700)),
                            pw.SizedBox(height: 8),
                            pw.Text(warehouseName,
                                style: const pw.TextStyle(fontSize: 16)),
                            pw.SizedBox(height: 4),
                            pw.Text('Date: $dispatchDate',
                                style: const pw.TextStyle(fontSize: 12)),
                          ]),
                      pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.end,
                          children: [
                            pw.Text('DELIVER TO',
                                style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.bold,
                                    fontSize: 12,
                                    color: PdfColors.grey700)),
                            pw.SizedBox(height: 8),
                            pw.Text(destination,
                                style: const pw.TextStyle(fontSize: 16)),
                          ]),
                    ],
                  ),
                  pw.SizedBox(height: 32),

                  // Items Table
                  pw.Container(
                      color: PdfColors.grey200,
                      padding: const pw.EdgeInsets.all(12),
                      child: pw.Row(children: [
                        pw.Expanded(
                            child: pw.Text('DESCRIPTION',
                                style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.bold))),
                        pw.SizedBox(
                            width: 40,
                            child: pw.Text('QTY',
                                style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.bold),
                                textAlign: pw.TextAlign.right)),
                        pw.SizedBox(
                            width: 60,
                            child: pw.Text('UNIT',
                                style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.bold),
                                textAlign: pw.TextAlign.right)),
                      ])),
                  pw.Container(
                      padding: const pw.EdgeInsets.all(12),
                      decoration: const pw.BoxDecoration(
                          border: pw.Border(
                        bottom: pw.BorderSide(color: PdfColors.grey300),
                        left: pw.BorderSide(color: PdfColors.grey300),
                        right: pw.BorderSide(color: PdfColors.grey300),
                      )),
                      child: pw.Row(children: [
                        pw.Expanded(child: pw.Text(itemName)),
                        pw.SizedBox(
                            width: 40,
                            child: pw.Text(quantity.toString(),
                                textAlign: pw.TextAlign.right)),
                        pw.SizedBox(
                            width: 60,
                            child:
                                pw.Text(unit, textAlign: pw.TextAlign.right)),
                      ])),

                  pw.SizedBox(height: 48),

                  pw.Text('DRIVER & TRANSPORT DETAILS',
                      style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold, fontSize: 14)),
                  pw.SizedBox(height: 12),
                  pw.Container(
                      padding: const pw.EdgeInsets.all(16),
                      decoration: pw.BoxDecoration(
                          border: pw.Border.all(color: PdfColors.grey300)),
                      child: pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Row(children: [
                              pw.SizedBox(
                                  width: 120, child: pw.Text('Driver Name:')),
                              pw.Text(driverName,
                                  style: pw.TextStyle(
                                      fontWeight: pw.FontWeight.bold))
                            ]),
                            pw.SizedBox(height: 8),
                            pw.Row(children: [
                              pw.SizedBox(
                                  width: 120, child: pw.Text('Driver Phone:')),
                              pw.Text(driverPhone)
                            ]),
                            pw.SizedBox(height: 8),
                            pw.Row(children: [
                              pw.SizedBox(
                                  width: 120,
                                  child: pw.Text('Vehicle Number:')),
                              pw.Text(vehicleNumber)
                            ]),
                          ])),

                  pw.Spacer(),
                  pw.Divider(),
                  pw.SizedBox(height: 16),
                  pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Column(
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            children: [
                              pw.Text('Authorized Signature',
                                  style: const pw.TextStyle(fontSize: 10)),
                              pw.SizedBox(height: 40),
                              pw.Container(
                                  width: 150,
                                  height: 1,
                                  color: PdfColors.black),
                            ]),
                        pw.Column(
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            children: [
                              pw.Text('Receiver Signature',
                                  style: const pw.TextStyle(fontSize: 10)),
                              pw.SizedBox(height: 40),
                              pw.Container(
                                  width: 150,
                                  height: 1,
                                  color: PdfColors.black),
                            ])
                      ])
                ],
              ));
        },
      ),
    );

    // Prompt user to save/print the PDF
    await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => pdf.save(),
        name: 'Waybill-$waybillNumber');
  }
}
