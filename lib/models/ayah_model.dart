class Ayah {
  final int id;
  final int surahNumber;
  final int ayahNumber;
  final String textArabic;
  final String textTranslation;

  Ayah({
    required this.id,
    required this.surahNumber,
    required this.ayahNumber,
    required this.textArabic,
    required this.textTranslation,
  });

  factory Ayah.fromMap(Map<String, dynamic> map) {
    return Ayah(
      id: map['id'] as int,
      surahNumber: map['surah_number'] as int,
      ayahNumber: map['ayah_number'] as int,
      textArabic: map['text_arabic'] as String,
      textTranslation: map['text_translation'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'surah_number': surahNumber,
      'ayah_number': ayahNumber,
      'text_arabic': textArabic,
      'text_translation': textTranslation,
    };
  }

  String get audioUrl {
    final surahStr = surahNumber.toString().padLeft(3, '0');
    final ayahStr = ayahNumber.toString().padLeft(3, '0');
    return 'https://everyayah.com/data/Alafasy_128kbps/$surahStr$ayahStr.mp3';
  }
}