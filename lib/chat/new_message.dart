import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NewMessage extends StatefulWidget {
  const NewMessage({Key? key}) : super(key: key);

  @override
  _NewMessageState createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  var _enteredMessage = '';
  final _controller= TextEditingController();

  void _sendMessage()async{
    FocusScope.of(context).unfocus();
    final user=FirebaseAuth.instance.currentUser;
    final userData=FirebaseFirestore.instance.collection('users').doc(user!.uid);
    FirebaseFirestore.instance.collection('chats').add({
      'text':_enteredMessage,
      'createdAt':Timestamp.now(),
      'userId':user.uid,
      //'username':FirebaseFirestore.instance.collection('users').where('uid', isEqualTo: uid)
    });
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
            child: TextField(
              controller: _controller,
              decoration: const InputDecoration(labelText: 'write a message'),
              onChanged: (value){
                setState(() {
                  _enteredMessage=value;
                });
              },
            )),
        IconButton(onPressed:_enteredMessage.trim().isEmpty?null:_sendMessage,
            icon: const Icon(Icons.send))
      ],
    );
  }
}