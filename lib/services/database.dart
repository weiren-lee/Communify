import 'package:cloud_firestore/cloud_firestore.dart';

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


  updateHouseUsers(houseId, username) async {
    FirebaseFirestore.instance
        .collection("house")
        .doc(houseId)
        .update({"users": FieldValue.arrayUnion([username])})
        .whenComplete(() async{
          print("name added to house");
        }).catchError((e) => print(e));
  }

  getUid(username) async {
    final QuerySnapshot qSnap = await FirebaseFirestore.instance.collection('user').where('name', isEqualTo: username).get();
    final allData = qSnap.docs.map((doc) => doc.data()).toList();
    var userDetails = allData[0] as Map;
    String userId = userDetails['userId'];
    return userId;
  }
}
