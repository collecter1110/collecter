class TextUtils {
  static String insertZwj(String text) {
    return text.replaceAllMapped(RegExp(r'(\S)(?=\S)'), (m) => '${m[1]}\u200D');
  }
}
