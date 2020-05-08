import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'file:///C:/Users/Harshul%20C/AndroidStudioProjects/cloud_project/lib/firebase/todoFunction.dart';
import 'file:///C:/Users/Harshul%20C/AndroidStudioProjects/cloud_project/lib/firebase/function.dart';

String user;

class CheckList extends StatefulWidget {
  @override
  _CheckListState createState() => _CheckListState();
}
String text;
final _firebase = Firestore.instance;
class _CheckListState extends State<CheckList> {
  bool check1 = false;
  final todo =TextEditingController();

  makeAlertDialog(BuildContext context){
    return showDialog(
      context:context,
      builder:(context){
        return AlertDialog(
          title: Text('Todo'),
          backgroundColor: Colors.yellow[400],
          content: TextField(
              controller: todo,
              style:TextStyle(
                fontSize: 30,
              )
          ),
          actions: <Widget>[
            MaterialButton(
              child:Text('ADD'),
              onPressed: (){
                setState(() {
                  text=todo.text;
                  Navigator.of(context).pop();
                });
                TodoFireBase.addFireBase(text,false);
              },
            ),
          ],
        );
      },
    );
  }

  void getCurr() async{
    user = await FireBase.getCurrentUser();
    print(user);
  }
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurr();

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        backgroundColor: Colors.yellow,
        title: Text('Todolist',
          style:TextStyle(
            fontSize: 30,
            color: Colors.black,
          ),
        ),
      ),
      body:Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: Container(
                height:520,
                decoration: BoxDecoration(
                    color: Colors.yellow,
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20),bottomRight: Radius.circular(20),bottomLeft: Radius.circular(20))
                ),
                child: Column(
                  children: <Widget>[
                    TodoStream(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        child:Icon(Icons.add,
          color: Colors.white,
          size: 40,
        ),
        onPressed: (){
          makeAlertDialog(context);

        },
      ),
    );
  }
}
class TodoStream extends StatelessWidget {

  Widget build(BuildContext context) {
    Map User=ModalRoute.of(context).settings.arguments;
    String user =User['user'];
    return StreamBuilder<QuerySnapshot>(
      stream: _firebase.collection('$user-todo').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.lightBlueAccent,
            ),
          );
        }
        final messages = snapshot.data.documents;
        List<Todolist> CheckList = [];


        for (var message in messages) {
          final todo = message.data['todo'];
          final status=message.data['status'];
          final ID=message.documentID;
          final messageBubble = Todolist(
            status: status,
            todo: todo,
            user:user,
            ID: ID,
          );
          CheckList.add(messageBubble);
          //print(message['time']);
        }
        return Expanded(
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
            children: CheckList,
          ),
        );
      },
    );
  }
}


class Todolist extends StatelessWidget {
  Todolist({this.status, this.todo,this.user,this.ID});

  bool status;
  final todo;
  String user;
  final ID;


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Expanded(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Material(
            color: Colors.black,
            borderRadius: BorderRadius.circular(10),
            child: Row(
              children: <Widget>[
                Checkbox(
                  value:status,
                  checkColor: Colors.black,
                  activeColor: Colors.yellow,

                  onChanged: (value) async{
                    if(status==true){
                      status=false;
                    }
                    else
                      status=true;
                    print(ID);
                    print(status);
                    final user = await FireBase.getCurrentUser();
                    TodoFireBase.updateStatus(user,ID,status);
                  },
                ),
                Text('$todo',
                  style:TextStyle(
                    fontSize: 30,
                    color: Colors.white,
                  ),
                ),
                IconButton(
                  icon:Icon(Icons.delete),
                  color: Colors.yellow,
                  onPressed: ()async{
                    TodoFireBase.deleteTodo(user, ID);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}