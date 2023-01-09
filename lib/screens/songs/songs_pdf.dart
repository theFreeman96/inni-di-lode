import 'dart:developer';
import 'dart:io';

// HTML renderers
import 'package:html2md/html2md.dart' as html2md;

// PDF
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

buildPDF(songId, songTitle, songText) async {
  double fontSize = 16.0;
  double lineHeight = 1.5;

  final songNumber = songId.toString().padLeft(3, '0');
  final String title = songTitle;
  final RegExp exp = RegExp(
      '[^\\p{Alphabetic}\\p{Mark}\\p{Decimal_Number}\\p{Connector_Punctuation}\\p{Join_Control}\\s]+',
      unicode: true,
      multiLine: true,
      caseSensitive: true);
  final String parsedTitle = title.replaceAll(exp, '');
  final pdf = pw.Document();

  pdf.addPage(
    pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      orientation: pw.PageOrientation.portrait,
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      header: (pw.Context context) {
        if (context.pageNumber == 1) {
          return pw.SizedBox();
        }
        return pw.Container(
          alignment: pw.Alignment.centerLeft,
          margin: const pw.EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
          padding: const pw.EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
          decoration: const pw.BoxDecoration(
            border: pw.Border(
              bottom: pw.BorderSide(width: 0.5, color: PdfColors.grey),
            ),
          ),
          child: pw.Text(
            '$songNumber. $songTitle',
            style: pw.Theme.of(context)
                .defaultTextStyle
                .copyWith(color: PdfColors.grey),
          ),
        );
      },
      footer: (pw.Context context) {
        return pw.Container(
          alignment: pw.Alignment.centerRight,
          margin: const pw.EdgeInsets.only(top: 1.0 * PdfPageFormat.cm),
          child: pw.Text(
            'Pagina ${context.pageNumber} di ${context.pagesCount}',
            style: pw.Theme.of(context)
                .defaultTextStyle
                .copyWith(color: PdfColors.grey),
          ),
        );
      },
      build: (pw.Context context) {
        return <pw.Widget>[
          pw.Header(
            level: 0,
            title: '$songNumber. $songTitle',
            child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: <pw.Widget>[
                pw.Container(
                  padding:
                      const pw.EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
                  child: pw.Text('$songNumber. $songTitle', textScaleFactor: 2),
                ),
                pw.Container(
                  padding: const pw.EdgeInsets.only(
                    bottom: 3.0 * PdfPageFormat.mm,
                  ),
                  child: pw.PdfLogo(),
                )
              ],
            ),
          ),
          pw.Paragraph(
            padding: const pw.EdgeInsets.only(top: 5.0 * PdfPageFormat.mm),
            text: html2md.convert(songText, rules: [
              html2md.Rule('emphasis', filters: ['em', 'i'],
                  replacement: (content, node) {
                if (content.trim().isEmpty) return '';
                return content.replaceFirst("\n", "");
              }),
              html2md.Rule('strong', filters: ['strong', 'b'],
                  replacement: (content, node) {
                if (content.trim().isEmpty) return '';
                return content;
              })
            ]),
            style: pw.TextStyle(fontSize: fontSize, lineSpacing: lineHeight),
          ),
        ];
      },
    ),
  );
  final directory = await getApplicationDocumentsDirectory();
  final file = File('${directory.path}/$songNumber. $parsedTitle.pdf');
  file.writeAsBytesSync(await pdf.save());
  Platform.isWindows || Platform.isMacOS || Platform.isMacOS
      ? null
      : Share.shareXFiles(
          [XFile('${directory.path}/$songNumber. $parsedTitle.pdf')]);
  log('$file');
}
