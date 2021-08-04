import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class Pimage extends StatelessWidget {
  // const Pimage({Key? key}) : super(key: key);
  final fb = FirebaseStorage.instance;
  // Firebase_Storage.refference ref();

  @override
  Widget build(BuildContext context) {
    final ref = fb.ref().child("images");
    return Scaffold(
      body: Container(
        child: FutureBuilder(
          future: getImage(),
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasData) {
                return Center(child: Image.network(snapshot.data!));
              } else
                return Text("NO data");
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }

  Future getImage() async {
    return FirebaseStorage.instance.ref('images').getDownloadURL();
  }
}
