import 'package:flutter/material.dart';
import 'file:///C:/Users/Harshul%20C/AndroidStudioProjects/cloud_project/lib/Pages/Home.dart';
import 'file:///C:/Users/Harshul%20C/AndroidStudioProjects/cloud_project/lib/Pages/disp.dart';
import 'file:///C:/Users/Harshul%20C/AndroidStudioProjects/cloud_project/lib/Pages/Authentication.dart';
import 'file:///C:/Users/Harshul%20C/AndroidStudioProjects/cloud_project/lib/Pages/Register.dart';
import 'file:///C:/Users/Harshul%20C/AndroidStudioProjects/cloud_project/lib/Pages/login.dart';
import 'file:///C:/Users/Harshul%20C/AndroidStudioProjects/cloud_project/lib/Pages/checklist.dart';

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



