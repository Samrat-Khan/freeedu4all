import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:education_community/screens/editProfilePage.dart';
import 'package:education_community/screens/settingsPage.dart';
import 'package:education_community/services/user_service.dart';
import 'package:education_community/widgets/textStyle.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyProfilePage extends StatefulWidget {
  static const Route = "My_Profile_Page";
  @override
  _MyProfilePageState createState() => _MyProfilePageState();
}

class _MyProfilePageState extends State<MyProfilePage> {
  String currentUserDisplayName, currentUserPhotoUrl;
  int countTotalPost, countTotalLikes;
  List _tab = ["Publish", "Draft"];
  TabController _tabController;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

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
        backgroundColor: Colors.red,
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SettingsPage(),
                ),
              );
            },
          ),
        ],
        flexibleSpace: FutureBuilder(
          future: getCurrentUserData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Text("Loading");
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
                            Text("Likes"),
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
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => EditProfilePage()),
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
              child: Text("Loading....."),
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
                          width: _width,
                          height: _height / 12,
                          padding: EdgeInsets.only(left: 15),
                          child: Row(
                            children: [
                              Icon(Icons.thumb_up_alt),
                              Text(ds.data()["TotalLikes"].toString()),
                              SizedBox(width: 15),
                              Icon(Icons.comment),
                              Text(ds.data()["TotalLikes"].toString()),
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
                var _width = MediaQuery.of(context).size.width;
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
