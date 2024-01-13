import 'package:firebase_auth/firebase_auth.dart';

class LoginToNewUser {
  User user;
  LoginToNewUser(this.user);
}

class HomeToBlogRead {
  String? blogUID, blogOwnerID;
  HomeToBlogRead({this.blogUID, this.blogOwnerID});
}

class BlogReadToComment {
  String? blogUID;
  BlogReadToComment({this.blogUID});
}

class BlogToBlogEdit {
  String? blogUid, blogTitle, blogDetail, blogPhoto;
  BlogToBlogEdit(
      {this.blogUid, this.blogTitle, this.blogDetail, this.blogPhoto});
}

class DraftToDraftEdit {
  String? blogUid, blogTitle, blogDetail, blogPhoto;
  DraftToDraftEdit(
      {this.blogUid, this.blogTitle, this.blogDetail, this.blogPhoto});
}

class SettingToReadPrivacy {
  String? text;
  SettingToReadPrivacy({this.text});
}
