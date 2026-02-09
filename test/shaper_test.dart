import 'package:flutter_test/flutter_test.dart';
import 'package:tamil_pdf_shaper/src/core/text_shaper.dart';

void main() {
  group('Tamil Shaper Logic', () {
    test('Returns empty string for empty input', () {
      expect(TamilShaper.shape(''), '');
    });

    test('Returns English text unchanged', () {
      expect(TamilShaper.shape('Hello World'), 'Hello World');
    });

    test('Correctly reorders "Kombu" (e.g. கெ)', () {
      // 'க' (Ka) + 'ெ' (e) -> 'ᶎ' (Mapped e) + 'க' (Ka)
      const input = 'கெ';
      final result = TamilShaper.shape(input);

      // Expected Glyph: ᶎ (from map for ெ)
      expect(result.startsWith('ᶎ'), true, reason: 'Should start with mapped Kombu glyph');
      expect(result.endsWith('க'), true, reason: 'Should end with Base consonant');
    });

    test('Correctly reorders "Rettai Kombu" (e.g. கே)', () {
      // 'க' + 'ே' -> 'ᶏ' (Mapped E) + 'க'
      const input = 'கே';
      final result = TamilShaper.shape(input);

      // Expected Glyph: ᶏ (from map for ே)
      expect(result.startsWith('ᶏ'), true, reason: 'Should start with mapped Rettai Kombu glyph');
      expect(result.endsWith('க'), true);
    });

    test('Correctly maps simple substitutions (e.g. கி)', () {
      // Based on the map: 'கி': 'ᴣ'
      const input = 'கி';
      final result = TamilShaper.shape(input);
      expect(result, 'ᴣ');
    });

    test('Handles mixed English and Tamil', () {
      const input = 'Date: தேதி';
      final result = TamilShaper.shape(input);
      expect(result.contains('Date: '), true);
      // 'தே' -> 'ᶏ' + 'த'
      expect(result.contains('ᶏ'), true);
    });
  });
}