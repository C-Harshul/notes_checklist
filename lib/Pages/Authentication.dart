import 'package:flutter/material.dart';

class Authenticate extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        backgroundColor: Colors.yellow,
        title: Center(
          child: Text('HUB',
          style:TextStyle(
             fontSize:40,
             color: Colors.black,
            ),
          ),
        ),
      ),
      body:Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Hero(
            tag:'logo',
            child: Container(
              child:Image.asset('back/note.jpg'),
              height: 200,
            ),
          ),
          SizedBox(
            height: 60,
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: RaisedButton(
              color: Colors.yellow,
              child:Center(
                child: Text('Login',
                style:TextStyle(
                  fontSize:20,
                  color: Colors.black
                  ),
                ),
              ),
              onPressed: (){
                Navigator.pushNamed(context, '/login');
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: RaisedButton(
              color: Colors.yellow,
              onPressed: (){
                Navigator.pushNamed(context, '/register');
              },
              child:Center(
                child:Text('Register',
                style:TextStyle(
                   fontSize:20,
                  color: Colors.black
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: RaisedButton(
              color:Colors.yellow,
              onPressed: (){

                Navigator.popAndPushNamed(context, '/dispcorr');
              },
              child:Center(
                child:Text('Offline',
                  style:TextStyle(
                      fontSize:20,
                      color: Colors.black
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
