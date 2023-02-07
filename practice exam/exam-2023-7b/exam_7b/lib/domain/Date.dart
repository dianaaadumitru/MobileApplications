class Date {
  String name;

  Date(this.name);

  Map<String, dynamic> toMap() {
    return {'name': name};
  }

  factory Date.fromJson(dynamic json) {
    var genre = Date(json['name']);

    return genre;
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
    };
  }
}