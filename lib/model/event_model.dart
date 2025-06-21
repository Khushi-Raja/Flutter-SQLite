class Event {
  final int? id;
  final String title;
  final String category;
  final String description;
  final String banner;           // URL or local asset path
  final DateTime date;

  Event({
    this.id,
    required this.title,
    required this.category,
    required this.description,
    required this.banner,
    required this.date,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'title': title,
    'category': category,
    'description': description,
    'banner': banner,
    'date': date.millisecondsSinceEpoch,
  };

  factory Event.fromMap(Map<String, dynamic> m) => Event(
    id: m['id'],
    title: m['title'],
    category: m['category'],
    description: m['description'],
    banner: m['banner'],
    date: DateTime.fromMillisecondsSinceEpoch(m['date']),
  );
}
