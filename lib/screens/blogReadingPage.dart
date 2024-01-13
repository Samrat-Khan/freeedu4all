import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:education_community/routes/routeDataPass.dart';
import 'package:education_community/services/firebaseUpdataDeleteData.dart';
import 'package:education_community/services/timeCalCulations.dart';
import 'package:education_community/services/user_service.dart';
import 'package:education_community/widgets/textStyle.dart';
import 'package:flutter/material.dart';

class BlogReadingPage extends StatefulWidget {
  final String blogUID, blogOwnerID;

  BlogReadingPage({
    this.blogUID,
    this.blogOwnerID,
  });
  @override
  _BlogReadingPageState createState() => _BlogReadingPageState();
}

class _BlogReadingPageState extends State<BlogReadingPage> {
  bool _isLiked, _isBookmarkChecked;
  int countLike = 0, min;
  String currentUserId;
  MicroToMin microToMin = MicroToMin();
  @override
  void initState() {
    super.initState();
    currentUserId = firebaseAuth.currentUser.uid;
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
          DocumentSnapshot<Map<String, dynamic>> ds = snapshot.data;

          _isLiked = ds.data()["Likes"][currentUserId] ??= false;
          min = microToMin.minConvert(ds.data()["TimeStamp"]);
          _isBookmarkChecked = ds.data()["Bookmark"][currentUserId] ??= false;

          return CustomScrollView(
            slivers: [
              sliverAppBar(ds),
              SliverFillRemaining(
                hasScrollBody: false,
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            ds.data()["BlogTitle"],
                            style: kReadingBlogTitle,
                          ),
                          SizedBox(height: 15),
                          rowOfLikesAndTime(ds),
                          SizedBox(height: 15),
                          rowOfPhotoAndName(ds),
                          SizedBox(height: 15),
                          SelectableText(
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

  FirebaseUpdateDeleteData _firebaseServiceUpdateData =
      FirebaseUpdateDeleteData();
  Future handelLike(DocumentSnapshot<Map<String, dynamic>> ds) async {
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

  Future handelBookmark(DocumentSnapshot<Map<String, dynamic>> ds) async {
    _isBookmarkChecked = ds.data()["Bookmark"][currentUserId] == true;
    if (_isBookmarkChecked) {
      setState(() {
        _isBookmarkChecked = false;
      });
      await _firebaseServiceUpdateData.handelBookmark(
        blogUid: widget.blogUID,
        isBookmarkChecked: _isBookmarkChecked,
        currentUserID: currentUserId,
      );
    } else {
      setState(() {
        _isBookmarkChecked = true;
      });
      await _firebaseServiceUpdateData.handelBookmark(
        blogUid: widget.blogUID,
        isBookmarkChecked: _isBookmarkChecked,
        currentUserID: currentUserId,
      );
    }
  }

  rowOfLikesAndTime(ds) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(Icons.access_time_sharp),
        SizedBox(width: 5),
        Text(
          min >= 0 && min <= 60
              ? "$min min"
              : (min ~/ 60) > 24
                  ? ds.data()["DateTime"]
                  : "${min ~/ 60} hrs",
          style: kReadingBlogTimeLike,
        ),
        SizedBox(width: 50),
        IconButton(
            icon: _isLiked ? kFillHeartIcon : kHeartIcon,
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

  rowOfPhotoAndName(ds) {
    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(50),
          child: FadeInImage(
            height: 30,
            width: 30,
            fit: BoxFit.cover,
            placeholder: AssetImage("images/profile.png"),
            image: NetworkImage(ds.data()["BlogOwnerPhotoUrl"]),
          ),
        ),
        SizedBox(width: 15),
        Text(
          ds.data()["BlogOwnerName"],
          style: kReadingBlogAuthor,
        ),
      ],
    );
  }

  SliverAppBar sliverAppBar(DocumentSnapshot<Map<String, dynamic>> ds) {
    return SliverAppBar(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      expandedHeight: 200,
      pinned: false,
      floating: true,
      leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_rounded),
          onPressed: () => Navigator.pop(context)),
      actions: [
        IconButton(
            icon: Icon(_isBookmarkChecked
                ? Icons.bookmark_rounded
                : Icons.bookmark_outline_rounded),
            onPressed: () {
              handelBookmark(ds);
            }),
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
                  image: ds.data()["BlogPhotoUrl"] == null
                      ? AssetImage("images/home.png")
                      : NetworkImage(ds.data()["BlogPhotoUrl"]),
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
      child: kFABComment,
      backgroundColor: Colors.white,
      onPressed: () {
        Navigator.pushNamed(
          context,
          "CommentPage",
          arguments: BlogReadToComment(
            blogUID: widget.blogUID,
          ),
        );
      },
    );
  }
}
