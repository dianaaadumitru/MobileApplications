class Tip {
  late int id;
  String name;
  String description;
  String materials;
  String steps;
  String category;
  String difficulty;

  Tip(this.name, this.description, this.materials, this.steps, this.category,
      this.difficulty) {
    id = -1;
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'materials': materials,
      'director': steps,
      'category': category,
      'difficulty': difficulty
    };
  }

  Map<String, dynamic> toMapWithId() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'materials': materials,
      'director': steps,
      'category': category,
      'difficulty': difficulty
    };
  }

  factory Tip.fromJson(dynamic json) {
    var movie = Tip(json['name'], json['description'], json['materials'],
        json['steps'], json['category'], json['difficulty']);
    movie.id = json['id'];

    return movie;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'materials': materials,
      'steps': steps,
      'category': category,
      'difficulty': difficulty
    };
  }
}
