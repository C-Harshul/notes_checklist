import 'dart:io';
import 'package:cloudproject/firebase/function.dart';
import 'package:flutter/material.dart';
import 'package:cloudproject/Dats/file.dart';
import 'package:cloudproject/Dats/titles.dart';
import 'package:path_provider/path_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
final _firestore = Firestore.instance;
String ttl = '';
String Val='';
String Flag='';
String nto = '';
String user;

class Display extends StatefulWidget {
  @override
  _DisplayState createState() => _DisplayState();
}
class _DisplayState extends State<Display> {

  final val = TextEditingController();
  void saveDat() async{
    print(Flag);
    await NoteFile.saveToFile(myController.text,Flag);
  }
  void noteUpStream()async{
    await for(var snapshot in _firestore.collection(user).snapshots()){
      for(var message in  snapshot.documents){
        final note=await NoteFile.readFromFile(Flag);
        if(message.data['Note']!=note){
          NoteFile.saveToFile(message.data['Note'], Flag);
          print('updated');
        }
      }
    }
  }
  void setTitle() async{
    await NoteFile.saveToFile(myController.text,val.text);
    await Titles.saveToFile(ttl);
  }
  void getCurr()async{
    user =await FireBase.getCurrentUser();

    if(user==null){
      user='OFFLINE';
    }
    print(user);

  }
  void hell()async{
    ttl=await Titles.readFromFile();
  }
  makeAlertDialog(BuildContext context){
    return showDialog(
        context:context,
        builder:(context){
          return  AlertDialog(
            backgroundColor: Colors.yellow,
            actions: <Widget>[

              FlatButton.icon(
                label: Text('Save in new file',
                  style: TextStyle(
                      fontSize: 25,
                      color: Colors.black
                  ),
                ),
                icon: Icon(Icons.save,
                  size:35,
                  color: Colors.black,
                ),
                onPressed: () {
                  hell();

                  setState(() {
                    createAlertDialog(context);
                   },
                  );
                  //Navigator.of(context).pop();
                },
              ),
              FlatButton.icon(
                  label: Text('Save',
                    style:TextStyle(
                      fontSize: 25,
                      color: Colors.black,
                    ),
                  ),
                  icon: Icon(Icons.save,
                    size:35,
                    color: Colors.black,
                  ),
                  onPressed: () async{
                    String ID;
                    int f=0;
                    saveDat();
                    if(user!='OFFLINE'){
                      await for(var snapshot in _firestore.collection(user).snapshots()){
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
                      print(ID);
                      Firestore.instance.collection(user).document(ID).updateData({'Note':myController.text});
                    }

                    Navigator.of(context).pop();
                  }),

              FlatButton.icon(
                label: Text('Home',
                  style:TextStyle(
                    fontSize: 25,
                    color: Colors.black
                  ),
                ),
                icon: Icon(Icons.home,
                  size:35,
                  color:Colors.black,
                ),
                onPressed: () {
                  //Navigator.of(context).pop();
                  Navigator.pushNamed(context, '/home',);
                },
              ),
            ],
          );
        }
    );
  }
  createAlertDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('File name:'),
          backgroundColor: Colors.yellow[400],
          content: TextField(
              controller: val,
              style:TextStyle(
                fontSize: 30,
              )
            ),
          actions: <Widget>[
            MaterialButton(
              child: Text('Submit',
                style:TextStyle(
                    color:Colors.blue,
                    fontSize: 20
                ),
              ),
              onPressed: () {
                setTitle();
                setState(()  {
                  Val = val.text;
                  if(ttl==null)
                    ttl=Val;
                  else
                    ttl=ttl+' '+Val;
                  Titles.saveToFile(ttl);
                  NoteFile.saveToFile(myController.text, Val);
                  if(user!='OFFLINE')
                  FireBase.addFireBase(myController.text,Val);
                },
                );
                Navigator.of(context).pop();

              },
            )
          ],
        );
      },
    );
  }
  void getData() async{
    print(Flag);
    await NoteFile.readFromFile(Flag).then((value) {

      setState(() {
        myController.text = value;
        nto = myController.text;
      });
      print(nto);
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurr();
    noteUpStream();
  }


  final myController = TextEditingController();

  Map Title={};
  int x=0;
  @override
  Widget build(BuildContext context) {
    if(user==null){
      setState(() {
        user='OFFLINE';
      });
    }
    noteUpStream();
    Title=Title.isNotEmpty?Title:ModalRoute.of(context).settings.arguments;
    setState(() {
      Flag=Title['title'];
    });
    if(x==0) {
      getData();
      x+=1;
    }

    return Scaffold(
      backgroundColor: Colors.grey[400],
      appBar:AppBar(
        automaticallyImplyLeading: false,
        title: Text('Edit your $Flag note',
          style:TextStyle(
            fontSize:25,
            color:Colors.black,
          ),
        ),
        actions: <Widget>[
          IconButton(
              icon:Icon(Icons.more_vert,
                color: Colors.black,
              ),
              onPressed:(){
                makeAlertDialog(context);
              }
          )
        ],
        backgroundColor: Colors.yellow[600],
      ) ,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[


            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: TextField(
                    style:TextStyle(
                      fontSize:30,
                    ),
                    controller: myController,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}