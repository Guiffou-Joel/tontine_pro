import 'package:path_provider/path_provider.dart'; // Filesystem locations
import 'dart:io'; // Used by File
import 'dart:convert';

import 'package:tontine_pro/models/tontine.dart'; // Used by json

class DatabaseFileRoutines {
  static Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  static Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/local_persistence.json');
  }

  static Future<String> readTontines() async {
    try {
      final file = await _localFile;
      if (!file.existsSync()) {
        print("File does not Exist: ${file.absolute}");
        await writeTontines('{"tontines": []}');
      }
      // Read the file
      String contents = await file.readAsString();
      return contents;
    } catch (e) {
      print("error readTontiness: $e");
      return "";
    }
  }

  static Future<File> writeTontines(String json) async {
    final file = await _localFile;
    // Write the file
    return file.writeAsString('$json');
  }

  // To read and parse from JSON data - databaseFromJson(jsonString);
  static Database databaseFromJson(String str) {
    final dataFromJson = json.decode(str);
    return Database.fromJson(dataFromJson);
  }

  // To save and parse to JSON Data - databaseToJson(jsonString);
  static String databaseToJson(Database data) {
    final dataToJson = data.toJson();
    return json.encode(dataToJson);
  }
}

class Database {
  List<Tontine> tontines;

  Database({
    required this.tontines,
  });

  factory Database.fromJson(Map<String, dynamic> json) => Database(
        tontines: List<Tontine>.from(
          json["tontines"].map(
            (x) => Tontine.fromJson(x),
          ),
        ),
      );

  Map<String, dynamic> toJson() => {
        "tontines": List<dynamic>.from(
          tontines.map(
            (x) => x.toJson(),
          ),
        ),
      };
}
