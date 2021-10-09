import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'authenticate.dart';
import 'driver.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  late TextEditingController _emailController,
      _reemailController,
      _passwordController,
      _repasswordController,
      _firstnameController,
      _lastnameController,
      _phonenumberController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _emailController = TextEditingController();
    _reemailController = TextEditingController();
    _passwordController = TextEditingController();
    _repasswordController = TextEditingController();
    _firstnameController = TextEditingController();
    _lastnameController = TextEditingController();
    _phonenumberController = TextEditingController();

    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _reemailController.dispose();
    _passwordController.dispose();
    _repasswordController.dispose();
    _firstnameController.dispose();
    _lastnameController.dispose();
    _phonenumberController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Register"),
        ),
        body: Form(
            key: _formKey,
            child: Column(children: [
              const SizedBox(height: 20.0),
              TextFormField(
                autocorrect: false,
                controller: _emailController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                    labelText: "Email Address",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0))),
                    hintText: 'Enter email address'),
              ),
              const SizedBox(height: 20.0),
              TextFormField(
                autocorrect: false,
                controller: _reemailController,
                validator: (value) {
                  if (value == null || value != _reemailController.text) {
                    return 'Email addresses do not match';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                    labelText: "Re-Enter Email Address",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0))),
                    hintText: 'Re-enter email address'),
              ),
              const SizedBox(height: 20.0),
              TextFormField(
                autocorrect: false,
                controller: _passwordController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Password cannot be empty';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                    labelText: "Enter Password",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0))),
                    hintText: 'Enter password'),
              ),
              const SizedBox(height: 20.0),
              TextFormField(
                autocorrect: false,
                controller: _repasswordController,
                validator: (value) {
                  if (value == null || value != _passwordController.text) {
                    return 'Passwords do not match';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                    labelText: "Verify Password",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0))),
                    hintText: 'Verify password'),
              ),
              const SizedBox(height: 20.0),
              TextFormField(
                autocorrect: false,
                controller: _firstnameController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Passwords do not match';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                    labelText: "Enter First Name",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0))),
                    hintText: 'Enter first name'),
              ),
              const SizedBox(height: 20.0),
              TextFormField(
                autocorrect: false,
                controller: _lastnameController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Last name cannot be empty';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                    labelText: "Enter Last Name",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0))),
                    hintText: 'Enter last name'),
              ),
              const SizedBox(height: 20.0),
              TextFormField(
                autocorrect: false,
                controller: _phonenumberController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Phone number cannot be empty';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                    labelText: "Enter Phone Number",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0))),
                    hintText: 'Enter phone number'),
              ),
              const SizedBox(height: 30.0),
              OutlinedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Processing Data')));

                    setState(() {
                      register();
                    });
                  }
                },
                child: const Text('Submit'),
              )
            ])));
  }

  Future<void> register() async {
    try {
      var authenticate = Authenticate().authorize();
      UserCredential userCredential =
      await authenticate.createUserWithEmailAndPassword(
          email: _emailController.text, password: _passwordController.text);
      _db
          .collection("user")
          .doc(userCredential.user!.uid)
          .set({
        "first_name": _firstnameController.text,
        "last_name": _lastnameController.text,
        "phone": _phonenumberController.text,
        "role": "customer",
        "register_date": DateTime.now()
      })
          .then((value) => null)
          .onError((error, stackTrace) => null);
      Navigator.pushReplacement(context,MaterialPageRoute(builder:  (con) => AppDriver()));
      // });

    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Error")));
    } catch (e) {
      print(e);
    }

    setState(() {});
  }
}