
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import 'chat_screen.dart';
import 'package:flash_chat/screens/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/components/rounded_button.dart';
import 'package:flash_chat/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginScreen extends StatefulWidget {
  static String id = 'login_screen';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool spinner = false;
  final _auth = FirebaseAuth.instance;
  String email;
  String password;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: spinner,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Flexible(
                child: Hero(
                  tag: 'logo',
                  child: Container(
                    height: 250.0,
                    child: Image.asset('images/logo.png'),
                  ),
                ),
              ),
              SizedBox(
                height: 48.0,
              ),
              TextField(
                keyboardType: TextInputType.emailAddress,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  email = value;
                },
                decoration: KTextfieldstyle.copyWith(
                  hintText: 'Enter you email',
                )
              ),
              SizedBox(
                height: 8.0,
              ),
              TextField(
                  textAlign: TextAlign.center,
                  obscureText: true,
                  onChanged: (value) {
                  password = value;
                },
                decoration:  KTextfieldstyle.copyWith(
                  hintText: 'Enter you password',
                )
              ),
              SizedBox(
                height: 24.0,
              ),
              roundedbuttons(
                  'Log In', Colors.lightBlueAccent, () async {
                    setState((){
                      spinner = true;
                    });
               try {
                  final user = await _auth.signInWithEmailAndPassword(
                      email: email, password: password);
                  if (user != null) {
                    Navigator.pushNamed(context, ChatScreen.id);
                    setState((){
                      spinner = false;
                    });
                  }
                }
                catch(e){
                 print(e);
                }
              }),
            ],
          ),
        ),
      ),
    );
  }
}
