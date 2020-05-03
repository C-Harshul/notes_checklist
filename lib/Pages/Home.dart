import 'package:flutter/material.dart';
import 'package:cloudproject/Dats/titles.dart';
import 'package:cloudproject/Dats/file.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloudproject/firebase/function.dart';
import 'package:firebase_auth/firebase_auth.dart';

//import 'package:animated_text_kit/animated_text_kit.dart';
final _firestore = Firestore.instance;
final _auth  = FirebaseAuth.instance;
class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String temp='';
  String Val='';
  String ttl='';
  List<String> filenm=[];
  List<String> filedel=[];
  String user;
  bool isPresent(String title) {
    return filenm.contains(title);
  }
  void gettitle()async{
    ttl=await Titles.readFromFile();
  }

  void noteStream()async{
    await for(var snapshot in _firestore.collection(user).snapshots()){
      for(var message in  snapshot.documents){
        final note=await NoteFile.readFromFile(message.data['Title']);
         if(!isPresent(message.data['Title'])){
           print(filenm);
           setState(() {
             filenm.add(message.data['Title']);
             NoteFile.saveToFile(message.data['Note'],message.data['Title']);
             gettitle();
             if(ttl==null)
               ttl=message.data['Title'];
             else
               ttl=ttl+' '+message.data['Title'];
             Titles.saveToFile(ttl);
           });
           if(message.data['Note']!=note){
             NoteFile.saveToFile(message.data['Note'], message.data['Title']);
             print('updated');
           }
         }
      }
    }
  }
  @override
  void deleteNote(String delnote) async{
    await Titles.readFromFile().then((names) {
      print(names);
      setState(() {
        Val= names;
        Val=Val+' ';
      });
    });
    for(int i=0;i<Val.length;++i){
      if(Val[i]==' ')
      {
        setState(() {
          filedel.add(temp);
          temp='';
        });
      }
      else{
        setState(() {
          temp=temp+Val[i];
        });
      }

    }

    filenm.remove(delnote);
    String del=filenm.join(' ');
    print (del);
    Titles.saveToFile(del);

  }
  void getTitle() async{
    await Titles.readFromFile().then((names) {
      print(names);
      setState(() {
        Val= names;
        Val=Val+' ';
      });
    });
    for(int i=0;i<Val.length;++i){
      if(Val[i]==' ')
      {
        setState(() {
          filenm.add(temp);
          temp='';
        });
      }
      else{
        setState(() {
          temp=temp+Val[i];
          }
        );
      }
    }
  }
 void getCurr()async{
    setState(() async{
      user =await FireBase.getCurrentUser();
    });
   print(user);
    if(user==null){
      setState(() {
        user='OFFLINE';
      });
    }
 }
 void firstStartCheck() async{
   String titles = await Titles.readFromFile();
   if(titles==null) {
     Titles.saveToFile('');
     NoteFile.saveToFile('', '');
   }
 }

  void initState() {

    super.initState();
    getCurr();
    getTitle();
    firstStartCheck();

  }
  Widget build(BuildContext context) {
    print(filenm);
    getCurr();
    firstStartCheck();
    noteStream();
    filenm.remove('');
    return Scaffold(
      backgroundColor: Colors.grey,
    appBar: AppBar(
       actions: <Widget>[
         IconButton(
          color: Colors.black,
          icon:Icon(Icons.close),
           onPressed: (){
            _auth.signOut();
            Navigator.popAndPushNamed(context, '/Auth');
           },
         ),
         IconButton(
           color:Colors.black,
           icon:Icon(Icons.check_box),
           onPressed:() async{
             final user = await FireBase.getCurrentUser();
              print(user);
            Navigator.pushNamed(context, '/check',arguments: {'user':user});
           }
         ),
       ],
      automaticallyImplyLeading: false,
     backgroundColor: Colors.yellow[600],
     title:Text(user==null?'OFFLINE':'$user',
     style:TextStyle(
       fontSize: 30,
       color:Colors.black,

      ),
     ),
      centerTitle:true,
    ),
    body:ListView.builder(

        itemCount:filenm.length,
        itemBuilder:(context, index)
     {

      return Padding(
        padding: const EdgeInsets.all(20.0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(20),

          ),
          child: Dismissible(
            background: Container(
              color: Colors.red,
              child:Row(
                children: <Widget>[
                  Icon(
                    Icons.delete,
                  ),
                  Text('Delete')
                ],
              )
            ),
            key: Key(filenm[index]),
            onDismissed: (Direction) async{

              deleteNote(filenm[index]);
              NoteFile.deleteFile(filenm[index]);
              int f=0;
              if(user!='OFFLINE') {
                await for (var snapshot in _firestore.collection(user)
                    .snapshots()) {
                  for (DocumentSnapshot message in snapshot.documents) {
                    if (message.data['Title'] == filenm[index]) {
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
            child: InkWell(
              onTap:(){
                String flag='';
                setState(() {
                  flag=filenm[index];
                });
                Navigator.popAndPushNamed(context, '/disp',arguments:{
                  'title':'$flag'
                  }
                );
             },
              child: Center(
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height:12,
                    ),
                    Text(filenm[index],
                          style: TextStyle(
                            fontSize: 30,
                            color: Colors.white
                           ),
                          ),
                    SizedBox(
                      height: 25,
                      width: 400,
                     )
                   ],
                 ),
               ),
             ),
           ),
         ),
      );
      },
    ),

      floatingActionButton: FloatingActionButton(
        child:Icon(Icons.add,
        color: Colors.black,
        ),
        backgroundColor: Colors.yellow[500],
        onPressed:(){
            Navigator.popAndPushNamed(context, '/disp',arguments:{
            'title':'-',
          });
        },
      ),
    );
  }
}


