
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class TodoFireBase {


  static Future<String> getCurrentUser() async{
    try{
      final user=await FirebaseAuth.instance.currentUser();
      if(user!=null)
        return user.email;
      else return 'OFFLINE';
    }
    catch(e){
      return 'OFFLINE';
    }
  }
  static void addFireBase(String Todo,bool Val)async{
    String currentUser = await getCurrentUser();
    Firestore.instance.collection('$currentUser-todo').add({
      'todo':Todo,
      'status':Val,
    });
  }
 static void updateStatus(user,ID,status){

    Firestore.instance.collection('$user-todo').document(ID).updateData({'status':status});
  }
 static void deleteTodo(user,ID){
   Firestore.instance.collection('$user-todo').document(ID).delete();
 }
}