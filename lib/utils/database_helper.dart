import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:sqflite_demo/models/notes.dart';

class DatabaseHelper {
  static DatabaseHelper? _databaseHelper; //Singleton DatabaseHelper
  static Database? _database; //  Singleton Database

  String noteTable = "note_Table";
  String colId = "id";
  String colTitle = "title";
  String colDescription = "discription";
  String colPriority = "priority";
  String colDate = "date";
  DatabaseHelper._createInstance(); //name constructor  create instance of databasehelper
  factory DatabaseHelper() {
    _databaseHelper ??= DatabaseHelper._createInstance();
    return _databaseHelper!;
  }
  Future<Database> get database async {
    _database ??= await intializeDatabase();
    return _database!;
  }

  Future<Database> intializeDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = '${directory.path}note.db';

    //open and create the database at given path
    var notesDatabase =
        await openDatabase(path, version: 1, onCreate: _createDb);
    return notesDatabase;
  }

  void _createDb(Database db, int newVersion) async {
    await db.execute(
        'CREATE TABLE $noteTable($colId INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,$colTitle TEXT,$colDescription TEXT,$colPriority INTEGER,$colDate TEXT)');
  }

  // fetch data
  Future<List<Map<String, dynamic>>> getNoteMapList() async 
  {
    Database db = await database;
    var result = await db.query(noteTable, orderBy: '$colPriority ASC');
    return result;
  }

  // insert new data
  Future<int> insertNote(Notes note) async {
    Database db = await database;
    var result = await db.insert(noteTable, note.toMap());
    return result;
  }
  //update data

  Future<int> updateNote(Notes note) async {
    Database db = await database;
    var result = await db.update(noteTable, note.toMap(),
        where: "$colId = ?", whereArgs: [note.id]);
    return result;
  }

  Future<int> deleteNote(int id) async {
    Database db = await database;
    var result =
        await db.delete(noteTable, where: "$colId = ?", whereArgs: [id]);
    return result;
  }

  Future<int> getCount() async {
    Database db = await database;
    List<Map<String, dynamic>> x =
        await db.rawQuery("SELECT COUNT (*) FROM $noteTable");
    int result = Sqflite.firstIntValue(x) ?? 0;
    return result;
  }

  Future<List<Notes>> getNoteList() async {
    var noteMapList = await getNoteMapList();
    int count = noteMapList.length;
    List<Notes> noteList = [];
    for (int i = 0; i < count; i++) {
      noteList.add(Notes.fromMapObject(noteMapList[i]));
    }
    return noteList;
  }
}
