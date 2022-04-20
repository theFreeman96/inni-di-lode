import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// HTML renderers
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:html2md/html2md.dart' as html2md;

// PDF
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '/theme/constants.dart';
import '/theme/provider.dart';

class SongsDetail extends StatefulWidget {
  final int songId;
  final String songTitle;
  final String songText;
  const SongsDetail(this.songId, this.songTitle, this.songText);

  @override
  _SongsDetailState createState() =>
      _SongsDetailState(songId, songTitle, songText);
}

class _SongsDetailState extends State<SongsDetail> {
  final int songId;
  final String songTitle;
  final String songText;

  _SongsDetailState(this.songId, this.songTitle, this.songText);

  final pdf = pw.Document();
  get songNumber => songId.toString().padLeft(3, '0');

  late String title = songTitle;
  RegExp exp = RegExp(
      r'[^\p{Alphabetic}\p{Mark}\p{Decimal_Number}\p{Connector_Punctuation}\p{Join_Control}\s]+',
      unicode: true,
      multiLine: true,
      caseSensitive: true);
  late String parsedTitle = title.replaceAll(exp, '');

  writeOnPdf() {
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
                    padding: const pw.EdgeInsets.only(
                        bottom: 3.0 * PdfPageFormat.mm),
                    child:
                        pw.Text('$songNumber. $songTitle', textScaleFactor: 2),
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
                html2md.Rule('listItem', filters: ['li'],
                    replacement: (content, node) {
                  var convertContent = content
                      .replaceAll(RegExp(r'^\n+'), '')
                      .replaceAll(RegExp(r'\n+$'), '\n')
                      .replaceAll(RegExp('\n', multiLine: true), '\n    ');
                  var prefix = ('bulletListMarker') + '   ';
                  if (node.parentElName == 'ol') {
                    var start = -1;
                    var startAttr = node.getParentAttribute('start');
                    if (startAttr != null && startAttr.isNotEmpty) {
                      try {
                        start = int.parse(startAttr);
                      } catch (e) {
                        log('listItem parse start error $e');
                      }
                    }
                    var index = (start > -1)
                        ? start + node.parentChildIndex
                        : node.parentChildIndex + 1;
                    prefix = '$index. ';
                  }
                  var postfix = ((node.nextSibling != null) &&
                          !RegExp(r'\n$').hasMatch(convertContent))
                      ? '\n'
                      : '';
                  return '$prefix$convertContent$postfix';
                }),
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
              style: pw.TextStyle(fontSize: textSize, lineSpacing: textHeight),
            ),
          ];
        },
      ),
    );
  }

  Future sharePdf() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/$songNumber. $parsedTitle.pdf');
    file.writeAsBytesSync(await pdf.save());
    Share.shareFiles(['${directory.path}/$songNumber. $parsedTitle.pdf']);
    log('$file');
  }

  double textSize = 16.0;
  double textSizeMin = 16.0;
  double textSizeMax = 20.0;

  double textHeight = 1.5;
  double textHeightMin = 1.0;
  double textHeightMax = 2.0;

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return SafeArea(
      child: Scaffold(
        extendBody: true,
        appBar: AppBar(
          elevation: 0.0,
          title: const Text('Dettaglio'),
          leading: IconButton(
            tooltip: 'Indietro',
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              FocusScope.of(context).unfocus();
              Navigator.of(context).pop();
            },
          ),
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.only(
                  left: kDefaultPadding, right: kDefaultPadding),
              child: Row(
                children: [
                  Icon(
                    themeProvider.isDarkMode
                        ? Icons.dark_mode
                        : Icons.light_mode,
                  ),
                  Switch(
                    value: themeProvider.isDarkMode,
                    onChanged: (value) {
                      final provider =
                          Provider.of<ThemeProvider>(context, listen: false);
                      provider.toggleTheme(value);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          tooltip: 'Preferito',
          child: const Icon(Icons.favorite_border),
          onPressed: () {},
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
        body: Scrollbar(
          isAlwaysShown: true,
          child: SingleChildScrollView(
            child: Center(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(kDefaultPadding),
                    child: CircleAvatar(
                      child: Text(
                        songId.toString(),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: kDefaultPadding),
                    child: Text(
                      songTitle,
                      style: const TextStyle(fontSize: 22.0),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: kDefaultPadding,
                      right: kDefaultPadding,
                      bottom: kDefaultPadding * 7,
                    ),
                    child: HtmlWidget(
                      songText,
                      textStyle: TextStyle(
                        fontSize: textSize,
                        height: textHeight,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          shape: const CircularNotchedRectangle(),
          notchMargin: 8.0,
          child: Padding(
            padding: const EdgeInsets.only(left: kDefaultPadding),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.settings),
                  tooltip: 'Impostazioni',
                  onPressed: () {
                    showModalBottomSheet<void>(
                      context: context,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(15),
                          topRight: Radius.circular(15),
                        ),
                      ),
                      isScrollControlled: true,
                      builder: (BuildContext context) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            ListTile(
                              leading: const Icon(Icons.format_size),
                              title: const Text('Dimensione Testo'),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.text_decrease),
                                    tooltip: 'Testo più Piccolo',
                                    onPressed: () {
                                      if (textSize > textSizeMin) {
                                        textSize = textSize - 2.0;
                                      } else {
                                        log('Dimensione minima del testo: $textSize');
                                      }
                                      setState(
                                        () {},
                                      );
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.text_increase),
                                    tooltip: 'Testo più Grande',
                                    onPressed: () {
                                      if (textSize < textSizeMax) {
                                        textSize = textSize + 2.0;
                                      } else {
                                        log('Dimensione massima del testo: $textSize');
                                      }
                                      setState(
                                        () {},
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                            ListTile(
                              leading: const Icon(Icons.format_line_spacing),
                              title: const Text('Interlinea'),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(
                                      Icons.density_small,
                                    ),
                                    tooltip: 'Diminuisci Interlinea',
                                    onPressed: () {
                                      if (textHeight > textHeightMin) {
                                        textHeight = textHeight - 0.5;
                                      } else {
                                        log('Interlinea minima: $textHeight');
                                      }
                                      setState(
                                        () {},
                                      );
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.density_medium,
                                    ),
                                    tooltip: 'Aumenta Interlinea',
                                    onPressed: () {
                                      if (textHeight < textHeightMax) {
                                        textHeight = textHeight + 0.5;
                                      } else {
                                        log('Interlinea massima: $textHeight');
                                      }
                                      setState(
                                        () {},
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                            const Divider(),
                            ListTile(
                              title: const Center(
                                child: Text('Chiudi'),
                              ),
                              onTap: () {
                                FocusScope.of(context).unfocus();
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
                IconButton(
                  icon: const Icon(
                    Icons.play_circle_fill,
                  ),
                  tooltip: 'Riproduci',
                  onPressed: () {},
                ),
                IconButton(
                  tooltip: 'Condividi',
                  icon: const Icon(
                    Icons.share,
                  ),
                  onPressed: () async {
                    writeOnPdf();
                    await sharePdf();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
