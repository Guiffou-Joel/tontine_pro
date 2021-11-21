import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:tontine_pro/models/position.dart';
import 'package:tontine_pro/models/tontine_liste.dart';
import 'package:tontine_pro/result.dart';
import 'models/tontine.dart';

class Computer extends StatefulWidget {
  List<Tontine> tontines;
  int capital;
  int nextPosition;
  Computer(
      {required this.tontines,
      required this.capital,
      required this.nextPosition,
      Key? key})
      : super(key: key);

  @override
  _ComputerState createState() => _ComputerState();
}

class _ComputerState extends State<Computer> {
  @override
  void initState() {
    super.initState();

    String solution = computing();
    Timer(
      Duration(seconds: 5),
      () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) {
              return Result(solution: solution);
            },
          ),
        );
      },
    );
  }

  String computing() {
    String r =
        "Ne pas prendre de nouvelle position, vous pourrais vous retrouver avec un solde négatif";
    print(r);
    List<Map<String, dynamic>> mesListes = [];
    for (int i = 0; i < widget.tontines.length; i++) {
      Tontine ton = widget.tontines[i];
      for (int j = 0; j < ton.listes.length; j++) {
        TontineListe l = ton.listes[j];
        for (int k = 0; k < l.positions.length; k++) {
          if (l.positions[j] == Position.me) {
            mesListes.add({
              "liste": l,
              "tontine": ton.name,
              "cotisation": ton.cotisation,
              "done": false,
            });
          }
        }
      }
    }
    for (int i = widget.tontines.length - 1; i >= 0; i--) {
      Tontine tontine = widget.tontines[i];
      print("tontine $i : ${tontine.toJson()}");
      TontineListe liste = tontine.listes.last;
      print("derniere liste : ${liste.toJson()}");
      int nextFreePosition = 0;
      String listName = "'Nouvelle liste'";
      for (int j = 0; j < liste.positions.length; j++) {
        if (liste.positions[j] == Position.libre) {
          nextFreePosition = j;
          listName = liste.name;
          break;
        }
      }
      // if (nextFreePosition == 0) {
      //   nextFreePosition = 1;
      // }
      print("liste name $listName, nextFreePosition $nextFreePosition");
      int p = widget.nextPosition - 1;
      int? cap = widget.capital;
      List<Map<String, dynamic>> tmpListes = mesListes;
      bool end = true;
      for (int j = 0; j < tmpListes.length; j++) {
        Map<String, dynamic> l = tmpListes[j];
        if (l["done"] == false) {
          end = false;
        }
      }
      while (end == false) {
        for (int j = 0; j < tmpListes.length; j++) {
          Map<String, dynamic> l = tmpListes[j];
          if (l["done"] == false) {
            int n = l["liste"].next - 1;
            if (l["liste"].positions[n] == Position.other) {
              cap = (cap! - l["cotisation"]) as int?;
              print("cotisation, reste $cap");
            }
            if (l["liste"].positions[n] == Position.me) {
              cap = (cap! + (l["cotisation"] * 3)) as int?;
              print("gagnant, up to $cap");
            }
            n++;
            l["liste"].next++;
            if (n > nextFreePosition) {
              l["done"] = true;
            }
          }
        }
        end = true;
        for (int j = 0; j < tmpListes.length; j++) {
          Map<String, dynamic> l = tmpListes[j];
          if (l["done"] == false) {
            end = false;
          }
        }
      }
      if (cap! > 0) {
        print("capital positif, $cap");
        r = "Prenez la position ${nextFreePosition + 1} de la liste $listName de la tontine ${tontine.name}";
        break;
      }

      // while (p != nextFreePosition) {
      //   print("valeur de p: $p");
      //   for (int j = 0; j < widget.tontines.length; j++) {
      //     print("valeur de j: $j, tontine ${widget.tontines[j].name}");
      //     Tontine ton = widget.tontines[j];
      //     for (int k = 0; k < ton.listes.length; k++) {
      //       print("valeur de k: $k, liste ${ton.listes[k].name}");
      //       TontineListe l = ton.listes[k];
      //       bool present = false;
      //       for (int o = 0; o < l.positions.length; o++) {
      //         Position pos = l.positions[o];
      //         if (pos == Position.me) {
      //           present = true;
      //           break;
      //         }
      //       }
      //       if (present) {
      //         print("present");
      //         Position pos = l.positions[p];
      //         if (pos == Position.other) {
      //           cap = cap - ton.cotisation;
      //           print("cotisation, reste $cap");
      //         }
      //         if (pos == Position.me) {
      //           cap = cap + (ton.cotisation * 3);
      //           print("gagnat, up to $cap");
      //         }
      //       }
      //       cap = cap - (tontine.cotisation);
      //       print("tontinage, reste $cap");
      //     }
      //   }
      //   if (cap < 0) {
      //     print("capital négatif, $cap");
      //     break;
      //   }
      //   p = ((p + 1) % 4);
      // }
      // if (cap > 0) {
      //   print("capital positif, $cap");
      //   r = "Prenez la position ${nextFreePosition + 1} de la liste $listName de la tontine ${tontine.name}";
      //   break;
      // }
    }
    return r;
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("Calcul en cours")),
      ),
      body: SpinKitFadingCircle(
        size: height * width * 0.001,
        itemBuilder: (BuildContext context, int index) {
          return DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: index.isEven ? Colors.red : Colors.green,
            ),
          );
        },
      ),
    );
  }
}
