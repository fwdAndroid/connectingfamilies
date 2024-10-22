import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

class StorageMethods {
  final FirebaseStorage firebaseStorage = FirebaseStorage.instance;

  // Adding Image to Firebase Storage
  Future<String> uploadImageToStorage(String childName, Uint8List file) async {
    Reference reference = firebaseStorage
        .ref()
        .child(childName)
        .child(Uuid().v1()); // Generate a unique ID for each image

    UploadTask uploadTask = reference.putData(file);
    TaskSnapshot taskSnapshot = await uploadTask;
    String downloadURL = await taskSnapshot.ref.getDownloadURL();
    return downloadURL;
  }
}
