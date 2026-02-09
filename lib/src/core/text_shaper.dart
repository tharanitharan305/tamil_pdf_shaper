import 'package:characters/characters.dart';

part 'tamil_glyph_map.dart';

/// The engine responsible for reordering and mapping Unicode Tamil text
/// to the specific glyph layout required by the PDF renderer.
class TamilShaper {
  // Private constructor to prevent instantiation.
  const TamilShaper._();

  /// Converts a standard Unicode Tamil string into the encoded format
  /// required by the Anand MuktaMalar font.
  static String shape(String input) {
    if (input.isEmpty) return input;

    final buffer = StringBuffer();

    // Iterate over grapheme clusters (characters), not code units.
    for (var grapheme in input.characters) {
      buffer.write(_processGrapheme(grapheme));
    }

    return buffer.toString();
  }

  /// Processes a single grapheme cluster.
  static String _processGrapheme(String grapheme) {
    // Check specific vowel combinations that require reordering
    if (grapheme.contains('ொ')) {
      return _reorderSurrounding(grapheme, 'ெ', 'ா');
    } else if (grapheme.contains('ோ')) {
      return _reorderSurrounding(grapheme, 'ே', 'ா');
    } else if (grapheme.contains('ௌ')) {
      return _reorderSurrounding(grapheme, 'ெ', 'ௗ');
    } else if (grapheme.contains('ெ')) {
      return _reorderPrefix(grapheme, 'ெ');
    } else if (grapheme.contains('ே')) {
      return _reorderPrefix(grapheme, 'ே');
    } else if (grapheme.contains('ை')) {
      return _reorderPrefix(grapheme, 'ை');
    }

    // Direct mapping fallback
    return _kTamilGlyphMap[grapheme] ?? grapheme;
  }

  /// Helper to handle Prefix + Base + Suffix reordering
  /// e.g. 'கொ' (Ko) -> 'ெ' (e-marker) + 'க' (Ka) + 'ா' (aa-marker)
  static String _reorderSurrounding(String grapheme, String prefixKey, String suffix) {
    // FIX: Use split('').first to get the raw consonant code unit,
    // ignoring the attached vowel sign in the cluster.
    final base = grapheme.split('').first;

    final mappedPrefix = _kTamilGlyphMap[prefixKey] ?? prefixKey;
    // Note: Suffix 'ா' or 'ௗ' might need mapping too if the map defines them,
    // but usually they are standard in these fonts or handled by fallback.
    // For safety, we check the map for the suffix too.
    final mappedSuffix = _kTamilGlyphMap[suffix] ?? suffix;

    return '$mappedPrefix$base$mappedSuffix';
  }

  /// Helper to handle Prefix + Base reordering
  /// e.g. 'கெ' (Ke) -> 'ெ' (e-marker) + 'க' (Ka)
  static String _reorderPrefix(String grapheme, String prefixKey) {
    // FIX: Extract consonant code unit
    final base = grapheme.split('').first;

    // FIX: Always map the prefix to ensure correct font rendering (e.g. ெ -> ᶎ)
    final mappedPrefix = _kTamilGlyphMap[prefixKey] ?? prefixKey;

    return '$mappedPrefix$base';
  }
}