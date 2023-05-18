import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleAuthService{

  static Future<UserCredential> signInWithGoogle(FirebaseAuth auth) async {
    // google sign in interface
    final googleSignIn = await GoogleSignIn().signIn();

    // get auth details from the request
    final googleAuth = await googleSignIn!.authentication;
    // create new user credential
    final userCredential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken
    );
    // sign in with that credential using firebase auth
    return await auth.signInWithCredential(userCredential);
  }

  static Future<void> signOut() async{
    GoogleSignIn().signOut();
  }
}