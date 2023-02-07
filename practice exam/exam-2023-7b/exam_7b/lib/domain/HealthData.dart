class HealthData {
  late int id;
  String date;
  String symptom;
  String medication;
  String dosage;
  String doctor;
  String notes;

  HealthData(this.date, this.symptom, this.medication, this.dosage, this.doctor,
      this.notes) {
    id = -1;
  }

  Map<String, dynamic> toMap() {
    return {
      'date': date,
      'symptom': symptom,
      'medication': medication,
      'dosage': dosage,
      'doctor': doctor,
      'notes': notes
    };
  }

  Map<String, dynamic> toMapWithId() {
    return {
      'id': id,
      'date': date,
      'symptom': symptom,
      'medication': medication,
      'dosage': dosage,
      'doctor': doctor,
      'notes': notes
    };
  }

  factory HealthData.fromJson(dynamic json) {
    var movie = HealthData(json['date'], json['symptom'], json['medication'],
        json['dosage'], json['doctor'], json['notes']);
    movie.id = json['id'];

    return movie;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date,
      'symptom': symptom,
      'medication': medication,
      'dosage': dosage,
      'doctor': doctor,
      'notes': notes
    };
  }
}