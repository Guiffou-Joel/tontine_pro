import 'package:tontine_pro/models/position.dart';

class TontineListe {
  String name;
  List<Position> positions;
  int next;

  TontineListe(
      {required this.name, required this.positions, required this.next});

  factory TontineListe.fromJson(Map<String, dynamic> json) => TontineListe(
        name: json["name"],
        positions: List<Position>.from(
          json["positions"].map(
            (x) {
              if (x == 0) return Position.libre;
              if (x == 1) return Position.me;
              if (x == 2) return Position.other;
            },
          ),
        ),
        next: json["next"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "positions": positions.map(
          (x) {
            if (x == Position.libre) return 0;
            if (x == Position.me) return 1;
            if (x == Position.other) return 2;
          },
        ).toList(),
        "next": next,
      };
}
