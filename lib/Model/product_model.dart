import 'package:cloud_firestore/cloud_firestore.dart';

class DataModel {
  final String? productId;
  final String? productUrl;
  final String? name;
  final String? userId;
  final String? mobileNumber;
  final String? address;
  final String? landmark;
  final String? itemName;
  final String? categories;
  final String? description;
  final String? disAppearTime;
  final bool? isAvailable;
  final bool? isCompleted;
  final bool? isAccepted;

  DataModel(
      {this.productId,
      this.productUrl,
      this.name,
      this.userId,
      this.mobileNumber,
      this.address,
      this.landmark,
      this.itemName,
      this.categories,
      this.description,
      this.disAppearTime,
      this.isAvailable,
      this.isCompleted,
      this.isAccepted});

  //Create a method to convert QuerySnapshot from Cloud Firestore to a list of objects of this DataModel
  //This function in essential to the working of FirestoreSearchScaffold

  List<DataModel> dataListFromSnapshot(QuerySnapshot<dynamic> querySnapshot) {
    return querySnapshot.docs.map((snapshot) {
      final Map<String, dynamic> dataMap =
          snapshot.data() as Map<String, dynamic>;

      return DataModel(
        productId: dataMap['productId'],
        productUrl: dataMap['productUrl'],
        name: dataMap['name'],
        userId: dataMap['userId'],
        mobileNumber: dataMap['mobileNumber'],
        address: dataMap['address'],
        landmark: dataMap['lankmark'],
        itemName: dataMap['itemName'],
        categories: dataMap['categories'],
        description: dataMap['description'],
        disAppearTime: dataMap['disAppearTime'],
        isAvailable: dataMap['isAvailable'],
        isCompleted: dataMap['isCompleted'],
        isAccepted: dataMap['isAccepted'],
      );
    }).toList();
  }
}
