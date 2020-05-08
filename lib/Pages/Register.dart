import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'file:///C:/Users/Harshul%20C/AndroidStudioProjects/cloud_project/lib/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'file:///C:/Users/Harshul%20C/AndroidStudioProjects/cloud_project/lib/Dats/titles.dart';
import 'package:cloudproject/Dats/file.dart';
class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  String email;
  String password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
        backgroundColor: Colors.yellow,
        title: Center(
          child: Text(
            'Registration screen',
            style:TextStyle(
              fontSize:40,
              color:Colors.black,
            ),
          ),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[

          Hero(
            tag:'logo',
            child: Container(
              child:Image.asset('back/note.jpg'),
              height: 150,
            ),
          ),
          SizedBox(
            height: 60,
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: TextField(
              keyboardType: TextInputType.emailAddress,
              textAlign: TextAlign.center,
              onChanged: (value) {
                email = value;
              },
              decoration:
              kTextFieldDecoration.copyWith(hintText: 'Enter your email'),
            ),
          ),
          SizedBox(
            height: 8.0,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              obscureText: true,
              textAlign: TextAlign.center,
              onChanged: (value) {
                password = value;
              },
              decoration: kTextFieldDecoration.copyWith(
                  hintText: 'Enter your password'),
            ),
          ),
          SizedBox(
            height: 24.0,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: RaisedButton(
              color: Colors.yellow,
              child:Text(
                  'Register',
                  style:TextStyle(
                    fontSize:20,
                    color: Colors.black,
                  )
              ),
              onPressed: ()async{
                await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
                NoteFile.saveToFile('',email);
                Titles.saveToFile('');
                Navigator.pushNamed(context, '/home');
              },
            ),
          )
        ],
      ),
    );
  }
}