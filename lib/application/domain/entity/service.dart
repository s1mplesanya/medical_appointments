import 'dart:convert';

import 'package:hive/hive.dart';
part 'service.g.dart';

@HiveType(typeId: 2)
class Service extends HiveObject {
  @HiveField(0)
  final String kod;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final String active;
  @HiveField(3)
  final String del;
  @HiveField(4)
  final String price;

  Service({
    required this.kod,
    required this.name,
    required this.active,
    required this.del,
    required this.price,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'Kod': kod,
      'Name': name,
      'Active': active,
      'Del': del,
      'Price': price,
    };
  }

  factory Service.fromMap(Map<String, dynamic> map) {
    return Service(
      kod: map['Kod'] as String,
      name: map['Name'] as String,
      active: map['Active'] as String,
      del: map['Del'] as String,
      price: map['Price'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Service.fromJson(String source) =>
      Service.fromMap(json.decode(source) as Map<String, dynamic>);
}
