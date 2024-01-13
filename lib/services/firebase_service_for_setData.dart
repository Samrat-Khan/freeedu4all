import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

import 'timeCalCulations.dart';

class FirebaseSetData {
  FirebaseStorage firebaseStorage = FirebaseStorage.instance;
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  String uploadPhotoLink;
  var currentDateTime = DateTime.now();
  MonthFormat monthFormat = MonthFormat();

  Future<String> uploadUserProfilePhotoToFireStorage(
      File fileImage, String userUniqueId) async {
    final Reference storageReference = firebaseStorage
        .ref()
        .child("UserImage/$userUniqueId/$userUniqueId.jpg");
    // final UploadTask uploadTask =
    await storageReference.putFile(fileImage);
    // await uploadTask.onComplete;
    uploadPhotoLink = await storageReference.getDownloadURL();

    return uploadPhotoLink;
  }

  ///WhatImage also define where fileImage will be upload on Firebase Storage
  ///If it BlogImage => BlogImage/UserId/BlogUid.jpg
  ///UserImage => UserImage/UserId/UserId.jpg
  ///CoverImage => CoverImage/UserId/UserId.jpg

  Future<String> photoUpload(
      {String whatImage, String userId, String blogUid, File fileImage}) async {
    final Reference reference =
        firebaseStorage.ref().child(whatImage == "UserImage"
            ? "$whatImage/$userId/$userId.jpg"
            : whatImage == "BlogImage"
                ? "$whatImage/$userId/$blogUid.jpg"
                : "$whatImage/$userId/$userId.jpg");

    // final UploadTask task =
    await reference.putFile(fileImage);
    // await task.onComplete;
    uploadPhotoLink = await reference.getDownloadURL();
    return uploadPhotoLink;
  }

  ///WhatBlog define where blog data upload to Publish Section or Draft Section

  Future uploadBlog({
    String whatBlog,
    String blogTitle,
    String blogUid,
    String blogType,
    String blogDetail,
    String userId,
    int timeStamp,
    File fileImage,
  }) async {
    String month = monthFormat.getMonth(currentDateTime.month);

    DocumentSnapshot<Map<String, dynamic>> variable =
        await FirebaseFirestore.instance.collection('Users').doc(userId).get();

    String blogPhotoUrl;

    if (whatBlog == "Publish") {
      blogPhotoUrl = await photoUpload(
          whatImage: "BlogImage",
          userId: userId,
          blogUid: blogUid,
          fileImage: fileImage);

      CollectionReference blogData = firebaseFirestore.collection("Blog");

      await blogData.doc(blogUid).set({
        "BlogOwnerId": userId,
        "BlogOwnerName": variable.data()["DisplayName"],
        "BlogOwnerPhotoUrl": variable.data()["PhotoUrl"],
        "BlogTitle": blogTitle,
        "BlogDetail": blogDetail,
        "BlogType": blogType,
        "BlogPhotoUrl": blogPhotoUrl,
        "BlogUid": blogUid,
        "TimeStamp": timeStamp,
        "DateTime": "$month ${currentDateTime.day} ${currentDateTime.year}",
        "TotalLikes": 0,
        "Likes": {},
        "Bookmark": {},
      });
    } else {
      //
      CollectionReference draftBlog = firebaseFirestore.collection("DraftBlog");
      //
      //
      blogPhotoUrl = await photoUpload(
          whatImage: "BlogImage",
          userId: userId,
          blogUid: blogUid,
          fileImage: fileImage);
      //
          //
      await draftBlog.doc(blogUid).set({
        "BlogOwnerId": userId,
        "BlogTitle": blogTitle,
        "BlogDetail": blogDetail,
        "BlogType": blogType,
        "BlogPhotoUrl": blogPhotoUrl,
        "BlogUid": blogUid,
        "TimeStamp": timeStamp,
        "DateTime": "$month ${currentDateTime.day} ${currentDateTime.year}",
      });
      //
    }
    //
  }

  Future addNewUserData(
      {File fileImage,
      String userId,
      String displayName,
      String userEmail,
      String aboutUser}) async {
    ///whatImage : UserImage
    CollectionReference userData = firebaseFirestore.collection("Users");
    String photoUrl = await photoUpload(
        whatImage: "UserImage", fileImage: fileImage, userId: userId);
    await userData.doc(userId).set({
      "DisplayName": displayName,
      "Email": userEmail,
      "About": aboutUser,
      "PhotoUrl": photoUrl,
      "UserUID": userId,
      "Time": currentDateTime.millisecondsSinceEpoch,
    });
  }

  ///End Here  Above
  Future updateUserDataToFirebase({
    String displayName,
    String photoUrl,
    String userEmail,
    String aboutUser,
    String uid,
    String coverPhoto,
  }) async {
    CollectionReference userData = firebaseFirestore.collection("Users");
    await userData.doc(uid).set({
      "DisplayName": displayName,
      "Email": userEmail,
      "About": aboutUser,
      "PhotoUrl": photoUrl,
      "UserUID": uid,
      "Time": currentDateTime.millisecondsSinceEpoch,
    });
  }

  Future blogAuthorDetail(String id) async {
    String name;
    DocumentSnapshot<Map<String, dynamic>> variable =
        await FirebaseFirestore.instance.collection('Users').doc(id).get();
    name = variable.data()["PhotoUrl"];
    return name;
  }

  Future addCommentToBlog({
    String comment,
    String blogUID,
    String userId,
  }) async {
    String commentID;
    Uuid uuid = Uuid();
    commentID = uuid.v1();
    int timeStamp = currentDateTime.microsecondsSinceEpoch;
    String month = monthFormat.getMonth(currentDateTime.month);
    CollectionReference addComment = firebaseFirestore.collection("Comments");
    DocumentSnapshot<Map<String, dynamic>> variable =
        await FirebaseFirestore.instance.collection('Users').doc(userId).get();
    await addComment.doc(commentID).set({
      "CommentUserName": variable.data()["DisplayName"],
      "CommentUserPhoto": variable.data()["PhotoUrl"],
      "Comment": comment,
      "BlogUID": blogUID,
      "CommentPersonID": userId,
      "CommentID": commentID,
      "TimeStamp": timeStamp,
      "DateTime": "$month ${currentDateTime.day} ${currentDateTime.year}",
    });
  }
}
