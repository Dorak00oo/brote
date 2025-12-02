import 'dart:io';
import 'package:excel/excel.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import 'package:open_filex/open_filex.dart';
import '../models/transaction.dart';

/// Resultado de exportación
class ExportResult {
  final String filePath;
  final String fileName;
  final String fileType; // 'excel' o 'pdf'
  
  ExportResult({
    required this.filePath,
    required this.fileName,
    required this.fileType,
  });
}

class ExportService {
  /// Obtiene el directorio de Descargas accesible al usuario
  static Future<Directory> _getExportDirectory() async {
    if (Platform.isAndroid) {
      // Obtener el directorio de almacenamiento externo
      final externalDir = await getExternalStorageDirectory();
      if (externalDir != null) {
        // Construir la ruta a la carpeta de Descargas
        // externalDir.path es algo como: /storage/emulated/0/Android/data/com.example.brote/files
        // Necesitamos ir a: /storage/emulated/0/Download
        // Extraer la ruta base del almacenamiento
        final pathParts = externalDir.path.split('/');
        if (pathParts.length >= 4) {
          // Construir /storage/emulated/0/Download
          final downloadPath = '/${pathParts[1]}/${pathParts[2]}/${pathParts[3]}/Download';
          final downloadDir = Directory(downloadPath);
          
          // Intentar crear si no existe (puede fallar sin permisos, pero lo intentamos)
          if (!await downloadDir.exists()) {
            try {
              await downloadDir.create(recursive: true);
            } catch (e) {
              print('No se pudo crear la carpeta Download: $e');
              // Continuar de todas formas, puede que exista pero no tengamos permisos de lectura
            }
          }
          
          // Si existe o se pudo crear, usarla
          if (await downloadDir.exists()) {
            print('Usando carpeta de Descargas: $downloadPath');
            return downloadDir;
          } else {
            print('La carpeta de Descargas no existe, usando fallback');
          }
        }
        
        // Fallback: usar la carpeta Brote en el almacenamiento externo
        final broteDir = Directory('${externalDir.path}/Brote');
        if (!await broteDir.exists()) {
          await broteDir.create(recursive: true);
        }
        print('Usando carpeta Brote (fallback): ${broteDir.path}');
        return broteDir;
      }
    }
    final appDir = await getApplicationDocumentsDirectory();
    print('Usando directorio de documentos de la app: ${appDir.path}');
    return appDir;
  }

