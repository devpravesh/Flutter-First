import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:onlylogin/Profile.dart';

import 'dart:io' as Io;

// ignore: must_be_immutable
class ProfilePage extends StatefulWidget {
  String? passingName;
  var phoneNumberofEditScreen;
  var address1;
  ProfilePage(
      {required this.passingName, this.phoneNumberofEditScreen, this.address1});
  @override
  ProfilePageState createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage>
    with SingleTickerProviderStateMixin {
  final FocusNode myFocusNode = FocusNode();
  final _text = TextEditingController();
  final fb = FirebaseDatabase.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String? newName;
  var newnumber;
  var newaddress;
  final ImagePicker _picker = ImagePicker();
  XFile? imageFile;

  bool _validate = false;

  var uid = FirebaseAuth.instance.currentUser!.uid;
  var uploadimage;

  TextEditingController myController = new TextEditingController();
  TextEditingController phoneController = new TextEditingController();
  TextEditingController addressController = new TextEditingController();

  @override
  void dispose() {
    _text.dispose();
    super.dispose();
  }

  @override
  void initState() {
    newName = widget.passingName;
    newnumber = widget.phoneNumberofEditScreen;
    newaddress = widget.address1;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ref = fb.reference().child("data").child(uid);
    myController.text = widget.passingName!;
    phoneController.text = widget.phoneNumberofEditScreen;
    addressController.text = widget.address1;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => Show(),
                  ),
                  (route) => false,
                )),
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
        color: Colors.white,
        child: ListView(
          children: <Widget>[
            Column(
              children: <Widget>[
                Container(
                  color: Colors.white,
                  child: Column(
                    children: [
                      Padding(
                          padding: const EdgeInsets.only(
                            top: 20,
                          ),
                          child: Stack(
                            fit: StackFit.loose,
                            children: <Widget>[
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    child: CircleAvatar(
                                        backgroundColor: Colors.white,
                                        backgroundImage: NetworkImage(
                                            "https://i.pinimg.com/564x/75/be/06/75be061dfa3a642cb6b4ef9acfd5c810.jpg"),
                                        radius: 70,
                                        child: FutureBuilder(
                                          future: getImage(),
                                          builder: (context,
                                              AsyncSnapshot snapshot) {
                                            if (snapshot.connectionState ==
                                                ConnectionState.done) {
                                              if (snapshot.hasData) {
                                                return Center(
                                                    child: Container(
                                                        decoration: BoxDecoration(
                                                            shape:
                                                                BoxShape.circle,
                                                            image: DecorationImage(
                                                                image: NetworkImage(
                                                                    snapshot
                                                                        .data!),
                                                                fit: BoxFit
                                                                    .cover))));
                                              } else
                                                return Text("NO data");
                                            } else {
                                              return Center(
                                                  child:
                                                      CircularProgressIndicator());
                                            }
                                          },
                                        )),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                  top: 90,
                                  right: 110,
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: <Widget>[
                                    CircleAvatar(
                                      backgroundColor: Colors.teal,
                                      child: IconButton(
                                          onPressed: pressed,
                                          icon: Icon(Icons.camera_alt)),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          )),
                    ],
                  ),
                ),
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                          padding: const EdgeInsets.only(
                              top: 25, right: 25, left: 25),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
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
                      Padding(
                        padding:
                            const EdgeInsets.only(top: 2, left: 25, right: 25),
                        child: Row(
                          children: [
                            Icon(
                              Icons.person,
                              color: Colors.black,
                            ),
                            Text(
                              "Name",
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(top: 2, left: 25, right: 25),
                        child: Row(
                          children: <Widget>[
                            Flexible(
                                child: TextFormField(
                              validator: (input) {
                                if (input!.isEmpty) {
                                  return 'please enter name';
                                }
                                return null;
                              },
                              onChanged: (value) {
                                newName = value;
                              },
                              controller: myController,
                              decoration: InputDecoration(
                                hintText: "Enter Name",
                                enabledBorder: new OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12)),
                                errorText:
                                    _validate ? 'Value Can\'t Be Empty' : null,
                              ),
                            ))
                          ],
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(top: 5, left: 25, right: 25),
                        child: Row(
                          children: [
                            Icon(
                              Icons.call,
                              color: Colors.black,
                            ),
                            Text(
                              "Phone Number",
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(top: 2, left: 25, right: 25),
                        child: Row(
                          children: [
                            Flexible(
                              child: TextField(
                                keyboardType: TextInputType.phone,
                                controller: phoneController,
                                onChanged: (value) {
                                  newnumber = value;
                                },
                                decoration: InputDecoration(
                                    enabledBorder: new OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(12)),
                                    errorText: _validate
                                        ? 'Value Can\'t Be Empty'
                                        : null,
                                    hintText: "Enter Phone Number"),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(top: 5, left: 25, right: 25),
                        child: Row(
                          children: [
                            Icon(
                              Icons.location_city,
                              color: Colors.black,
                            ),
                            Text(
                              "Address",
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(top: 2, left: 25, right: 25),
                        child: Row(
                          children: [
                            Flexible(
                              child: TextField(
                                controller: addressController,
                                onChanged: (value) {
                                  newaddress = value;
                                },
                                decoration: InputDecoration(
                                  errorText: _validate
                                      ? 'Value Can\'t Be Empty'
                                      : null,
                                  hintText: "Enter Address",
                                  enabledBorder: new OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12)),
                                ),
                                maxLength: 50,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Center(
                        // ignore: deprecated_member_use
                        child: RaisedButton(
                          onPressed: () async {
                            _text.text.isEmpty
                                ? _validate = true
                                : _validate = false;
                            try {
                              if (widget.passingName != newName)
                                await ref.update(
                                  {'name': myController.text},
                                ).whenComplete(() {
                                  // final scaffold =
                                  //     ScaffoldMessenger.of(context);
                                  // scaffold.showSnackBar(SnackBar(
                                  //     content:
                                  //         Text('Name SuccessFuly Updated')));
                                  print("name completed");
                                });

                              if (widget.phoneNumberofEditScreen != newnumber)
                                await ref.update({
                                  'phone number': phoneController.text
                                }).whenComplete(() {
                                  print("phone completed");
                                });
                              if (widget.address1 != newaddress)
                                await ref.update({
                                  'address': addressController.text
                                }).whenComplete(() {
                                  print("address completed");
                                });
                              final scaffold = ScaffoldMessenger.of(context);
                              scaffold.showSnackBar(SnackBar(
                                  content:
                                      Text('Detailes Successfully Updated')));
                            } finally {
                              Navigator.of(context).pop();
                            }
                          },
                          child: Text(
                            "Save",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          color: Colors.teal,
                          splashColor: Colors.amber,
                        ),
                      ),
                      // Padding(
                      //   padding: const EdgeInsets.all(8.0),
                      //   child: RaisedButton(
                      //     onPressed: () {
                      //       Navigator.of(context).push(
                      //           MaterialPageRoute(builder: (_) => Pimage()));
                      //     },
                      //     child: Text('FBImg'),
                      //   ),
                      // ),
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

  Future pressed() async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text('Choose...'),
              content: SingleChildScrollView(
                child: ListBody(
                  children: [
                    Divider(
                      height: 1,
                      color: Colors.blue,
                    ),
                    ListTile(
                      onTap: () {
                        _getFromGallery(context);
                        Navigator.of(context).pop();
                      },
                      title: Text("Gallery"),
                      leading: Icon(Icons.image),
                    ),
                    ListTile(
                      onTap: () {
                        _getFromCamera(context);
                        Navigator.of(context).pop();
                      },
                      title: Text('Camera'),
                      leading: Icon(Icons.camera),
                    ),
                    // Stack(
                    //   children: [
                    //     Container(
                    //         decoration: BoxDecoration(
                    //       image: DecorationImage(
                    //           image: FileImage(Io.File(imageFile!.path))),
                    //     ))
                    //   ],
                    // )
                  ],
                ),
              ));
        });
  }

  void _getFromGallery(BuildContext context) async {
    XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        imageFile = pickedFile;
        uploadtofirebase();
        print(imageFile!.path);
      });
    }
  }

  void _getFromCamera(BuildContext context) async {
    XFile? pickedFile = await _picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      setState(() {
        imageFile = pickedFile;
        uploadtofirebase();
        print(imageFile!.path);
      });
    }
  }

  User user = FirebaseAuth.instance.currentUser!;

  // await ref.child(user.uid).set({

  //   "address": _add,
  // });
  Future uploadtofirebase() async {
    var file = Io.File(imageFile!.path);
    FirebaseStorage storage = FirebaseStorage.instance;
    Reference ref = storage.ref().child('${user.uid}profilePicture.jpg');
    UploadTask uploadTask = ref.putFile(file);
    var result = await uploadTask;
    uploadimage = await ref.getDownloadURL();
    // res.ref.getDownloadURL();

    setState(() {
      uploadimage = imageFile;
      final scaffold = ScaffoldMessenger.of(context);
      scaffold
          .showSnackBar(SnackBar(content: Text("Profile Picture is updated")));
      print('Profile picture is updated');
      // ignore: deprecated_member_use
    });
    print(result);
  }

  Future getImage() async {
    return FirebaseStorage.instance
        .ref('${user.uid}profilePicture.jpg')
        .getDownloadURL();
  }
}
