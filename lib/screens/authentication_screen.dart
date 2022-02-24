


import 'dart:io';

import 'package:chat2/widgets/auth_form.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage ;

class AuthenticationScreen extends StatefulWidget {
  const AuthenticationScreen({Key? key}) : super(key: key);

  @override
  _AuthenticationScreenState createState() => _AuthenticationScreenState();
}

class _AuthenticationScreenState extends State<AuthenticationScreen> {


  @override
  void initState() {
    Firebase.initializeApp();
    super.initState();
  }
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  void _submitUser(
      String email,
      String password,
      String userName,
      File image,
      bool isLogin,
      BuildContext ctx,
      ) async {

    try {
      if (isLogin) {

        await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email, password: password);

      } else {
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password);

        firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
            .ref()
            .child('user_image')
            .child(userCredential.user!.uid + '.jpg');

        await ref.putFile(image);

        final url= await ref.getDownloadURL();

        await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredential.user!.uid)
            .set({
          'userName': userName,
          'email': email,
          'image_url':url,
        }).then((value) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('user created with id=${userCredential.user!.uid}')));
        });
      }
    } on PlatformException catch (error) {
      var message = 'an error occurred please check your credentials';
      if (error.message != null) {
        message = error.message!;
      }
      ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(context).errorColor,
      ));
    } catch (error) {
      ScaffoldMessenger.of(ctx)
          .showSnackBar(SnackBar(content: Text(error.toString())));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        body:AuthForm(
          submitUser: _submitUser,
        ));
    /**/
  }
}