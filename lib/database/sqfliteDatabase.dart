import 'dart:convert';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:isky_new/models/flashcardWithWord.dart';
import 'package:path_provider/path_provider.dart';
import 'package:isky_new/models/statistics.dart';
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
        version: 13,
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
      await db.execute('DROP TABLE IF EXISTS statistics ');
     await db.execute('''
    CREATE TABLE statistics(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      folderId INTEGER NOT NULL,  
      correctWordsPerTime INTEGER NULL,
      amountCorrectAnswers INTEGER NULL,
      amountIncorrectAnswers INTEGER NULL,
      amountAnswersPerDay INTEGER NULL,
      wordsLearnedToday INTEGER NULL,
      createdAt TEXT DEFAULT CURRENT_TIMESTAMP,
      FOREIGN KEY (folderId) REFERENCES folders (id) ON DELETE CASCADE
    )
    '''
    );
    print('Таблица statistics создана');
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
    await db.execute('''
    CREATE TABLE statistics(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      folderId INTEGER NOT NULL,  
      correctWordsPerTime INTEGER NULL,
      amountCorrectAnswers INTEGER NULL,
      amountIncorrectAnswers INTEGER NULL,
      amountAnswersPerDay INTEGER NULL,
      wordsLearnedToday INTEGER NULL,
      createdAt TEXT DEFAULT CURRENT_TIMESTAMP,
      FOREIGN KEY (folderId) REFERENCES folders (id) ON DELETE CASCADE
    )
    '''
    );
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

    final allStatistics = <int, List<Statistics>>{};
  for (final folder in folders) {
    allStatistics[folder.id!] = await getStatistics(folder.id!);
  }

    final exportData = {
      'folders':folders.map((f)=>f.toMap()).toList(),
      'words': allWords.entries.map((e)=>{
        'folderId':e.key,
        'words':e.value.map((w)=>w.toMap()).toList(),
      }).toList(),
      'statistics': allStatistics.entries.map((e) => {
          'folderId': e.key,
          'statistics': e.value.map((s) => s.toMap()).toList(),
        }).toList(),
    };

    return jsonEncode(exportData);
  }

  //Импорт JSON в БД (очистить старую и вставить новую)
  Future<void> importJsonToDatabase(String jsonString) async{
    final db = await instance.database;
    await db.transaction((txn) async{
      //Очистка таблиц
      await txn.delete('statistics');
      await txn.delete('words');
      await txn.delete('folders');

      final data = jsonDecode(jsonString) as Map<String, dynamic>;

      // 1. Восстановление папок
    final Map<int, int> oldToNewFolderId = {};
    for (final folderMap in data['folders'] as List) {
      final folder = Folders.fromMap(folderMap);
      final newId = await txn.insert('folders', folder.toMap());
      final oldId = folderMap['id'] as int;
      oldToNewFolderId[oldId] = newId;
    }

    // 2. Восстановление слов
    for (final entry in data['words'] as List) {
      final oldFolderId = entry['folderId'] as int;
      final newFolderId = oldToNewFolderId[oldFolderId];
      if (newFolderId == null) continue;

      for (final wordMap in entry['words'] as List) {
        final word = Words.fromMap({...wordMap, 'folderId': newFolderId});
        await txn.insert('words', word.toMap());
      }
    }

      for (final entry in data['statistics'] as List) {
    final oldFolderId = entry['folderId'] as int;
    final newFolderId = oldToNewFolderId[oldFolderId];
    if (newFolderId == null) continue;

    for (final statMap in entry['statistics'] as List) {
      final stat = Statistics.fromMap({...statMap, 'folderId': newFolderId});
      await txn.insert('statistics', stat.toMap());
    }
    }
    });
  }

  Future<File> exportDatabaseToFile() async {
     final jsonString = await exportDatabaseToJson();

  late Directory? baseDir;

  if (Platform.isAndroid) {
    baseDir = await getDownloadsDirectory();
    if (baseDir == null) {
      baseDir = await getExternalStorageDirectory();
    }
  } else if (Platform.isIOS) {
    baseDir = await getApplicationDocumentsDirectory();
  } else {
    baseDir = await getApplicationDocumentsDirectory();
  }

  final file = File(join(baseDir!.path, 'isky_backup.json'));
  await file.writeAsString(jsonString, encoding: utf8);
  return file;
  }

  Future<void> importDatabaseFromFile(File file) async {
    try{
      final jsonString = await file.readAsString(encoding: utf8);
      await importJsonToDatabase(jsonString);
      print('Данные импортировались!');
    }
    catch(e){
      print(e);
      rethrow;
    }
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

Future<List<Words>?> getFlashcards(int folderId, {int page = 1, int limit = 25}) async{
  try{
  final db = await instance.database;
  final offset = (page - 1) * limit;
  final List<Map<String, dynamic>> flashcards = await db.rawQuery(
    '''SELECT * FROM words WHERE folderId = ? LIMIT ? OFFSET ?''', [folderId,limit, offset]
  );

  if(flashcards.isNotEmpty){
    return flashcards.map((map)=>Words.fromMap(map)).toList();
  }

  return null;
  }
  catch(e){
    print('Ошибка получения flashcards: $e');
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


//Statistics
Future<int> createStatisticDay(int   folderId, Statistics statistic)async{
  try{
    final now = DateTime.now();
    final dateString = '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
    final db = await instance.database;
    //Проверка на существование статистики этого дня
    //Если да, то обновление статистики этого дня
    //Если нет, то создание статистики этого дня
    final List<Map<String, Object?>> existStatistic = await db.query('statistics',where: 'date(createdAt) = ? AND folderId = ?', whereArgs: [dateString, folderId], orderBy: 'id DESC');
    if(existStatistic.isEmpty){
      print('Статистики на этот день не существует');//'
      //Создание статистики
      final newStatistic = await db.insert('statistics', statistic.toMap());
      return newStatistic;
    }
    else{
      print('Обновление статистики');
      final existing = existStatistic.first;
      final prevCorrectWordsPerTime = existing['correctWordsPerTime'] as int? ?? 0;
      final prevCorrectAnswers = existing['amountCorrectAnswers'] as int? ?? 0;
      final prevIncorrectAnswers = existing['amountIncorrectAnswers'] as int? ?? 0;
      final prevAnswersPerDay = existing['amountAnswersPerDay'] as int? ?? 0;
      final prevWordsLearnedToday = existing['wordsLearnedToday'] as int? ?? 0;
      
      int correctWordsPerTime = prevCorrectWordsPerTime;
      if(statistic.correctWordsPerTime != null && statistic.correctWordsPerTime! > correctWordsPerTime){
        correctWordsPerTime = statistic.correctWordsPerTime!;
      }
      final updatedStatistic = db.update('statistics',
      {
        'correctWordsPerTime': correctWordsPerTime ,
        'amountCorrectAnswers': statistic.amountCorrectAnswers != 0 ? statistic.amountCorrectAnswers! + prevCorrectAnswers : prevCorrectAnswers,
        'amountIncorrectAnswers': statistic.amountIncorrectAnswers != 0 ? statistic.amountIncorrectAnswers! + prevIncorrectAnswers : prevIncorrectAnswers,
        'amountAnswersPerDay': statistic.amountAnswersPerDay != 0 ? statistic.amountAnswersPerDay! + prevAnswersPerDay : prevAnswersPerDay,
        'wordsLearnedToday': statistic.wordsLearnedToday != 0 ? statistic.wordsLearnedToday! + prevWordsLearnedToday : prevWordsLearnedToday
      },
       where: 'date(createdAt) = ? AND folderId = ?', whereArgs: [dateString, folderId]);
      
      return updatedStatistic;
    }
  }
  catch(e){
    print('Ошибка создания статистики: $e');
    rethrow;
  }
}

Future<List<Statistics>> getStatistics(int folderId) async{
  try{
    final db = await instance.database;
    final List<Map<String, dynamic>> statisticsRows = await db.rawQuery('''
      SELECT * FROM statistics WHERE folderId = ? ORDER BY date(createdAt)
    ''', [folderId]);

    if(statisticsRows.isEmpty){
      return [];
    }
    final stats = statisticsRows.map((row) => Statistics.fromMap(row)).toList();
    final List<Statistics> filledStats = [];
    final DateFormat format = DateFormat('yyyy-MM-dd HH:mm:ss');
    DateTime? lastDate;

  for (int i = 0; i < stats.length; i++) {
  final currentStat = stats[i];
  final currentDate = format.parse(currentStat.createdAt!);

  filledStats.add(currentStat);

  // Проверяем следующую дату, если она существует
  if (i < stats.length - 1) {
    final nextStat = stats[i + 1];
    final tomorrowDay = format.parse(nextStat.createdAt!);
    if (tomorrowDay.difference(currentDate).inDays > 1) { // Точный разрыв
      var nextDay = currentDate.add(const Duration(days: 1));
      while (nextDay.isBefore(tomorrowDay)) { // Добавляем дни до следующей даты
        filledStats.add(Statistics(
          folderId: folderId,
          correctWordsPerTime: 0,
          amountCorrectAnswers: 0,
          amountIncorrectAnswers: 0,
          amountAnswersPerDay: 0,
          wordsLearnedToday: 0,
          createdAt: DateFormat('yyyy-MM-dd HH:mm:ss').format(nextDay),
        ));
        nextDay = nextDay.add(const Duration(days: 1));
      }
    }
  }
}

  //   for (final stat in stats) {
  //   final currentDate = format.parse(stat.createdAt!);

  //   if (lastDate != null) {
  //     // Проверим пропущенные дни между lastDate и currentDate
  //     var nextDay = lastDate.add(const Duration(days: 1));
  //     while (nextDay.isBefore(currentDate)) {
  //       // Добавляем "пустой" день
  //       filledStats.add(Statistics(
  //         folderId: folderId,
  //         correctWordsPerTime: 0,
  //         amountCorrectAnswers: 0,
  //         amountIncorrectAnswers: 0,
  //         amountAnswersPerDay: 0,
  //         wordsLearnedToday: 0,
  //         createdAt: DateFormat('yyyy-MM-dd HH:mm:ss').format(nextDay),
  //       ));
  //       nextDay = nextDay.add(const Duration(days: 1));
  //     }
  //   }

  //   filledStats.add(stat);
  //   lastDate = currentDate;
  //     print(currentDate.month);
  // }
  for(var i = 0; i <filledStats.length;i++){
    print(filledStats[i].createdAt);
  }
  print(filledStats.length);
  return filledStats;
  }
  catch(e){
    print('Ошибка получения статистики: $e');
    rethrow;
  }
}
}