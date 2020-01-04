extension StringExt on String {
  String get titleCase {
    if (this.length <= 1) return this.toUpperCase();
    var words = this.split(' ');
    var capitalized = words.map((word) {
      var first = word.substring(0, 1).toUpperCase();
      var rest = word.substring(1);
      return '$first$rest';
    });
    return capitalized.join(' ');
  }
}