class Todo{
  final int id ;
  final String title;
  final String createdat;
  final String? updatedat;
  Todo({
    required this.id,
    required this.title,
    required this.createdat,
    this.updatedat});
   factory Todo.fromSqfliteDatabase(Map<String, dynamic> map) => Todo(
    id: map['id']?.toInt() ?? 0, 
    title: map['title'] ?? "",
    createdat: DateTime.fromMicrosecondsSinceEpoch(map['created_at']).toIso8601String(),
    updatedat: map['updated_at'] == null? null:
    DateTime.fromMicrosecondsSinceEpoch(map['created_at']).toIso8601String());
    

}