class Genre {
  String name;

  Genre(this.name);

  Map<String, dynamic> toMap() {
    return {'name': name};
  }

  factory Genre.fromJson(dynamic json) {
    var genre = Genre(json['name']);

    return genre;
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
    };
  }
}
