import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';


class AuthClass {

  FirebaseAuth auth = FirebaseAuth.instance;

  //Create Account
  Future createAccount({ required String email, required String password}) async {

  try {
  await auth.createUserWithEmailAndPassword(
    email: email,
    password: password,
  );
  return 'Account Created';
} on FirebaseAuthException catch (e) {
  if (e.code == 'weak-password') {
    return 'The password provided is too weak.';
  } else if (e.code == 'email-already-in-use') {
    return 'The account already exists for that email.';
  }
} catch (e) {
  return "Error Occurred";
 }
}
  //Sign in user
 Future signIN({ required String email, required String password}) async {
    try {
   await auth.signInWithEmailAndPassword(
    email: email,
    password: password,
  );
  return 'Welcome';
} on FirebaseAuthException catch (e) {
  if (e.code == 'user-not-found') {
    return'No user found for that email.';
  } else if (e.code == 'wrong-password') {
    return 'Wrong password provided for that user.';
  }
 }
}

  //Reset Password
  Future<String> restPassword({ required String email}) async {
    try {
   await auth.sendPasswordResetEmail(
    email: email,
  );
  return 'Email sent';

  }catch(e) {
     return 'Error Occurred';
  }
}

  //Sign out user
  void signOut() {
    auth.signOut();
  }

  //Google Auth
    Future<UserCredential> signInWithGoogle() async {
  // Trigger the authentication flow
  final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

  // Obtain the auth details from the request
  final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

  // Create a new credential
  final credential = GoogleAuthProvider.credential(
    accessToken: googleAuth?.accessToken,
    idToken: googleAuth?.idToken,
  );

  // Once signed in, return the UserCredential
  return await FirebaseAuth.instance.signInWithCredential(credential);
}


  //Facebook
    Future<UserCredential> signInWithFacebook() async {
  // Trigger the sign-in flow
  final LoginResult loginResult = await FacebookAuth.instance.login();

  // Create a credential from the access token
  final OAuthCredential facebookAuthCredential = FacebookAuthProvider.credential(loginResult.accessToken!.token);

  // Once signed in, return the UserCredential
  return FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
}
}
