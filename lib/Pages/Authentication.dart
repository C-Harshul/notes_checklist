
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cloudproject/components/Rounded_Button.dart';
class Authenticate extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      body:Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Row(

            children: <Widget>[
              Center(
                child: Hero(
                  tag:'logo',
                  child: Container(
                    child:Padding(
                      padding: const EdgeInsets.fromLTRB(40,0,0,0),
                      child: Image.asset('back/note.jpg'),
                    ),
                    height: 100,
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0,0,10,0),
                  child: TypewriterAnimatedTextKit(
                    text: ['Notes_App'
                    ],
                    alignment: AlignmentDirectional.topStart,
                    textStyle: TextStyle(
                      fontFamily: 'Caveat',
                      fontSize: 52,
                      color: Colors.black,
                    ),
                  ),
                ),
              )
            ],
          ),
          SizedBox(
            height: 60,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(15,0,15,0),
            child: RoundedButton(
              colour: Colors.yellow,
              title: 'Login',
              onPressed: (){
                Navigator.pushNamed(context, '/login');
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(15,0,15,0),
            child: RoundedButton(
              colour: Colors.yellow,
              title:'Register',
              onPressed: (){
                Navigator.pushNamed(context, '/register');
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(15,0,15,0),
            child: RoundedButton(
              title: 'Offline',
              colour:Colors.yellow,
              onPressed: (){
                Navigator.pushNamed(context, '/OfflineHome');
              },
            ),
          ),
        ],
      ),
    );
  }
}
