import 'package:flutter/material.dart';
import 'file:///C:/Users/Harshul%20C/AndroidStudioProjects/cloud_project/lib/Pages/Home.dart';
import 'file:///C:/Users/Harshul%20C/AndroidStudioProjects/cloud_project/lib/Pages/disp.dart';
import 'package:cloudproject/Pages/Authentication.dart';
import 'package:cloudproject/Pages/Register.dart';
import 'package:cloudproject/Pages/login.dart';
import 'package:cloudproject/Pages/checklist.dart';
import 'package:firebase_auth/firebase_auth.dart';
void main() {

  runApp(MaterialApp(

    initialRoute: '/home',

    routes:{
        '/login':(context)=>Login(),
        '/home':(context)=>Home(),
        '/disp':(context)=>Display(),
        '/register':(context)=>Register(),
        '/Auth':(context)=>Authenticate(),
        '/check':(context)=>CheckList(),
       // '/':(context)=>Authenticate(),
    },
   ),
  );

}



