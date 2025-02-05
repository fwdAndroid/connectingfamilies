import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectingfamilies/models/user_model.dart';
import 'package:connectingfamilies/screen/profile_setup/app_regulation.dart';
import 'package:connectingfamilies/service/storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart'; // Import this for BuildContext
import 'package:google_sign_in/google_sign_in.dart';

class DatabaseMethods {
  Future<bool> checkIfEmailExists(String email) async {
    try {
      final List<String> methods =
          await FirebaseAuth.instance.fetchSignInMethodsForEmail(email);
      return methods.isNotEmpty; // Returns true if the email exists.
    } catch (e) {
      throw Exception("Error checking email: ${e.toString()}");
    }
  }

  // Add Service
  Future<String> signUpUser(
      {required BuildContext context, // Add BuildContext
      required String confirmPassword,
      required String fullName,
      required List<String> nutrition,
      required List<String> parenting,
      required String email,
      required String familyDescription,
      required String location,
      required String password,
      required String familyType,
      required List<String> interest,
      required String phoneNumber,
      required String specialSituation,
      required Uint8List file,
      required List<Map<String, String>> familyMembers}) async {
    String res = 'An error occurred';
    try {
      // Check if email is already registered
      List<String> methods =
          await FirebaseAuth.instance.fetchSignInMethodsForEmail(email);
      if (methods.isNotEmpty) {
        // Show error message in Scaffold
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Email is already registered')),
        );
        return 'Email is already registered';
      } else {
        if (email.isNotEmpty && password.isNotEmpty && fullName.isNotEmpty) {
          UserCredential cred = await FirebaseAuth.instance
              .createUserWithEmailAndPassword(email: email, password: password);

          String photoURL = await StorageMethods().uploadImageToStorage(
            'ProfilePics',
            file,
          );

          // Add User to the database with model
          UserModel userModel = UserModel(
            familyMembers: familyMembers,
            familyType: familyType,
            photo: photoURL,
            uuid: cred.user!.uid,
            parentingStyle: parenting,
            phoneNumber: phoneNumber,
            favorite: [],
            confrimPassword: confirmPassword,
            location: location,
            interest: interest,
            familyDescription: familyDescription,
            nutritions: nutrition,
            fullName: fullName,
            specialSituation: specialSituation,
            email: email,
            password: password,
          );

          await FirebaseFirestore.instance
              .collection('users')
              .doc(cred.user!.uid)
              .set(userModel.toJson());

          res = 'success';
          Navigator.push(context,
              MaterialPageRoute(builder: (builder) => AppRegulation()));
        }
      }
    } catch (e) {
      res = e.toString();
      // Optionally display the error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(res)),
      );
    }
    return res;
  }

  Future<String> loginUpUser({
    required String email,
    required String pass,
  }) async {
    String res = 'Wrong Email or Password';
    try {
      if (email.isNotEmpty && pass.isNotEmpty) {
        await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email, password: pass);
        res = 'success';
      } else {
        res = 'Please fill in all fields';
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        res = 'No user found for this email.';
      } else if (e.code == 'wrong-password') {
        res = 'Wrong password provided.';
      }
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  // Google SignIn
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
