import 'package:flash_chat/screens/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/components/rounded_button.dart';
import 'package:flash_chat/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'chat_screen.dart';


class RegistrationScreen extends StatefulWidget {
  static String id = 'registration_screen';

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
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
              Hero(
                tag: 'logo',
                child: Container(
                  height: 200.0,
                  child: Image.asset('images/logo.png'),
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
                  )),
              SizedBox(
                height: 8.0,
              ),
              TextField(
                obscureText: true,
                textAlign: TextAlign.center,
                  onChanged: (value) {
                    password = value;
                  },
                  decoration: KTextfieldstyle.copyWith(
                    hintText: 'Enter you password',
                  )),
              SizedBox(
                height: 24.0,
              ),
              roundedbuttons('Register', Colors.blue, () async {
                setState
                  ((){
                  spinner = true;
                });
                try {
                  final new_user = await _auth.createUserWithEmailAndPassword(
                      email: email, password: password);
                  if(new_user != null){
                    Navigator.pushNamed(context, ChatScreen.id);
                    setState
                      ((){
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
