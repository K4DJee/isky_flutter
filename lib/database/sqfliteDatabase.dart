import 'dart:convert';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:isky_new/models/flashcardWithWord.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import '../models/folders.dart';
import '../models/words.dart';

class SQLiteDatabase {
  static final SQLiteDatabase instance = SQLiteDatabase._init();
  static Database? _database;
 
  SQLiteDatabase._init();

  Future<Database> get database async {
    if (_database == null) {
      print('Инициализация базы данных...');
      try { 
        if(Platform.isWindows || Platform.isLinux) {
          sqfliteFfiInit();
          databaseFactory = databaseFactoryFfi;
          print('FFI инициализировано для десктопа');
        }


        final dbPath = await getDatabasesPath();
        final path = join(dbPath, 'folders.db');
        // await deleteDatabase(path);
        _database = await _initDB('folders.db');
        print('База данных инициализирована: $_database');
      } catch (e) {
        print('Ошибка инициализации базы данных: $e');
        rethrow; // Передаем ошибку дальше для обработки
      }
    }
    return _database!;
  }
  
  Future<Database> _initDB(String filePath) async {
    print('Начало инициализации базы данных по пути: $filePath');
      try {
      final dbPath = await getDatabasesPath();
      final path = join(dbPath, filePath);
      print('Полный путь к файлу базы: $path');
      return await openDatabase(
        path,
        version: 11,
        onCreate: _createDB,
        onUpgrade: _onUpgrade, // Добавляем для будущих миграций
      );
    } catch (e) {
      print('Ошибка открытия базы данных: $e');
      rethrow;
    }
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    print('Миграция БД: с $oldVersion на $newVersion');
    if (oldVersion < newVersion) {
      await db.execute('DROP TABLE IF EXISTS words ');
      await db.execute('''
    CREATE TABLE words (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      folderId INTEGER NOT NULL,  
      word TEXT NOT NULL,
      translate TEXT NOT NULL,
      example TEXT,
      difficulty TEXT NOT NULL DEFAULT 'hard',
      counter INTEGER DEFAULT 0, 
      expiresAt TEXT DEFAULT CURRENT_TIMESTAMP,
      CHECK(difficulty IN ('easy', 'medium', 'hard')),
      FOREIGN KEY (folderId) REFERENCES folders (id) ON DELETE CASCADE
    )
    ''');
      await db.execute('DROP TABLE IF EXISTS flashcards');
      print('Таблица flashcards успешно добавлена!');
    }
  }

