extension CapExtension on String {
  String get firstCaps => '${this[0].toUpperCase()}${this.substring(1)}';
}