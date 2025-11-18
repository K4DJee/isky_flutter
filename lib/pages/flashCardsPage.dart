import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iskai/database/sqfliteDatabase.dart';
import 'package:iskai/helpers/formatDayEnding.dart';
import 'package:iskai/helpers/showExitDialog.dart';
import 'package:iskai/l10n/app_localizations.dart';
import 'package:iskai/models/statistics.dart';
import 'package:iskai/models/words.dart';
import 'package:iskai/services/databaseService.dart';

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
  final DatabaseService _dbService = DatabaseService();
  int amountCorrectAnswers = 0,
      amountIncorrectAnswers = 0,
      amountAnswersPerDay = 0,
      wordsLearnedToday = 0;

  String showNextInDays(int days){
  newCounter = _currentFlashcard!.counter + days;
  return '$newCounter ${formatDayEnding(days, context)}';
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
      ).showSnackBar(SnackBar(content: Text('${AppLocalizations.of(context)!.errorLoadingFlashcard} $e')));
    }
  }

  Future<void> _setDifficulty(difficulty) async {
    try {
      if (_currentFlashcard == null) {
        // print('Отсутствует flashcard');
        return;
      }
      final rowAffected = await SQLiteDatabase.instance.changeWordDifficulty(
        _currentFlashcard?.id,
        difficulty!,
      );
      if (rowAffected == 0) {
        // print('Слова не существует');
        return;
      }
      setState(() {
        amountCorrectAnswers++;
        amountAnswersPerDay++;
        wordsLearnedToday++;
      });
      // print(
      //   'Сложность слова ${_currentFlashcard?.word} была успешна изменена на ${difficulty}}',
      // );
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
      appBar: AppBar(
      title: Text(AppLocalizations.of(context)!.educationAnki),
      leading: IconButton(onPressed: ()async{
          final shouldExit = await showExitDialog(context);
          if(shouldExit){
            HapticFeedback.heavyImpact();
            await _dbService.createStatisticDay(
              widget.selectedFolderId,
              Statistics(
                folderId: widget.selectedFolderId,
                amountCorrectAnswers: amountCorrectAnswers,
                amountIncorrectAnswers: amountIncorrectAnswers,
                amountAnswersPerDay: amountAnswersPerDay,
                wordsLearnedToday: wordsLearnedToday,
                createdAt: DateTime.now().toString()
              ),
            );
            Navigator.pop(context);
          }
        }, icon: Icon(Icons.close)),
      ),
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
                            AppLocalizations.of(context)!.noWords,
                            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            AppLocalizations.of(context)!.noWordsDescription,
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
              Text(AppLocalizations.of(context)!.noMoreWords)
              else
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${AppLocalizations.of(context)!.wordInFlashcard} ${_currentFlashcard?.word ?? '...'}',
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    if (_showAnswer)
                      Text(
                        '${AppLocalizations.of(context)!.translateInFlashcard} ${_currentFlashcard?.translate}',
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
                      ElevatedButton(onPressed: () async => await _setDifficulty('hard'), child: Text(AppLocalizations.of(context)!.highDifficulty,  textAlign: TextAlign.center)),
                      ElevatedButton(onPressed: () async => await _setDifficulty('medium'), child: Text('${AppLocalizations.of(context)!.mediumDifficulty}\n${showNextInDays(2)}', textAlign: TextAlign.center,)),
                      ElevatedButton(onPressed: () async => await _setDifficulty('easy'), child: Text('${AppLocalizations.of(context)!.lowDifficulty}\n${showNextInDays(3)}',  textAlign: TextAlign.center)),
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
                    child:  Text(AppLocalizations.of(context)!.showAnswer),
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
