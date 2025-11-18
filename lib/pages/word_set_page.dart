import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iskai/l10n/app_localizations.dart';
import 'package:iskai/models/languages.dart';
import 'package:iskai/models/words.dart';
import 'package:iskai/providers/FolderUpdateProvider.dart';
import 'package:iskai/services/databaseService.dart';
import 'package:provider/provider.dart';

class WordSetPage extends StatefulWidget {
  final String appBarTitle;
  final Map<String, dynamic> dataSet;
  final int selectedFolderId;
  const WordSetPage({
    super.key,
    required this.appBarTitle,
    required this.dataSet,
    required this.selectedFolderId,
  });

  @override
  State<WordSetPage> createState() => _WordSetPageState();
}

class _WordSetPageState extends State<WordSetPage> {
  bool _isLoading = true;
  List<Map<String, String>> words = [];
  List<bool> _selected = [];
  final DatabaseService _dbService = DatabaseService();
  Languages? _selectedLanguageItem;
  late String _selectedCodeLanguage;
  static final List<Languages> _languages = [
    Languages(lang: 'English', code: 'en'),
    Languages(lang: 'Русский', code: 'ru'),
  ];

  Future<void> _loadWordsFromWordSet(String path) async {
    try {
      if (path.isEmpty) {
        // Если путь пустой, просто завершаем загрузку
        setState(() {
          _isLoading = false;
          words = [];
          _selected = [];
        });
        return;
      }

      String jsonString = await rootBundle.loadString(path);
      final List<dynamic> jsonList = jsonDecode(jsonString);
      final List<Map<String, String>> loadedWords = jsonList.map((item) {
        if (item is Map<String, dynamic>) {
          return item.map(
            (key, value) => MapEntry(key.toString(), value.toString()),
          );
        } else {
          return <String, String>{};
        }
      }).toList();

      setState(() {
        _isLoading = false;
        words = loadedWords;
        _selected = List<bool>.filled(loadedWords.length, false);
      });
    } catch (e) {
      print('${AppLocalizations.of(context)!.errorLoadJsonFromWordSet} $e');
      setState(() {
        _isLoading = false;
        words = [];
        _selected = [];
      });
    }
  }

