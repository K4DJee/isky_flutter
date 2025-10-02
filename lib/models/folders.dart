class Folders {
  final int? id;
  final String name;

  Folders({
    this.id,
    required this.name
  });

  Map<String, dynamic> toMap(){
    return {
      'id': id,
      'name': name
    };
  }

  factory Folders.fromMap(Map<String, dynamic> map){
    return Folders(
      id:map['id'],
      name: map['name']
    );
  }
}