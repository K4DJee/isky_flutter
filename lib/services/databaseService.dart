import 'package:isky_new/database/sqfliteDatabase.dart';
import 'package:isky_new/models/folders.dart';
import 'package:isky_new/models/words.dart';

class DatabaseService {
  final SQLiteDatabase _db = SQLiteDatabase.instance;
  Future<List<Folders>> loadFolders() async {
    print('Начало загрузки папок...');
    try {
      final folders = await _db.getFolders();
      print('Получен список папок: ${folders.map((f) => f.name).join(', ')}');
      return folders;
    } catch (e) {
      print('Ошибка загрузки папок: $e');
      throw e;
    }
  }

  Future<List<Words>> loadWordsFromFolder(int folderId) async {
    print('Загрузка слов для папки с ID $folderId');
    try {
      final words = await _db.getWords(folderId);
      print('Получен список слов: ${words.map((w) => w.word).join(', ')}');
      return words;
    } catch (e) {
      print('Ошибка загрузки слов: $e');
      throw e;
    }
  }

  Future<int> createFolder(String folderName) async {
    print('Попытка создания папки: $folderName');
    try {
      final newFolder = Folders(id: null, name: folderName);
      print('Создан объект папки: ${newFolder.toMap()}');
      final folderId = await _db.createFolder(newFolder);
      if (folderId == 0) {
        print('Ошибка создания новой папки, такая папка уже существует');
        return folderId;
      }
      return folderId;
    } catch (e) {
      print('Ошибка создания папки $e');
      throw e;
    }
  }

  Future<void> addWord(Words word) async {
    print('Попытка добавления слова');
    try {
      await _db.addWord(word);
    } catch (e) {
      print('Ошибка добавления слова: $e');
      throw e;
    }
  }

  Future<void> deleteFolder(int id) async {
    try {
      final result = await _db.deleteFolder(id);
      if (result == 0) {
        print('Ошибка удаления папки, такой папки не существует');
      }
      await loadFolders();
    } catch (e) {
      print('Ошибка удаления папки: $e');
    }
  }

  Future<void> deleteWord(int id) async {
    try {
      final result = await _db.deleteWord(id);
      if (result == 0) {
         print('Такое слово не существует');
      }
    } catch (e) {
      print('Ошибка удаления слова: $e');
      throw e;
    }
  }

  Future<void> changeWord(Words word) async {
    try {
      final result = await _db.changeWord(word);
      if (result == 0) {
        print("Ошибка изменения слова, такого слов не существует");
      }
      print('Слово успешно изменилось c ID$result');
    } catch (e) {
      print('Ошибка изменения слова: $e');
      throw e;
    }
  }

  Future<List<Words>?> getFlashcards(int folderId, {int page = 1, int limit = 25})async{
    try{
      print('Начало получения flashcards');
      final flashcards = await _db.getFlashcards(folderId, page:page, limit:limit);
      if(flashcards == null){
        print('Слов нету');
        return null;
      }
      print('flashcards получены: $flashcards');
      return flashcards;
    }
    catch(e){
      print('Ошибка получения flashcards: $e');
    }
  }
}