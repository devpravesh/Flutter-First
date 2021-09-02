import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:onlylogin/Admin/All_User_Details.dart';
import 'package:onlylogin/Users/Profile.dart';

import 'dart:async';

import 'package:onlylogin/Users/signup.dart';

// import 'package:onlylogin/signUp.dart';

class Loginpage extends StatefulWidget {
  @override
  _LoginpageState createState() => _LoginpageState();
}

class _LoginpageState extends State<Loginpage> {
  late String _email, _password;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Sign In')),
      ),
      body: SingleChildScrollView(
        child: Form(
            key: _formKey,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image.network(
                    "https://i.pinimg.com/originals/14/4b/dd/144bdd2ab3aca50af01ea92119fdda33.png",
                    height: 260,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      validator: (input) {
                        if (input!.isEmpty) {
                          return 'Please Enter Your Email';
                        }
                      },
                      onSaved: (input) => _email = input!,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        enabledBorder: new OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      validator: (input) {
                        if (input!.length < 6) {
                          return 'Please Enter Valid Password';
                        }
                      },
                      onSaved: (input) => _password = input!,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        enabledBorder: new OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      obscureText: true,
                    ),
                  ),
                  // ignore: deprecated_member_use
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        // ignore: deprecated_member_use
                        RaisedButton(
                          onPressed: signIn,
                          child: Text('Login'),
                          textColor: Colors.white,
                          color: Colors.blueAccent,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                              side: BorderSide(color: Colors.black, width: 2)),
                        ),
                        // ignore: deprecated_member_use
                        RaisedButton(
                          onPressed: () {
                            Navigator.of(context).push(
                                MaterialPageRoute(builder: (_) => Signup()));
                          },
                          textColor: Colors.white,
                          color: Colors.blueAccent,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                              side: BorderSide(color: Colors.black, width: 2)),
                          child: Text('Click To SignUp'),
                        ),
                      ],
                    ),
                  ),
                ])),
      ),
    );
  }

  Future<void> signIn() async {
    final formState = _formKey.currentState;
    if (formState!.validate()) {
      formState.save();
      await Firebase.initializeApp();
      var dataref = await FirebaseDatabase.instance.reference().once();

      try {
        // ignore: unused_local_variable
        UserCredential user = await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: _email, password: _password);

        var uid = FirebaseAuth.instance.currentUser!.uid;
        if (dataref.value['data'][uid]['role'] == 'admin') {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (_) => Admin()));
        } else
          Navigator.of(context)
              .pushReplacement(MaterialPageRoute(builder: (ctx) => Show()));

        Center(child: CircularProgressIndicator());
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          print('No user found for that email.');
          final scaffold = ScaffoldMessenger.of(context);
          scaffold.showSnackBar(
              SnackBar(content: Text("No User Found For That Email")));
        } else if (e.code == 'wrong-password') {
          final scaffold = ScaffoldMessenger.of(context);
          scaffold.showSnackBar(SnackBar(content: Text("Wrong Password")));
          print('Wrong password provided for that user.');
        }
      }
    }
  }
}
