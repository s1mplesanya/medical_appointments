class Doctor {
  final String kod;
  final String name;
  final String filial;
  final String dolzhnost;
  final String img;
  final String active;
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

  factory Doctor.fromJson(Map<String, dynamic> json) {
    return Doctor(
      kod: json['Kod'] as String,
      name: json['Name'] as String,
      filial: json['Filial'] as String,
      dolzhnost: json['Dolzhnost'] as String,
      img: json['img'] as String,
      active: json['Active'] as String,
      del: json['Del'] as String,
    );
  }
}
