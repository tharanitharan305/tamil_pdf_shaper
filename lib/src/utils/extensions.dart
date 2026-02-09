

import '../core/text_shaper.dart';

/// Public extensions for easy usage.
extension TamilPdfStringExtension on String {
  /// Transforms this string into a format suitable for rendering
  /// with the [TamilPdfFont].
  ///
  /// Example:
  /// ```dart
  /// pdf.addPage(pw.Page(build: (ctx) {
  ///   return pw.Text("வணக்கம்".toTamilPdf());
  /// }));
  /// ```
  String get toTamilPdf {
    return TamilShaper.shape(this);
  }
}