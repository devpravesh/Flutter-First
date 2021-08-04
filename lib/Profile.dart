// import 'dart:html';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
// import 'package:onlylogin/imagepicker.dart';
// import 'package:image_picker/image_picker.dart';
import 'package:onlylogin/profileedit.dart';
import 'package:onlylogin/signIn.dart';
// import 'package:onlylogin/imagepicker.dart';

class Show extends StatefulWidget {
  Show({Key? key}) : super(key: key);

  @override
  _ShowState createState() => _ShowState();
}

class _ShowState extends State<Show> {
  final fb = FirebaseDatabase.instance;
  var passingName;
  var phoneNymber;
  var useraddress;

  var uid = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    final ref = fb.reference().child("data").child(uid);
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(
                      builder: (_) => ProfilePage(
                            passingName: passingName,
                            phoneNumberofEditScreen: phoneNymber,
                            address1: useraddress,
                          )))
                  .then((value) => refreshData());
            },
            icon: Icon(
              Icons.edit,
              color: Colors.black,
            ),
          ),
        ],
        title: Text(
          "Profile",
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: Container(
        color: Colors.blue[50],
        child: ListView(
          children: <Widget>[
            Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(
                    top: 20,
                  ),
                  child: Container(
                      height: 140.0,
                      width: 140.0,
                      child: CircleAvatar(
                          radius: 70,
                          backgroundColor: Colors.white,
                          child: FutureBuilder(
                            future: getImage(),
                            builder: (context, AsyncSnapshot snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.done) {
                                if (snapshot.hasData) {
                                  return Center(
                                      child: Container(
                                          decoration: BoxDecoration(
                                              // gradient: LinearGradient(colors: [
                                              //   Colors.black,
                                              //   Colors.red
                                              // ]),
                                              shape: BoxShape.circle,
                                              border: Border.all(width: 1),
                                              image: DecorationImage(
                                                  image: NetworkImage(
                                                      snapshot.data!),
                                                  fit: BoxFit.cover))));
                                } else
                                  return Text(" Upload Profile Picture");
                              } else {
                                return Center(
                                    child: CircularProgressIndicator());
                              }
                            },
                          ))
                      // decoration: BoxDecoration(
                      //   shape: BoxShape.circle,
                      //   image: DecorationImage(
                      //     image: NetworkImage(
                      //         "https://i.pinimg.com/564x/75/be/06/75be061dfa3a642cb6b4ef9acfd5c810.jpg"),
                      //     fit: BoxFit.cover,
                      //   ),
                      // ),
                      ),
                ),
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                          padding: const EdgeInsets.only(
                              top: 25, right: 25, left: 25),
                          child:
                              Row(mainAxisAlignment: MainAxisAlignment.center,
                                  // mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[
                                Column(
                                  children: <Widget>[
                                    Text(
                                      "Personal Details",
                                      style: TextStyle(
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ])),
                      Divider(
                        thickness: 1,
                        indent: 25,
                        endIndent: 25,
                        color: Colors.black,
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(top: 5, left: 30, right: 30),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          // mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Text("Name",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold)),
                            Icon(Icons.person)
                          ],
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(top: 5, left: 25, right: 25),
                        child: Row(
                          children: <Widget>[
                            Flexible(
                              child: FutureBuilder(
                                future: ref.once(),
                                builder: (context, AsyncSnapshot snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.done) {
                                    if (snapshot.hasData) {
                                      passingName = snapshot.data.value["name"];
                                      phoneNymber =
                                          snapshot.data.value["phone number"];
                                      useraddress =
                                          snapshot.data.value["address"];
                                      return Container(
                                        padding: EdgeInsets.all(5),
                                        width: double.infinity,
                                        height: 45,
                                        decoration: BoxDecoration(
                                            color: Colors.blue[200],
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10)),
                                            border: Border.all(
                                                width: 1.0,
                                                color: Colors.black)),
                                        child: Center(
                                          child: Text(
                                            "${snapshot.data.value["name"].toString()}",
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      );
                                    } else
                                      return Text("NO data");
                                  } else {
                                    return Center(
                                        child: CircularProgressIndicator());
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(top: 5, left: 30, right: 30),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          // mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Text(
                              "EMAIL ID",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            Icon(Icons.mail)
                          ],
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(top: 2, left: 25, right: 25),
                        child: Row(
                          children: [
                            Flexible(
                              child: FutureBuilder(
                                future: ref.once(),
                                builder: (context, AsyncSnapshot snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.done) {
                                    if (snapshot.hasData) {
                                      return Padding(
                                        padding: const EdgeInsets.only(top: 5),
                                        child: Container(
                                          padding: EdgeInsets.all(5),
                                          width: double.infinity,
                                          height: 45,
                                          decoration: BoxDecoration(
                                              color: Colors.red[200],
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10)),
                                              border: Border.all(
                                                  width: 1.0,
                                                  color: Colors.black)),
                                          child: Center(
                                            child: Text(
                                              "${snapshot.data.value["email"].toString()}",
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ),
                                      );
                                    } else
                                      return Text("NO data");
                                  } else {
                                    return Center(
                                        child: CircularProgressIndicator());
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(top: 5, left: 30, right: 30),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Phone Number",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            Icon(Icons.call)
                          ],
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(top: 5, left: 25, right: 25),
                        child: Row(
                          children: [
                            Flexible(
                              child: FutureBuilder(
                                future: ref.once(),
                                builder: (context, AsyncSnapshot snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.done) {
                                    if (snapshot.hasData) {
                                      return Container(
                                        padding: EdgeInsets.all(5),
                                        width: double.infinity,
                                        height: 45,
                                        decoration: BoxDecoration(
                                            color: Colors.amber[200],
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10)),
                                            border: Border.all(
                                                width: 1.0,
                                                color: Colors.black)),
                                        child: Center(
                                          child: Text(
                                            "${snapshot.data.value["phone number"].toString()}",
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      );
                                    } else
                                      return Text("NO data");
                                  } else {
                                    return Center(
                                        child: CircularProgressIndicator());
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(top: 5, left: 30, right: 30),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Address",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            Icon(Icons.place)
                          ],
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(top: 2, left: 25, right: 25),
                        child: Row(
                          children: [
                            Flexible(
                              child: FutureBuilder(
                                future: ref.once(),
                                builder: (context, AsyncSnapshot snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.done) {
                                    if (snapshot.hasData) {
                                      return Container(
                                        padding: EdgeInsets.all(5),
                                        width: double.infinity,
                                        height: 45,
                                        decoration: BoxDecoration(
                                            color: Colors.green[200],
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10)),
                                            border: Border.all(
                                                width: 1.0,
                                                color: Colors.black)),
                                        child: Center(
                                          child: Text(
                                            "${snapshot.data.value["address"].toString()}",
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      );
                                    } else
                                      return Text("NO data");
                                  } else {
                                    return Center(
                                        child: CircularProgressIndicator());
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      Center(
                        child: FlatButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                              side: BorderSide(color: Colors.black, width: 2)),
                          onPressed: _signOut,
                          color: Colors.blue[500],
                          splashColor: Colors.red,
                          child: Text("SignOut"),
                          textColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  refreshData() {
    setState(() {});
  }

  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => Loginpage(),
      ),
      (route) => false,
    );
  }

  User user = FirebaseAuth.instance.currentUser!;
  Future getImage() async {
    return FirebaseStorage.instance
        .ref('${user.uid}profilePicture.jpg')
        .getDownloadURL();
  }
}
