import 'dart:io';

import 'package:education_community/screens/bottomAppBar.dart';
import 'package:education_community/services/firebase_service_for_setData.dart';
import 'package:education_community/services/photo_picker.dart';
import 'package:education_community/services/user_service.dart';
import 'package:education_community/widgets/textStyle.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:uuid/uuid.dart';

class BlogPost extends StatefulWidget {
  @override
  _BlogPostState createState() => _BlogPostState();
}

class _BlogPostState extends State<BlogPost> {
  String blogTitle, blogDetail;
  String blogPhotoUrl, currentUserId;
  File imageFile;
  String _result = "Solution";
  int _radioValue = 0;
  bool fieldIsEmpty;
  String blogId = Uuid().v4();
  TextEditingController _titleTextController = TextEditingController();
  TextEditingController _detailTextController = TextEditingController();
  final PageController _page = PageController();
  int timeStamp = DateTime.now().microsecondsSinceEpoch;
  bool _inAsyncCall = false;
  bool isSelected = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fieldIsEmpty = true;
    currentUserId = firebaseAuth.currentUser.uid;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _detailTextController.dispose();
    _titleTextController.dispose();
    _page.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var _height = MediaQuery.of(context).size.height;
    var _width = MediaQuery.of(context).size.width;

    return ModalProgressHUD(
      inAsyncCall: _inAsyncCall,
      child: scaffoldForBlogWriting(_width, _height),
    );
  }

  ///Here User write His/Her Article
  Scaffold scaffoldForBlogWriting(double _width, double _height) {
    return Scaffold(
      appBar: postAppBar(),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            photoUploadContainer(_width, _height),
            SizedBox(
              height: 10,
            ),
            postTypeSelectRow(),
            SizedBox(
              height: 10,
            ),
            postTitleWriteBox(),
            SizedBox(
              height: 25,
            ),
            postDetailWriteBox(),
          ],
        ),
      ),
    );
  }

  AppBar postAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      automaticallyImplyLeading: false,
      title: Text(
        "Write Post",
        style: kBlogUploadTitle,
      ),
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios_rounded, color: Colors.black),
        onPressed: () {
          imageFile = null;
          Navigator.pop(context);
        },
      ),
      actions: [
        IconButton(
          icon: Icon(
            Icons.cloud_upload,
            color: Colors.black,
          ),
          onPressed: () {
            fieldIsEmpty = checkAllFieldAreFullOrNot();
            showDialog(
              context: context,
              builder: (_) => AlertDialog(
                content: fieldIsEmpty
                    ? Text(
                        "One Or More Field Is Empty",
                        style: kWarningText,
                      )
                    : null,
                actions: [
                  OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      backgroundColor: Colors.black,
                    ),
                    onPressed: fieldIsEmpty ? null : dataUploadToFirebase,
                    label: Text("Upload"),
                    icon: Icon(Icons.upload_outlined),
                  ),
                  OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      backgroundColor: Colors.black,
                    ),
                    onPressed: draftBlogDataToFirebase,
                    label: Text("Save As Draft"),
                    icon: Icon(Icons.drafts_outlined),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  InkWell photoUploadContainer(double _width, double _height) {
    return InkWell(
      onTap: imagePicFromGallery,
      child: Container(
        width: _width,
        height: _height / 5,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: imageFile != null
                ? FileImage(imageFile)
                : AssetImage("images/post.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Container(
            child: Text(
              "Click To Upload a Photo",
              style: kBlogPostStyle,
            ),
            decoration: BoxDecoration(color: Colors.white.withOpacity(0.5)),
          ),
        ),
      ),
    );
  }

  Container postTitleWriteBox() {
    return Container(
      padding: EdgeInsets.fromLTRB(10, 2, 10, 2),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          border: Border.all(color: Colors.black)),
      child: TextField(
        decoration: InputDecoration(
          hintText: "What is Dark Matter ?",
          labelText: "Title of Your Post",
          labelStyle: TextStyle(color: Colors.black),
          border: InputBorder.none,
        ),
        textInputAction: TextInputAction.next,
        controller: _titleTextController,
        onChanged: (String text) {
          blogTitle = text;
        },
      ),
    );
  }

  Container postDetailWriteBox() {
    return Container(
      padding: EdgeInsets.fromLTRB(10, 2, 10, 2),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          border: Border.all(color: Colors.black)),
      child: TextField(
        decoration: InputDecoration(
          hintText: "All about Dark Matter....",
          labelText: "Detail of Your Post",
          labelStyle: TextStyle(color: Colors.black),
          border: InputBorder.none,
        ),
        //  textInputAction: TextInputAction.done,
        maxLength: 10000,
        maxLines: 10,
        controller: _detailTextController,
        onChanged: (String text) {
          blogDetail = text;
        },
      ),
    );
  }

  Row postTypeSelectRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Radio(
            activeColor: Colors.black,
            value: 0,
            groupValue: _radioValue,
            onChanged: _handleRadioValueChange),
        Text(
          "Fix",
          style: kBlogPostStyle,
        ),
        Radio(
            activeColor: Colors.black,
            value: 1,
            groupValue: _radioValue,
            onChanged: _handleRadioValueChange),
        Text(
          "Info",
          style: kBlogPostStyle,
        ),
        Radio(
            activeColor: Colors.black,
            value: 2,
            groupValue: _radioValue,
            onChanged: _handleRadioValueChange),
        Text(
          "Help",
          style: kBlogPostStyle,
        ),
        Radio(
            activeColor: Colors.black,
            value: 3,
            groupValue: _radioValue,
            onChanged: _handleRadioValueChange),
        Text(
          "Giveaway",
          style: kBlogPostStyle,
        ),
      ],
    );
  }

  FirebaseSetData fireBaseService = FirebaseSetData();
  PhotoPicker photoPicker = PhotoPicker();

  /// Handeling Radio Button Values
  void _handleRadioValueChange(int value) {
    setState(() {
      _radioValue = value;

      switch (_radioValue) {
        case 0:
          _result = "Solution";

          break;
        case 1:
          _result = "Information";

          break;
        case 2:
          _result = "Help";

          break;
        case 3:
          _result = "Giveaway";

          break;
      }
    });
  }

  /// Checking if any filed.isEmpty ? Drafting the blog : Publishing blog
  /// Field mean all include image but  not radio it's default have a value of "FIX"
  bool checkAllFieldAreFullOrNot() {
    if (_titleTextController.text.isEmpty ||
        _detailTextController.text.isEmpty ||
        imageFile == null) {
      return true;
    } else {
      return false;
    }
  }

  ///Data Upload To firebaseFirestore
  dataUploadToFirebase() async {
    ///whatBlog : Publish
    setState(() {
      _inAsyncCall = true;
    });
    try {
      Navigator.pop(context);
      fireBaseService
          .uploadBlog(
        whatBlog: "Publish",
        blogUid: blogId,
        blogDetail: blogDetail,
        blogTitle: blogTitle,
        fileImage: imageFile,
        blogType: _result,
        timeStamp: timeStamp,
        userId: currentUserId,
      )
          .whenComplete(
        () {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => BottomNavigationAppBar()),
              (route) => false);
        },
      );
      setState(() {
        _inAsyncCall = false;
      });
    } catch (e) {
      setState(() {
        _inAsyncCall = false;
      });
    }
  }

  ///Data Upload To firebaseFirestore as Draft Collection
  draftBlogDataToFirebase() async {
    setState(() {
      _inAsyncCall = true;
    });

    /// whatBlog : Draft
    await fireBaseService
        .uploadBlog(
      whatBlog: "Draft",
      userId: currentUserId,
      timeStamp: timeStamp,
      blogType: _result,
      blogTitle: blogTitle,
      blogDetail: blogDetail,
      blogUid: blogId,
      fileImage: imageFile,
    )
        .whenComplete(
      () {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => BottomNavigationAppBar()),
            (route) => false);
      },
    );
    setState(() {
      _inAsyncCall = false;
    });
  }

  imagePicFromGallery() async {
    imageFile = await photoPicker.pickImageFromGallery();
  }
}
