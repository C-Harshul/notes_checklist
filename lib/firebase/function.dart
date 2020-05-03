import 'file:///C:/Users/Harshul%20C/AndroidStudioProjects/cloud_project/lib/Pages/disp.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class FireBase {


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
  static void addFireBase(String noteText,String Val)async{
    String currentUser = await getCurrentUser();
    Firestore.instance.collection(currentUser).add({
      'Note':noteText,
      'Title':Val,
    });
  }
  static void updateFireBase(String noteText)async{
    String ID;
    int f=0;
    String currUser = await getCurrentUser();
    await for(var snapshot in Firestore.instance.collection(currUser).snapshots()){
      for(DocumentSnapshot message in snapshot.documents){
        if(message.data['Title']==Flag){
          ID=message.documentID;
          f=1;
        }
        if(f==1)
          break;
      }
      if(f==1)
        break;
    }

    Firestore.instance.collection('$currUser').document(ID).updateData({'Note':noteText});
  }
}