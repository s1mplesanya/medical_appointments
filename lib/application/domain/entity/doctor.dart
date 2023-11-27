import 'dart:convert';

import 'package:hive/hive.dart';
part 'doctor.g.dart';

@HiveType(typeId: 1)
class Doctor extends HiveObject {
  @HiveField(0)
  final String kod;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final String filial;
  @HiveField(3)
  final String dolzhnost;
  @HiveField(4)
  final String img;
  @HiveField(5)
  final String active;
  @HiveField(6)
  final String del;
  Doctor({
    required this.kod,
    required this.name,
    required this.filial,
    required this.dolzhnost,
    required this.img,
    required this.active,
    required this.del,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'Kod': kod,
      'Name': name,
      'Filial': filial,
      'Dolzhnost': dolzhnost,
      'img': img,
      'Active': active,
      'Del': del,
    };
  }

  factory Doctor.fromMap(Map<String, dynamic> map) {
    return Doctor(
      kod: map['Kod'] as String,
      name: map['Name'] as String,
      filial: map['Filial'] as String,
      dolzhnost: map['Dolzhnost'] as String,
      img: map['img'] as String,
      active: map['Active'] as String,
      del: map['Del'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Doctor.fromJson(String source) =>
      Doctor.fromMap(json.decode(source) as Map<String, dynamic>);
}
