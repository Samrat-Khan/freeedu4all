import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:education_community/screens/editProfilePage.dart';
import 'package:education_community/screens/settingsPage.dart';
import 'package:education_community/services/countLikeComment.dart';
import 'package:education_community/services/user_service.dart';
import 'package:education_community/widgets/textStyle.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyProfilePage extends StatefulWidget {
  @override
  _MyProfilePageState createState() => _MyProfilePageState();
}

class _MyProfilePageState extends State<MyProfilePage> {
  String currentUserDisplayName, currentUserPhotoUrl, currentUserId;
  int countTotalPost, countTotalLikes, countTotalComment;
  List _tab = ["Publish", "Draft"];
  TabController _tabController;
  @override
  void initState() {
    super.initState();
    currentUserId = firebaseAuth.currentUser.uid;
  }

  CountLikes _countLikes = CountLikes();
  CountComments _comments = CountComments();
  Future getCurrentUserData() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    var getLike = await firestore
        .collection("Blog")
        .where("BlogOwnerId", isEqualTo: currentUserId)
        .get();
    countTotalPost = getLike.docs.length;
    countTotalLikes = await _countLikes.countLike(blogOwnerId: currentUserId);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _tab.length,
      initialIndex: 0,
      child: SafeArea(
        child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection("Users")
                .doc(currentUserId)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Scaffold(
                  body: Text("Text......"),
                );
              }
              DocumentSnapshot ds = snapshot.data;

              return Scaffold(
                appBar: currentUserAppBarData(
                  userPhotoUrl: ds.data()["PhotoUrl"],
                  userDisplayName: ds.data()["DisplayName"],
                ),
                body: TabBarView(
                  controller: _tabController,
                  children: [
                    currentUserPublishedPost(),
                    currentUserDraftPost()
                  ],
                ),
              );
            }),
      ),
    );
  }

  PreferredSize currentUserAppBarData(
      {String userPhotoUrl, String userDisplayName}) {
    // print("Calling Photo URL ${ds.data()["PhotoUrl"]}");
    // print("Calling Display Name ${ds.data()["DisplayName"]}");
    return PreferredSize(
      preferredSize: Size.fromHeight(210),
      child: AppBar(
        bottom: TabBar(
          tabs: [
            Tab(
              child: Text("Published"),
            ),
            Tab(
              child: Text("Draft"),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              Navigator.pushNamed(
                context,
                "SettingsPage",
                arguments: SettingsPage(),
              );
            },
          ),
        ],
        flexibleSpace: Padding(
          padding: EdgeInsets.only(top: 40),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 36,
                      backgroundColor: Colors.limeAccent,
                      backgroundImage: userPhotoUrl != null
                          ? NetworkImage(userPhotoUrl)
                          : AssetImage("images/google.png"),
                    ),
                    SizedBox(height: 10),
                    Text(userDisplayName),
                  ],
                ),
              ),
              Container(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text("Posts"),
                        SizedBox(width: 25),
                        Text("Likes"),
                      ],
                    ),
                    SizedBox(height: 15),
                    FutureBuilder(
                        future: getCurrentUserData(),
                        builder: (context, snapshot) {
                          return Row(
                            children: [
                              Text(countTotalPost.toString()),
                              SizedBox(width: 25),
                              Text(countTotalLikes.toString()),
                            ],
                          );
                        }),
                    SizedBox(height: 15),
                    OutlineButton.icon(
                      label: Text("Edit Profile"),
                      icon: Icon(
                        Icons.edit,
                        size: 15,
                      ),
                      color: Colors.green,
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          "EditProfilePage",
                          arguments: EditProfilePage(),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Container currentUserPublishedPost() {
    var _height = MediaQuery.of(context).size.height;
    var _width = MediaQuery.of(context).size.width;
    return Container(
      child: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("Blog")
            .where("BlogOwnerId", isEqualTo: currentUserId)
            .orderBy("TimeStamp", descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: Text("No Data",
                  style: TextStyle(fontWeight: FontWeight.bold)),
            );
          }
          return ListView.builder(
            itemCount: snapshot.data.documents.length,
            itemBuilder: (context, index) {
              DocumentSnapshot ds = snapshot.data.documents[index];

              return Padding(
                padding: const EdgeInsets.all(10.0),
                child: Card(
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          width: _width,
                          height: _height / 6,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            image: DecorationImage(
                              image: NetworkImage(ds.data()["BlogPhotoUrl"]),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Container(
                          width: _width,
                          height: _height / 15,
                          padding: EdgeInsets.only(top: 5, left: 10),
                          child: Text(
                            ds.data()["BlogTitle"],
                            style: kCurrentUserBlogTitle,
                            overflow: TextOverflow.fade,
                          ),
                        ),
                        Container(
                          height: _height / 18,
                          width: _width,
                          padding: EdgeInsets.only(top: 5, left: 10),
                          child: Row(
                            children: [
                              Icon(Icons.thumb_up),
                              Text("10"),
                              SizedBox(width: 20),
                              Icon(Icons.comment),
                              Text("10"),
                              Spacer(),
                              IconButton(
                                  icon: Icon(Icons.edit_rounded),
                                  onPressed: null),
                              IconButton(
                                  icon: Icon(Icons.delete_forever),
                                  onPressed: null),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Container currentUserDraftPost() => Container(
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("DraftBlog")
              .where("BlogOwnerId", isEqualTo: currentUserId)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: Text("Loading....."),
              );
            }
            return ListView.builder(
              itemCount: snapshot.data.documents.length,
              itemBuilder: (context, index) {
                DocumentSnapshot ds = snapshot.data.documents[index];
                var _height = MediaQuery.of(context).size.height;
                // var _width = MediaQuery.of(context).size.width;
                return Padding(
                  padding: EdgeInsets.all(15),
                  child: Card(
                    child: Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: _height / 8,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: ds.data()["BlogPhotoUrl"] == null
                                    ? AssetImage("images/loading.gif")
                                    : NetworkImage(ds.data()["BlogPhotoUrl"]),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Container(
                            height: _height / 15,
                            padding: EdgeInsets.only(top: 5, left: 10),
                            child: Text(
                              ds.data()["BlogTitle"] == null
                                  ? "You Didn't Specify Title Yet "
                                  : ds.data()["BlogTitle"],
                              style: kCurrentUserBlogTitle,
                              overflow: TextOverflow.fade,
                            ),
                          ),
                          Container(
                            height: _height / 18,
                            padding: EdgeInsets.only(top: 5, left: 10),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text(
                                  ds.data()["DateTime"],
                                ),
                                Spacer(),
                                IconButton(
                                    icon: Icon(Icons.edit_rounded),
                                    onPressed: null),
                                IconButton(
                                    icon: Icon(Icons.delete_forever),
                                    onPressed: null),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      );
}
