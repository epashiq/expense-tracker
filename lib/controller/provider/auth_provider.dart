import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker/utils/snackbar_utils.dart';
import 'package:expense_tracker/view/pages/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthProvider with ChangeNotifier {
  Future<void> login(
      String email, String password, BuildContext context) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      SnackbarUtils.showMessage('login Successfully');
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const HomePage(),
          ));
    } catch (e) {
      log(e.toString());
      SnackbarUtils.showMessage('login failed');
    }
  }

  Future<void> signUp(
      String email, String password, BuildContext context, String name) async {
    final db = FirebaseFirestore.instance.collection('user');
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      db.doc(email).set({email: email, password: password});
      SnackbarUtils.showMessage('Registration Completed');
    } catch (e) {
      SnackbarUtils.showMessage('Registration Failed');
    }
  }

  Future<UserCredential> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;
    final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken, idToken: googleAuth?.idToken);
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }
}
