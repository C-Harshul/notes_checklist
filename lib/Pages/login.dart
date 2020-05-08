import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'file:///C:/Users/Harshul%20C/AndroidStudioProjects/cloud_project/lib/constants.dart';

import 'file:///C:/Users/Harshul%20C/AndroidStudioProjects/cloud_project/lib/Dats/titles.dart';
import 'package:cloudproject/Dats/file.dart';
import 'package:firebase_auth/firebase_auth.dart';
class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
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
            'Login Screen',
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
            padding: const EdgeInsets.fromLTRB(20,10,20,10),
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
            padding: const EdgeInsets.fromLTRB(20,10,20,10),
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
                  'login',
                  style:TextStyle(
                    fontSize:20,
                    color: Colors.black,
                  )
              ),
              onPressed: ()async{
                await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
                String titles = await Titles.readFromFile();
                if(titles==null) {
                  Titles.saveToFile('');
                  NoteFile.saveToFile('', '');
                }
                Navigator.popAndPushNamed(context, '/dispcorr');
              },
            ),
          )
        ],
      ),
    );
  }
}