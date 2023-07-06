import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:easy_font_loader/src/cache/factory/factory.dart';
import 'package:easy_font_loader/src/models/font_model.dart';

class EasyFontLoader {

  /// Loads a font file into registry (URL or Asset).
  ///
  /// e.g.
  ///
  /// await EasyFontLoader.load(
  ///     FontModel(
  ///       source: 'assets/scintilla.ttf',
  ///       fontFamily: 'monaco',
  ///       weight: 400,
  ///     ),
  ///   );
  static Future<void> load( FontModel fontModel ) async {

    try {

      var bytes = await downloadAndCache( fontModel.source );

      if (bytes == null || bytes.isEmpty) {
        if (kDebugMode) {
          print('EasyFontLoader: Failed to load font (empty).');
        }
        return;
      }

      var fontLoader = FontLoader(fontModel.fontFamily);


      fontLoader.addFont(Future.value(ByteData.view(bytes.buffer)));

      await fontLoader.load();

      if (kDebugMode) {
        print('EasyFontLoader: Initialized ${fontModel.fontFamily}');
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }
}