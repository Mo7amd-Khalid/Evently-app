
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthServices {
  static FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  static Future<UserCredential> registerUser(String name, String email, String password)async
  {
    var user = await firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
    await user.user!.updateDisplayName(name);
    await FirebaseFirestore.instance.collection("users").doc(user.user!.uid).set(
        {"email" : user.user!.email}
    );
    return user;
  }

  static Future<void> loginUser (String email, String password)async{
    await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
  }

  static Future<void> logout()async {
    await firebaseAuth.signOut();
  }

  static Future<void> updateImageProfile(String photoURL) async{
    await firebaseAuth.currentUser?.updatePhotoURL(photoURL);
  }
  static User? getUserData(){
    return firebaseAuth.currentUser;
  }

  static Future<bool> resetPassword (String email)async{
    // to check if this email exist in database or not
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection("users").get();
    for(var doc in querySnapshot.docs)
      {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        if(data["email"] == email)
          {
            await firebaseAuth.sendPasswordResetEmail(email: email);
            return true;
          }
      }
    return false;

  }
}