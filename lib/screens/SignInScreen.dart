import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:fake_to_nahin/globals.dart' as globals;

import 'package:fake_to_nahin/models/UserModel.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path_provider/path_provider.dart';

class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final emailLoginController = TextEditingController();
  final passwordLoginController = TextEditingController();
  Directory dir;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView(
        children: <Widget>[
          Container(
            height: 300,
            decoration: BoxDecoration(
                image: DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage('assets/img/app.png'))),
          ),
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: <Widget>[
                IconButton(icon: Icon(Icons.person), onPressed: null),
                Expanded(
                    child: Container(
                        margin: EdgeInsets.only(right: 20, left: 10),
                        child: TextField(
                          controller: emailLoginController,
                          decoration: InputDecoration(hintText: 'Email'),
                        )))
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: <Widget>[
                IconButton(icon: Icon(Icons.lock), onPressed: null),
                Expanded(
                    child: Container(
                        margin: EdgeInsets.only(right: 20, left: 10),
                        child: TextField(
                          controller: passwordLoginController,
                          decoration: InputDecoration(hintText: 'Password'),
                          obscureText: true,
                        ))),
              ],
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: Container(
                height: 60,
                child: RaisedButton(
                  onPressed: () {
                    getData(emailLoginController.text).then((userDoc) => {
                          if (userDoc.data["password"] ==
                              passwordLoginController.text)
                            {onSuccess(userDoc.data)}
                          else
                            {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    content: Text("Password Incorrect"),
                                  );
                                },
                              )
                            }
                        });
                  },
                  color: Colors.lightBlue[800],
                  child: Text(
                    'SIGN IN',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          InkWell(
            onTap: () {
              Navigator.pushNamed(context, 'SignUp');
            },
            child: Center(
              child: RichText(
                text: TextSpan(
                    text: 'Don\'t have an account?',
                    style: TextStyle(color: Colors.black),
                    children: [
                      TextSpan(
                        text: 'SIGN UP',
                        style: TextStyle(
                            color: Colors.lightBlue[800],
                            fontWeight: FontWeight.bold,
                            fontSize: 22.0),
                      )
                    ]),
              ),
            ),
          )
        ],
      ),
    );
  }

  getData(String uid) async {
    final usersCollectionRef = Firestore.instance.collection("users");
    return usersCollectionRef.document(uid).get();
  }

  onSuccess(userDataMap) async {
    Directory dir = await getApplicationDocumentsDirectory();
    String path = dir.path + "current_user.json";

    File loggedInUserFile = new File(path);
    // print(userDataObj);
    loggedInUserFile.writeAsStringSync(jsonEncode(userDataMap));
    globals.currentUser = UserModel.fromObject(userDataMap);
    Navigator.pushReplacementNamed(context, 'Home');
  }
}

// return showDialog(
//   context: context,
//   builder: (context) {
//     return AlertDialog(
//       content: Text(currentUser.firstName),
//     );
//   },
// );
