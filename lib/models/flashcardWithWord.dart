class FlashcardWithWord {
  final int? id;
  final int folderId;
  final int wordId;
  final String difficulty;
  final String word;
  final String translate;

  FlashcardWithWord({
    required this.id,
    required this.folderId,
    required this.wordId,
    required this.difficulty,
    required this.word,
    required this.translate,
  });

  factory FlashcardWithWord.fromMap(Map<String, dynamic> map) => FlashcardWithWord(
        id: map['id'],
        folderId: map['folderId'],
        wordId: map['wordId'],
        difficulty: map['difficulty'],
        word: map['word'],
        translate: map['translate'],
      );
}