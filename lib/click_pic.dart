import 'dart:io';

import 'package:ameno/good_job.dart';
import 'package:ameno/helpers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as storageRef;
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';

import 'notification_api.dart';

class ClickPictureScreen extends StatefulWidget {
  const ClickPictureScreen({super.key});

  @override
  State<ClickPictureScreen> createState() => _ClickPictureScreenState();
}

class _ClickPictureScreenState extends State<ClickPictureScreen> {
  XFile? imageXFile;
  final ImagePicker _picker = ImagePicker();
  String uniqueIdName = DateTime.now().microsecondsSinceEpoch.toString();
  bool uploading = false;
  captureImageWithCamera() async {
    imageXFile = await _picker.pickImage(
        source: ImageSource.camera,
        maxHeight: 720,
        maxWidth: 1280,
        imageQuality: 30);
    if (mounted) {
      setState(() {
        imageXFile;
      });
    }
  }

  uploadImage(mImageFile) async {
    storageRef.Reference reference =
        storageRef.FirebaseStorage.instance.ref().child('menus');

    storageRef.UploadTask uploadTask =
        reference.child(uniqueIdName + '.jpeg').putFile(mImageFile);

    storageRef.TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {});

    String downloadURL = await taskSnapshot.ref.getDownloadURL();
    return downloadURL;
  }

  uploadImagetoFirebase() async {
    if (imageXFile != null) {
      EasyLoading.show(status: 'Uploading images...');
      setState(() {
        uploading = true;
      });
      //start uploading the image

      String downloadUrl = await uploadImage(File(imageXFile!.path));

      //save info in firestore
      saveInfo(downloadUrl);
    } else {
      EasyLoading.showError('Please Pick Images');
    }
  }

  saveInfo(String downloadUrl) {
    final ref = FirebaseFirestore.instance.collection('mealImages');

    ref
        .doc(uniqueIdName)
        .set({'createdAt': DateTime.now(), 'imageUrl': downloadUrl});
    EasyLoading.showSuccess('Image Added Successfully');
    NotificationApi.showNotification(
        title: 'Image Uploaded',
        body: 'The image has been successfully uploaded.');

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => GoodJobScreen()),
    );

    setState(() {
      uniqueIdName = DateTime.now().microsecondsSinceEpoch.toString();

      uploading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: kPrimaryColor,
            child: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
              onPressed: () {
                // Define the action when the back button is pressed
                Navigator.pop(context);
              },
            ),
          ),
        ),
        // iconTheme: IconThemeData(
        //   color: Theme.of(context).primaryColor,
        // ),
        centerTitle: true,
      ),
      body: Column(children: [
        Image.asset(
          'assets/images/baby.png',
          fit: BoxFit.cover,
          height: MediaQuery.of(context).size.height * .18,
        ),
        SizedBox(
          height: 40,
        ),
        Expanded(
          child: Container(
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                color: Color(0xffF4F4F4),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: imageXFile == null
                  ? Column(children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 10, right: 10, top: 18, bottom: 50),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Image.asset('assets/images/fork.png'),
                            Stack(
                              children: [
                                Image.asset('assets/images/Corners.png'),
                                GestureDetector(
                                    onTap: () {
                                      captureImageWithCamera();
                                    },
                                    child: Image.asset(
                                        'assets/images/circle.png')),
                              ],
                            ),
                            SvgPicture.asset('assets/images/spoon.svg')
                          ],
                        ),
                      ),
                      Text(
                        'Click your meal',
                        style: TextStyle(fontSize: 24),
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      GestureDetector(
                        onTap: () {
                          captureImageWithCamera();
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Color(0x0000004D),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Color(0x0000004D),
                                offset: Offset(0, 4),
                                blurRadius: 4,
                                spreadRadius: 0,
                              ),
                            ],
                          ),
                          child: CircleAvatar(
                            backgroundColor: kPrimaryColor,
                            radius: 40,
                            child: Icon(
                              Icons.camera_alt,
                              size: 36,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ])
                  : Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 10, right: 10, top: 18, bottom: 50),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircleAvatar(
                                radius: 100,
                                backgroundImage:
                                    FileImage(File(imageXFile!.path)),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          'Will you eat this?',
                          style: TextStyle(fontSize: 24),
                        ),
                        SizedBox(
                          height: 25,
                        ),
                        uploading == true
                            ? CircularProgressIndicator()
                            : GestureDetector(
                                onTap: () {
                                  uploadImagetoFirebase();
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Color(0x0000004D),
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Color(0x0000004D),
                                        offset: Offset(0, 4),
                                        blurRadius: 4,
                                        spreadRadius: 0,
                                      ),
                                    ],
                                  ),
                                  child: CircleAvatar(
                                    backgroundColor: kPrimaryColor,
                                    radius: 40,
                                    child: Icon(
                                      Icons.done,
                                      size: 36,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                      ],
                    )),
        ),
      ]),
    );
  }
}
