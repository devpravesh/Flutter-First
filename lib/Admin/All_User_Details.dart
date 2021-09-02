import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:onlylogin/Login.dart';

class Admin extends StatefulWidget {
  Admin({Key? key}) : super(key: key);

  @override
  _AdminState createState() => _AdminState();
}

class _AdminState extends State<Admin> {
  final fb = FirebaseDatabase.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Pannel'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: _signOut,
          ),
        ],
      ),
      body: FutureBuilder(
        future: getdata(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              return ListView.builder(
                  itemCount: snapshot.data!.length,
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  padding: EdgeInsets.all(10),
                  itemBuilder: (context, int index) {
                    Map result = snapshot.data!;
                    List resultList = [];
                    result.forEach((key, value) {
                      resultList.add(key);
                    });

                    if (snapshot.data['${resultList[index]}']['role'] !=
                        "admin") {
                      return Padding(
                        padding: const EdgeInsets.only(
                            left: 15, right: 15, top: 2, bottom: 10),
                        child: InkWell(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            child: Container(
                              height: 40,
                              decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                  border: Border.all(
                                      width: 1.0, color: Colors.black)),
                              child: Text(
                                "${snapshot.data['${resultList[index]}']['name']}",
                                textAlign: TextAlign.center,
                                strutStyle: StrutStyle(height: 2.3),
                                style: /*Theme.of(context).textTheme.headline6, */
                                    TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            onTap: () {
                              AlertDialog alert = AlertDialog(
                                title: Column(
                                  children: [
                                    Text(
                                      "Name:- "
                                      "${snapshot.data['${resultList[index]}']['name']}",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      "Email:- ${snapshot.data['${resultList[index]}']['email']}",
                                    ),
                                    if (snapshot.data['${resultList[index]}']
                                            ['phone number'] !=
                                        null)
                                      Text(
                                          "Phone:- ${snapshot.data['${resultList[index]}']['phone number']}"),
                                    if (snapshot.data['${resultList[index]}']
                                            ['address'] !=
                                        null)
                                      Text(
                                          "Address:- ${snapshot.data['${resultList[index]}']['address']}"),
                                  ],
                                ),
                                actions: [
                                  FlatButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(),
                                    child: Text('OK'),
                                    splashColor: Colors.red,
                                    textColor: Colors.blue,
                                  )
                                ],
                              );
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return alert;
                                },
                              );
                            }),
                      );
                    } else {
                      return Container();
                    }
                  });
            } else
              return Text("NO data");
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
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

  final ref = FirebaseAuth.instance;
  Future getdata() async {
    var result =
        await FirebaseDatabase.instance.reference().child('data').once();
    return result.value;
  }
}
