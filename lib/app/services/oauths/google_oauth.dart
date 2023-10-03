import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignInAPI {
  static final _googleSignIn = GoogleSignIn();
  static Future<GoogleSignInAccount?> signIn() => _googleSignIn.signIn();
  static Future signOut() => _googleSignIn.disconnect();
}
