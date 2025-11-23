class UserStatistics {
  final int? id;
  final int dailyStreak;
  final String createdAt;

  UserStatistics({
     this.id,
    required this.dailyStreak,
    required this.createdAt,
  });

  Map<String, dynamic> topMap() =>{
    'id': id,
    'dailyStreak': dailyStreak,
    'createdAt': createdAt
  };

  factory UserStatistics.fromMap(Map<String,dynamic> map) => UserStatistics(
    id: map['id'],
    dailyStreak: map['dailyStreak'],
    createdAt: map['createdAt']
  );
}

//Попробовать создать методы этого класса