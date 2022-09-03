import 'package:flutter/material.dart';
import 'package:flash_chat/screens/welcome_screen.dart';
import 'package:flash_chat/screens/login_screen.dart';
import 'package:flash_chat/screens/registration_screen.dart';
import 'package:flash_chat/screens/chat_screen.dart';
import 'package:firebase_core/firebase_core.dart';


void main() async {

   try {
     WidgetsFlutterBinding.ensureInitialized();
     await Firebase.initializeApp(
       options: FirebaseOptions(
         apiKey: "AIzaSyBW5hUvDHYMtCWDMy7k_kefq3AgliVcvOo", // Your apiKey
         appId: "1:523380102874:android:839e4a5f7d9609bcc977e3", // Your appId
         messagingSenderId: "523380102874", // Your messagingSenderId
         projectId: "flash-chat-4910f", // Your projectId
       ),
     );
      runApp(FlashChat());
    }
    catch(e){
     print(e);
    }
}

class FlashChat extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: WelcomeScreen.id,
      routes: {
        WelcomeScreen.id: (context) => WelcomeScreen(),
        LoginScreen.id: (context) => LoginScreen(),
        RegistrationScreen.id: (context) => RegistrationScreen(),
        ChatScreen.id: (context) => ChatScreen(),
      },

    );
  }
}
