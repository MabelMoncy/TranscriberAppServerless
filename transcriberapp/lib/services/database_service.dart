import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/transcription_record.dart';

class DatabaseService {
    static final DatabaseService instance = DatabaseService._init();
    static Database? _database;

    DatabaseService._init();

    Future<Database> get database async {
        if (_database != null) return _database!;
        _database = await _initDB('transcription.db');
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

    Future _createDB(Database db, int version) async {
        await db.execute('''
        CREATE TABLE history(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            fileName TEXT NOT NULL,
            filePath TEXT NOT NULL,
            transcription TEXT NOT NULL,
            dateCreated TEXT NOT NULL,
            isAccidental INTEGER NOT NULL
        )
        ''');
    }

    Future<int> create(TranscriptionRecord record) async {
        final db = await instance.database;
        return await db.insert('history', record.toMap());
    }

    Future<List<TranscriptionRecord>> readAllHistory() async {
        final db = await instance.database;
        // Optimized sorting
        const orderBy = 'id DESC'; 
        final result = await db.query('history', orderBy: orderBy);
        return result.map((json) => TranscriptionRecord.fromMap(json)).toList();
    }

    Future<int> delete(int id) async {
        final db = await instance.database;
        return await db.delete('history', where: 'id = ?', whereArgs: [id]);
    }
}