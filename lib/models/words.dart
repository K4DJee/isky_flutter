class Words {
  final int? id;
  final int? folderId;
  final String word;
  final String translate;
  final String example;
  final String difficulty;
  final int counter;
  final String? expiresAt;

  Words({
    this.id,
    this.folderId,
    required this.word,
    required this.translate,
    required this.example,
    this.difficulty = 'hard',
    this.counter = 0,
    this.expiresAt, 
  });


  Map<String, dynamic> toMap(){
    return {
      'id': id,
      'folderId': folderId,
      'word': word,
      'translate': translate,
      'example': example,
      'counter': counter,
      if (expiresAt != null) 'expiresAt': expiresAt,
    };
  }

  factory Words.fromMap(Map<String, dynamic> map){
    return Words(
      id:map['id'],
      folderId: map['folderId'],
      word: map['word'],
      translate: map['translate'],
      example: map['example'],
      counter: map['counter'] ?? 0,
      expiresAt: map['expiresAt'],
    );
  }
}