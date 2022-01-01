import 'dart:io';

abstract class BaseStorageProvider {
  Future<String> uploadProductImage({required File image});

  Future<String> uploadUserProfile({required File image});
}