  // Метод для закрытия базы данных
  Future<void> close() async {
    final db = _database;
    if (db != null) {
      await db.close();
      _database = null;
    }
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
    CREATE TABLE IF NOT EXISTS folders(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL
      )
    ''');
    await db.execute('''
    CREATE TABLE words (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      folderId INTEGER NOT NULL,  
      word TEXT NOT NULL,
      translate TEXT NOT NULL,
      example TEXT,
      difficulty TEXT NOT NULL DEFAULT 'hard',
      counter INTEGER DEFAULT 0, 
      expiresAt TEXT DEFAULT CURRENT_TIMESTAMP,
      CHECK(difficulty IN ('easy', 'medium', 'hard')),
      FOREIGN KEY (folderId) REFERENCES folders (id) ON DELETE CASCADE
    )
    ''');
    print('Поле difficulty добавлено в words, таблица flashcards удалена');
    await db.execute('PRAGMA foreign_keys = ON;');
  }



  //Folder operations
  Future<int> createFolder(Folders folder) async {
    print('Попытка создать папку: ${folder.toMap()}');
    final db = await instance.database;
    //Проверка на существование 
    final List<Map<String, dynamic>> existFolder = await 
    db.query('folders', where: 'name = ?', whereArgs: [folder.name], orderBy: 'id DESC');  
    if(existFolder.isNotEmpty){
      print('Такая папка уже существует');
      return 0;
    }
    final id = await db.insert('folders', folder.toMap());
    print('Папка создана с ID: $id');
    return id;
  }

  Future<List<Folders>> getFolders() async {
    final db = await instance.database;
    final result = await db.query('folders', orderBy: 'id DESC');
    return result.map((map)=>Folders.fromMap(map)).toList();
  }

  Future<int> deleteFolder(int id) async {
    //Проверка на существование папки
    final db = await instance.database;
    final existFolder = await db.query('folders', where: 'id = ?', whereArgs: [id]);
    if(existFolder.isEmpty){
    print('Такой папки не существует');
    return 0;
    }
    await db.delete('folders', where: 'id = ?', whereArgs: [id]);
    return id;
  } 

  Future<int> changeFolderName(int id, String name) async {
    //Проверка на существование папки
    final db = await instance.database;
    final existFolder = await db.query('folders', where: 'id = ?', whereArgs: [id]);
    if(existFolder.isEmpty){
    print('Такой папки не существует');
    return 0;
    }
    final rowsAffected = await db.update(
    'folders',
    {'name': name},
    where: 'id = ?',
    whereArgs: [id],
  );
    return rowsAffected > 0 ? id : 0;
  }

  //Words operation
  Future<int> addWord(Words word) async{
    print('Попытка добавления нового слова');
    final db = await instance.database;
    final id = await db.insert('words', word.toMap());
    print('Слово создано с ID: $id');
    return id;
  }

  Future<int> changeWord(Words word)async{
    print('Попытка изменения слова');
    try{
      final db = await instance.database;
      //Проверка на существование слова
      final existWord = await db.query('words', where: 'id = ?', whereArgs: [word.id], orderBy: 'id DESC');
      if(existWord.isEmpty){
        print('Ошибка изменения слова, такого слова не существует');
        return 0;
      }
      final result = await db.update('words', word.toMap(), where: 'id = ?', whereArgs: [word.id]);
      return result;
    }
    catch(e){
      throw(e);
    }
  }

  Future<List<Words>> getWords(int folderId) async{
    print('Попытка получения слов из папки с ID $folderId');
    final db = await instance.database;
    final result = await db.query('words', where:'folderId = ?', whereArgs: [folderId], orderBy: 'id DESC');
    return result.map((map)=>Words.fromMap(map)).toList();
  }

  Future<int> deleteWord(int id) async{
    print('Попытка удаления слова с ID$id');
    try{
    final db = await instance.database;
    //Проверка на существование слова
    final existWord = await db.query('words', where:'id =?', whereArgs: [id], orderBy: 'id DESC' );
    if(existWord.isEmpty){
      print('Слово с ID$id не найдено');
      return 0;
    }
    final result = await db.delete('words', where:'id = ?', whereArgs: [id]);
    print('Слово с ID $id удалено');
    return result;  
    }
    catch(e){
      print("Ошибка при удалении слова с ID$id");
      throw  Error();
    }
  }


  //wifi and bluetooth
  //Экспорт всей БД в Json строку или файл
  Future<String> exportDatabaseToJson() async{
    final db = await instance.database;
    final folders = await getFolders();
    final allWords = <int, List<Words>>{};
    for(final folder in folders){
      allWords[folder.id!] = await getWords(folder.id!);
    }

    final exportData = {
      'folders':folders.map((f)=>f.toMap()).toList(),
      'words': allWords.entries.map((e)=>{
        'folderId':e.key,
        'words':e.value.map((w)=>w.toMap()).toList(),
      }).toList(),
    };

    return jsonEncode(exportData);
  }

  //Импорт JSON в БД (очистить старую и вставить новую)
  Future<void> importJsonToDatabase(String jsonString) async{
    final db = await instance.database;
    await db.transaction((txn) async{
      //Очистка таблиц
      await txn.delete('words');
      await txn.delete('folders');

      final data = jsonDecode(jsonString) as Map<String, dynamic>;

      //Вставка folders
      for (final folderMap in data['folders'] as List){
        final folder = Folders.fromMap(folderMap);
        await txn.insert('folders', folder.toMap());
      }

      //Вставка words
      for(final entry in data['words'] as List){
        final folderId = entry['folderId'] as int;
        for(final wordMap in entry['words'] as List){
          final word = Words.fromMap({...wordMap, 'folderId': folderId});
          await txn.insert('words', word.toMap());
        }
      }
    });
  }

  // Импорт файла БД (замена)
Future<void> importDatabaseFile(File newDbFile) async {
  await close(); // Закрыть текущую БД
  final dbPath = await getDatabasesPath();
  final targetFile = File(join(dbPath, 'folders.db'));
  await targetFile.delete(); // Удалить старую
  await newDbFile.copy(targetFile.path);
  _database = await _initDB('folders.db'); // Переоткрыть
}



Future<Words?> getFlashcard(int folderId) async{
  try{
    print(folderId);
    print('Начало получения flashcard');
    final db = await instance.database;
    final now = DateTime.now().toIso8601String();
    final List<Map<String, dynamic>> fromFlashcards = await db.rawQuery('''
    SELECT *
    FROM words w
    WHERE w.folderId = ?
    AND (w.expiresAt <= ? OR w.difficulty = 'hard')
    ORDER BY 
        CASE w.difficulty
          WHEN 'hard' THEN 1
          WHEN 'medium' THEN 2
          WHEN 'easy' THEN 3
        END,
        RANDOM()
    LIMIT 1
  ''', [folderId, now]);

  if (fromFlashcards.isNotEmpty) {
    return Words.fromMap(fromFlashcards.first);
  }

  return null;
  }
  catch(e){
    print('Ошибка получения flashcard: $e');
    rethrow;
  }
}


Future<int> changeWordDifficulty(int? id, String difficulty) async{
  try{
    print('Начало изменения сложности у слова');
    final db = await instance.database;
    final now = DateTime.now();

    final existWord = await db.query('words', where: 'id = ?', whereArgs: [id], orderBy: 'id DESC');
      if(existWord.isEmpty){
        print('Ошибка: слово с ID $id не существует');
        return 0;
    } 
    final wordMap = existWord.first;

    final currentCounter = wordMap['counter'] as int? ?? 0;
    int newCounter;
    Duration interval;
    if(difficulty == 'easy'){
      newCounter = currentCounter + 3;
      interval = Duration(days: 3 * newCounter);
    }
    else if(difficulty == 'medium'){
      newCounter = currentCounter + 2;
      interval = Duration(days: 2 * newCounter);
    }
    else{
      newCounter = 0;
      interval = Duration.zero;
    }

    //expiresAt
    final nextShow = now.add(interval);
    final nextShowStr = DateFormat('yyyy-MM-dd HH:mm:ss').format(nextShow);

    final rowAffected = await db.update('words', 
    {
      'difficulty': difficulty,
      'counter': newCounter,
      'expiresAt': nextShowStr,
    },
     where: 'id = ?', whereArgs: [id] );
    print('Сложность обновлена. Затронуто строк: $rowAffected');
    return rowAffected;
  }
  catch(e){
    print('Ошибка получения flashcard: $e');
    rethrow;
  }
}
}