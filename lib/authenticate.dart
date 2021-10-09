import 'driver.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Authenticate {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  String _verificationId = '';

  @override
  authorize(){
    return _auth;
  }

  authorizedUser(){
    return _auth.currentUser;
  }

  void anonSignIn(context) async{
    _auth.signInAnonymously().then((result) {
      final User? user = result.user;
    });
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (con) => AppDriver()));
  }

  void signInWithEmailAndPassword(_email, _password, context) async{
    await Firebase.initializeApp();
    try{
      UserCredential uid = await _auth.signInWithEmailAndPassword(
          email: _email,
          password: _password);
      Navigator.push(context,MaterialPageRoute(builder:  (context) => AppDriver()));

    }on FirebaseAuthException catch(e) {
      ScaffoldMessenger.of(context).clearSnackBars();
      if (e.code == 'wrong-password') {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Wrong password")));
      }else if(e.code =='user-not-found')    {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("User not found")));
      }
    }catch (e){
      print(e);
    }
  }

  void signInOnlyEmail(_email, context) async{
    try{
      _auth.sendSignInLinkToEmail(
        email: _email,
        actionCodeSettings: ActionCodeSettings(
            url: "fhossain6-midterm.firebaseapp.com",
            androidPackageName: "com.example.midterm",
            iOSBundleId: "com.example.midterm",
            handleCodeInApp: true,
            androidMinimumVersion: "16",
            androidInstallApp: true),
      );
      Navigator.push(context,MaterialPageRoute(builder:  (context) => AppDriver()));
    }on FirebaseAuthException catch(e)
    {}catch(e){
      print(e);
    }
  }

  Future<void> phoneSignIn(_phoneNumber, context) async{
    PhoneVerificationCompleted verificationCompleted =
        (PhoneAuthCredential phoneAuthCredential) async {
      await _auth.signInWithCredential(phoneAuthCredential); };

    PhoneVerificationFailed verificationFailed =
        (FirebaseAuthException authException) {
      print("Failed: $authException");
    };

    PhoneCodeSent codeSent =
        (String verificationId, [int? resendToken]) async {
      _verificationId = verificationId;
    };

    await _auth.verifyPhoneNumber(
      phoneNumber: _phoneNumber,
      timeout: const Duration(seconds: 30),
      verificationCompleted: verificationCompleted,
      verificationFailed: verificationFailed,
      codeSent: codeSent,
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
    print(_verificationId);
  }

  void signInWithPhone(_sms, context) async{
    try {
      final AuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _verificationId,
        smsCode: _sms,
      );
      print(credential);
      final User? user = (await _auth.signInWithCredential(credential)).user;

      Navigator.push(context,MaterialPageRoute(builder:  (context) => AppDriver()));
    } catch (e) {
      print("Id: $_verificationId");
      print(e);
    }
  }

  void googleSignIn(context) async{
    final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();

    final GoogleSignInAuthentication googleAuth = await googleUser
        .authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    print(credential);

    await FirebaseAuth.instance.signInWithCredential(credential);
    final QuerySnapshot result = await FirebaseFirestore.instance
        .collection('users')
        .where('first_name', isEqualTo: googleUser.displayName)
        .limit(1)
        .get();
    print(result.docs);
    print(googleUser.email);
    final List <DocumentSnapshot> docs = result.docs;
    if (docs.isEmpty) {
      try {
        _db
            .collection("users")
            .doc()
            .set({
          "first_name": googleUser.displayName,
          "last_name": '',
          "role": 'customer',
          "registration_deadline": DateTime.now(),
        })
            .then((value) => null)
            .onError((error, stackTrace) => null);
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (con) => AppDriver()));
      } on FirebaseAuthException catch (e) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Error")));
      } catch (e) {
        print(e);
      }
    } else {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (con) => AppDriver()));
    }
  }

  void signOut(BuildContext context) async {
    return showDialog(context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Log Out"),
            content: Text("Are you sure you want to log out?"),
            actions: <Widget>[
              TextButton(
                onPressed: () async {
                  await _auth.signOut();
                  ScaffoldMessenger.of(context)
                      .showSnackBar(
                      const SnackBar(content: Text('User logged out.')));
                  Navigator.pushReplacement(
                      context, MaterialPageRoute(builder: (con) => AppDriver()));
                  ScaffoldMessenger.of(context).clearSnackBars();
                },
                child: Text("Yes"),
              ),
            ],
          );
        });
  }
}