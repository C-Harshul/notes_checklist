import 'package:cloudproject/Dats/titles.dart';
import 'package:cloudproject/Dats/file.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';
class Disp extends StatefulWidget {
  @override
  _DispState createState() => _DispState();
}

class _DispState extends State<Disp> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();


  }
  void getCurrentUser() async{
    final user=await FirebaseAuth.instance.currentUser();
    currentUser = user.email;
    print(currentUser);
  }
  String currentUser;
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('$currentUser',
          style: TextStyle(
              color: Colors.black
          ),
        ),
        backgroundColor: Colors.yellow,
      ),
      body:Column(
        children: <Widget>[
          NoteStream(currentUser: currentUser,),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child:Icon(Icons.add,
          color: Colors.black,
        ),
        backgroundColor: Colors.yellow[500],
        onPressed:(){
          Navigator.pushNamed(context, '/disp',arguments:{
            'title':'-',
          });
        },
      ),
    );
  }
}
class NoteStream extends StatelessWidget {
  NoteStream({this.currentUser});

  List noteList = [];
  bool isPresent(String title) {
    return noteList.contains(title);
  }
  void getList() async{
    final names = await Titles.readFromFile();
    String ff='';
    for(int i =0 ;i<=names.length;++i){
      ff=ff+names[i];
      if(names[i]==' '){
        noteList.add(ff);
      }
    }
  }

  String currentUser;
  @override
  Widget build(BuildContext context) {

     return StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance.collection('$currentUser').snapshots(),
        // ignore: missing_return
        builder:(context,snapshot){
          List <NoteTiles> noteBox =[];
          if(snapshot.hasData!=null){
            final notes = snapshot.data.documents;

            for(var note in notes){
              final title = note.data['Title'];
              final Note = note.data['Note'];
              final NoteTile =NoteTiles(
                title:title,
                Note:Note,
              );
              getList();
              if(!isPresent(title))
                NoteFile.saveToFile(Note, title);
              noteBox.add(NoteTile);
            }
            return Expanded(
              child: ListView(
                children: noteBox,
              ),
            );
          }


        }
    );
  }
}
class NoteTiles extends StatelessWidget {
  NoteTiles({this.title,this.Note});
  String title;
  String Note;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(

          color: Colors.black,
          child:InkWell(
            child: Center(
              child: Text('$title',
                style: TextStyle(
                    fontSize: 30,
                    color:Colors.white
                ),
              ),
            ),
            onTap: (){
              Navigator.pushNamed(context, '/disp',arguments:{
                'title':'$title'
              }
              );
            },
          )
      ),
    );
  }
}

