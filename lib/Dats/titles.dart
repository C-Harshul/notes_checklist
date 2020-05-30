
import 'package:path_provider/path_provider.dart';
import  'dart:io';
import'dart:async';
import 'file:///C:/Users/Harshul%20C/AndroidStudioProjects/cloud_project/lib/firebase/function.dart';

class Titles{

  static Future <String> getFilePath() async {
    try {
      Directory directory = await getApplicationDocumentsDirectory();
      print(directory);
      return directory.path;
    }catch(e){
      print('ERRRRRRROOOOOORRRR');
    }
  }
  static Future <File>  getFile() async{
    try {
      String user = await FireBase.getCurrentUser();
      String path = await getFilePath();
      if(user==null){
        user='OFFLINE';
        return File('$path/OFFLINE.txt');
      }
      else{
        return File('$path/$user.txt');
      }
     }catch(e){
      print('Error 1');
    }
  }
  static Future <File> saveToFile(String names) async{
    try{
      final file=await getFile();
      return file.writeAsString(names);
    }catch(e){
      print('Error');
      return null;
    }

  }
  static Future<String>readFromFile()async{
    try{
      final file=await getFile();
      String fileContent=await file.readAsString();
      return fileContent;
    }
    catch(e){
      print('ERROR');
      return null;
    }
  }
}

