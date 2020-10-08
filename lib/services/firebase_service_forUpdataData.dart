import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:education_community/services/timeCalCulations.dart';
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
      {File photoForDp,
      String displayName,
      String bio,
      String userId,
      File photoForCover}) async {
    String userUniqueId = userId;
    String coverPhotoUrl;
    if (photoForDp != null) {
      if (photoForCover != null) {
        String dpPhotoUrl =
            await updateUserProfilePhotoToFireStorage(photoForDp, userId);
        coverPhotoUrl =
            await updateUserCoverPhotoToFireStorage(photoForCover, userId);
        await firebaseFirestore.collection("Users").doc(userUniqueId).update(
          {
            "PhotoUrl": dpPhotoUrl,
            "CoverPhotoUrl": coverPhotoUrl,
            "DisplayName": displayName,
            "About": bio,
          },
        );
      } else {
        String dpPhotoUrl =
            await updateUserProfilePhotoToFireStorage(photoForDp, userId);
        await firebaseFirestore.collection("Users").doc(userUniqueId).update(
          {
            "PhotoUrl": dpPhotoUrl,
            "DisplayName": displayName,
            "About": bio,
          },
        );
      }
    } else {
      if (photoForCover != null) {
        coverPhotoUrl =
            await updateUserCoverPhotoToFireStorage(photoForCover, userId);
        await firebaseFirestore.collection("Users").doc(userUniqueId).update(
          {
            "CoverPhotoUrl": coverPhotoUrl,
            "DisplayName": displayName,
            "About": bio,
          },
        );
      } else {
        await firebaseFirestore.collection("Users").doc(userUniqueId).update(
          {
            "DisplayName": displayName,
            "About": bio,
          },
        );
      }
    }
  }

  Future<String> updateUserProfilePhotoToFireStorage(
      File fileImage, String userId) async {
    String userUniqueId = userId;
    final StorageReference storageReference = firebaseStorage
        .ref()
        .child("UserImage/$userUniqueId/$userUniqueId.jpg");
    final StorageUploadTask uploadTask = storageReference.putFile(fileImage);
    await uploadTask.onComplete;
    uploadPhotoLink = await storageReference.getDownloadURL();
    return uploadPhotoLink;
  }

  Future<String> updateUserCoverPhotoToFireStorage(
      File fileImage, String userId) async {
    String userUniqueId = userId;
    final StorageReference storageReference = firebaseStorage
        .ref()
        .child("CoverImage/$userUniqueId/$userUniqueId.jpg");
    final StorageUploadTask uploadTask = storageReference.putFile(fileImage);
    await uploadTask.onComplete;
    uploadPhotoLink = await storageReference.getDownloadURL();
    return uploadPhotoLink;
  }
}
