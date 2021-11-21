import 'package:flutter/material.dart';
import 'package:tontine_pro/computer.dart';
import 'package:tontine_pro/models/tontine.dart';

class Seting extends StatefulWidget {
  List<Tontine> tontines;

  Seting({required this.tontines, Key? key}) : super(key: key);

  @override
  _SetingState createState() => _SetingState();
}

class _SetingState extends State<Seting> {
  int capital = 0;
  int nextPosition = 1;
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("Informations")),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            children: <Widget>[
              Text(
                "Veuillez remplir les informations suivantes",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: height * width * 0.00008,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(height: height * 0.1),
              TextFormField(
                onChanged: (value) {
                  capital = int.parse(value);
                },
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Votre capital",
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  // helperText: "help",
                  // icon: icon,
                  // prefixIcon:icon,
                  // suffixIcon: icon
                ),
              ),
              SizedBox(height: height * 0.1),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceAround,
              //   children: <Widget>[
              //     Text(
              //       "Prochaine position gagnante",
              //       style: TextStyle(fontSize: height * width * 0.00007),
              //     ),
              //     DropdownButton<int>(
              //       value: nextPosition,
              //       items: <int>[1, 2, 3, 4]
              //           .map<DropdownMenuItem<int>>((int option) {
              //         return DropdownMenuItem<int>(
              //           value: option,
              //           child: Text("Position ${option}"),
              //         );
              //       }).toList(),
              //       onChanged: (int? value) {
              //         setState(() {
              //           nextPosition = value!;
              //         });
              //       },
              //     ),
              //   ],
              // ),
              SizedBox(height: height * 0.2),
              RaisedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return Computer(
                          tontines: widget.tontines,
                          capital: capital,
                          nextPosition: nextPosition,
                        );
                      },
                    ),
                  );
                },
                color: Colors.blue,
                child: Text("Compute", style: TextStyle(color: Colors.white)),
              )
            ],
          ),
        ),
      ),
    );
  }
}
