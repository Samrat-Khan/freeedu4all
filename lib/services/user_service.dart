import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn googleSignIn = GoogleSignIn();
User currentUser;
final StorageReference storageRef = FirebaseStorage.instance.ref();

class UserService {
  String name;
  String email;
  String imageUrl;
  Future<User> signInWithGoogle() async {
    final GoogleSignInAccount googleSignInAccount =
        await googleSignIn.signIn(); // await for Google SignIn
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication; // await for Google Auth
    final AuthCredential authCredential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    ); // For Authentication taking user id and access token and send to firebase
    final UserCredential userCredential = await _auth.signInWithCredential(
        authCredential); // get back signIn user Credentials
    final User user = userCredential.user; // get the user
    if (!user.isAnonymous) {
      // check sign in success or not and perform below operations
      assert(!user.isAnonymous);
      assert(await user.getIdToken() != null);
      assert(user.email != null);
      assert(user.displayName != null);
      assert(user.photoURL != null);
      final User currentUser = _auth.currentUser;
      assert(user.uid == currentUser.uid);
      name = user.displayName;
      imageUrl = user.photoURL;
      email = user.email;
    }
    return user;
  }

  Future<void> signOutFromGoogle() async {
    //  Sign Out
    await googleSignIn.signOut();
    print("User Signed Out");
  }
}
