import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:education_community/services/firebase_service_forUpdataData.dart';
import 'package:education_community/services/timeCalCulations.dart';
import 'package:education_community/services/user_service.dart';
import 'package:education_community/widgets/textStyle.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'commentPage.dart';

class BlogReadingPage extends StatefulWidget {
  static const Route = "Blog_Read_Page";
  final String blogUID, blogOwnerID;

  BlogReadingPage({
    this.blogUID,
    this.blogOwnerID,
  });
  @override
  _BlogReadingPageState createState() => _BlogReadingPageState();
}

class _BlogReadingPageState extends State<BlogReadingPage> {
  bool _isLiked;
  int countLike = 0, min;
  String currentUserId;
  MicroToMin microToMin = MicroToMin();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    currentUserId = googleSignIn.currentUser.id;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: commentFAB(context),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("Blog")
            .doc(widget.blogUID)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Text("Loading....");
          }
          DocumentSnapshot ds = snapshot.data;

          _isLiked = ds.data()["Likes"][currentUserId] ??= false;
          min = microToMin.minConvert(ds.data()["TimeStamp"]);

          return CustomScrollView(
            shrinkWrap: true,
            slivers: [
              sliverAppBar(ds),
              SliverFillRemaining(
                hasScrollBody: false,
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(20),
                      child: Column(
                        children: [
                          Text(
                            ds.data()["BlogTitle"],
                            style: kReadingBlogTitle,
                          ),
                          SizedBox(height: 15),
                          rowOfLikesAndTime(ds),
                          SizedBox(height: 15),
                          // rowOfPhotoAndName(),
                          SizedBox(height: 15),
                          Text(
                            ds.data()["BlogDetail"],
                            style: kReadingBlogDetail,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  FirebaseServiceUpdateData _firebaseServiceUpdateData =
      FirebaseServiceUpdateData();
  Future handelLike(DocumentSnapshot ds) async {
    _isLiked = ds.data()["Likes"][currentUserId] == true;
    if (_isLiked == true) {
      setState(() {
        countLike = ds.data()["TotalLikes"] - 1;
        if (countLike < 0) {
          countLike = 0;
        }
        _isLiked = false;
      });
      await _firebaseServiceUpdateData.handelLikes(
          isLiked: _isLiked,
          currentUserID: currentUserId,
          blogUid: widget.blogUID,
          count: countLike);
    } else {
      setState(() {
        countLike = ds.data()["TotalLikes"] + 1;
        _isLiked = true;
      });
      await _firebaseServiceUpdateData.handelLikes(
          isLiked: _isLiked,
          currentUserID: currentUserId,
          blogUid: widget.blogUID,
          count: countLike);
    }
  }

  rowOfLikesAndTime(ds) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(Icons.access_time_sharp),
        SizedBox(width: 5),
        Text(
          min > 0 && min <= 60
              ? "$min min"
              : (min ~/ 60) > 24
                  ? ds.data()["DateTime"]
                  : "${min ~/ 60} hrs",
          style: kReadingBlogTimeLike,
        ),
        SizedBox(width: 50),
        IconButton(
            icon: _isLiked
                ? Icon(Icons.thumb_up)
                : Icon(Icons.thumb_up_alt_outlined),
            onPressed: () async {
              await handelLike(ds);
            }),
        SizedBox(width: 5),
        Text(
          ds.data()["TotalLikes"] == null
              ? "0"
              : ds.data()["TotalLikes"].toString(),
          style: kReadingBlogTimeLike,
        ),
      ],
    );
  }

  SliverAppBar sliverAppBar(DocumentSnapshot ds) {
    return SliverAppBar(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      expandedHeight: 200,
      pinned: true,
      actions: [
        IconButton(icon: Icon(Icons.bookmark), onPressed: null),
      ],
      flexibleSpace: Stack(
        children: [
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
                image: DecorationImage(
                  image: NetworkImage(ds.data()["BlogPhotoUrl"]),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  FloatingActionButton commentFAB(BuildContext context) {
    return FloatingActionButton(
      child: Icon(Icons.comment_outlined),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CommentPage(
              blogUID: widget.blogUID,
            ),
          ),
        );
      },
    );
  }
}
