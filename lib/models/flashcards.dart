class Flashcards{
  final int? id;
  final int wordId;
  final String difficulty;

  Flashcards({
    this.id,
    required this.wordId,
    this.difficulty = 'low'
  });

  Map<String, dynamic> toMap() =>{
    'id': id,
    'wordId': wordId,
    'difficulty': difficulty,
  };

  factory Flashcards.fromMap(Map<String, dynamic> map) => Flashcards(
    id: map['id'],
    wordId: map['wordId'],
    difficulty: map['difficulty'] ?? 'low',
  );
}