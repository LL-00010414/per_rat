import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  //Google Sign in
  signInWithGoogle() async {
    //interactive sign in process
    final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();

    //obtain request
    final GoogleSignInAuthentication gAuth = await gUser!.authentication;
    //create new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: gAuth.accessToken,
      idToken: gAuth.idToken,
    );
    GoogleSignIn.games().currentUser;
    //finally, signing in
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }
}
