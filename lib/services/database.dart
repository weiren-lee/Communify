import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DatabaseService {
  Future<void> addHouseData(Map<String, dynamic> houseMap, String houseId) async {
    await FirebaseFirestore.instance
        .collection("house")
        .doc(houseId)
        .set(houseMap)
        .catchError((e) {
      print(e.toString());
    });
  }

  getHouseData() async{
    return await FirebaseFirestore.instance.collection("house").snapshots();
  }

  Future<void> addData(Map<String, dynamic> feedData, String feedId) async {
    await FirebaseFirestore.instance
        .collection("feed")
        .doc(feedId)
        .set(feedData)
        .catchError((e) {
      print(e.toString());
    });
  }

  getFeedData(houseId) async {
    return await FirebaseFirestore.instance.collection("feed").where('houseId', isEqualTo: houseId).snapshots();
    QuerySnapshot response2 = FirebaseFirestore.instance.collection("user").snapshots() as QuerySnapshot<Object?>;
  }

  Future<void> addUserData(Map<String, dynamic> userData, String userId) async {
    await FirebaseFirestore.instance
        .collection("user")
        .doc(userId)
        .set(userData)
        .catchError((e) {
      print(e.toString());
    });
  }

  // Future<String?> getUserEmail() async {
  //   return FirebaseAuth.instance.currentUser!.email.toString();
  // }
  //
  // getUserName() async {
  //   return await FirebaseFirestore.instance.collection("user").snapshots();
  // }

  updateUserHouse(userId, houseId) async {
    await FirebaseFirestore.instance
        .collection("user")
        .doc(userId)
        .update({"houseId": houseId})
    .whenComplete(() async{
      print("house updated");
    }).catchError((e) => print(e));
  }

  getUid(username) async {
    final QuerySnapshot qSnap = await FirebaseFirestore.instance.collection('user').where('name', isEqualTo: username).get();
    final allData = qSnap.docs.map((doc) => doc.data()).toList();
    var userDetails = allData[0] as Map;
    String userId = userDetails['userId'];
    return userId;
  }

  // getUserId(username) async {
  //   return await FirebaseFirestore.instance
  //       .collection("user")
  //       .where("name", isEqualTo: username)
  //       .snapshots();
  // }


}
