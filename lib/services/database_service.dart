import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/ayah_model.dart';

class DatabaseService {
  static final DatabaseService instance = DatabaseService._init();
  static Database? _database;

  DatabaseService._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('quran_poc.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE ayahs (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        surah_number INTEGER NOT NULL,
        ayah_number INTEGER NOT NULL,
        text_arabic TEXT NOT NULL,
        text_translation TEXT NOT NULL
      )
    ''');

    await _seedInitialData(db);
  }

  Future<void> _seedInitialData(Database db) async {
    final sampleAyahs = [
      {
        'surah_number': 1,
        'ayah_number': 1,
        'text_arabic': 'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ',
        'text_translation': 'In the name of Allah, the Entirely Merciful, the Especially Merciful.',
      },
      {
        'surah_number': 1,
        'ayah_number': 2,
        'text_arabic': 'الْحَمْدُ لِلَّهِ رَبِّ الْعَالَمِينَ',
        'text_translation': '[All] praise is [due] to Allah, Lord of the worlds.',
      },
      {
        'surah_number': 1,
        'ayah_number': 3,
        'text_arabic': 'الرَّحْمَٰنِ الرَّحِيمِ',
        'text_translation': 'The Entirely Merciful, the Especially Merciful.',
      },
      {
        'surah_number': 1,
        'ayah_number': 4,
        'text_arabic': 'مَالِكِ يَوْمِ الدِّينِ',
        'text_translation': 'Sovereign of the Day of Recompense.',
      },
      {
        'surah_number': 1,
        'ayah_number': 5,
        'text_arabic': 'إِيَّاكَ نَعْبُدُ وَإِيَّاكَ نَسْتَعِينُ',
        'text_translation': 'It is You we worship and You we ask for help.',
      },
      {
        'surah_number': 1,
        'ayah_number': 6,
        'text_arabic': 'اهْدِنَا الصِّرَاطَ الْمُسْتَقِيمَ',
        'text_translation': 'Guide us to the straight path.',
      },
      {
        'surah_number': 1,
        'ayah_number': 7,
        'text_arabic': 'صِرَاطَ الَّذِينَ أَنْعَمْتَ عَلَيْهِمْ غَيْرِ الْمَغْضُوبِ عَلَيْهِمْ وَلَا الضَّالِّينَ',
        'text_translation': 'The path of those upon whom You have bestowed favor, not of those who have evoked [Your] anger or of those who are astray.',
      },
    ];

    for (final ayah in sampleAyahs) {
      await db.insert('ayahs', ayah);
    }
  }

  Future<List<Ayah>> fetchAyahsBySurah(int surahNumber) async {
    final db = await database;
    final result = await db.query(
      'ayahs',
      where: 'surah_number = ?',
      whereArgs: [surahNumber],
      orderBy: 'ayah_number ASC',
    );
    return result.map((json) => Ayah.fromMap(json)).toList();
  }
}