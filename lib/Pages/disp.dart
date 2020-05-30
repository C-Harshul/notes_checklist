
import 'package:cloudproject/firebase/function.dart';
import 'package:flutter/material.dart';
import 'package:cloudproject/Dats/file.dart';
import 'package:cloudproject/Dats/titles.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
final _firestore = Firestore.instance;
String ttl = '';
String Val='';
String Flag='';
String nto = '';
String user;
String changeCheck = '';
class Display extends StatefulWidget {
  @override
  _DisplayState createState() => _DisplayState();
}
class _DisplayState extends State<Display> {

  final val = TextEditingController();


//  void setTitle() async{
//    await NoteFile.saveToFile(myController.text,myTitle.text);
//    await Titles.saveToFile(ttl);
//  }
  void getCurr()async{
    user =await FireBase.getCurrentUser();

    if(user==null){
      user='OFFLINE';
    }
    print(user);

  }
  Future<void> hell()async{
    ttl=await Titles.readFromFile();
  }


  void getData() async{
    print(Flag);
    await NoteFile.readFromFile(Flag).then((value) {

      setState(() {

        if(Flag!='-') {
          myController.text = value;
          myTitle.text = Flag;
        }
        changeCheck = value;
      });
      print(nto);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurr();

  }
  void saveDat() async{
    print(Flag);
    print(myController.text);
    await NoteFile.saveToFile(myController.text,Flag);
  }
  void noteUpStream(String Flag)async {
    await for (var snapshot in _firestore.collection(user).snapshots()) {
      for (var message in snapshot.documents) {
        final note = await NoteFile.readFromFile(Flag);
        if (myController.text != note) {
          NoteFile.saveToFile(myController.text, Flag);
          print('updated');
        }
      }
    }
  }
  createAlertDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Do you want to save the changes'),
          backgroundColor: Colors.yellow[400],
          actions: <Widget>[
            FlatButton(
              child: Text('Yes'),
              onPressed: () async{
                if(Flag=='-'){
                  await hell();
                  print(ttl);

                  setState((){
                    Val = myTitle.text;
                    if(ttl==null)
                      ttl=Val;
                    else
                      ttl=ttl+'^'+Val;
                     Titles.saveToFile(ttl);
                     NoteFile.saveToFile(myController.text, Val);
                    if(user!='OFFLINE')
                      FireBase.addFireBase(myController.text,Val);
                    },
                  );
                  Navigator.of(context).pop();
                }
                else{
                  String ID;
                  int f = 0;
                  print(myController.text);
                  print(myTitle.text);
                  saveDat();
                  if (user != 'OFFLINE') {
                    await for (var snapshot in _firestore.collection(user)
                        .snapshots()) {
                      for (DocumentSnapshot message in snapshot.documents) {
                        if (message.data['Title'] == Flag) {
                          ID = message.documentID;
                          f = 1;
                        }
                        if (f == 1)
                          break;
                      }
                      if (f == 1)
                        break;
                    }
                    print(ID+"-----------------------------------------------");
                    Firestore.instance.collection(user).document(ID).updateData(
                        {'Note': myController.text});
                  }
                  noteUpStream(Flag);
                  Navigator.of(context).pop();

                }

              },
            ),
            FlatButton(
              child:Text('No'),
              onPressed: (){
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  final myController = TextEditingController();
  final myTitle = TextEditingController();

  Map Title={};
  int x=0;
  @override
  Widget build(BuildContext context) {
    if (user == null) {
      setState(() {
        user = 'OFFLINE';
      });
    }

    Title = Title.isNotEmpty ? Title : ModalRoute
        .of(context)
        .settings
        .arguments;
    setState(() {
      Flag = Title['title'];
    });
    if (x == 0) {
      getData();
      x += 1;
    }
    return Scaffold(
      backgroundColor: Colors.grey[400],
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            color: Colors.black,
            onPressed: () async {
              if (myController.text != changeCheck && myTitle.text != '') {
                await createAlertDialog(context);
              }
              if(user=="OFFLINE")
                Navigator.popAndPushNamed(context, "/OfflineHome");
              else
                Navigator.of(context).pop();
            }
        ),
        automaticallyImplyLeading: false,
        title: Text('Edit your $Flag note',
          style: TextStyle(
            fontSize: 25,
            color: Colors.black,
          ),
        ),

        backgroundColor: Colors.yellow[600],
      ),
      body: WillPopScope(
        // ignore: missing_return
        onWillPop: () async {
          if (myController.text != changeCheck && myTitle.text != '') {
            print(myController.text);
            await createAlertDialog(context);
          }
          Navigator.pop(context);
        },
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: TextField(
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                          hintText: 'Title',
                          border: InputBorder.none,
                          hintStyle: TextStyle(
                            color: Colors.grey,
                          )
                      ),
                      style: TextStyle(
                        fontSize: 30,
                        color: Colors.white,
                      ),
                      controller: myTitle,
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                    ),
                  ),
                ),
              ),

              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.yellow,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: TextField(
                          decoration:InputDecoration(
                            border:InputBorder.none
                          ),
                          style: TextStyle(
                            fontSize: 30,
                          ),
                          controller: myController,
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
