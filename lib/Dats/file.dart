
import 'package:path_provider/path_provider.dart';
import  'dart:io';
import'dart:async';
import 'package:flutter/foundation.dart';
import 'package:cloudproject/firebase/function.dart';

class NoteFile {

  static Future <String> getFilePath() async {
    try {
      Directory directory = await getApplicationDocumentsDirectory();
      print(directory);
      return directory.path;
    } catch (e) {
      print('ERRRRRRROOOOOORRRR');
    }
  }

  static Future <File> getFile(String title) async {
    try {
      String path = await getFilePath();
      print(path);
      String user = await FireBase.getCurrentUser();
      return File('$path/$user-$title.txt');
    } catch (e) {
      print('Error 1');
    }
  }

  static Future <File> saveToFile(String data, String title) async {
    try {
      final file = await getFile(title);
      return file.writeAsString(data);
    } catch (e) {
      print('Error');
    }
  }

  static Future<String> readFromFile(String title) async {
    print(title);
    try {
      final file = await getFile(title);

      String fileContent = await file.readAsString();
      return fileContent;
    }
    catch (e) {
      print('Erroryvyv');
    }
  }

  static Future<void> deleteFile(String title) async {
    print(title);
    try {
      final file = await getFile(title);
      file.delete();
      print('$title Deleted');
    }
    catch (e) {
      print('Delete error');
    }
  }
}