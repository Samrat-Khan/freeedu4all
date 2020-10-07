import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:education_community/screens/editProfilePage.dart';
import 'package:education_community/screens/settingsPage.dart';
import 'package:education_community/services/countLikeComment.dart';
import 'package:education_community/services/user_service.dart';
import 'package:education_community/widgets/loadingWidget.dart';
import 'package:education_community/widgets/textStyle.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyProfilePage extends StatefulWidget {
  @override
  _MyProfilePageState createState() => _MyProfilePageState();
}

class _MyProfilePageState extends State<MyProfilePage> {
  String currentUserDisplayName, currentUserPhotoUrl;
  int countTotalPost, countTotalLikes, countTotalComment;
  List _tab = ["Publish", "Draft"];
  TabController _tabController;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  CountLikes _countLikes = CountLikes();
  CountComments _comments = CountComments();
  Future getCurrentUserData() async {
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection("Users")
        .doc(googleSignIn.currentUser.id)
        .get();
    currentUserDisplayName = snapshot.data()["DisplayName"];
    currentUserPhotoUrl = snapshot.data()["PhotoUrl"];

    FirebaseFirestore firestore = FirebaseFirestore.instance;
    var getPost = await firestore
        .collection("Blog")
        .where("BlogOwnerId", isEqualTo: googleSignIn.currentUser.id)
        .get();
    countTotalPost = getPost.docs.length;
    countTotalLikes = await _countLikes.countLike();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _tab.length,
      initialIndex: 0,
      child: SafeArea(
        child: Scaffold(
          appBar: currentUserAppBarData(),
          body: TabBarView(
            controller: _tabController,
            children: [currentUserPublishedPost(), currentUserDraftPost()],
          ),
        ),
      ),
    );
  }

  PreferredSize currentUserAppBarData() {
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
        flexibleSpace: FutureBuilder(
          future: getCurrentUserData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: LoadingWidget());
            }
            return Padding(
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
                          backgroundImage: NetworkImage(currentUserPhotoUrl),
                        ),
                        SizedBox(height: 10),
                        Text(currentUserDisplayName),
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
                        Row(
                          children: [
                            Text(countTotalPost.toString()),
                            SizedBox(width: 25),
                            Text(countTotalLikes.toString()),
                          ],
                        ),
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
            );
          },
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
            .where("BlogOwnerId", isEqualTo: googleSignIn.currentUser.id)
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
              .where("BlogOwnerId", isEqualTo: googleSignIn.currentUser.id)
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
                            height: _height / 4,
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
                            child: Text(
                              ds.data()["DateTime"],
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
