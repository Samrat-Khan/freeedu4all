import 'package:cloud_firestore/cloud_firestore.dart';

class CountLikes {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future countLike({String blogOwnerId}) async {
    num countTotalLike = 0;
    var getLikes = await firestore
        .collection("Blog")
        .where("BlogOwnerId", isEqualTo: blogOwnerId)
        .get();
    for (int i = 0; i < getLikes.docs.length; i++) {
      countTotalLike = getLikes.docs[i].data()["TotalLikes"] + countTotalLike;
    }
    return countTotalLike;
  }
}

class CountComments {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  Future countComment(String blogUID) async {
    var getComments = await firestore
        .collection("Comments")
        .where("BlogUID", isEqualTo: blogUID)
        .get();
    return getComments.docs.length;
  }
}
