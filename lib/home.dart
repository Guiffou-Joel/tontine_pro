import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:tontine_pro/models/position.dart';
import 'package:tontine_pro/models/tontine.dart';
import 'package:tontine_pro/models/tontine_liste.dart';
import 'package:tontine_pro/seting.dart';
import 'package:tontine_pro/utils/database.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Tontine> tontines = [];
  late Database data;

  // @override
  // void initState(){
  //   super.initState();
  //   tontines
  // }

  String positionToString(Position p) {
    String r = "";
    if (p == Position.libre) r = "libre";
    if (p == Position.other) r = "occupée par un autre";
    if (p == Position.me) r = "occupée par moi";
    return r;
  }

  @override
  void initState() {
    super.initState();
    DatabaseFileRoutines.readTontines().then((String value) {
      print("String readTontines : $value");
      data = DatabaseFileRoutines.databaseFromJson(value);
      setState(() {
        tontines = data.tontines;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("Home")),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: <Widget>[
            // SizedBox(height: height * 0.05),
            Text(
              "Veuillez remplir les listes des tontines",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: height * width * 0.00008,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(height: height * 0.03),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: tontines.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(tontines[index].name,
                              style:
                                  TextStyle(fontSize: height * width * 0.0001)),
                          Text("${tontines[index].cotisation} par semaine"),
                          FlatButton(
                            onPressed: () async {
                              await addListeDialog(index);
                              setState(() {});
                            },
                            child: Row(
                              children: <Widget>[
                                Icon(
                                  Icons.add,
                                  color: Colors.blue,
                                  size: height * width * 0.00008,
                                ),
                                Text(
                                  "Nouvelle liste",
                                  style: TextStyle(
                                      color: Colors.blue,
                                      fontSize: height * width * 0.00005),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Container(
                        // margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        height: height * 0.33,
                        width: width * 0.95,
                        decoration: BoxDecoration(
                          // borderRadius: BorderRadius.circular(20),
                          border: Border(
                            bottom: BorderSide(width: 2),
                            top: BorderSide(width: 2),
                            left: BorderSide(width: 2),
                            right: BorderSide(width: 2),
                          ),
                        ),
                        child: ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemCount: tontines[index].listes.length,
                          itemBuilder: (context, i) {
                            TextStyle style = TextStyle(
                              fontSize: height * width * 0.000068,
                            );
                            print(
                                "Position 1: ${positionToString(tontines[index].listes[i].positions[0])}");
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 5, vertical: 10),
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 5, vertical: 10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border(
                                    bottom: BorderSide(width: 2),
                                    top: BorderSide(width: 2),
                                    left: BorderSide(width: 2),
                                    right: BorderSide(width: 2),
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      "Liste ${tontines[index].listes[i].name}",
                                      style: TextStyle(
                                        fontSize: height * width * 0.0001,
                                      ),
                                    ),
                                    Text(
                                      "Position 1: ${positionToString(tontines[index].listes[i].positions[0])}",
                                      style: style,
                                    ),
                                    Text(
                                      "Position 2: ${positionToString(tontines[index].listes[i].positions[1])}",
                                      style: style,
                                    ),
                                    Text(
                                      "Position 3: ${positionToString(tontines[index].listes[i].positions[2])}",
                                      style: style,
                                    ),
                                    Text(
                                      "Position 4: ${positionToString(tontines[index].listes[i].positions[3])}",
                                      style: style,
                                    ),
                                    Text(
                                        "Prochaine position gagnante : ${tontines[index].listes[i].next}"),
                                    Row(
                                      children: <Widget>[
                                        IconButton(
                                          onPressed: () async {
                                            await alterListeDialog(index, i);
                                            setState(() {});
                                          },
                                          icon: Icon(
                                            Icons.edit,
                                            color: Colors.green,
                                          ),
                                        ),
                                        IconButton(
                                          onPressed: () {
                                            setState(() {
                                              tontines[index]
                                                  .listes
                                                  .removeAt(i);
                                            });
                                          },
                                          icon: Icon(
                                            Icons.delete,
                                            color: Colors.red,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      FlatButton(
                        onPressed: () {
                          setState(() {
                            tontines.removeAt(index);
                          });
                        },
                        child: Row(
                          children: <Widget>[
                            Icon(
                              Icons.delete,
                              color: Colors.red,
                              size: height * width * 0.00008,
                            ),
                            Text(
                              "suprimer",
                              style: TextStyle(
                                  color: Colors.blue,
                                  fontSize: height * width * 0.00007),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                FlatButton(
                  onPressed: () async {
                    await addTonTineDialog();
                  },
                  child: Row(
                    children: <Widget>[
                      Icon(
                        Icons.add,
                        color: Colors.blue,
                        size: height * width * 0.00015,
                      ),
                      Text(
                        "ajouter une Tontine",
                        style: TextStyle(
                            color: Colors.blue,
                            fontSize: height * width * 0.00006),
                      ),
                    ],
                  ),
                ),
                RaisedButton(
                    color: Colors.blue,
                    onPressed: () {
                      data.tontines = tontines;
                      String st = DatabaseFileRoutines.databaseToJson(data);
                      DatabaseFileRoutines.writeTontines(st).then(
                        (value) => print("writen"),
                      );
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return Seting(tontines: tontines);
                          },
                        ),
                      );
                    },
                    child: Text("Continuer",
                        style: TextStyle(color: Colors.white))),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<Null> addTonTineDialog() {
    String name = "";
    int somme = 0;
    return showDialog(
      context: context,
      // barrierDismissible: true,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: Center(
            child: Text(
              "Nouvelle Tontine",
              style: TextStyle(color: Colors.orange),
            ),
          ),
          contentPadding: EdgeInsets.all(10.0),
          children: <Widget>[
            TextFormField(
              onChanged: (value) {
                name = value;
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Nom de la tontine",
                floatingLabelBehavior: FloatingLabelBehavior.always,
                // helperText: "help",
                // icon: icon,
                // prefixIcon:icon,
                // suffixIcon: icon
              ),
            ),
            SizedBox(height: 10),
            TextFormField(
              onChanged: (value) {
                somme = int.parse(value);
              },
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: "cotisation hebdomadaire",
                floatingLabelBehavior: FloatingLabelBehavior.always,
                // helperText: "help",
                // icon: icon,
                // prefixIcon:icon,
                // suffixIcon: icon
              ),
            ),
            FlatButton(
              color: Colors.blue,
              textColor: Colors.white,
              child: new Text('Add'),
              onPressed: () {
                if (name != "" && somme != 0) {
                  tontines
                      .add(Tontine(name: name, cotisation: somme, listes: []));
                }
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  Future<Null> addListeDialog(int index) {
    String name = "";
    List<Position> pos = [
      Position.libre,
      Position.libre,
      Position.libre,
      Position.libre,
    ];
    int next = 1;
    return showDialog(
      context: context,
      // barrierDismissible: true,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return SimpleDialog(
              title: Center(
                child: Text(
                  "Nouvelle Liste",
                  style: TextStyle(color: Colors.orange),
                ),
              ),
              contentPadding: EdgeInsets.all(10.0),
              children: <Widget>[
                TextFormField(
                  onChanged: (value) {
                    name = value;
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Nom de la liste",
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    // helperText: "help",
                    // icon: icon,
                    // prefixIcon:icon,
                    // suffixIcon: icon
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  "Sélectionnez l'état de chaque position de la liste",
                  textAlign: TextAlign.center,
                ),
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: 4,
                  itemBuilder: (context, i) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Text("Position ${i + 1}"),
                        DropdownButton<Position>(
                          value: pos[i],
                          items: <Position>[
                            Position.libre,
                            Position.me,
                            Position.other
                          ].map<DropdownMenuItem<Position>>((Position option) {
                            return DropdownMenuItem<Position>(
                              value: option,
                              child: Text(positionToString(option)),
                            );
                          }).toList(),
                          onChanged: (Position? value) {
                            setState(() {
                              pos[i] = value!;
                            });
                          },
                        ),
                      ],
                    );
                  },
                ),
                SizedBox(height: 10),
                Text(
                  "Sélectionnez La prochaine position gagnante de cette liste",
                  textAlign: TextAlign.center,
                ),
                DropdownButton<int>(
                  value: next,
                  items: <int>[
                    1,
                    2,
                    3,
                    4,
                  ].map<DropdownMenuItem<int>>((int option) {
                    return DropdownMenuItem<int>(
                      value: option,
                      child: Text(option.toString()),
                    );
                  }).toList(),
                  onChanged: (int? value) {
                    setState(() {
                      next = value!;
                    });
                  },
                ),
                FlatButton(
                  color: Colors.blue,
                  textColor: Colors.white,
                  child: new Text('Add'),
                  onPressed: () {
                    if (name != "") {
                      tontines[index].listes.add(
                            TontineListe(
                              name: name,
                              positions: pos,
                              next: next,
                            ),
                          );
                    }
                    Navigator.pop(context);
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<Null> alterListeDialog(int index, int i) {
    return showDialog(
      context: context,
      // barrierDismissible: true,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return SimpleDialog(
              title: Center(
                child: Text(
                  "Modifier la Liste ${tontines[index].listes[i].name}",
                  style: TextStyle(color: Colors.orange),
                ),
              ),
              contentPadding: EdgeInsets.all(10.0),
              children: <Widget>[
                Text(
                  "Sélectionnez l'état de chaque position de la liste",
                  textAlign: TextAlign.center,
                ),
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: 4,
                  itemBuilder: (context, j) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Text("Position ${i + 1}"),
                        DropdownButton<Position>(
                          value: tontines[index].listes[i].positions[j],
                          items: <Position>[
                            Position.libre,
                            Position.me,
                            Position.other
                          ].map<DropdownMenuItem<Position>>((Position option) {
                            return DropdownMenuItem<Position>(
                              value: option,
                              child: Text(positionToString(option)),
                            );
                          }).toList(),
                          onChanged: (Position? value) {
                            setState(() {
                              tontines[index].listes[i].positions[j] = value!;
                            });
                          },
                        ),
                      ],
                    );
                  },
                ),
                SizedBox(height: 10),
                Text(
                  "Sélectionnez La prochaine position gagnante de cette liste",
                  textAlign: TextAlign.center,
                ),
                DropdownButton<int>(
                  value: tontines[index].listes[i].next,
                  items: <int>[
                    1,
                    2,
                    3,
                    4,
                  ].map<DropdownMenuItem<int>>((int option) {
                    return DropdownMenuItem<int>(
                      value: option,
                      child: Text(option.toString()),
                    );
                  }).toList(),
                  onChanged: (int? value) {
                    setState(() {
                      tontines[index].listes[i].next = value!;
                    });
                  },
                ),
                FlatButton(
                  color: Colors.blue,
                  textColor: Colors.white,
                  child: new Text('Modifier'),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }
}
