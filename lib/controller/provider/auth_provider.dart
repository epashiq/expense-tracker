import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker/utils/snackbar_utils.dart';
import 'package:expense_tracker/view/pages/add_expense_page.dart';
import 'package:expense_tracker/view/pages/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider with ChangeNotifier {
  Future<void> login(
      String email, String password, BuildContext context) async {
    try {
      UserCredential credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      if (credential.user != null) {
        final user = FirebaseAuth.instance.currentUser;
        final encodedUser =
            json.encode({'uid': user!.uid, 'email': user.email});
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('user', encodedUser.toString());

        SnackbarUtils.showMessage('login Successfully');
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const AddExpensePage(),
            ));
      }
    } catch (e) {
      log(e.toString());
      SnackbarUtils.showMessage('login failed');
    }
  }

  Future<void> signUp(
      String email, String password, BuildContext context, String name) async {
    final db = FirebaseFirestore.instance.collection('user');
    try {
      UserCredential credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      db.doc(credential.user?.uid).set({email: email, password: password});
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('email', email);
      await prefs.setString('name', name);
      SnackbarUtils.showMessage('Registration Completed');
    } catch (e) {
      SnackbarUtils.showMessage('Registration Failed');
    }
  }

  Future<UserCredential> signInWithGoogle(BuildContext context) async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;
      final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth?.accessToken, idToken: googleAuth?.idToken);
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const AddExpensePage(),
          ));
      return await FirebaseAuth.instance.signInWithCredential(credential);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<String?> getUserEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('email');
  }

  Future<void> logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    await GoogleSignIn().signOut();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('user');

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }

  void disposeLoginField()async{
    
  }
}
