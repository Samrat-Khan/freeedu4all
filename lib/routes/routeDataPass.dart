import 'package:firebase_auth/firebase_auth.dart';

class LoginToNewUser {
  User user;
  LoginToNewUser(this.user);
}

class HomeToBlogRead {
  String blogUID, blogOwnerID;
  HomeToBlogRead({this.blogUID, this.blogOwnerID});
}

class BlogReadToComment {
  String blogUID;
  BlogReadToComment({this.blogUID});
}
