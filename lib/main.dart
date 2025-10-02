import 'dart:io';

import 'package:flutter/material.dart';
import 'package:isky_new/database/sqfliteDatabase.dart';
import 'package:isky_new/helpers/themes.dart';
import 'package:isky_new/l10n/app_localizations.dart';
import 'package:isky_new/modals/AddWordModal.dart';
import 'package:isky_new/models/folders.dart';
import 'package:isky_new/models/words.dart';
import 'package:isky_new/pages/flashCardsPage.dart';
import 'package:isky_new/pages/onBoardingScreen.dart';
import 'package:isky_new/pages/wordActionsPage.dart';
import 'package:isky_new/providers/FolderUpdateProvider.dart';
import 'package:isky_new/services/adService.dart';
import 'package:yandex_mobileads/mobile_ads.dart';
import 'pages/SettingsPage.dart';
import 'pages/SyncPage.dart';
import 'modals/AddFolderModal.dart';
import 'package:provider/provider.dart';
import 'package:isky_new/providers/locale_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:animations/animations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Обязательно для async в main
  final prefs = await SharedPreferences.getInstance();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LocaleProvider(prefs)),
        ChangeNotifierProvider(
          create: (_) => ThemeProvider(prefs),
        ), // <-- Добавили ThemeProvider
        ChangeNotifierProvider(create: (_) => FolderUpdateProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.  HEADER
  @override
  Widget build(BuildContext context) {
    return Consumer2<LocaleProvider, ThemeProvider>(
      // <-- Consumer2 для двух провайдеров
      builder: (context, localeProvider, themeProvider, child) {
        return MaterialApp(
          title: 'Isky',

          theme: themeProvider.currentTheme,
          darkTheme: themeProvider.currentTheme,
          themeMode: themeProvider.themeMode,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: localeProvider.locale,
          home: const MyHomePage(title: 'Isky'),//OnBoardingScreen()
        );
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Folders> _folders = [];
  List<Words> _words = [];
  bool _isLoading = true;
  final SQLiteDatabase _sqfliteDatabase = SQLiteDatabase.instance;
  final _folderNameController = TextEditingController();
  final _wordController = TextEditingController();
  final _translateController = TextEditingController();
  final _exampleController = TextEditingController();
  Folders? _selectedFolder;
  int? _selectedFolderIdForWord;
  late TextEditingController searchController;
  List<Words> _filteredWords = [];
  final AdService _adService = AdService();

  @override
  void initState() {
    super.initState();
    searchController = TextEditingController();
    context.read<FolderUpdateProvider>().addListener(_onFolderUpdated);
    searchController.addListener(()=>_filterWords());
    _loadFolders();

    if(Platform.isWindows || Platform.isLinux){
      return;
    }
    MobileAds.initialize().then((_) {
      if (mounted) {
        _adService.loadAd(context, setState);
      }
    });
  }

  

  void _filterWords(){
    String query = searchController.text.toLowerCase().trim();
    
    if(query.isEmpty){
      setState(() {
      _filteredWords = _words;
    });
    return;
    }

    setState(() {
    _filteredWords = _words.where((word) {
      return word.word.toLowerCase().contains(query) ||
             word.translate.toLowerCase().contains(query) ||
             word.example.toLowerCase().contains(query);
    }).toList();
  });
  }

  



  Future<void> _loadFolders() async {
    print('Начало загрузки папок...');
    try {
      final folders = await _sqfliteDatabase.getFolders();
      print('Получен список папок: ${folders.map((f) => f.name).join(', ')}');
      setState(() {
        _folders = folders;

        if (_selectedFolderIdForWord == null && folders.isNotEmpty) {
          final firstFolder = folders.first;
          _selectedFolderIdForWord = firstFolder.id;
          _selectedFolder = firstFolder;
        }

        if (_selectedFolderIdForWord != null) {
          _loadWordsFromFolder(_selectedFolderIdForWord!);
        }

        _isLoading = false;
      });
    } catch (e) {
      print('Ошибка загрузки папок: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _onFolderUpdated() {
    _loadFolders();
  }

  Future<void> _loadWordsFromFolder(int folderId) async {
    print('Загрузка слов для папки с ID $folderId');
    try {
      final words = await _sqfliteDatabase.getWords(folderId);
      print('Получен список слов: ${words.map((w) => w.word).join(', ')}');
      setState(() {
        _words = words;
        _filteredWords = List.from(words);
      });
      _filterWords();
    } catch (e) {
      print('Ошибка загрузки слов: $e');
    }
  }

  Future<int> _CreateNewFolder(String folderName) async {
    print('Попытка создания папки: $folderName');
    try {
      final newFolder = Folders(id: null, name: folderName);
      print('Создан объект папки: ${newFolder.toMap()}');
      final folderId = await _sqfliteDatabase.createFolder(newFolder);
      if (folderId == 0) {
        print('Ошибка создания новой папки, такая папка уже существует');
        return folderId;
      }
      await _loadFolders();
      return folderId;
    } catch (e) {
      print('Ошибка создания папки $e');
      throw Error();
    }
  }

  Future<void> _AddWord() async {
    print('Попытка добавления слова');
    try {
      if (_selectedFolderIdForWord != null) {
        final newWord = Words(
          folderId: _selectedFolderIdForWord,
          word: _wordController.text.trim(),
          translate: _translateController.text.trim(),
          example: _exampleController.text.trim(),
        );

        await _sqfliteDatabase.addWord(newWord);
        _wordController.clear();
        _translateController.clear();
        _exampleController.clear();
        await _loadWordsFromFolder(_selectedFolderIdForWord!);
      } else {
        print('Ошибка: Не выбрана папка');
      }
    } catch (e) {
      print('Ошибка добавления слова: $e');
    }
  }

  Future<void> _deleteFolder(int id) async {
    try {
      final result = await _sqfliteDatabase.deleteFolder(id);
      if (result == 0) {
        print('Ошибка удаления папки, такой папки не существует');
      }
      await _loadFolders();
    } catch (e) {
      print('Ошибка удаления папки: $e');
    }
  }

  Future<void> _deleteWord(int id) async {
    try {
      final result = await _sqfliteDatabase.deleteWord(id);
      if (result == 0) {
        return print('Такое слово не существует');
        //Логика
      }
      if (_selectedFolderIdForWord != null) {
        await _loadWordsFromFolder(_selectedFolderIdForWord!);
      } else {
        print('Ошибка: Не выбрана папка для обновления списка слов');
      }
      Navigator.pop(context);
    } catch (e) {
      print('Ошибка удаления слова: $e');
      throw e;
    }
  }

  Future<void> _changeWord(Words word) async {
    try {
      final result = await _sqfliteDatabase.changeWord(word);
      if (result == 0) {
        print("Ошибка изменения слова, такого слов не существует");
      }
      print('Слово успешно изменилось c ID$result');
    } catch (e) {
      print('Ошибка изменения слова: $e');
      throw e;
    }
  }

  void _showAddFolderDialog() {
    print('Открытие AddFolderDialog');
    _folderNameController.clear();

    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      constraints: BoxConstraints(
        maxHeight:
            MediaQuery.of(context).size.height * 0.7, // Половина высоты экрана
      ),
      builder: (context) => AddFolderModal(
        controller: _folderNameController,
        onCreate: () async {
          print('Кнопка "Создать" нажата в модальном окне');
          // Получаем текст из контроллера и вызываем _CreateNewFolder
          String folderName = _folderNameController.text.trim();
          if (folderName.isNotEmpty) {
            print('Имя папки: $folderName');
            try {
              final folderId = await _CreateNewFolder(folderName);
              setState(() {
                _selectedFolderIdForWord = folderId;
                _selectedFolder = _folders.firstWhere(
                  (folder) => folder.id == folderId,
                  orElse: () => Folders(id: folderId, name: folderName),
                );
                _loadWordsFromFolder(folderId);
              });
            } catch (e) {
              print('Ошибка при создании папки: $e');
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Ошибка создания папки: $e')),
              );
            }
          } else {
            print('Имя папки пустое');
          }
        },
      ),
    );
  }

  void _showAddWordDialog(BuildContext context) {
    print('Открытие AddWordDialog');
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => AddWordModal(
        controller1: _wordController,
        controller2: _translateController,
        controller3: _exampleController,
        folders: _folders
            .map((folder) => {'id': folder.id, 'name': folder.name})
            .toList(),
        onFolderSelected: (id) {
          setState(() {
            _selectedFolder = _folders.firstWhere(
              (folder) => folder.id == _selectedFolderIdForWord,
              orElse: () => _selectedFolder ?? _folders.first,
            );
          });
          print('Выбрана папка с ID: $id');
        },
        selectedFolderId: _selectedFolderIdForWord,
        onCreate: _AddWord,
      ),
    );
  }

  void _showDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Внимание!'),
        content: const Text('Вы точно хотите это сделать?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Отмена'),
          ),
        ],
      ),
    );
  }

  void _showBottomSheet(Words word) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // ← Позволяет контролировать размер
      useSafeArea: false,
      builder: (context) {
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Выберите действие',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => _changeWord(word),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 77, 183, 58),
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: Text(
                  AppLocalizations.of(context)!.showBottomSheetChange,
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => _deleteWord(word.id!),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 77, 183, 58),
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text('Удалить'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 77, 183, 58),
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text('Закрыть'),
              ),
              const SizedBox(height: 35),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<DropdownMenuItem<Folders>> items = _folders.take(10).map((
      Folders folder,
    ) {
      return DropdownMenuItem<Folders>(value: folder, child: Text(folder.name));
    }).toList();

    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: ColorScheme.fromSeed(
                  seedColor: const Color.fromARGB(255, 77, 183, 58),
                ).primary,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(radius: 25),

                  Text(
                    '${AppLocalizations.of(context)!.selectedFolderTitle} ${_selectedFolder?.name != null ? _selectedFolder?.name : AppLocalizations.of(context)!.folderAbsent}',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  Text(
                    '${AppLocalizations.of(context)!.wordsInFolder} ${_words.length}',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ],
              ),
            ),
            DropdownButton<int?>(
              items: _folders.take(10).map((folder) {
                return DropdownMenuItem<int?>(
                  value: folder.id,
                  child: Text(folder.name),
                );
              }).toList(),
              padding: EdgeInsets.only(left: 20.0, right: 20.0),
              hint:  Text(AppLocalizations.of(context)!.yourFolders),
              value: _selectedFolderIdForWord,
              onChanged: (int? newValue) {
                setState(() {
                  _selectedFolderIdForWord = newValue;
                  if (newValue != null) {
                    _selectedFolder = _folders.firstWhere(
                      (f) => f.id == newValue,
                      orElse: () =>
                          Folders(id: newValue, name: "Неизвестная папка"),
                    );
                    _loadWordsFromFolder(newValue);
                  }
                });
              },
            ),
            ListTile(
              leading: const Icon(Icons.folder),
              title:  Text(AppLocalizations.of(context)!.addFolderTooltip),
              onTap: () {
                Navigator.pop(context);
                _showAddFolderDialog();
              },
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: Text(AppLocalizations.of(context)!.mainPage),
              onTap: () {
                Navigator.pop(context); // Закрывает drawer
              },
            ),
            ListTile(
              leading: const Icon(Icons.sync),
              title: Text(AppLocalizations.of(context)!.synchronizationPage),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SyncPage()),
                );
              },
            ),
            ListTile(
              //Статистика
              leading: const Icon(Icons.analytics_outlined),
              title: Text(AppLocalizations.of(context)!.statisticsPage),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SettingsPage()),
                );
                // Можно открыть новую страницу:
                // Navigator.push(context, MaterialPageRoute(builder: (context) => SettingsPage()));
              },
            ),
            ListTile(
              //Проверка знаний enky
              leading: ImageIcon(
                AssetImage("assets/imgs/cards-svgrepo-com.png"),
              ),
              title: Text(AppLocalizations.of(context)!.educationAnki),
              onTap: () {
                if (_selectedFolderIdForWord == null) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Выберите папку',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FlashcardPage(
                      selectedFolderId: _selectedFolderIdForWord!,
                    ),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: Text(AppLocalizations.of(context)!.settingsPage),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SettingsPage()),
                );
                // Можно открыть новую страницу:
                // Navigator.push(context, MaterialPageRoute(builder: (context) => SettingsPage()));
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: <Widget>[
          PopupMenuButton(
            itemBuilder: (BuildContext context) => [
              PopupMenuItem(
                onTap: (){
                  _adService.loadAd(context, setState);
                },
                child: Row(
                  children: [
                    Icon(Icons.ads_click),
                    SizedBox(width: 8),
                    Text('Реклама'),
                  ],
                ),
              ),
            ],
          ),
          PopupMenuButton<String>(
            icon: ImageIcon(AssetImage("assets/imgs/cards-svgrepo-com.png")),
            onSelected: (String value) {},
            itemBuilder: (BuildContext context) => [
              PopupMenuItem(
                child: Row(
                  children: [
                    Icon(Icons.share),
                    SizedBox(width: 8),
                    Text('Все слова'),
                  ],
                ),
              ),
              PopupMenuItem(
                child: Row(
                  children: [
                    Icon(Icons.feedback),
                    SizedBox(width: 8),
                    Text('Плохие слова'),
                  ],
                ),
              ),
              PopupMenuItem(
                child: Row(
                  children: [
                    Icon(Icons.feedback),
                    SizedBox(width: 8),
                    Text('Слова, которые нужно подучить'),
                  ],
                ),
              ),
            ],
          ),
        ],
        title: Text(widget.title),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          flex: 1,
                          child: Text(
                            '${AppLocalizations.of(context)!.selectedFolderTitle} ${_selectedFolder?.name ?? AppLocalizations.of(context)!.folderAbsent}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),

                        Expanded(
                          flex: 1,
                          child: SearchBar(
                            autoFocus: false,
                            constraints: BoxConstraints.tightFor(height: 40),
                            controller: searchController, //
                            trailing: <Widget>[const Icon(Icons.search)],
                            onSubmitted: (value) {
                              FocusScope.of(context).unfocus();
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(

                    child: 
                    _filteredWords.isEmpty 
                    ? Center(
                      child: Text(AppLocalizations.of(context)!.noWordsFound,
                      style:TextStyle(color: Colors.grey, fontSize: 16)),
                    )
                    : ListView.builder(
                      itemCount: _filteredWords.length,
                      itemBuilder: (context, index) {
                        final word = _filteredWords[index];

                        return OpenContainer(
                          closedColor: Theme.of(context).cardColor,
                          openColor: Theme.of(context).scaffoldBackgroundColor,
                          transitionType: ContainerTransitionType.fade,
                          transitionDuration: Duration(milliseconds: 50),
                          openBuilder: (context, action) {
                            return WordActionsPage(
                              word: word,
                              onSave: (updatedWord) async {
                                await _changeWord(updatedWord);
                                await _loadWordsFromFolder(
                                  _selectedFolderIdForWord!,
                                );
                              },
                              onDelete: (wordId) async {
                                await _deleteWord(wordId);
                                await _loadWordsFromFolder(
                                  _selectedFolderIdForWord!,
                                );
                              },
                            );
                          },
                          closedBuilder: (context, action) {
                            return Card(
                              elevation: 4,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(0),
                                side: BorderSide.none,
                              ),
                              margin: EdgeInsets.only(bottom: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  ListTile(
                                    title: Text(
                                      word.word,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20.0,
                                      ),
                                    ),
                                    subtitle: Text(
                                      word.translate,
                                      style: TextStyle(
                                        color: Colors.green,
                                        fontSize: 18.0,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      left: 16,
                                      bottom: 8,
                                    ),
                                    child: Text(word.example),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: _adService.getAdWidget(),
                  )
                ],
              ),
            ),

      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: 'addFolder',
            onPressed: _showAddFolderDialog,
            tooltip: AppLocalizations.of(context)!.addFolderTooltip,
            child: const Icon(Icons.folder),
          ),
          const SizedBox(height: 10),
          FloatingActionButton(
            heroTag: 'addWord',
            onPressed: () => _showAddWordDialog(context),
            tooltip: AppLocalizations.of(context)!.addWordTooltip,
            child: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }
  @override
  void dispose() {
    searchController.removeListener(()=>_filterWords);
    searchController.dispose();
    _adService.dispose();
    super.dispose();
  }
}

