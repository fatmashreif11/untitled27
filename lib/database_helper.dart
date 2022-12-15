import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'constants.dart';
import 'info_model.dart';

class DatabaseHelper {
  // singleton(only instance to use)
  static final DatabaseHelper instance = DatabaseHelper._init();

  DatabaseHelper._init();

  //named constrector
  static Database? _database;

  Future <Database>? get database async {
    if (_database != null) return _database!;
    _database = await initDB();
    return _database!;
  }

  Future <Database> initDB() async {
    String path = join(await getDatabasesPath(), 'infoDatabase.db');
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future <void> _onCreate(Database?db, int? version) async {
    //create tables in db - sql syntax'
    //CREATE TABLE t1(a,b PRIMARY KEY)
    db!.execute('''
    CREATE TABLE $infoTable (
    $columnID $idType,
    $columnName $textType,
    $columnPhone $textType,
    $columnEmail $textType
    )
    
    
    ''');
  }

  /// CRUD OPERATION (CREATE -READ -UPDATE -DELETE)
  /// creat tabel
  Future<void> insertInfo(InfoModel info) async {
    final db = await instance.database;
    db!.insert(infoTable,
      info.toDB(),
      conflictAlgorithm: ConflictAlgorithm.replace,
      //read
    );
  }
    Future <List<InfoModel>> readALLInfo() async {
      final db = await instance.database;
      List<Map<String, dynamic>> data = await db!.query(infoTable);

      return data.isNotEmpty ? data.map((element) => InfoModel.fromDB(element))
          .toList()
          : [];
    }
    // read
    Future<InfoModel> readOneInfo(int id) async {
      final db = await instance.database;
      List<Map<String, dynamic>> data = await db!.query(infoTable,
        where: '$columnID =?',
        whereArgs: [id],
      );
      return data.isNotEmpty
          ? InfoModel.fromDB(data.first)
          : throw Exception('Id $id is not found');
    }
    //update
          static Future<void> editInfo(InfoModel info) async {
      final db = await instance.database;
      db!.update(infoTable,
        info.toDB(),
        where: '$columnID =?',
        whereArgs: [info.id],
      );
    }
//delet
           static Future<void> deleteInfo(int id) async {
        final db = await instance.database;
        db!.delete(infoTable,
          where: '$columnID =?',
          whereArgs: [id],
        );
      }
    }