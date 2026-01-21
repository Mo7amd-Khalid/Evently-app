
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthServices {
  static FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  static Future<void> logout()async {
    await firebaseAuth.signOut();
  }

  static Future<void> updateImageProfile(String photoURL) async{
    await firebaseAuth.currentUser?.updatePhotoURL(photoURL);
  }
  static User? getUserData(){
    return firebaseAuth.currentUser;
  }

}