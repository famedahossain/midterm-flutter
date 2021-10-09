import 'login_view.dart';
import 'home_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'authenticate.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AppDriver extends StatelessWidget {
  AppDriver({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Authenticate().authorizedUser() == null ? const LoginPage() : HomePage();
  }
}