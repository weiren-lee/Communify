import 'package:communify/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:communify/models/user.dart';

class AuthService {
  FirebaseAuth _auth = FirebaseAuth.instance;
  DatabaseService databaseService = DatabaseService();

  Userid? _userFromFirebaseUser(User user) {
    return user != null ? Userid(uid: user.uid) : null;
  }

  getUserName() {
    try {
      User? currentUser = _auth.currentUser;
      currentUser?.reload();
      if (currentUser != null) {
        String? username = currentUser.displayName;
        return username;
      }
    } catch (e) {
      print(e.toString());
    }
  }

  getProfilePicture() {
    try {
      User? currentUser = _auth.currentUser;
      currentUser?.reload();
      if (currentUser != null) {
        String? profilepicture = currentUser.photoURL?? 'https://i.pinimg.com/originals/65/25/a0/6525a08f1df98a2e3a545fe2ace4be47.jpg';
        return profilepicture;
      }
    } catch (e) {
      print(e.toString());
    }
  }

  updateProfile(String photoURL, String displayName) {
    try {
      User? currentUser = _auth.currentUser;
      currentUser?.reload();
      if (currentUser != null) {
        currentUser.updatePhotoURL(photoURL).catchError((e) {print(e.toString());});
        currentUser.updateDisplayName(displayName).catchError((e) {print(e.toString());});
      }
    } catch(e) {
      print(e.toString());
    }
  }

  Future signInEmailAndPass(String email, String password) async {
    try {
      UserCredential authResult = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User? firebaseUser = authResult.user;
      return _userFromFirebaseUser(firebaseUser!);
    } catch (e) {
      print(e.toString());
    }
  }

  Future signUpWithEmailAndPassword(String email, String password, String name) async {
    try {
      UserCredential authResult = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User? firebaseUser = authResult.user;
      firebaseUser?.updateDisplayName(name);

      return _userFromFirebaseUser(firebaseUser!);
    } catch (e) {
      print(e.toString());
    }
  }

  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
