import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:education_community/services/timeCalCulations.dart';
import 'package:education_community/services/user_service.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseServiceUpdateData {
  FirebaseStorage firebaseStorage = FirebaseStorage();
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  String uploadPhotoLink;
  var currentDateTime = DateTime.now();
  MonthFormat monthFormat = MonthFormat();

  Future handelLikes(
      {String blogUid, int count, String currentUserID, bool isLiked}) async {
    await firebaseFirestore.collection("Blog").doc(blogUid).update(
      {
        'TotalLikes': count,
        'Likes.$currentUserID': isLiked,
      },
    );
  }

  Future updateUserProfileData(
      {File photo, String name, String displayName, String bio}) async {
    String userUniqueId = googleSignIn.currentUser.id;
    if (photo != null) {
      String photoUrl = await updateUserProfilePhotoToFireStorage(photo);
      await firebaseFirestore.collection("Users").doc(userUniqueId).update(
        {
          "Name": name,
          "PhotoUrl": photoUrl,
          "DisplayName": displayName,
          "About": bio,
        },
      );
    } else {
      await firebaseFirestore.collection("Users").doc(userUniqueId).update(
        {
          "Name": name,
          "DisplayName": displayName,
          "About": bio,
        },
      );
    }
  }

  Future<String> updateUserProfilePhotoToFireStorage(File fileImage) async {
    String userUniqueId = googleSignIn.currentUser.id;
    final StorageReference storageReference = firebaseStorage
        .ref()
        .child("UserImage/$userUniqueId/$userUniqueId.jpg");
    final StorageUploadTask uploadTask = storageReference.putFile(fileImage);
    await uploadTask.onComplete;
    uploadPhotoLink = await storageReference.getDownloadURL();
    return uploadPhotoLink;
  }
}
