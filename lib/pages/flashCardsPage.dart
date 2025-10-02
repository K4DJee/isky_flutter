import 'package:flutter/material.dart';
import 'package:isky_new/database/sqfliteDatabase.dart';
import 'package:isky_new/helpers/formatDayEnding.dart';
import 'package:isky_new/models/flashcardWithWord.dart';
import 'package:isky_new/models/words.dart';
import 'package:intl/intl.dart';

class FlashcardPage extends StatefulWidget {
  final int selectedFolderId;
  const FlashcardPage({super.key, required this.selectedFolderId});
  

  @override
  State<FlashcardPage> createState() => _FlashcardPageState();
}

class _FlashcardPageState extends State<FlashcardPage> {
  Words? _currentFlashcard;
  bool _showAnswer = false;
  bool _isLoading = true;
  String? _selectedDifficulty;
  int? newCounter;

  String showNextInDays(int days){
  newCounter = _currentFlashcard!.counter + days;
  return '${newCounter} ${formatDayEnding(days, context)}';
  }


  @override
  void initState() {
    super.initState();
    _loadFlashcard();
  }

  Future<void> _loadFlashcard() async {
    try {
      Words? flashcard = await SQLiteDatabase.instance.getFlashcard(
        widget.selectedFolderId,
      );
      if (mounted) {
        setState(() {
          _currentFlashcard = flashcard;
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
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Ошибка загрузки карточки: $e')));
    }
  }

  Future<void> _setDifficulty(difficulty) async {
    try {
      if (_currentFlashcard == null) {
        return print('Отсутствует flashcard');
      }
      final rowAffected = await SQLiteDatabase.instance.changeWordDifficulty(
        _currentFlashcard?.id,
        difficulty!,
      );
      if (rowAffected == 0) {
        print('Слова не существует');
        return;
      }
      print(
        'Сложность слова ${_currentFlashcard?.word} была успешна изменена на ${difficulty}}',
      );
      await _loadFlashcard();
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('flashCard')),
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
                            'Слов для обучающих карточек нету, добавьте новые слова или дождитесь слов',
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
                      ElevatedButton(onPressed: () async => await _setDifficulty('hard'), child: Text('Сложно',  textAlign: TextAlign.center)),
                      ElevatedButton(onPressed: () async => await _setDifficulty('medium'), child: Text('Средне\n${showNextInDays(2)}', textAlign: TextAlign.center,)),
                      ElevatedButton(onPressed: () async => await _setDifficulty('easy'), child: Text('Легко\n${showNextInDays(3)}',  textAlign: TextAlign.center)),
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
