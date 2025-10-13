class Statistics {
  final int? id;
  final int? folderId;
  final int? correctWordsPerTime;
  final int? amountCorrectAnswers;
  final int? amountIncorrectAnswers;
  final int? amountAnswersPerDay;
  final int? wordsLearnedToday;
  final String createdAt;

  Statistics({
    this.id,
    required this.folderId,
    this.correctWordsPerTime,
    this.amountCorrectAnswers,
    this.amountIncorrectAnswers,
    this.amountAnswersPerDay,
    this.wordsLearnedToday,
    required this.createdAt
  });

  Map<String, dynamic> toMap()=>{
    'id': id,
    'folderId': folderId,
    'correctWordsPerTime': correctWordsPerTime,
    'amountCorrectAnswers': amountCorrectAnswers,
    'amountIncorrectAnswers': amountIncorrectAnswers,
    'amountAnswersPerDay': amountAnswersPerDay,
    'wordsLearnedToday': wordsLearnedToday,
    'createdAt': createdAt
  };

  factory Statistics.fromMap(Map<String, dynamic> map) => Statistics(
    folderId: map['folderId'], 
    correctWordsPerTime: map['correctWordsPerTime'], 
    amountCorrectAnswers: map['amountCorrectAnswers'], 
    amountIncorrectAnswers: map['amountIncorrectAnswers'],
    amountAnswersPerDay: map['amountAnswersPerDay'], 
    wordsLearnedToday: map['wordsLearnedToday'],
    createdAt: map['createdAt']
  );

}
