class Service {
  final String kod;
  final String name;
  final String active;
  final String del;
  final String price;

  Service({
    required this.kod,
    required this.name,
    required this.active,
    required this.del,
    required this.price,
  });

  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
      kod: json['Kod'] as String,
      name: json['Name'] as String,
      active: json['Active'] as String,
      del: json['Del'] as String,
      price: json['Price'] as String,
    );
  }
}
