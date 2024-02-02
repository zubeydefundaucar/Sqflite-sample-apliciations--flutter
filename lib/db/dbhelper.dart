import 'dart:async';

import 'package:flutter_localdatabasereal/db/questionmodel.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class Dbhelper {
  Database? _db;
  String Tablename = "ToDO";
  Future<Database> get db async {
    if (_db != null) {
      return _db!;
    }
    _db = await inilizedb();
    return _db!;
  }

  Future<String> get fullpath async {
    const name = "todo.db";
    final path = await getDatabasesPath();
    return join(path, name);
  }

  Future<Database> inilizedb() async {
    final path = await fullpath;

    var xdb = openDatabase(path,
        onCreate: createdb, version: 1, singleInstance: true);
    return xdb;
  }

  Future<void> createdb(Database db, int version) async {
    await db.execute("""
create table $Tablename(
  "id" INTEGER NOT NULL,
  "title" TEXT NOT NULL,
  "created_at" INTEGER NOT NULL DEFAULT (cast(strftime('%s','now') as int )),
  "updated_at" INTEGER,
  PRIMARY KEY("id" AUTOINCREMENT))
    """);
  }

  Future<int> rawinsert({required String title}) async {
    Database db = await this.db;
    var result = await db.rawInsert(
        '''INSERT INTO $Tablename (title,created_at) VALUES (?,?)''',
        [title, DateTime.now().microsecondsSinceEpoch]);
    return result;
  }


  Future<List<Todo>> fetchAll() async {
    final database = await this.db;
    final todos = await database.rawQuery(
        '''SELECT * from $Tablename ORDER BY COALESCE(updated_at,created_at)''');
    return todos.map((todo) => Todo.fromSqfliteDatabase(todo)).toList();
  }

  Future<List<Todo>> fetcbyid() async {
    final database = await this.db;
    final todos =
        await database.rawQuery('''SELECT * from $Tablename  WHERE id= ?''');
    return todos.map((todo) => Todo.fromSqfliteDatabase(todo)).toList();
  }

  Future<void> delete(int id) async {
    Database db = await this.db;
    await db.rawDelete("delete from $Tablename where id = $id");
   
  }

  Future<int> update({required int id, String? title}) async {
    Database db = await this.db;
    var result = await db.update(Tablename, {
      if (title!=null) 'title': title,
      'updated_at': DateTime.now().millisecondsSinceEpoch,

    },
        where: 'id =?',
        whereArgs: [id]);
    return result;
  }
}
