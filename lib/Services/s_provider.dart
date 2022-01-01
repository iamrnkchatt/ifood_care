import 'dart:io';
import 'package:donationapp/Services/base_s_provider.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

class StorageProvider extends BaseStorageProvider {
  final FirebaseStorage _firebaseStorage;

  StorageProvider({required FirebaseStorage firebaseStorage})
      : _firebaseStorage = FirebaseStorage.instance;

  Future<String> _uploadImage({
    required File image,
    required String ref,
  }) async {
    final downloadUrl = await _firebaseStorage
        .ref(ref)
        .putFile(image)
        .then((taskSnapshot) => taskSnapshot.ref.getDownloadURL());
    return downloadUrl;
  }

  @override
  Future<String> uploadProductImage({required File? image}) async {
    final imageId = Uuid().v4();
    final downloadUrl = await _uploadImage(
      image: image as File,
      ref: 'PRODUCTS/product_$imageId.jpg',
    );
    return downloadUrl;
  }

  @override
  Future<String> uploadUserProfile({required File? image}) async {
    final imageId = Uuid().v4();
    final downloadUrl = await _uploadImage(
      image: image as File,
      ref: 'USERS/profileImage_$imageId.jpg',
    );
    return downloadUrl;
  }
}
