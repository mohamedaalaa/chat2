import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'message_bubble.dart';

class Messages extends StatelessWidget {
  const Messages({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final user=FirebaseAuth.instance.currentUser;
    return StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('chats')
                  .orderBy(
                'createdAt',
                descending: true,
              ).snapshots(),

              builder: (context, AsyncSnapshot<dynamic> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                final messages = snapshot.data.docs;
                print(FirebaseFirestore.instance.collection('users').where(messages[0]['userId'],isEqualTo: user!.uid));
                print(messages[0]['userId']==user.uid);
                print(messages[0]['userId']);
                print(messages[1]['userId']);
                return  ListView.builder(
                    reverse: true,
                    itemCount: messages.length,
                    itemBuilder: (_, i) {
                      return MessageBubble(message: messages[i]['text'],
                        isMe:messages[i]['userId']==user.uid);//messages[i]['usrId']==snapshot.data.uid,);
                    });
              },
            );

  }

}
