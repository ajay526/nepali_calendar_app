class Festival {
  final String id;
  final String name;
  final String date;
  final String description;
  final String type;
  final bool isPublicHoliday;
  final int? duration;

  Festival({
    required this.id,
    required this.name,
    required this.date,
    required this.description,
    required this.type,
    required this.isPublicHoliday,
    this.duration,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'date': date,
      'description': description,
      'type': type,
      'isPublicHoliday': isPublicHoliday,
      'duration': duration,
    };
  }

  factory Festival.fromJson(Map<String, dynamic> json) {
    return Festival(
      id: json['id'] as String,
      name: json['name'] as String,
      date: json['date'] as String,
      description: json['description'] as String,
      type: json['type'] as String,
      isPublicHoliday: json['isPublicHoliday'] as bool,
      duration: json['duration'] as int?,
    );
  }

  @override
  String toString() {
    return 'Festival{id: $id, name: $name, date: $date, type: $type, isPublicHoliday: $isPublicHoliday, duration: $duration}';
  }
}
