// import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
// import 'package:path/path.dart' as Path;
import 'dart:io' as Io;

class ImageP extends StatefulWidget {
  String? imagePic;
  ImageP({this.imagePic});
  @override
  _ImagePState createState() => _ImagePState();
}

XFile? imageFile;
// var storeimg;
// FirebaseStorage _storage = FirebaseStorage.instance;

class _ImagePState extends State<ImageP> {
  final ImagePicker _picker = ImagePicker();
  Future imagePic(BuildContext context) {
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
                      },
                      title: Text("Gallery"),
                      leading: Icon(Icons.image),
                    ),
                    ListTile(
                      onTap: () {
                        _getFromCamera(context);
                      },
                      title: Text('Camera'),
                      leading: Icon(Icons.camera),
                    )
                  ],
                ),
              ));
        });
  }

  @override
  Widget build(BuildContext context) {
    @override
    void dispose() {
      imageFile = null;
      super.dispose();
    }

    return Scaffold(
      body: Container(
        alignment: Alignment.bottomCenter,
        child: RaisedButton(
          onPressed: () {
            imagePic(context);
          },
          child: Text('Select Image'),
          // storeimg = Io.File(imageFile!.path),
        ),
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(image: FileImage(Io.File(imageFile!.path)))),
      ),

      //     child: imageFile == null
      //         ? Container(
      //             alignment: Alignment.center,
      //             child: Column(
      //               mainAxisAlignment: MainAxisAlignment.center,
      //               children: <Widget>[
      //                 RaisedButton(
      //                   color: Colors.greenAccent,
      //                   onPressed: () {
      //                     _getFromGallery();
      //                   },
      //                   child: Text("PICK FROM GALLERY"),
      //                 ),
      //                 Container(
      //                   height: 40.0,
      //                 ),
      //                 RaisedButton(
      //                   color: Colors.lightGreenAccent,
      //                   onPressed: () {
      //                     _getFromCamera();
      //                   },
      //                   child: Text("PICK FROM CAMERA"),
      //                 )
      //               ],
      //             ),
      //           )
      //         : Stack(children: [
      // Container(
      //     decoration: BoxDecoration(
      //         image: DecorationImage(
      //             image: FileImage(Io.File(imageFile!.path)))));
      //             Align(
      //               alignment: Alignment.bottomCenter,
      //               child: MaterialButton(
      //                 onPressed: () {
      //                   dispose();
      //                   Navigator.pop(context);
      //                 },
      //                 child: Text("Dispose"),
      //                 color: Colors.amber,
      //               ),
      //             )
      //           ]))
    );
  }

  void _getFromGallery(BuildContext context) async {
    XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        imageFile = pickedFile;
        print(imageFile!.path);
      });
    }
  }

  void _getFromCamera(BuildContext context) async {
    XFile? pickedFile = await _picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      setState(() {
        imageFile = pickedFile;
      });
    }
  }
}









  // Future uploadimage(BuildContext context) async {
    //  StorageReference storageReference = FirebaseStorage.instance
    //      .ref()
    //      .child('Images/${Path.(imageFile!.path)}}');
  // }

