import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../../features/history/application/history_provider.dart';
import '../../features/growth/domain/growth_record_entity.dart';

class PdfExportService {
  static final _dateTimeFmt = DateFormat('yyyy-MM-dd HH:mm');
  static final _dateFmt = DateFormat('yyyy-MM-dd');

  static Future<pw.Font> _loadFont() async {
    return await PdfGoogleFonts.notoSansJPRegular();
  }

  /// 履歴データを PDF ファイルにして共有シートを開く
  static Future<void> exportHistory(
    Map<String, List<HistoryItem>> groupedHistory,
  ) async {
    final font = await _loadFont();
    final pdf = pw.Document();

    final allItems = groupedHistory.values.expand((list) => list).toList()
      ..sort((a, b) => b.record.recordedAt.compareTo(a.record.recordedAt));

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        theme: pw.ThemeData.withFont(base: font),
        header: (_) => pw.Padding(
          padding: const pw.EdgeInsets.only(bottom: 8),
          child: pw.Text(
            '育児タスク履歴',
            style: pw.TextStyle(
              font: font,
              fontSize: 18,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
        ),
        footer: (ctx) => pw.Align(
          alignment: pw.Alignment.centerRight,
          child: pw.Text(
            '出力日時: ${_dateTimeFmt.format(DateTime.now())}',
            style: pw.TextStyle(
              font: font,
              fontSize: 9,
              color: PdfColors.grey600,
            ),
          ),
        ),
        build: (context) => [
          pw.TableHelper.fromTextArray(
            headerStyle: pw.TextStyle(
              font: font,
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.white,
            ),
            headerDecoration: const pw.BoxDecoration(color: PdfColors.teal700),
            cellStyle: pw.TextStyle(font: font, fontSize: 10),
            cellAlignments: {
              0: pw.Alignment.centerLeft,
              1: pw.Alignment.centerLeft,
              2: pw.Alignment.centerLeft,
            },
            headers: ['日時', 'タスク名', 'メモ'],
            data: allItems
                .map((item) => [
                      _dateTimeFmt.format(item.record.recordedAt),
                      item.task.title,
                      item.record.memo ?? '',
                    ])
                .toList(),
          ),
        ],
      ),
    );

    await Printing.sharePdf(
      bytes: await pdf.save(),
      filename: 'itukara_history_${_stamp()}.pdf',
    );
  }

  /// 成長記録を PDF ファイルにして共有シートを開く
  static Future<void> exportGrowth(List<GrowthRecordEntity> records) async {
    final font = await _loadFont();
    final pdf = pw.Document();

    final sorted = List<GrowthRecordEntity>.from(records)
      ..sort((a, b) => b.recordedAt.compareTo(a.recordedAt));

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        theme: pw.ThemeData.withFont(base: font),
        header: (_) => pw.Padding(
          padding: const pw.EdgeInsets.only(bottom: 8),
          child: pw.Text(
            '成長の記録',
            style: pw.TextStyle(
              font: font,
              fontSize: 18,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
        ),
        footer: (ctx) => pw.Align(
          alignment: pw.Alignment.centerRight,
          child: pw.Text(
            '出力日時: ${_dateTimeFmt.format(DateTime.now())}',
            style: pw.TextStyle(
              font: font,
              fontSize: 9,
              color: PdfColors.grey600,
            ),
          ),
        ),
        build: (context) => [
          pw.TableHelper.fromTextArray(
            headerStyle: pw.TextStyle(
              font: font,
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.white,
            ),
            headerDecoration: const pw.BoxDecoration(color: PdfColors.teal700),
            cellStyle: pw.TextStyle(font: font, fontSize: 10),
            headers: ['日付', '身長(cm)', '体重(kg)', '頭囲(cm)', 'ワクチン', 'メモ'],
            data: sorted
                .map((r) => [
                      _dateFmt.format(r.recordedAt),
                      r.height?.toString() ?? '',
                      r.weight?.toString() ?? '',
                      r.headCircumference?.toString() ?? '',
                      r.vaccinationName ?? '',
                      r.memo ?? '',
                    ])
                .toList(),
          ),
        ],
      ),
    );

    await Printing.sharePdf(
      bytes: await pdf.save(),
      filename: 'itukara_growth_${_stamp()}.pdf',
    );
  }

  static String _stamp() => DateFormat('yyyyMMdd_HHmm').format(DateTime.now());
}