  /// Exporta a Excel de forma asíncrona con chunks para no bloquear
  static Future<ExportResult> exportToExcel({
    required List<Transaction> transactions,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      if (transactions.isEmpty) {
        throw Exception('No hay transacciones para exportar');
      }
      
      // Limitar transacciones
      final limitedTransactions = transactions.take(5000).toList();
      
      // Crear Excel
      final excel = Excel.createExcel();
      
      // Crear la hoja de Transacciones primero
      final sheet = excel['Transacciones'];
      
      // Eliminar todas las hojas excepto "Transacciones"
      final sheetNames = excel.sheets.keys.toList();
      for (final sheetName in sheetNames) {
        if (sheetName != 'Transacciones') {
          try {
            excel.delete(sheetName);
            print('Hoja eliminada: $sheetName');
          } catch (e) {
            print('No se pudo eliminar la hoja $sheetName: $e');
          }
        }
      }
      
      // Verificar que solo quede la hoja de Transacciones
      final remainingSheets = excel.sheets.keys.toList();
      print('Hojas restantes después de limpiar: $remainingSheets');

      // Encabezados
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: 0)).value = 'Fecha';
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: 0)).value = 'Título';
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: 0)).value = 'Categoría';
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: 0)).value = 'Tipo';
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 4, rowIndex: 0)).value = 'Monto';
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 5, rowIndex: 0)).value = 'Fuente';
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 6, rowIndex: 0)).value = 'Descripción';

      // Procesar datos - sin chunks para evitar problemas
      final dateFormat = DateFormat('dd/MM/yyyy');
      
      for (int i = 0; i < limitedTransactions.length; i++) {
        final transaction = limitedTransactions[i];
        final row = i + 1;
        
        // Asignar valores directamente
        sheet.cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: row)).value = 
            dateFormat.format(transaction.date);
        sheet.cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: row)).value = 
            transaction.title;
        sheet.cell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: row)).value = 
            transaction.category;
        sheet.cell(CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: row)).value = 
            transaction.type == TransactionType.income ? 'Ingreso' : 'Gasto';
        sheet.cell(CellIndex.indexByColumnRow(columnIndex: 4, rowIndex: row)).value = 
            transaction.amount;
        sheet.cell(CellIndex.indexByColumnRow(columnIndex: 5, rowIndex: row)).value = 
            transaction.source ?? '-';
        sheet.cell(CellIndex.indexByColumnRow(columnIndex: 6, rowIndex: row)).value = 
            transaction.description ?? '-';
      }

      // Calcular totales
      final totalIncome = limitedTransactions
          .where((t) => t.type == TransactionType.income)
          .fold(0.0, (sum, t) => sum + t.amount);
      final totalExpenses = limitedTransactions
          .where((t) => t.type == TransactionType.expense)
          .fold(0.0, (sum, t) => sum + t.amount);

      // Totales
      final totalRow = limitedTransactions.length + 2;
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: totalRow)).value = 'Total Ingresos:';
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 4, rowIndex: totalRow)).value = totalIncome;
      
      final totalExpensesRow = limitedTransactions.length + 3;
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: totalExpensesRow)).value = 'Total Gastos:';
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 4, rowIndex: totalExpensesRow)).value = totalExpenses;

      final balanceRow = limitedTransactions.length + 4;
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: balanceRow)).value = 'Balance:';
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 4, rowIndex: balanceRow)).value = totalIncome - totalExpenses;
      
      // Asegurarse de que el sheet tenga los datos antes de codificar
      print('Excel creado con ${limitedTransactions.length} transacciones');

      // Obtener directorio antes de codificar
      final directory = await _getExportDirectory();
      final fileName = 'transacciones_${DateFormat('yyyyMMdd_HHmmss').format(DateTime.now())}.xlsx';
      final filePath = '${directory.path}/$fileName';
      
      // Dar tiempo a la UI antes de la operación pesada
      await Future.delayed(const Duration(milliseconds: 10));
      
      // Codificar Excel - asegurarse de que se codifica correctamente
      print('Codificando Excel...');
      final bytes = excel.encode();
      if (bytes == null) {
        throw Exception('Error: No se pudo generar el archivo Excel');
      }
      
      print('Excel codificado: ${bytes.length} bytes');
      
      // Escribir archivo
      final file = File(filePath);
      await file.writeAsBytes(bytes);
      print('Archivo Excel guardado en: $filePath');
      
      // Verificar que el archivo se escribió correctamente
      if (await file.exists()) {
        final fileSize = await file.length();
        print('Archivo verificado: $fileSize bytes');
      } else {
        throw Exception('Error: El archivo no se creó correctamente');
      }

      return ExportResult(
        filePath: filePath,
        fileName: fileName,
        fileType: 'excel',
      );
    } catch (e, stackTrace) {
      throw Exception('Error al exportar a Excel: $e\nStack: $stackTrace');
    }
  }

  /// Exporta a PDF de forma asíncrona con chunks para no bloquear
  static Future<ExportResult> exportToPDF({
    required List<Transaction> transactions,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      if (transactions.isEmpty) {
        throw Exception('No hay transacciones para exportar');
      }
      
      final pdf = pw.Document();

      // Calcular totales
      final totalIncome = transactions
          .where((t) => t.type == TransactionType.income)
          .fold(0.0, (sum, t) => sum + t.amount);
      final totalExpenses = transactions
          .where((t) => t.type == TransactionType.expense)
          .fold(0.0, (sum, t) => sum + t.amount);
      final balance = totalIncome - totalExpenses;

      // Crear encabezado de tabla
      pw.TableRow buildTableHeader() {
        return pw.TableRow(
          decoration: const pw.BoxDecoration(color: PdfColors.grey200),
          children: [
            pw.Padding(
              padding: const pw.EdgeInsets.all(6),
              child: pw.Text('Fecha', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 9)),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(6),
              child: pw.Text('Título', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 9)),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(6),
              child: pw.Text('Categoría', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 9)),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(6),
              child: pw.Text('Tipo', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 9)),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(6),
              child: pw.Text('Monto', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 9)),
            ),
          ],
        );
      }

      // Crear fila de transacción
      pw.TableRow buildTransactionRow(Transaction transaction) {
        final isIncome = transaction.type == TransactionType.income;
        return pw.TableRow(
          children: [
            pw.Padding(
              padding: const pw.EdgeInsets.all(6),
              child: pw.Text(
                DateFormat('dd/MM/yy').format(transaction.date),
                style: const pw.TextStyle(fontSize: 8),
              ),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(6),
              child: pw.Text(
                transaction.title.length > 20 
                    ? '${transaction.title.substring(0, 20)}...' 
                    : transaction.title,
                style: const pw.TextStyle(fontSize: 8),
              ),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(6),
              child: pw.Text(
                transaction.category.length > 15 
                    ? '${transaction.category.substring(0, 15)}...' 
                    : transaction.category,
                style: const pw.TextStyle(fontSize: 8),
              ),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(6),
              child: pw.Text(
                isIncome ? 'Ingreso' : 'Gasto',
                style: pw.TextStyle(
                  fontSize: 8,
                  color: isIncome ? PdfColors.green700 : PdfColors.red700,
                ),
              ),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(6),
              child: pw.Text(
                '${isIncome ? '+' : '-'}\$${transaction.amount.toStringAsFixed(0)}',
                style: pw.TextStyle(
                  fontSize: 8,
                  fontWeight: pw.FontWeight.bold,
                  color: isIncome ? PdfColors.green700 : PdfColors.red700,
                ),
              ),
            ),
          ],
        );
      }

      // Dividir transacciones en lotes
      const int rowsPerPage = 25;
      final int totalPages = (transactions.length / rowsPerPage).ceil().clamp(1, 100);
      final limitedTransactions = transactions.take(rowsPerPage * 100).toList();

      for (int pageIndex = 0; pageIndex < totalPages; pageIndex++) {
        final startIndex = pageIndex * rowsPerPage;
        final endIndex = (startIndex + rowsPerPage).clamp(0, limitedTransactions.length);
        final pageTransactions = limitedTransactions.sublist(startIndex, endIndex);
        
        if (pageTransactions.isEmpty) break;

        pdf.addPage(
          pw.Page(
            pageFormat: PdfPageFormat.a4,
            margin: const pw.EdgeInsets.all(32),
            build: (pw.Context context) {
              return pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  if (pageIndex == 0) ...[
                    pw.Text(
                      'Reporte de Transacciones',
                      style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold),
                    ),
                    pw.SizedBox(height: 4),
                    pw.Text(
                      'Generado: ${DateFormat('dd/MM/yyyy HH:mm').format(DateTime.now())}',
                      style: const pw.TextStyle(fontSize: 10),
                    ),
                    if (startDate != null || endDate != null)
                      pw.Text(
                        'Período: ${startDate != null ? DateFormat('dd/MM/yyyy').format(startDate) : 'Inicio'} - ${endDate != null ? DateFormat('dd/MM/yyyy').format(endDate) : 'Fin'}',
                        style: const pw.TextStyle(fontSize: 10),
                      ),
                    pw.SizedBox(height: 12),
                    pw.Container(
                      padding: const pw.EdgeInsets.all(12),
                      decoration: pw.BoxDecoration(
                        border: pw.Border.all(color: PdfColors.grey300),
                        borderRadius: const pw.BorderRadius.all(pw.Radius.circular(4)),
                      ),
                      child: pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
                        children: [
                          pw.Column(
                            children: [
                              pw.Text('Ingresos', style: const pw.TextStyle(fontSize: 10)),
                              pw.Text(
                                '\$${totalIncome.toStringAsFixed(0)}',
                                style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold, color: PdfColors.green700),
                              ),
                            ],
                          ),
                          pw.Column(
                            children: [
                              pw.Text('Gastos', style: const pw.TextStyle(fontSize: 10)),
                              pw.Text(
                                '\$${totalExpenses.toStringAsFixed(0)}',
                                style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold, color: PdfColors.red700),
                              ),
                            ],
                          ),
                          pw.Column(
                            children: [
                              pw.Text('Balance', style: const pw.TextStyle(fontSize: 10)),
                              pw.Text(
                                '\$${balance.toStringAsFixed(0)}',
                                style: pw.TextStyle(
                                  fontSize: 14,
                                  fontWeight: pw.FontWeight.bold,
                                  color: balance >= 0 ? PdfColors.green700 : PdfColors.red700,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    pw.SizedBox(height: 12),
                  ] else ...[
                    pw.Text(
                      'Reporte de Transacciones - Pág. ${pageIndex + 1}',
                      style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold),
                    ),
                    pw.SizedBox(height: 8),
                  ],
                  pw.Table(
                    border: pw.TableBorder.all(color: PdfColors.grey300),
                    columnWidths: {
                      0: const pw.FlexColumnWidth(1.2),
                      1: const pw.FlexColumnWidth(2),
                      2: const pw.FlexColumnWidth(1.5),
                      3: const pw.FlexColumnWidth(1),
                      4: const pw.FlexColumnWidth(1.3),
                    },
                    children: [
                      buildTableHeader(),
                      ...pageTransactions.map((t) => buildTransactionRow(t)),
                    ],
                  ),
                  pw.Spacer(),
                  pw.Text(
                    'Página ${pageIndex + 1} de $totalPages - Total: ${transactions.length} transacciones',
                    style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey600),
                  ),
                ],
              );
            },
          ),
        );
        
        // Permitir que la UI se actualice cada 3 páginas
        if (pageIndex % 3 == 0 && pageIndex > 0) {
          await Future.delayed(const Duration(milliseconds: 1));
        }
      }

      // Obtener directorio
      final directory = await _getExportDirectory();
      final fileName = 'reporte_${DateFormat('yyyyMMdd_HHmmss').format(DateTime.now())}.pdf';
      final filePath = '${directory.path}/$fileName';
      
      // Dar tiempo a la UI antes de guardar
      await Future.delayed(const Duration(milliseconds: 10));
      
      // Generar bytes
      final bytes = await pdf.save();
      final file = File(filePath);
      await file.writeAsBytes(bytes);

      return ExportResult(
        filePath: filePath,
        fileName: fileName,
        fileType: 'pdf',
      );
    } catch (e, stackTrace) {
      throw Exception('Error al exportar a PDF: $e\nStack: $stackTrace');
    }
  }

  /// Comparte un archivo exportado
  static Future<void> shareFile(ExportResult result) async {
    await Share.shareXFiles(
      [XFile(result.filePath)],
      text: 'Reporte de transacciones - Brote',
      subject: result.fileName,
    );
  }

  /// Abre un archivo exportado
  static Future<void> openFile(ExportResult result) async {
    await OpenFilex.open(result.filePath);
  }
}
