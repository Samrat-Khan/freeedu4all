import 'dart:io';

import 'package:education_community/services/firebaseUpdataDeleteData.dart';
import 'package:education_community/services/photo_picker.dart';
import 'package:education_community/services/user_service.dart';
import 'package:education_community/widgets/textStyle.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class BlogEditPage extends StatefulWidget {
  final String blogUid, blogTitle, blogDetail, blogPhoto, blogType;
  BlogEditPage(
      {this.blogPhoto,
      this.blogType,
      this.blogDetail,
      this.blogTitle,
      this.blogUid});
  @override
  _BlogEditPageState createState() => _BlogEditPageState();
}

class _BlogEditPageState extends State<BlogEditPage> {
  File fileImage;
  String currentUserId;
  String _result = "Solution";
  int _radioValue = 0;
  TextEditingController _titleController;
  TextEditingController _detailController;
  bool _inAsyncCall = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    currentUserId = firebaseAuth.currentUser.uid;
    _detailController = TextEditingController();
    _titleController = TextEditingController();
    _titleController.text = widget.blogTitle;
    _detailController.text = widget.blogDetail;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _titleController.dispose();
    _detailController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var _height = MediaQuery.of(context).size.height;
    var _width = MediaQuery.of(context).size.width;
    return ModalProgressHUD(
      inAsyncCall: _inAsyncCall,
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: Text(
              "Edit Post",
              style: kSettingTitle,
            ),
            leading: IconButton(
                icon: Icon(
                  Icons.arrow_back_ios_rounded,
                  color: Colors.black,
                ),
                onPressed: () => Navigator.pop(context)),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                InkWell(
                  onTap: () => pickImage(),
                  child: Container(
                    width: _width,
                    height: _height / 4,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: fileImage == null
                            ? widget.blogPhoto != null
                                ? NetworkImage(widget.blogPhoto)
                                : AssetImage("images/home.png")
                            : FileImage(fileImage),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Text("Click To Change Photo"),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(10),
                  child: TextField(
                    controller: _titleController,
                    decoration: InputDecoration(
                      hintText: "Blog Title",
                      labelText: "Blog Title",
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          width: 1.5,
                        ),
                      ),
                    ),
                  ),
                ),
                widget.blogType == "Draft"
                    ? Row(
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
                      )
                    : SizedBox(height: 1),
                Container(
                  padding: EdgeInsets.all(10),
                  child: TextField(
                    controller: _detailController,
                    maxLines: 10,
                    maxLength: 10000,
                    decoration: InputDecoration(
                      hintText: "Blog Detail",
                      labelText: "Blog Detail",
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          width: 1.5,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
                widget.blogType != "Draft"
                    ? RaisedButton(
                        child: Text(
                          "Update",
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: updatePublishBlog,
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          RaisedButton(
                            child: Text(
                              "Update Draft",
                              style: TextStyle(color: Colors.white),
                            ),
                            onPressed: updateDraftBlog,
                          ),
                          RaisedButton(
                            child: Text(
                              "Publish",
                              style: TextStyle(color: Colors.white),
                            ),
                            onPressed: publishDraftBlog,
                          ),
                        ],
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  PhotoPicker _photoPicker = PhotoPicker();
  FirebaseUpdateDeleteData _updateDeleteData = FirebaseUpdateDeleteData();
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

  pickImage() async {
    fileImage = await _photoPicker.pickImageFromGallery();
  }

  updatePublishBlog() async {
    setState(() {
      _inAsyncCall = true;
    });
    await _updateDeleteData
        .updatePublishPost(
      blogTitle: _titleController.text,
      blogDetail: _detailController.text,
      blogUid: widget.blogUid,
      fileImage: fileImage,
      userId: currentUserId,
    )
        .whenComplete(() {
      Navigator.pop(context);
      setState(() {
        _inAsyncCall = false;
      });
    });
  }

  updateDraftBlog() async {
    setState(() {
      _inAsyncCall = true;
    });
    await _updateDeleteData
        .draftPostUpdate(
      blogTitle: _titleController.text,
      blogDetail: _detailController.text,
      blogUid: widget.blogUid,
      fileImage: fileImage,
      userId: currentUserId,
    )
        .whenComplete(() {
      Navigator.pop(context);
      setState(() {
        _inAsyncCall = false;
      });
    });
  }

  publishDraftBlog() async {
    setState(() {
      _inAsyncCall = true;
    });
    await _updateDeleteData
        .publishDraftBlog(
      blogTitle: _titleController.text,
      blogDetail: _detailController.text,
      blogUid: widget.blogUid,
      fileImage: fileImage,
      userId: currentUserId,
      blogType: _result,
    )
        .whenComplete(() {
      Navigator.pop(context);
      setState(() {
        _inAsyncCall = false;
      });
    });
  }
}
