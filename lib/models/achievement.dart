class Achievement {
  final int id;
  final String name;
  final String description;
  final String icon;
  final int progress;
  final bool unlocked;
  final DateTime? dateUnlocked;


  Achievement({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.progress,
    required this.unlocked,
    this.dateUnlocked,
  });

  Map<String, dynamic> toMap() =>{
    'id': id,
    'name': name,
    'description': description,
    'icon': icon,
    'progress': progress,
    'unlocked': unlocked,
    'dateUnlocked': dateUnlocked?.millisecondsSinceEpoch,
  };

  factory Achievement.fromMap(Map<String, dynamic> map) => Achievement(
    id: map['id'],
    name: map['name'],
    description: map['description'],
    icon: map['icon'],
    progress: map['progress'],
    unlocked: map['unlocked'] || true,
    dateUnlocked: map['dateUnlocked'] != null
            ? DateTime.fromMillisecondsSinceEpoch(map['dateUnlocked'])
            : null,
  );
}