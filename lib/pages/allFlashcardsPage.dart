import 'package:flutter/material.dart';
import 'package:isky_new/database/sqfliteDatabase.dart';
import 'package:isky_new/helpers/formatDayEnding.dart';
import 'package:isky_new/models/flashcardWithWord.dart';
import 'package:isky_new/models/words.dart';
import 'package:intl/intl.dart';
import 'package:isky_new/services/databaseService.dart';

class AllFlashcardsPage extends StatefulWidget {
  final int selectedFolderId;
  const AllFlashcardsPage({super.key, required this.selectedFolderId});
  

  @override
  State<AllFlashcardsPage> createState() => _AllFlashcardsPageState();
}

class _AllFlashcardsPageState extends State<AllFlashcardsPage> {
  Words? _currentFlashcard;
  bool _showAnswer = false;
  bool _isLoading = true;
  String? _selectedDifficulty;
  int? newCounter;
  final DatabaseService _dbService = DatabaseService();
  int page = 1;
  List<Words> allFlashcards = [];
  List<Words>? pageFlashcards;
  int index = 0;

  String showNextInDays(int days){
  newCounter = _currentFlashcard!.counter + days;
  return '${newCounter} ${formatDayEnding(days, context)}';
  }


  @override
  void initState() {
    super.initState();
    _getFlashcards();
  }

  Future<void> _getFlashcards() async {
    try {
      setState(() {
        _isLoading = true;
      });
      allFlashcards.clear();
      do{
        pageFlashcards = await _dbService.getFlashcards(widget.selectedFolderId,page: page, limit: 15);
        if (pageFlashcards != null) {
          allFlashcards.addAll(pageFlashcards!);
          page++;
        }
      }
      while(pageFlashcards != null && pageFlashcards!.isNotEmpty);


      if (mounted) {
        setState(() {
          _isLoading = false;
          _showAnswer = false;
          _currentFlashcard = allFlashcards.isNotEmpty ? allFlashcards[0] : null;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка загрузки карточек: $e')),
      );
      }
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Ошибка загрузки карточки: $e')));
    }
  }

  Future<void> _nextFlashcard() async {
    try {
      if(allFlashcards.length > index + 1){
        setState(() {
          index++;
          _currentFlashcard = allFlashcards[index];
          _isLoading = false;
          _showAnswer = false;
        });
        }
      else{
        setState(() {
          index++;
          _currentFlashcard = null;
          _isLoading = false;
          _showAnswer = false;
        });
      }
      
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка перехода к следующей карточке: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('All words')),
      body: Center(
        child: SizedBox(
          width: 350,
          height: 400,
          child: Card(
            child:  _isLoading
            ? const Center(child: CircularProgressIndicator(backgroundColor: Colors.green, valueColor: AlwaysStoppedAnimation(Colors.black26),))
            : (_currentFlashcard == null 
            ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.warning, size: 48, color: Colors.grey),
                          const SizedBox(height: 16),
                          Text(
                            'Слов нет',
                            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Слов для обучающих карточек нету, добавьте новые слова',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    ) 
            : Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if(_currentFlashcard == null)
              Text('Слов нету')
              else
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Слово: ${_currentFlashcard?.word ?? '...'}',
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    if (_showAnswer)
                      Text(
                        'Перевод: ${_currentFlashcard?.translate}',
                        style: const TextStyle(fontSize: 18),
                      ),
                  ],
                ),
              ),

              
              if (_showAnswer)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(onPressed: () async => await _nextFlashcard(), child: Text('Следующее слово',  textAlign: TextAlign.center)),
                    ],
                  ),
                )
              else
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() => _showAnswer = true);
                    },
                    child: const Text('Показать ответ'),
                  ),
                ),
              ],
            )),
          ),
        ),
      ),
    );
  }
}
