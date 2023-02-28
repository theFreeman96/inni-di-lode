import 'package:flutter/material.dart';

import '/data/queries.dart';

import 'editor.dart';

submit({
  required Editor widget,
  required GlobalKey<FormState> editorKey,
  required QueryCtr query,
  required newSongId,
  required TextEditingController titleController,
  required TextEditingController textController,
  required List<int> macroList,
  required List<int> catList,
  required List<int> autList,
}) {
  final String transformedText = textController.text
      .replaceAll('---Strofa---\n', '<li>')
      .replaceAll('---Coro---', '<b>Coro:</b>')
      .replaceAll('---Bridge---', '<b>Bridge:</b>')
      .replaceAll('---Finale---', '<b>Finale:</b>')
      .replaceAll('\n', '<br>');
  final String formattedText = '<ol>$transformedText</ol>';

  if (editorKey.currentState!.validate()) {
    if (widget.songId != null) {
      query.updateSongs(
        titleController.text,
        formattedText,
        widget.songId,
      );
      for (int i = 0; i < macroList.length; i++) {
        int selectedMacro = macroList[i];
        int selectedCat = catList[i];
        if (selectedCat != 0) {
          query.updateSongsCategories(
            widget.songId,
            selectedMacro,
            selectedCat,
            titleController.text,
          );
        }
      }
      for (int selectedAut in autList) {
        if (selectedAut != 0) {
          query.updateSongsAuthors(
            widget.songId,
            selectedAut,
            titleController.text,
          );
        }
      }
    } else {
      query.insertSongs(
        titleController.text,
        formattedText,
        0,
      );
      for (int i = 0; i < macroList.length; i++) {
        int selectedMacro = macroList[i];
        int selectedCat = catList[i];
        if (selectedCat != 0) {
          query.insertSongsCategories(
            newSongId,
            selectedMacro,
            selectedCat,
            titleController.text,
          );
        }
      }
      for (int selectedAut in autList) {
        if (selectedAut != 0) {
          query.insertSongsAuthors(
            newSongId,
            selectedAut,
            titleController.text,
          );
        }
      }
    }
  }
}
