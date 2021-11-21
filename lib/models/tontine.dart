import 'package:tontine_pro/models/tontine_liste.dart';

class Tontine {
  String name;
  int cotisation;
  List<TontineListe> listes;

  Tontine({required this.name, required this.cotisation, required this.listes});

  factory Tontine.fromJson(Map<String, dynamic> json) => Tontine(
        cotisation: json["cotisation"],
        name: json["name"],
        listes: List<TontineListe>.from(
          json["listes"].map(
            (x) => TontineListe.fromJson(x),
          ),
        ),
      );

  Map<String, dynamic> toJson() => {
        "cotisation": cotisation,
        "name": name,
        "listes": listes.map((x) => x.toJson()).toList(),
      };
}
