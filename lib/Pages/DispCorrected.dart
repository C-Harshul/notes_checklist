import 'package:cloudproject/Dats/titles.dart';
import 'package:cloudproject/Dats/file.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloudproject/firebase/function.dart';
import 'package:firebase_auth/firebase_auth.dart';
class Disp extends StatefulWidget {
  @override
  _DispState createState() => _DispState();
}

class _DispState extends State<Disp> {

  @override

  void getCurrentUser() async{
    final user=await FirebaseAuth.instance.currentUser();
    currentUser = user.email;
    print(currentUser);
  }
  String currentUser;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentUser();
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text('🗒 Notes',
          style: TextStyle(
              fontFamily: 'Caveat',
              color: Colors.black,
               fontSize: 40,
          ),
        ),
        actions: <Widget>[
          IconButton(
            color: Colors.black,
            icon: Icon(Icons.backspace),
            onPressed: () {
              FirebaseAuth.instance.signOut();
              Navigator.popAndPushNamed(context,'/Auth');
            },
          ),
          IconButton(
              color: Colors.black,
              icon: Icon(Icons.check_box),
              onPressed: () async {
                final user = await FireBase.getCurrentUser();
                print(user);
                if (user == 'OFFLINE') {
                  Navigator.popAndPushNamed(context, '/Auth');
                } else
                  Navigator.pushNamed(
                      context, '/check', arguments: {'user': user});
              }
          ),
        ],
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
  Future<String> getCurrentUser() async{
    final user=await FirebaseAuth.instance.currentUser();
    if(user==null)
      currentUser="OFFLINE";
    else
      currentUser = user.email;
    return currentUser;
  }
  String currentUser;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
        future: getCurrentUser(),
        builder: (context, AsyncSnapshot<String> snapshot) {
          if (snapshot.hasData) {
            return StreamBuilder<QuerySnapshot>(
                stream: Firestore.instance.collection('$currentUser').snapshots(),
                // ignore: missing_return
                builder:(context,snapshot){
                  List <NoteTiles> noteBox =[];
                  if(snapshot.data!=null){
                    final notes = snapshot.data.documents;
                    for(var note in notes){
                      final title = note.data['Title'];
                      final Note = note.data['Note'];
                      final NoteTile =NoteTiles(
                        title:title,
                        Note:Note,
                        user:currentUser,
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
                  else
                  if(snapshot.data == null) return CircularProgressIndicator();
                }
            );
          }
          else {
            return CircularProgressIndicator();
          }
        }
    );
  }
}
class NoteTiles extends StatelessWidget {
  NoteTiles({this.title,this.Note,this.user});
  String title;
  String Note;
  String user;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Dismissible(
        background: Container(
            color: Colors.red,
            child: Row(
              children: <Widget>[
                Icon(
                  Icons.delete,
                ),
                Text('Delete')
              ],
            )
        ),
        key: Key(title),
        onDismissed: (Direction) async {
          NoteFile.deleteFile(title);
          int f = 0;
          if (user != 'OFFLINE') {
            await for (var snapshot in Firestore.instance.collection(user).snapshots()) {
              for (DocumentSnapshot message in snapshot.documents) {
                if (message.data['Title'] == title) {
                  message.reference.delete();
                  f = 1;
                }
                if (f == 1)
                  break;
              }
              if (f == 1)
                break;
            }
          }
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Colors.black,
          ),

            child:Padding(
              padding: const EdgeInsets.all(15.0),
              child: InkWell(
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
              ),
            )
        ),
      ),
    );
  }
}

