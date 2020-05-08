import 'package:cloudproject/Pages/Authentication.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloudproject/Pages/Home.dart';
import 'package:cloudproject/Pages/disp.dart';

import 'package:cloudproject/Pages/Register.dart';
import 'package:cloudproject/Pages/login.dart';
import 'package:cloudproject/Pages/checklist.dart';
import 'package:provider/provider.dart';
import 'package:cloudproject/firebase/function.dart';

void main()=>runApp(NotesApp());
class NotesApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamProvider.value(
      value:FireBase.user,
      child: MaterialApp(
        home:CheckLogin(),
        routes:{
          '/dispcorr':(context)=>Home(),
          '/login':(context)=>Login(),
          '/disp':(context)=>Display(),
          '/register':(context)=>Register(),
          '/Auth':(context)=>Authenticate(),
          '/check':(context)=>CheckList(),
          // '/':(context)=>Authenticate(),

        },
      ),
    );
  }
}
class CheckLogin extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<FirebaseUser>(context);
    if(user!=null)
      return Home();
    else
      return Authenticate();
  }
}



