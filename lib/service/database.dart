import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectingfamilies/models/user_model.dart';
import 'package:connectingfamilies/service/storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class DatabaseMethods {
  // Add Service
  Future<String> signUpUser(
      {required String confirmPassword,
      required String fullName,
      required String nutrition,
      required String parenting,
      required String dob,
      required String email,
      required String familyDescription,
      required String location,
      required String password,
      required String familyType,
      required List<String> interest,
      required String phoneNumber,
      required String specialSituation,
      required Uint8List file}) async {
    String res = 'Wrong Email or Password';
    try {
      if (email.isNotEmpty || password.isNotEmpty || fullName.isNotEmpty) {
        UserCredential cred = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password);
        String photoURL = await StorageMethods().uploadImageToStorage(
          'ProfilePics',
          file,
        );
        //Add User to the database with modal
        UserModel userModel = UserModel(
          familyType: familyType,
          photo: photoURL,
          uuid: cred.user!.uid,
          parentingStyle: parenting,
          phoneNumber: phoneNumber,
          favorite: [],
          confrimPassword: confirmPassword,
          location: location,
          interest: interest,
          dateofBirth: dob,
          familyDescription: familyDescription,
          nutritions: nutrition,
          fullName: fullName,
          specialSituation: specialSituation,
          email: email,

          password: password,
          // photoURL: photoURL
        );
        await FirebaseFirestore.instance
            .collection('users')
            .doc(cred.user!.uid)
            .set(userModel.toJson());
        res = 'success';
      }
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  Future<String> loginUpUser({
    required String email,
    required String pass,
  }) async {
    String res = ' Wrong Email or Password';
    try {
      if (email.isNotEmpty || pass.isNotEmpty) {
        await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email, password: pass);

        res = 'success';
      }
    } on FirebaseException catch (e) {
      if (e == 'WrongEmail') {
        print(e.message);
      }
      if (e == 'WrongPassword') {
        print(e.message);
      }
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  //Google SignIn
  Future<UserCredential> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    final GoogleSignInAuthentication googleAuth =
        await googleUser!.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    return await FirebaseAuth.instance.signInWithCredential(credential);
  }
}
