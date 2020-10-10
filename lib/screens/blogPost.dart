import 'dart:io';

import 'package:education_community/providerServices/authUserProvider.dart';
import 'package:education_community/screens/bottomAppBar.dart';
import 'package:education_community/services/firebase_service_for_setData.dart';
import 'package:education_community/services/photo_picker.dart';
import 'package:education_community/services/user_service.dart';
import 'package:education_community/widgets/textStyle.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class BlogPost extends StatefulWidget {
  @override
  _BlogPostState createState() => _BlogPostState();
}

class _BlogPostState extends State<BlogPost> {
  String blogTitle, blogDetail;
  String blogPhotoUrl, currentUserId;
  File imageFile;
  String _result = "Fix";
  int _radioValue = 0;
  bool fieldIsEmpty;
  String blogId = Uuid().v4();
  TextEditingController _titleTextController = TextEditingController();
  TextEditingController _detailTextController = TextEditingController();
  int timeStamp = DateTime.now().microsecondsSinceEpoch;
  bool _inAsyncCall = false;

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
  }

  @override
  Widget build(BuildContext context) {
    var _height = MediaQuery.of(context).size.height;
    var _width = MediaQuery.of(context).size.width;

    return ModalProgressHUD(
      inAsyncCall: _inAsyncCall,
      child: Scaffold(
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
      ),
    );
  }

  AppBar postAppBar() {
    return AppBar(
      centerTitle: true,
      automaticallyImplyLeading: false,
      title: Text("Write Post"),
      leading: IconButton(
        icon: Icon(Icons.cancel),
        onPressed: () {
          imageFile = null;
          Navigator.pop(context);
        },
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.cloud_upload),
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
                  FlatButton.icon(
                    onPressed: fieldIsEmpty ? null : dataUploadToFirebase,
                    label: Text("Upload"),
                    icon: Icon(Icons.upload_outlined),
                  ),
                  FlatButton.icon(
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
                : AssetImage("images/no-image.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Container(
            child: Text("Click To Upload a Photo"),
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
            value: 0,
            groupValue: _radioValue,
            onChanged: _handleRadioValueChange),
        Text("Fix"),
        Radio(
            value: 1,
            groupValue: _radioValue,
            onChanged: _handleRadioValueChange),
        Text("Info"),
        Radio(
            value: 2,
            groupValue: _radioValue,
            onChanged: _handleRadioValueChange),
        Text("Help"),
        Radio(
            value: 3,
            groupValue: _radioValue,
            onChanged: _handleRadioValueChange),
        Text("Giveaway"),
      ],
    );
  }

  void _handleRadioValueChange(int value) {
    setState(() {
      _radioValue = value;

      switch (_radioValue) {
        case 0:
          _result = "Fix";

          break;
        case 1:
          _result = "Info";

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

  PhotoPicker photoPicker = PhotoPicker();
  bool checkAllFieldAreFullOrNot() {
    if (_titleTextController.text.isEmpty ||
        _detailTextController.text.isEmpty ||
        imageFile == null) {
      return true;
    } else {
      return false;
    }
  }

  dataUploadToFirebase() async {
    setState(() {
      _inAsyncCall = true;
    });
    FirebaseServiceSetData fireBaseService = FirebaseServiceSetData();
    blogPhotoUrl = await fireBaseService.uploadBlogPhotoToFireStorage(imageFile,
        Provider.of<UserProvider>(context, listen: false).user, blogId);
    fireBaseService
        .updateBlogDataToFirebase(
      blogTitle: blogTitle,
      blogDetail: blogDetail,
      blogUid: blogId,
      timeStamp: timeStamp,
      blogPhotoUrl: blogPhotoUrl,
      blogType: _result,
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
  }

  draftBlogDataToFirebase() async {
    setState(() {
      _inAsyncCall = true;
    });

    FirebaseServiceSetData fireBaseService = FirebaseServiceSetData();
    if (imageFile != null) {
      blogPhotoUrl = await fireBaseService.uploadBlogPhotoToFireStorage(
          imageFile, currentUserId, blogId);
    }

    fireBaseService
        .saveBlogAsDraft(
      blogDetail: blogDetail,
      blogTitle: blogTitle,
      blogPhotoUrl: blogPhotoUrl,
      blogType: _result,
      blogUid: blogId,
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
  }

  imagePicFromGallery() async {
    imageFile = await photoPicker.pickImageFromGallery();
  }
}
