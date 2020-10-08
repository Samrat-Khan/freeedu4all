import 'dart:io';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:education_community/screens/myProfilePage.dart';
import 'package:education_community/services/firebase_service_forUpdataData.dart';
import 'package:education_community/services/photo_picker.dart';
import 'package:education_community/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class EditProfilePage extends StatefulWidget {
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  String photo, bio, displayName;
  String currentUserId;
  File fileImageOfDp, fileImageOfCover;

  pickFileImageForDp() async {
    PhotoPicker photoPicker = PhotoPicker();
    fileImageOfDp = await photoPicker.pickImageFromGallery();
  }

  pickFileImageForCover() async {
    PhotoPicker photoPicker = PhotoPicker();
    fileImageOfCover = await photoPicker.pickImageFromGallery();
  }

  updateData() async {
    FirebaseServiceUpdateData firebaseServiceUpdateData =
        FirebaseServiceUpdateData();
    await firebaseServiceUpdateData
        .updateUserProfileData(
      photoForDp: fileImageOfDp,
      displayName: displayName,
      bio: bio,
      photoForCover: fileImageOfCover,
      userId: currentUserId,
    )
        .whenComplete(() {
      setState(() {
        isUploading = false;
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => MyProfilePage()),
            (route) => false);
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    currentUserId = firebaseAuth.currentUser.uid;
  }

  Future getUserData() async {
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection("Users")
        .doc(currentUserId)
        .get();
    displayName = snapshot.data()["DisplayName"];
    bio = snapshot.data()["About"];
    photo = snapshot.data()["PhotoUrl"];
  }

  bool isUploading = false;

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: isUploading,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("Edit Profile"),
        ),
        body: FutureBuilder(
          future: getUserData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Text("Loading");
            }
            return SingleChildScrollView(
              child: Container(
                child: Column(
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height / 5,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height / 5,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: fileImageOfCover == null
                                    ? AssetImage("images/google.png")
                                    : FileImage(fileImageOfCover),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height / 5,
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                              child: Container(
                                color: Colors.black.withOpacity(0.1),
                              ),
                            ),
                          ),
                          Positioned(
                            right: 1,
                            bottom: 1,
                            child: IconButton(
                              icon: Icon(
                                Icons.camera_alt,
                                size: 35,
                                color: Colors.black,
                              ),
                              onPressed: pickFileImageForCover,
                            ),
                          ),
                          CircleAvatar(
                            radius: 60,
                            backgroundImage: fileImageOfDp == null
                                ? NetworkImage(photo)
                                : FileImage(fileImageOfDp),
                            child: Container(
                              height: double.infinity,
                              width: double.infinity,
                              alignment: Alignment.bottomRight,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.6),
                                borderRadius: BorderRadius.circular(100),
                              ),
                              child: IconButton(
                                icon: Icon(
                                  Icons.camera_alt,
                                  color: Colors.black,
                                  size: 35,
                                ),
                                onPressed: pickFileImageForDp,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(10),
                      child: TextField(
                        controller: TextEditingController()..text = displayName,
                        decoration: InputDecoration(
                          hintText: "Display Name",
                          labelText: "User Name",
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              width: 1.5,
                            ),
                          ),
                        ),
                        onChanged: (text) {
                          displayName = text;
                          print(displayName);
                        },
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(10),
                      child: TextField(
                        controller: TextEditingController()..text = bio,
                        maxLines: 10,
                        maxLength: 180,
                        decoration: InputDecoration(
                          hintText: "Bio",
                          labelText: "What Best Describe You",
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              width: 1.5,
                            ),
                          ),
                        ),
                        onChanged: (text) {
                          bio = text;
                          print(bio);
                        },
                      ),
                    ),
                    MaterialButton(
                      elevation: 3,
                      color: Colors.green,
                      child: Text("Update"),
                      onPressed: () {
                        setState(() {
                          isUploading = true;
                        });
                        updateData();
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