 Future<String?> showAddLangOfWordsDialog() async {
  return await showModalBottomSheet<String>(
    context: context,
    isScrollControlled: true,
    builder: (context) => Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            AppLocalizations.of(context)!.selectLanguage,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          ListView.builder(
            shrinkWrap: true,
            itemCount: _languages.length,
            itemBuilder: (context, index) {
              final lang = _languages[index];
              return ListTile(
                title: Text(lang.lang),
                onTap: () {
                  Navigator.pop(context, lang.code);
                },
              );
            },
          ),
        ],
      ),
    ),
  );
}

  Future<void> _importSelectedWordsToFolder(
    int folderId,
    String? language,
  ) async {
    try {
      if(language == null){
        ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          showCloseIcon: true,
          content: Text(AppLocalizations.of(context)!.selectLang),
        ),
      );
      return;
      }
      List<Map<String, String>> selectedWords = [];
      //Импорт слов определённого языка
      String jsonString = await rootBundle.loadString(widget.dataSet['langCode'][language]);
      final List<dynamic> jsonList = jsonDecode(jsonString);
      final List<Map<String, String>> loadedWords = jsonList.map((item) {
        if (item is Map<String, dynamic>) {
          return item.map(
            (key, value) => MapEntry(key.toString(), value.toString()),
          );
        } else {
          return <String, String>{};
        }
      }).toList();
      for (int i = 0; i < loadedWords.length; i++) {
        if (_selected[i]) {
          selectedWords.add(loadedWords[i]);
        }
      }

      if (selectedWords.isEmpty) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar( SnackBar
        (
          showCloseIcon: true,
          content: Text(AppLocalizations.of(context)!.notSelectedWordsForAdd)));
        return;
      }

      for (Map<String, String> wordMap in selectedWords) {
        Words word = Words.fromMap(wordMap);
        final wordwithFolderId = Words(
          folderId: folderId,
          word: word.word,
          translate: word.translate,
          example: word.example,
        );
        print(wordwithFolderId);
        await _dbService.addWord(wordwithFolderId);
      }

      ScaffoldMessenger.of(context).showSnackBar(
         SnackBar(
          showCloseIcon: true,
          content: Text(AppLocalizations.of(context)!.successAddedWordsToFolders),
          backgroundColor: Colors.green,
        ),
      );
      context.read<FolderUpdateProvider>().notifyFolderUpdated();
      setState(() {
        _selected = List<bool>.filled(words.length, false);
      });
    } catch (e) {
      print('${AppLocalizations.of(context)!.errorAddingWords} $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${AppLocalizations.of(context)!.errorAddingWords} $e'), backgroundColor: Colors.red),
      );
    }
  }

  Future<void> _importAllWordsToFolder(int folderId, String? language) async {
    try {
      if(language == null){
        ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          showCloseIcon: true,
          content: Text(AppLocalizations.of(context)!.selectLang),
        ),
      );
      return;
      }
      //Импорт слов определённого языка
      String jsonString = await rootBundle.loadString(widget.dataSet['langCode'][language]);
      final List<dynamic> jsonList = jsonDecode(jsonString);
      final List<Map<String, String>> loadedWords = jsonList.map((item) {
        if (item is Map<String, dynamic>) {
          return item.map(
            (key, value) => MapEntry(key.toString(), value.toString()),
          );
        } else {
          return <String, String>{};
        }
      }).toList();

      await _dbService.importWordsToFolder(folderId, loadedWords);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          showCloseIcon: true,
          content: Text(AppLocalizations.of(context)!.successAddedWordsToFolders),
          backgroundColor: Colors.green,
        ),
      );
      context.read<FolderUpdateProvider>().notifyFolderUpdated();
    } catch (e) {
      SnackBar(
        showCloseIcon: true,
        content: Text('${AppLocalizations.of(context)!.errorAddingWords} $e'),
        backgroundColor: Colors.red,
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _loadWordsFromWordSet(widget.dataSet['path']);
  }

  @override
  Widget build(BuildContext context) {
    bool hasSelected = _selected.contains(true);
    return Scaffold(
      appBar: AppBar(title: Text(widget.appBarTitle)),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            SizedBox(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.dataSet['name'], style: TextStyle(
                    fontSize: 18,
                  ),),
                  Text(widget.dataSet['description'], style: TextStyle(
                    fontSize: 16,
                  ),),
                  Text('${AppLocalizations.of(context)!.amountOfWords} ${words.length}', style: TextStyle(
                    fontSize: 16,
                  ),),
                  SizedBox(height: 5),
                  ElevatedButton(
                    onPressed: () async{
                      String? selectedLangCode = await showAddLangOfWordsDialog();
                      _importAllWordsToFolder(widget.selectedFolderId, selectedLangCode);
                    },
                    child: Text(AppLocalizations.of(context)!.downloadAllWordsBtn),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            if (_isLoading)
              const Center(child: CircularProgressIndicator())
            else
              Expanded(
                child: ListView.builder(
                  itemCount: words.length,
                  itemBuilder: (context, index) {
                    return CheckboxListTile(
                      contentPadding: EdgeInsets.zero,
                      value: _selected[index],
                      onChanged: (bool? newValue) {
                        setState(() {
                          _selected[index] = newValue ?? false;
                        });
                        print(_selected);
                      },
                      title: Text(
                        words[index]['word'] ?? '',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(words[index]['translate'] ?? ''),
                    );
                  },
                ),
              ),
            Visibility(
              visible: hasSelected,
              child: Align(
                alignment: Alignment.centerRight,
                child: SafeArea(
                  child: Padding(
                padding: EdgeInsets.only(
                  bottom: 4.0,
                  right: 5,
                ),
                child: ElevatedButton(
                  onPressed: () async{
                    String? selectedLangCode = await showAddLangOfWordsDialog();
                    _importSelectedWordsToFolder(
                      widget.selectedFolderId,
                      selectedLangCode,
                    );
                  },
                  child: Text(AppLocalizations.of(context)!.downloadSelectedWordsBtn),
                ),
              ),
                ) 
              ) 
            ),
          ],
        ),
      ),
    );
  }
}
