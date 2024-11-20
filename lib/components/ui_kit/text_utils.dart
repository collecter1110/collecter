import 'package:characters/characters.dart';

class TextUtils {
  static String insertZwj(String text) {
    final buffer = StringBuffer();

    for (final character in text.characters) {
      buffer.write(character);
      if (character != text.characters.last) {
        buffer.write('\u200D');
      }
    }

    return buffer.toString();
  }
}
