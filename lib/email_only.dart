import 'package:flutter/material.dart';
import 'authenticate.dart';

class OnlyEmail extends StatefulWidget {
  OnlyEmail({Key? key}) : super(key: key);

  @override
  _OnlyEmailSignInState createState() => _OnlyEmailSignInState();
}
class _OnlyEmailSignInState extends State<OnlyEmail> {

  final _formKey = GlobalKey<FormState>();
  late TextEditingController _emailController;
  void initState(){
    super.initState();
    _emailController = TextEditingController();
  }
  void dipose(){
    _emailController.dispose();
    super.dispose();
  }

  String _email = '';
  @override
  Widget build(BuildContext context){

    final emailInput = TextFormField(
      autocorrect: false,
      controller: _emailController,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Please enter your email";
        }
        return null;
      },
      decoration: const  InputDecoration(
          labelText: "Email Address",
          border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(15.0))),
          hintText: "Enter Email"),
    );

    final submit = OutlinedButton(
      onPressed:(){
        if(_formKey.currentState!.validate()){
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text('Loading Data')));
          _email = _emailController.text;
          _emailController.clear();


          setState(() {
            Authenticate().signInOnlyEmail(_email, context);
          });
        }
      },
      child: const Text('Submit'),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text("Sign In With Only Email"),
      ),
      backgroundColor: Colors.lime.shade400,
      body: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget> [
                        emailInput,
                        submit
                      ],
                    )
                ),
              ]
          )
      ),
    );
  }
}