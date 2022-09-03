import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// ignore_for_file: prefer_const_constructors
final _firebase = FirebaseFirestore.instance;
User loggedinuser;



class ChatScreen extends StatefulWidget {
  static String id = 'chat_screen';

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final messagetextcontroller = TextEditingController();
  String messagetext;
  final _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    getcurrentuser();
  }

  void getcurrentuser() async {
    try {
      var user = await _auth.currentUser;
      if (user != null) {
        loggedinuser = user;
        print(loggedinuser.email);
      }
    }
    catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                _auth.signOut();
                Navigator.pop(context);
              }),
        ],
        title: Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(child: messagestream()),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: messagetextcontroller,
                      onChanged: (value) {
                        messagetext = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  FlatButton(
                    onPressed: () {
                      messagetextcontroller.clear();
                      _firebase.collection('messages').add({
                        'text': messagetext,
                        'sender': loggedinuser.email,
                          'timestamp': FieldValue.serverTimestamp(),
                      });
                    },
                    child: Text(
                      'Send',
                      style: kSendButtonTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class messagestream extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(

        stream: _firebase.collection('messages').orderBy('timestamp',descending: true).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.blue,
              ),
            );
          }
          final messages = snapshot.data.docs;
          List<messagebubble> messageWidget = [];
          for (var message in messages) {
            final messagetext = message['text'];
            final messagesender = message['sender'];
            final time = message['timestamp'];

            final currentuser = loggedinuser.email;

            final messagebubbles = messagebubble(
                messagetext, messagesender, currentuser == messagesender, time);
            messageWidget.add(messagebubbles);
            //   try {
            //     messageWidget.sort((a, b) =>
            //         DateTime.parse(b.time).compareTo(DateTime.parse(a.time)));
            //   }
            //   catch(e){
            //     print(e);
            //   }
            }
            return Expanded(
              child: ListView(
                reverse: true,
                padding: EdgeInsets.symmetric(
                    horizontal: 30, vertical: 20),
                children:
                messageWidget,


              ),
            );
          }
    );
  }
}


class messagebubble extends StatelessWidget {
  messagebubble(this.text, this.sender,this.isme,this.time);

  final String text;
  final String sender;
  final bool isme;
  final Timestamp time;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:  EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: isme? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(sender,
          style: TextStyle(
            color: Colors.grey,
            fontSize: 11
          ),
          ),
          Padding(
            padding:  EdgeInsets.symmetric(horizontal: 0, vertical: 3),
            child: Material(
              elevation: 5,
              borderRadius: isme? BorderRadius.only(topLeft: Radius.circular(30) ,bottomLeft: Radius.circular(30),bottomRight: Radius.circular(30)) :
              BorderRadius.only(topRight: Radius.circular(30) ,bottomLeft: Radius.circular(30),bottomRight: Radius.circular(30)),
              color: isme? Colors.lightBlue : Colors.white,
                child: Padding(
                  padding:  EdgeInsets.symmetric(horizontal: 25,vertical: 10),
                  child: Text('$text',
                    style: TextStyle(
                        fontSize: 17,
                      color: isme? Colors.white : Colors.black,
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
