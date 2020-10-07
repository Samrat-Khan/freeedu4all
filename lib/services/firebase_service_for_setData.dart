import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:education_community/services/user_service.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

import 'timeCalCulations.dart';

class FirebaseServiceSetData {
  FirebaseStorage firebaseStorage = FirebaseStorage();
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  String uploadPhotoLink;
  var currentDateTime = DateTime.now();
  MonthFormat monthFormat = MonthFormat();

  Future<String> uploadUserProfilePhotoToFireStorage(
      File fileImage, String userUniqueId) async {
    final StorageReference storageReference = firebaseStorage
        .ref()
        .child("UserImage/$userUniqueId/$userUniqueId.jpg");
    final StorageUploadTask uploadTask = storageReference.putFile(fileImage);
    await uploadTask.onComplete;
    uploadPhotoLink = await storageReference.getDownloadURL();

    return uploadPhotoLink;
  }

  Future updateUserDataToFirebase(
      {String fullName,
      String displayName,
      String photoUrl,
      String userEmail,
      String userType,
      String aboutUser,
      String uid,
      String userID}) async {
    CollectionReference userData = firebaseFirestore.collection("Users");
    await userData.doc(uid).set({
      "Name": fullName,
      "DisplayName": displayName,
      "Email": userEmail,
      "UserType": userType,
      "About": aboutUser,
      "PhotoUrl": photoUrl,
      "UserID": userID,
      "UserUID": uid,
    });
  }

  Future<String> uploadBlogPhotoToFireStorage(
      File fileImage, String userUniqueId, String blogUniqueId) async {
    final StorageReference storageReference = firebaseStorage
        .ref()
        .child("PostImage/$userUniqueId/$blogUniqueId.jpg");
    final StorageUploadTask uploadTask = storageReference.putFile(fileImage);
    await uploadTask.onComplete;
    uploadPhotoLink = await storageReference.getDownloadURL();
    return uploadPhotoLink;
  }

  Future updateBlogDataToFirebase({
    String blogTitle,
    String blogPhotoUrl,
    String blogUid,
    String blogType,
    String blogDetail,
    int timeStamp,
  }) async {
    String month = monthFormat.getMonth(currentDateTime.month);

    DocumentSnapshot variable = await FirebaseFirestore.instance
        .collection('Users')
        .doc(currentUser.uid)
        .get();
    CollectionReference blogData = firebaseFirestore.collection("Blog");

    await blogData.doc(blogUid).set({
      "BlogOwnerId": currentUser.uid,
      "BlogOwnerName": variable.data()["DisplayName"],
      "BlogTitle": blogTitle,
      "BlogDetail": blogDetail,
      "BlogType": blogType,
      "BlogPhotoUrl": blogPhotoUrl,
      "BlogUid": blogUid,
      "TimeStamp": timeStamp,
      "DateTime": "$month ${currentDateTime.day} ${currentDateTime.year}",
      "TotalLikes": 0,
      "Likes": {},
    });
  }

  Future blogAuthorDetail(String id) async {
    String name;
    DocumentSnapshot variable =
        await FirebaseFirestore.instance.collection('Users').doc(id).get();
    name = variable.data()["PhotoUrl"];
    return name;
  }

  Future saveBlogAsDraft({
    String blogTitle,
    String blogPhotoUrl,
    String blogUid,
    String blogType,
    String blogDetail,
    int timeStamp,
  }) async {
    String month = monthFormat.getMonth(currentDateTime.month);
    CollectionReference draftBlog = firebaseFirestore.collection("DraftBlog");
    await draftBlog.doc(blogUid).set({
      "BlogOwnerId": currentUser.uid,
      "BlogTitle": blogTitle,
      "BlogDetail": blogDetail,
      "BlogType": blogType,
      "BlogPhotoUrl": blogPhotoUrl,
      "BlogUid": blogUid,
      "TimeStamp": timeStamp,
      "DateTime": "$month ${currentDateTime.day} ${currentDateTime.year}",
    });
  }

  Future addCommentToBlog({
    String comment,
    String blogUID,
    String commentPersonId,
  }) async {
    String commentID;
    Uuid uuid = Uuid();
    commentID = uuid.v1();
    int timeStamp = currentDateTime.microsecondsSinceEpoch;
    String month = monthFormat.getMonth(currentDateTime.month);
    CollectionReference addComment = firebaseFirestore.collection("Comments");
    await addComment.doc(commentID).set({
      "Comment": comment,
      "BlogUID": blogUID,
      "CommentPersonID": commentPersonId,
      "CommentID": commentID,
      "TimeStamp": timeStamp,
      "DateTime": "$month ${currentDateTime.day} ${currentDateTime.year}",
    });
  }
}
