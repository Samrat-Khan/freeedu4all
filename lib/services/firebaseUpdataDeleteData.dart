import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:education_community/services/firebase_service_for_setData.dart';
import 'package:education_community/services/timeCalCulations.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseUpdateDeleteData {
  FirebaseStorage firebaseStorage = FirebaseStorage();
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  String uploadPhotoLink;
  var currentDateTime = DateTime.now();
  MonthFormat monthFormat = MonthFormat();
  FirebaseSetData firebaseSetData = FirebaseSetData();

  Future handelBookmark(
      {String blogUid, String currentUserID, bool isBookmarkChecked}) async {
    await firebaseFirestore.collection("Blog").doc(blogUid).update(
      {
        'Bookmark.$currentUserID': isBookmarkChecked,
      },
    );
  }

  Future handelLikes(
      {String blogUid, int count, String currentUserID, bool isLiked}) async {
    await firebaseFirestore.collection("Blog").doc(blogUid).update(
      {
        'TotalLikes': count,
        'Likes.$currentUserID': isLiked,
      },
    );
  }

  ///WhatImage also define where fileImage will be upload on Firebase Storage
  ///If it BlogImage => BlogImage/UserId/BlogUid.jpg
  ///UserImage => UserImage/UserId/UserId.jpg
  ///CoverImage => CoverImage/UserId/UserId.jpg

  Future<String> photoUpload(
      {String whatImage, String userId, String blogUid, File fileImage}) async {
    final StorageReference reference =
        firebaseStorage.ref().child(whatImage == "UserImage"
            ? "$whatImage/$userId/$userId.jpg"
            : whatImage == "BlogImage"
                ? "$whatImage/$userId/$blogUid.jpg"
                : "$whatImage/$userId/$userId.jpg");

    final StorageUploadTask task = reference.putFile(fileImage);
    await task.onComplete;
    uploadPhotoLink = await reference.getDownloadURL();
    return uploadPhotoLink;
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
        String dpPhotoUrl = await photoUpload(
            whatImage: "UserImage", fileImage: photoForDp, userId: userId);
        coverPhotoUrl = await photoUpload(
          whatImage: "CoverImage",
          userId: userId,
          fileImage: photoForCover,
        );
        await firebaseFirestore.collection("Users").doc(userUniqueId).update(
          {
            "PhotoUrl": dpPhotoUrl,
            "CoverPhotoUrl": coverPhotoUrl,
            "DisplayName": displayName,
            "About": bio,
          },
        );
      } else {
        String dpPhotoUrl = await photoUpload(
            whatImage: "UserImage", fileImage: photoForDp, userId: userId);
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
        coverPhotoUrl = await photoUpload(
          whatImage: "CoverImage",
          userId: userId,
          fileImage: photoForCover,
        );
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
    String uploadPhotoLink = await photoUpload(
      whatImage: "UserImage",
      userId: userId,
      fileImage: fileImage,
    );
    return uploadPhotoLink;
  }

  Future<String> updateUserCoverPhotoToFireStorage(
      File fileImage, String userId) async {
    String uploadPhotoLink = await photoUpload(
        whatImage: "CoverImage", userId: userId, fileImage: fileImage);
    return uploadPhotoLink;
  }

  ///edit Publish BlogData

  Future updatePublishPost(
      {File fileImage,
      String blogTitle,
      String blogDetail,
      String blogUid,
      String userId}) async {
    String photoUrl;
    if (fileImage != null) {
      photoUrl = await photoUpload(
        userId: userId,
        whatImage: "BlogImage",
        blogUid: blogUid,
        fileImage: fileImage,
      );
      firebaseFirestore.collection("Blog").doc(blogUid).update({
        "BlogTitle": blogTitle,
        "BlogDetail": blogDetail,
        "BlogPhotoUrl": photoUrl,
      });
    } else {
      firebaseFirestore.collection("Blog").doc(blogUid).update({
        "BlogTitle": blogTitle,
        "BlogDetail": blogDetail,
      });
    }
  }

  ///edit Draft blogData
  Future draftPostUpdate(
      {File fileImage,
      String blogTitle,
      String blogDetail,
      String blogUid,
      String userId}) async {
    String photoUrl;
    String month = monthFormat.getMonth(currentDateTime.month);
    if (fileImage != null) {
      photoUrl = await photoUpload(
        userId: userId,
        whatImage: "BlogImage",
        blogUid: blogUid,
        fileImage: fileImage,
      );
      firebaseFirestore.collection("DraftBlog").doc(blogUid).update({
        "BlogTitle": blogTitle,
        "BlogDetail": blogDetail,
        "BlogPhotoUrl": photoUrl,
        "TimeStamp": currentDateTime.microsecondsSinceEpoch,
        "DateTime": "$month ${currentDateTime.day} ${currentDateTime.year}",
      });
    } else {
      firebaseFirestore.collection("DraftBlog").doc(blogUid).update({
        "BlogTitle": blogTitle,
        "BlogDetail": blogDetail,
        "TimeStamp": currentDateTime.microsecondsSinceEpoch,
        "DateTime": "$month ${currentDateTime.day} ${currentDateTime.year}",
      });
    }
  }

  ///publish Draft Blog
  Future publishDraftBlog(
      {File fileImage,
      String blogTitle,
      String blogDetail,
      String blogUid,
      String userId,
      String blogType}) async {
    await firebaseSetData
        .uploadBlog(
            blogTitle: blogTitle,
            blogDetail: blogDetail,
            blogUid: blogUid,
            fileImage: fileImage,
            timeStamp: currentDateTime.microsecondsSinceEpoch,
            userId: userId,
            blogType: blogType,
            whatBlog: "Publish")
        .whenComplete(() {
      firebaseFirestore.collection("DraftBlog").doc(blogUid).delete();
    });
  }
}

class Delete {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseStorage _storage = FirebaseStorage.instance;
  Future deleteDaftBlog(
      {String blogUid, String currentUserId, String blogPhotoUrl}) async {
    await _firestore.collection("DraftBlog").doc(blogUid).delete();
    if (blogPhotoUrl != null) {
      await _storage
          .getReferenceFromUrl(blogPhotoUrl)
          .then((value) => value.delete());
    }
  }

  Future deletePublishBlog(
      {String blogUid, String currentUserId, String blogPhotoUrl}) async {
    await _firestore.collection("Blog").doc(blogUid).delete();
    if (blogPhotoUrl != null) {
      await _storage
          .getReferenceFromUrl(blogPhotoUrl)
          .then((value) => value.delete());
    }

    await _firestore
        .collection("Comments")
        .where("BlogUID", isEqualTo: blogUid)
        .snapshots()
        .forEach((doc) {
      doc.docs.forEach((doc) {
        String data = doc.data()["CommentID"];
        _firestore.collection("Comments").doc(data).delete();
      });
    });
  }
}
