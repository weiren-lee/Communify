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

  // getUserId() {
  //   try {
  //     User? currentUser = _auth.currentUser;
  //     currentUser?.reload();
  //     if (currentUser != null) {
  //       String? username = currentUser.displayName;
  //       var snapshot = databaseService.getUserId(username);
  //       print(snapshot.data['userId']);
  //       var userId = snapshot.data['userId'];
  //       return userId;
  //     }
  //   } catch (e) {
  //     print(e.toString());
  //   }
  // }

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
