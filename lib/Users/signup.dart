// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:onlylogin/Login.dart';

class Signup extends StatefulWidget {
  Signup({Key? key}) : super(key: key);

  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  late String _phone, _name, _add, _email, _password;
  final fb = FirebaseDatabase.instance;
  final auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    // final ref = fb.reference().child("data");
    return Scaffold(
        appBar: AppBar(title: Text('SignUp')),
        body: SingleChildScrollView(
          child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Image.asset(
                    'assets/images/Web_Photo_Editor.jpg',
                    height: 100,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      keyboardType: TextInputType.name,
                      validator: (input) {
                        if (input!.isEmpty) {
                          return 'Please enter name';
                        }
                      },
                      onSaved: (input) => _name = input!.trim(),
                      decoration: InputDecoration(
                        hintText: 'Name',
                        enabledBorder: new OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      onChanged: (value) {
                        setState(() {
                          _name = value.trim();
                        });
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        hintText: 'Email',
                        enabledBorder: new OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      validator: (value) {
                        if (value!.isEmpty ||
                            !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                .hasMatch(value)) {
                          return 'Enter a valid email!';
                        }
                        return null;
                      },
                      onChanged: (input) {
                        setState(() {
                          _email = input.trim();
                        });
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      validator: (input) {
                        if (input!.isEmpty) {
                          return 'Please enter Mobile Number';
                        }
                        return null;
                      },
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        hintText: 'Enter Mobile Number',
                        enabledBorder: new OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      onChanged: (input) {
                        setState(() {
                          _phone = input.trim();
                        });
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: 'Password',
                        enabledBorder: new OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      validator: (input) {
                        if (input!.length < 6) {
                          return 'Password atleast 6 characters';
                        }
                      },
                      onChanged: (input) {
                        setState(() {
                          _password = input.trim();
                        });
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      validator: (input) {
                        if (input!.isEmpty) {
                          return 'Please enter Address';
                        }
                      },
                      keyboardType: TextInputType.name,
                      decoration: InputDecoration(
                        hintText: 'Address',
                        enabledBorder: new OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      onChanged: (input) {
                        setState(() {
                          _add = input.trim();
                        });
                      },
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: RaisedButton(
                            onPressed: () {
                              Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                      builder: (_) => Loginpage()));
                            },
                            textColor: Colors.white,
                            color: Colors.blueAccent,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                                side:
                                    BorderSide(color: Colors.black, width: 2)),
                            child: Text('SignIn')),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: RaisedButton(
                            // color: Theme.of(context).accentColor,
                            onPressed: validation,
                            textColor: Colors.black,
                            color: Colors.greenAccent,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                                side:
                                    BorderSide(color: Colors.black, width: 2)),
                            child: Text('SignUp')),
                      ),
                    ],
                  )
                ],
              )),
        ));
  }

  Future validation() async {
    final formState = _formKey.currentState;
    if (formState!.validate()) {
      // formState.save();
      final ref = fb.reference().child("data");
      await auth.createUserWithEmailAndPassword(
          email: _email, password: _password);

      User user = FirebaseAuth.instance.currentUser!;
      try {
        await ref.child(user.uid).set({
          // ignore: unnecessary_null_comparison
          "name": _name,
          "password": _password,
          "email": _email,
          "phone number": _phone,
          "address": _add,
        }).whenComplete(() {
          print("acount creation completed");
        });
        final scaffold = ScaffoldMessenger.of(context);
        scaffold.showSnackBar(
            SnackBar(content: Text('Account Successfully Created')));
      } finally {
        Navigator.of(context).pop();
      }
    }
  }
}
