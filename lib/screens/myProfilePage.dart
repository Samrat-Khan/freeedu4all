import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:education_community/routes/routeDataPass.dart';
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
  String currentUserDisplayName,
      currentUserPhotoUrl,
      currentUserId,
      currentUserBio,
      currentUserEmail;
  int countTotalPost, countTotalLikes, countTotalComment;
  @override
  void initState() {
    super.initState();
    currentUserId = firebaseAuth.currentUser.uid;
  }

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  CountLikes _likes = CountLikes();
  Future getCurrentUserData() async {
    var getUserData =
        await firestore.collection("Users").doc(currentUserId).get();
    var getTotalPost = await firestore
        .collection("Blog")
        .where("BlogOwnerId", isEqualTo: currentUserId)
        .get();
    countTotalLikes = await _likes.countLike(blogOwnerId: currentUserId);
    countTotalPost = getTotalPost.docs.length;
    currentUserDisplayName = getUserData.data()["DisplayName"];
    currentUserPhotoUrl = getUserData.data()["PhotoUrl"];
    currentUserBio = getUserData.data()["About"];
    currentUserEmail = getUserData.data()["Email"];
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("Blog")
              .where("BlogOwnerId", isEqualTo: currentUserId)
              .orderBy("TimeStamp", descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Scaffold(
                body: Center(
                  child: LinearProgressIndicator(),
                ),
              );
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Scaffold(
                body: Center(
                  child: LinearProgressIndicator(),
                ),
              );
            }
            return Scaffold(
              body: CustomScrollView(
                slivers: [
                  sliverAppBarForUserData(),
                  sliverListForPublishedPost(snapshot),
                ],
              ),
            );
          }),
    );
  }

  SliverAppBar sliverAppBarForUserData() {
    return SliverAppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Colors.transparent,
      elevation: 0,
      expandedHeight: 200,
      centerTitle: true,
      collapsedHeight: 160,
      pinned: true,
      floating: true,
      flexibleSpace: FutureBuilder(
          future: getCurrentUserData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            return Card(
              child: Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: MediaQuery.of(context).size.height / 8,
                          width: MediaQuery.of(context).size.width / 4,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: FadeInImage(
                              fit: BoxFit.cover,
                              placeholder: AssetImage("images/google.png"),
                              image: NetworkImage(currentUserPhotoUrl),
                            ),
                          ),
                        ),
                        SizedBox(height: 15),
                        Text(
                          currentUserDisplayName,
                          style: kProfileUserName,
                        ),
                      ],
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width / 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            child: Text(
                              currentUserBio,
                              style: kCurrentUserBio,
                            ),
                          ),
                          Divider(
                            thickness: 2,
                            color: Colors.black,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: Row(
                              children: [
                                Text(
                                  "$countTotalPost Post",
                                  style: kLikePostStyle,
                                ),
                                SizedBox(width: 20),
                                Text(
                                  "$countTotalLikes Like",
                                  style: kLikePostStyle,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }

  SliverList sliverListForPublishedPost(AsyncSnapshot snapshot) {
    return SliverList(
      delegate: SliverChildListDelegate(
        List.generate(
          snapshot.data.documents.length,
          (index) {
            DocumentSnapshot ds = snapshot.data.documents[index];

            return Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: FadeInImage(
                      fit: BoxFit.cover,
                      placeholder: AssetImage("images/1.webp"),
                      image: NetworkImage(ds.data()["BlogPhotoUrl"]),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(5),
                    child: Text(
                      ds.data()["BlogTitle"],
                      style: kCurrentUserBlogTitle,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        child: Row(
                          children: [
                            kFillHeartIcon,
                            SizedBox(width: 5),
                            Text(ds.data()["TotalLikes"].toString()),
                            SizedBox(width: 20),
                            IconButton(
                                icon: kCommentIcon,
                                onPressed: () {
                                  Navigator.pushNamed(context, "CommentPage",
                                      arguments: BlogReadToComment(
                                          blogUID: ds.data()["BlogUid"]));
                                }),
                          ],
                        ),
                      ),
                      PopupMenuButton(itemBuilder: (context) {
                        return {"Edit", "Delete"}.map((String choice) {
                          return PopupMenuItem(
                            child: Text(choice),
                            value: choice,
                          );
                        }).toList();
                      }),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  handelSelect() {}
}
