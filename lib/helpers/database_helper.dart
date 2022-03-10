import 'dart:ffi';

import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:contato/models/contato.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {
  static DatabaseHelper? _databaseHelper;
  static Database? _database;

  DatabaseHelper._createInstance();

  String contatoTable = 'contato';
  String colId = 'id';
  String colNome = 'nome';
  String colEmail = 'email';
  String colImagem = 'imagem';

  factory DatabaseHelper() {
    if (_databaseHelper! == null) {
      _databaseHelper = DatabaseHelper._createInstance();
    }
    return _databaseHelper!;
  }
  Future<Database> get database async {
    if (_database == null) {
      _database = await initializeDatabase();
    }
    return _database!;
  }

  Future<Database> initializeDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'contatos.db';
    var contatosDatabase =
        await openDatabase(path, version: 1, onCreate: _createDb);
    return contatosDatabase;
  }

  void _createDb(Database db, int newVersion) async {
    await db.execute(
        'CREATE TABLE $contatoTable($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colNome TEXT, '
        '$colEmail TEXT, '
        ', $colImagem TEXT)');
  }

  // CRUD com Helper SQL

  // inserir

  Future<int> inserirContato(Contato contato) async {
    Database db = await this.database;
    var resultado = await db.insert(contatoTable, contato.toMap());
    return resultado;
  }

  //retornar um contato pelo Id

  Future<Contato?> getContato(int id) async {
    List<Map> maps = await db.query(contatoTable,
        columns: [colId, colNome, colEmail, colImagem],
        where: "$colId = ?",
        whereArgs: [id]);
    if (maps.length > 0) {
      return Contato.fromMap(maps.first);
    } else {
      return null;
    }
  }

  // retorma a lista de constatos
  Future<List<Contato>> getContatos() async {
    Database db = await this.database;
    var resultado = await db.query(contatoTable);
    List<Contato> lista = resultado.isNotEmpty
        ? resultado.map((e) => Contato.fromMap(e)).toList()
        : [];
    return lista;
  }

  // atualizar contato
  Future<int> upDateContato(Contato contato) async {
    var db = await this.database;
    var resultado = await db.update(contatoTable, contato.toMap(),
        where: "$colId = ?", whereArgs: [contato.id]);
    return resultado;
  }

  // deletar contato
  Future<int> deleteContato(int id) async {
    var db = await this.database;
    int resultado =
        await db.delete(contatoTable, where: "$colId = ?", whereArgs: [id]);
    return resultado;
  }

  // obter o número de contatos no banco de dados

  Future<int> getCount() async {
    Database db = await this.database;
    List<Map<String, dynamic>> x =
        await db.rawQuery('SELECT COUNT (*) from $contatoTable');
    int? resultado = Sqflite.firstIntValue(x);
    return resultado!;
  }

  // fechar o banco de dados
  Future close() async {
    Database db = await this.database;
    db.close();
  }
}
