import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:pdf/widgets.dart' as pw;

/// A Singleton manager for loading the Tamil PDF font.
///
/// This class handles caching internally to prevent reading the asset bundle
/// multiple times during PDF generation cycles.
class TamilPdfFont {
  static const String _fontAssetPath = 'packages/tamil_pdf_shaper/assets/fonts/Anand_MuktaMalar.ttf';

  static pw.Font? _cachedFont;

  /// Loads the embedded Tamil font.
  ///
  /// Returns a [pw.Font] object ready for use with the `pdf` package.
  /// This method is idempotent; subsequent calls return the cached instance.
  static Future<pw.Font> load() async {
    if (_cachedFont != null) {
      return _cachedFont!;
    }

    try {
      final ByteData fontData = await rootBundle.load(_fontAssetPath);
      _cachedFont = pw.Font.ttf(fontData);
      return _cachedFont!;
    } catch (e, stack) {
      throw FlutterError(
          'Failed to load Tamil font from package. \n'
              'Error: $e\nStack: $stack'
      );
    }
  }

  /// Synchronously returns the cached font if available.
  ///
  /// Throws an error if [load] has not been awaited at least once.
  static pw.Font get font {
    assert(_cachedFont != null, 'TamilPdfFont.load() must be called and awaited before accessing the font property.');
    return _cachedFont!;
  }
}