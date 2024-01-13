import 'package:education_community/routes/routeDataPass.dart';
import 'package:education_community/screens/HomePage.dart';
import 'package:education_community/screens/aboutPrivacyPage.dart';
import 'package:education_community/screens/addNewUsersData.dart';
import 'package:education_community/screens/allDraftedPostPage.dart';
import 'package:education_community/screens/blogEditPage.dart';
import 'package:education_community/screens/blogReadingPage.dart';
import 'package:education_community/screens/bookmarkPage.dart';
import 'package:education_community/screens/bottomAppBar.dart';
import 'package:education_community/screens/commentPage.dart';
import 'package:education_community/screens/createNewBlog.dart';
import 'package:education_community/screens/editProfilePage.dart';
import 'package:education_community/screens/loginPage.dart';
import 'package:education_community/screens/myProfilePage.dart';
import 'package:education_community/screens/settingsPage.dart';
import 'package:flutter/material.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;
    switch (settings.name) {
      case "/LoginPage":
        return MaterialPageRoute(builder: (context) => LogInPage());
      case "ForgotPassword":
        return MaterialPageRoute(builder: (context) => ForgotPassword());

      case "AddNewUserDataPage":
        return MaterialPageRoute(builder: (context) {
          LoginToNewUser loginToNewUser = args as LoginToNewUser;
          return AddNewUsersData(
            user: loginToNewUser.user,
          );
        });
      case "Homepage":
        return MaterialPageRoute(builder: (context) => Homepage());
      case "BlogReadPage":
        return MaterialPageRoute(builder: (context) {
          HomeToBlogRead homeToBlogRead = args as HomeToBlogRead;
          return BlogReadingPage(
            blogUID: homeToBlogRead.blogUID!,
            blogOwnerID: homeToBlogRead.blogOwnerID!,
          );
        });
      case "CommentPage":
        return MaterialPageRoute(builder: (context) {
          BlogReadToComment blogReadToComment = args as BlogReadToComment;
          return CommentPage(
            blogUID: blogReadToComment.blogUID!,
          );
        });
      case "BlogPostPage":
        return MaterialPageRoute(builder: (context) => BlogPost());
      case "SettingsPage":
        return MaterialPageRoute(builder: (context) => SettingsPage());
      case "MyProfilePage":
        return MaterialPageRoute(builder: (context) => MyProfilePage());

      case "EditProfilePage":
        return MaterialPageRoute(builder: (context) => EditProfilePage());
      case "BookmarkPage":
        return MaterialPageRoute(builder: (context) => BookMarkPage());
      case "BottomAppBar":
        return MaterialPageRoute(
            builder: (context) => BottomNavigationAppBar());
      case "DraftPost":
        return MaterialPageRoute(builder: (context) => DraftPost());
      case "BlogEditPage":
        return MaterialPageRoute(builder: (context) {
          BlogToBlogEdit blogEdit = args as BlogToBlogEdit;

          return BlogEditPage(
            blogTitle: blogEdit.blogTitle!,
            blogDetail: blogEdit.blogDetail!,
            blogUid: blogEdit.blogUid!,
            blogPhoto: blogEdit.blogPhoto!,
          );
        });
      case "DraftBlogEditPage":
        return MaterialPageRoute(builder: (context) {
          DraftToDraftEdit blogEdit = args as DraftToDraftEdit;
          return BlogEditPage(
            blogTitle: blogEdit.blogTitle!,
            blogDetail: blogEdit.blogDetail!,
            blogUid: blogEdit.blogUid!,
            blogPhoto: blogEdit.blogPhoto!,
            blogType: "Draft",
          );
        });
      case "AboutPrivacyPage":
        return MaterialPageRoute(builder: (context) {
          SettingToReadPrivacy settingToReadPrivacy =
              args as SettingToReadPrivacy;
          return AboutPrivacyPage(
            text: settingToReadPrivacy.text!,
          );
        });
      default:
        return _errorPage(settings.name);
    }
  }

  static Route<dynamic> _errorPage(args) {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Error'),
        ),
        body: Center(
          child: Text(args.toString()),
        ),
      );
    });
  }
}
