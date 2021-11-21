import 'package:flutter/material.dart';

class Result extends StatefulWidget {
  String solution;

  Result({required this.solution, Key? key}) : super(key: key);

  @override
  _ResultState createState() => _ResultState();
}

class _ResultState extends State<Result> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("Résultat")),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Text(
              "Bravo, nous avons trouvée une solution optimale pour vous !",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: height * width * 0.00007,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              widget.solution,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.green,
                fontSize: height * width * 0.0001,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
