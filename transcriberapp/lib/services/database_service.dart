import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/transcription_record.dart';

class DatabaseService{
    //1.Singleton pattern:ensure only one instance exists
    static final DatabaseService instance = DatabaseService._init(); //'instance' is the object here or singleton
    static Database? _database;

    DatabaseService._init(); //_init() is a private constructor when we add that we strictly controls others from creating a new constructor.

    //2. Get the database. If it doesn't exist, initialize it.
    Future<Database> get database async{
        if(_database != null) return _database!;
        _database = await _initDB('transcription.db');
        return _database!;
    }

    //3. Open the database file on the phones drive
    Future<Database> _initDB(String filePath) async{
        final dbPath = await getDatabasesPath();
        final path = join(dbPath, filePath);
        return await openDatabase(
          path,
          version:1,
          onCreate:_createDB,
          onUpgrade: _upgradeDB,
        );
    }

    //3b. Database upgrade handler for future schema changes
    Future _upgradeDB(Database db, int oldVersion, int newVersion) async{
        // Example for future updates:
        // if (oldVersion < 2) {
        //   await db.execute('ALTER TABLE history ADD COLUMN newField TEXT');
        // }
    }

    //4. Creating the database.Create the table (This runs Only the first time the app is launched)
    Future _createDB(Database db, int version) async{
        //SQL: "Create a box named 'history' with these strict rules" 
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

    //5. Create (Insert) a new record
    Future<int> create(TranscriptionRecord record) async{
        final db = await instance.database;
        return await db.insert('history',record.toMap());
    }

    //6. Read all records (Query)
    Future<List<TranscriptionRecord>> readAllHistory() async{
        final db = await instance.database;
        final orderBy = 'dateCreated DESC';

        final result = await db.query('history',orderBy:orderBy);
        return result.map((json) => TranscriptionRecord.fromMap(json)).toList();
    }

    //7. Delete a record
    Future<int> delete(int id) async{
        final db = await instance.database;
        return await db.delete('history',where:'id = ?',whereArgs:[id],);
    }
}