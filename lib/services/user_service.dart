import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

class CheckUserExist {
  Future<bool> checkIfUserAlreadyExist(String uID) async {
    try {
      var colRef = FirebaseFirestore.instance.collection("Users");
      var doc = await colRef.doc(uID).get();
      return doc.exists;
    } catch (e) {
      throw e;
    }
  }
}

class EmailAuth {
  Future signUpWithEmail({String email, String password}) async {
    try {
      UserCredential user = await firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      return user.user;
    } on FirebaseAuthException catch (e) {
      print(e.message);
    }
  }

  Future signInWithEmail({String email, String password}) async {
    try {
      UserCredential user = await firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      return user.user;
    } on FirebaseAuthException catch (e) {
      print(e.message);
    }
  }

  Future signOut() async {
    await firebaseAuth.signOut();
  }

  Future getCurrentUser() async {
    User user = firebaseAuth.currentUser;
    return user;
  }

  Future verifyEmail() async {
    User user = firebaseAuth.currentUser;
    user.sendEmailVerification();
  }

  Future isEmailVerify() async {
    User user = firebaseAuth.currentUser;
    return user.emailVerified;
  }

  Future changeEmail({String newEmail}) async {
    User user = firebaseAuth.currentUser;
    user.updateEmail(newEmail).then((value) {
      verifyEmail();
    });
  }

  Future changePassword({String newPassword}) async {
    User user = firebaseAuth.currentUser;
    user.updatePassword(newPassword);
  }

  Future forgotPassword({String email}) async {
    await firebaseAuth.sendPasswordResetEmail(email: email);
    return null;
  }
}
