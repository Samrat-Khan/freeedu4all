import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:education_community/services/firebase_service_forUpdataData.dart';
import 'package:education_community/services/photo_picker.dart';
import 'package:education_community/services/user_service.dart';
import 'package:flutter/material.dart';

class EditProfilePage extends StatefulWidget {
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  String name, photo, bio, displayName;
  File fileImage;

  pickFileImage() async {
    PhotoPicker photoPicker = PhotoPicker();
    fileImage = await photoPicker.pickImageFromGallery();
  }

  updateData() async {
    FirebaseServiceUpdateData firebaseServiceUpdateData =
        FirebaseServiceUpdateData();
    await firebaseServiceUpdateData.updateUserProfileData(
      photo: fileImage,
      displayName: displayName,
      name: name,
      bio: bio,
    );
  }

  @override
  Widget build(BuildContext context) {
    Future getUserData() async {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection("Users")
          .doc(googleSignIn.currentUser.id)
          .get();
      name = snapshot.data()["Name"];
      displayName = snapshot.data()["DisplayName"];
      bio = snapshot.data()["About"];
      photo = snapshot.data()["PhotoUrl"];
    }

    return Scaffold(
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
          return Container(
            padding: EdgeInsets.all(15),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 60,
                  backgroundImage: fileImage == null
                      ? NetworkImage(photo)
                      : FileImage(fileImage),
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
                      onPressed: pickFileImage,
                    ),
                  ),
                ),
                TextField(
                  controller: TextEditingController()..text = name,
                  onChanged: (text) {
                    name = text;
                  },
                  decoration: InputDecoration(
                    hintText: "Name",
                  ),
                ),
                TextField(
                  controller: TextEditingController()..text = displayName,
                  decoration: InputDecoration(
                    hintText: "Display Name",
                  ),
                  onChanged: (text) {
                    displayName = text;
                    print(displayName);
                  },
                ),
                TextField(
                  controller: TextEditingController()..text = bio,
                  maxLines: null,
                  decoration: InputDecoration(
                    hintText: "Bio",
                  ),
                  onChanged: (text) {
                    bio = text;
                    print(bio);
                  },
                ),
                MaterialButton(
                  child: Text("Update"),
                  onPressed: updateData,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
