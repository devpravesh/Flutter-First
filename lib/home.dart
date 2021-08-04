import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:onlylogin/signIn.dart';

class Home extends StatefulWidget {
  const Home({Key? key, required this.user}) : super(key: key);
  final UserCredential user;

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final fb = FirebaseDatabase.instance;
  String name = "abc";
  var uid = FirebaseAuth.instance.currentUser!.uid;
  // final myController = new TextEditingController();
  TextEditingController myController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    final ref = fb.reference().child("data").child(uid);
    return Scaffold(
        appBar: AppBar(
          title: Text('Home ${widget.user.user!.email}'),
        ),
        body: SingleChildScrollView(
            child: Column(children: <Widget>[
          FutureBuilder(
            future: ref.once(),
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasData) {
                  return Center(
                      child: Text("${snapshot.data.value["name"].toString()}"));
                } else
                  return Text("NO data");
              } else {
                return Center(child: CircularProgressIndicator());
              }
            },
          ),
          TextField(
            controller: myController,
            // onChanged: () {},
          ),
          // ignore: deprecated_member_use
          RaisedButton(
            onPressed: () {
              setState(() async {
                await ref.update({'name': myController.text});
              });
            },
            child: Text("Edit"),
          ),
          // ignore: deprecated_member_use
          RaisedButton(
            onPressed: () async {
              await ref.remove();
              await FirebaseAuth.instance.currentUser!.delete();
            },
            child: Text("Delete User"),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                  padding: const EdgeInsets.all(8),
                  // ignore: deprecated_member_use
                  child: RaisedButton(
                    onPressed: _signOut,
                    child: Text('Logout'),
                  )),
            ],
          )
        ])));
  }

  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();

    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (_) => Loginpage()));
  }
}
