import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:onlylogin/admin.dart';
import 'package:onlylogin/Profile.dart';
import 'package:onlylogin/signIn.dart';

// ignore: must_be_immutable
class UserManagement extends StatelessWidget {
  UserManagement({Key? key}) : super(key: key);
  User? user;
  var uid = FirebaseAuth.instance.currentUser?.uid;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          user = snapshot.data;

          Future getValue() async {
            var dataref = await FirebaseDatabase.instance.reference().once();

            if (user != null) {
              dataref.value['data'][uid]['role'] == 'admin'
                  ? Navigator.pushReplacement(
                      context, MaterialPageRoute(builder: (_) => Admin()))
                  : WidgetsBinding.instance!.addPostFrameCallback((_) {
                      Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (ctx) => Show()));
                    });
            } else
              WidgetsBinding.instance!.addPostFrameCallback((_) {
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (ctx) => Loginpage()));
              });
          }

          getValue();
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(
                color: Colors.black,
              ),
              // child: Text("Checking Authentication"),
            ),
          );
        });
  }
}
