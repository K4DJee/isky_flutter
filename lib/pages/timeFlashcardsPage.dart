import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:isky_new/helpers/formatDuration.dart';
import 'package:isky_new/helpers/showExitDialog.dart';
import 'package:isky_new/models/statistics.dart';
import 'package:isky_new/models/words.dart';
import 'package:isky_new/services/databaseService.dart';
import 'package:isky_new/widgets/timeProgressBar.dart';

class TimeFlashcardsPage extends StatefulWidget {
  final int selectedFolderId;
  const TimeFlashcardsPage({super.key, required this.selectedFolderId});

  @override
  State<TimeFlashcardsPage> createState() => _TimeFlashcardsPageState();
}

class _TimeFlashcardsPageState extends State<TimeFlashcardsPage> {
  Words? _currentFlashcard;
  bool _showAnswer = false;
  bool _isLoading = true;
  String? _selectedDifficulty;
  int? newCounter;
  Duration _selectedDuration = Duration(minutes: 1);
  List<Words> allFlashcards = [];
  List<Words>? pageFlashcards;
  int index = 0;
  int page = 1;
  late TextEditingController controller;
  final DatabaseService _dbService = DatabaseService();
  bool _isTimerStarted = false;
  bool _isTimerFinished = false;
  int correctWordsPerTime = 0,
      amountCorrectAnswers = 0,
      amountIncorrectAnswers = 0,
      amountAnswersPerDay = 0,
      wordsLearnedToday = 0;
  DateTime? _startTime;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController(); // Initialize the controller
  }

  @override
  void dispose() {
    controller.dispose(); // Dispose of the controller to prevent memory leaks
    super.dispose();
  }

  void setTimerAndStart(Duration timer) async {
    await _getFlashcards();
    print('Таймер пошёл');
    setState(() {
      _isTimerStarted = true;
      this._selectedDuration = timer;
      _startTime = DateTime.now();
    });
  }

  Future<void> _getFlashcards() async {
    try {
      setState(() {
        _isLoading = true;
      });
      allFlashcards.clear();
      do {
        pageFlashcards = await _dbService.getFlashcards(
          widget.selectedFolderId,
          page: page,
          limit: 15,
        );
        if (pageFlashcards != null) {
          allFlashcards.addAll(pageFlashcards!);
          page++;
        }
      } while (pageFlashcards != null && pageFlashcards!.isNotEmpty);

      if (mounted) {
        setState(() {
          _isLoading = false;
          _showAnswer = false;
          _currentFlashcard = allFlashcards.isNotEmpty
              ? allFlashcards[0]
              : null;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Ошибка загрузки слова: $e')));
      }
    }
  }

  Future<void> _nextFlashcard() async {
    try {
      print("${controller.text}, ${_currentFlashcard!.word}");
      if (_currentFlashcard != null &&
          controller.text != _currentFlashcard!.word) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Неверное слово, попробуйте снова')),
        );
        setState(() {
          amountIncorrectAnswers++;
          amountAnswersPerDay++;
        });
        return;
      }

      if (allFlashcards.length > index + 1) {
        setState(() {
          controller.clear();
          index++;
          _currentFlashcard = allFlashcards[index];
          _isLoading = false;
          _showAnswer = false;
          correctWordsPerTime++;
          wordsLearnedToday++;
          amountCorrectAnswers++;
          amountAnswersPerDay++;
        });
      } else {
        setState(() {
          controller.clear();
          index++;
          _currentFlashcard = null;
          _isLoading = false;
          _showAnswer = false;
        });

        _finishTimerEarly();
        return;
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Ошибка перехода к следующему переводу слова: $e'),
          ),
        );
      }
    }
  }

  void _finishTimerEarly() {
    if (_isTimerStarted && !_isTimerFinished) {
      setState(() {
        _isTimerStarted = false;
        _isTimerFinished = true;
      });

      _handleTimerFinish();
    }
    HapticFeedback.heavyImpact();
  }

  Future<void> _handleTimerFinish() async {
    final actualDuration = _elapsedTime;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Тренировка завершена')));

    await _dbService.createStatisticDay(
      widget.selectedFolderId,
      Statistics(
        folderId: widget.selectedFolderId,
        correctWordsPerTime: correctWordsPerTime,
        amountCorrectAnswers: amountCorrectAnswers,
        amountIncorrectAnswers: amountIncorrectAnswers,
        amountAnswersPerDay: amountAnswersPerDay,
        wordsLearnedToday: wordsLearnedToday,
        createdAt: DateTime.now().toString()
      ),
    );

    final player = AudioPlayer();
    await player.play(AssetSource('audio/timeFinishedSound.mp3'));
  }

  Duration get _elapsedTime {
    if (_startTime == null) return Duration.zero;
    return DateTime.now().difference(_startTime!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Написание слова по переводу на время'),
        elevation: 0,
        actions: [IconButton(icon: const Icon(Icons.help), onPressed: () {})],
        leading: IconButton(onPressed: ()async{
          final shouldExit = await showExitDialog(context);
          if(shouldExit){
            if (_isTimerStarted && !_isTimerFinished) {
              _finishTimerEarly(); // сохранить статистику
            }
            Navigator.pop(context);
          }
        }, icon: Icon(Icons.close)),
      ),
      body: Column(
        children: [
          if (_isTimerStarted)
            TimerProgressBar(
              testDuration: _selectedDuration,
              onTimerFinish: () async {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text('Тест завершён')));
                setState(() {
                  _isTimerStarted = false;
                  _isTimerFinished = true;
                });
                final actualDuration = _elapsedTime;
                await _dbService.createStatisticDay(
                  widget.selectedFolderId,
                  Statistics(
                    folderId: widget.selectedFolderId,
                    correctWordsPerTime: correctWordsPerTime,
                    amountCorrectAnswers: amountCorrectAnswers,
                    amountIncorrectAnswers: amountIncorrectAnswers,
                    amountAnswersPerDay: amountAnswersPerDay,
                    wordsLearnedToday: wordsLearnedToday,
                    createdAt: DateTime.now().toString()
                  ),
                );
                final player = AudioPlayer();
                player.play((AssetSource('audio/timeFinishedSound.mp3')));
                HapticFeedback.heavyImpact();
              },
            ),
          Expanded(
            child: Center(
              child: _isLoading
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          'Выберите время, за которое будете проходить тренировку',
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),
                        Wrap(
                          alignment: WrapAlignment.center,
                          spacing: 8.0,
                          runSpacing: 8.0,
                          children: [
                            ElevatedButton(
                              onPressed: () =>
                                  setTimerAndStart(Duration(minutes: 2)),
                              child: const Text('2 мин'),
                            ),
                            ElevatedButton(
                              onPressed: () =>
                                  setTimerAndStart(Duration(minutes: 5)),
                              child: const Text('5 мин'),
                            ),
                            ElevatedButton(
                              onPressed: () =>
                                  setTimerAndStart(Duration(minutes: 10)),
                              child: const Text('10 мин'),
                            ),
                            ElevatedButton(
                              onPressed: () =>
                                  setTimerAndStart(Duration(minutes: 15)),
                              child: const Text('15 мин'),
                            ),
                            ElevatedButton(
                              onPressed: () =>
                                  setTimerAndStart(Duration(minutes: 20)),
                              child: const Text('20 мин'),
                            ),
                            ElevatedButton(
                              onPressed: () =>
                                  setTimerAndStart(Duration(minutes: 30)),
                              child: const Text('30 мин'),
                            ),
                            ElevatedButton(
                              onPressed: () =>
                                  setTimerAndStart(Duration(minutes: 45)),
                              child: const Text('45 мин'),
                            ),
                            ElevatedButton(
                              onPressed: () =>
                                  setTimerAndStart(Duration(minutes: 60)),
                              child: const Text('60 мин'),
                            ),
                          ],
                        ),
                      ],
                    )
                  : SizedBox(
                      width: 400,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          _currentFlashcard == null && _isTimerFinished == false
                              ? Column(
                                  children: [
                                    const Icon(
                                      Icons.warning,
                                      size: 48,
                                      color: Colors.grey,
                                    ),
                                    const SizedBox(height: 16),
                                    const Text(
                                      'Слов нет',
                                      style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'Слов для обучающих карточек нету, добавьте новые слова',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(color: Colors.grey[600]),
                                    ),
                                  ],
                                )
                              : Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: _isTimerFinished == false
                                      ? Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              _currentFlashcard!.translate,
                                              style: const TextStyle(
                                                fontSize: 24,
                                                fontWeight: FontWeight.bold,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                            const SizedBox(height: 40),
                                            TextField(
                                              controller: controller,
                                              decoration: InputDecoration(
                                                labelText: 'Слово',
                                                suffixIcon: IconButton(
                                                  onPressed: _nextFlashcard,
                                                  icon: const Icon(
                                                    Icons.arrow_right_alt_sharp,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        )
                                      : Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Image.asset(
                                              'assets/gifs/clock(60fps).gif',
                                              height: 50,
                                              width: 50,
                                            ),
                                            Card(
                                              child: Padding(
                                                padding: EdgeInsets.all(16),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text('Время закончилось!', style: TextStyle(fontWeight: FontWeight.bold),),
                                                    Text(
                                                      'Всего слов: $amountAnswersPerDay',
                                                    ),
                                                    Text(
                                                      'Правильно: $amountCorrectAnswers',
                                                      style: TextStyle(color: Colors.green[400])
                                                    ),
                                                    Text(
                                                      'Ошибок: $amountIncorrectAnswers',
                                                      style: TextStyle(color: Colors.red)
                                                    ),
                                                    Text(
                                                      'Время: ${formatDuration(_elapsedTime)}',
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                ),
                        ],
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
