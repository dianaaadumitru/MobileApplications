class Category {
  String name;

  Category(this.name);

  Map<String, dynamic> toMap() {
    return {'name': name};
  }

  factory Category.fromJson(dynamic json) {
    var genre = Category(json['name']);

    return genre;
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
    };
  }
}
