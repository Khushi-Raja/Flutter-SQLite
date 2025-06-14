import 'package:brainybeam/screens/login_screen.dart';
import 'package:brainybeam/services/auth_service.dart';
import 'package:flutter/material.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController emailCtrl = TextEditingController();
  final TextEditingController passCtrl = TextEditingController();
  final AuthService auth = AuthService();
  final _key = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("SIGNUP"),
      ),
      body: Form(
        key: _key,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              customTextFormField(
                controller: emailCtrl,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Email Required';
                  } else {
                    return null;
                  }
                },
                labelText: "Email",
                prefixIcon: Icon(Icons.email),
              ),
              SizedBox(height: 15),
              customTextFormField(
                controller: passCtrl,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Password Required';
                  } else {
                    return null;
                  }
                },
                labelText: "Password",
                prefixIcon: Icon(Icons.password),
                obscureText: true,
              ),
              SizedBox(height: 15),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.9,
                child: ElevatedButton(
                  onPressed: () async {
                    if (_key.currentState!.validate()) {
                      bool success =
                      await auth.signup(emailCtrl.text, passCtrl.text);
                      if (success) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return LoginScreen();
                            },
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Email already exists"),
                          ),
                        );
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text("SIGNUP"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget customTextFormField(
      {TextEditingController? controller,
        String? Function(String?)? validator,
        Widget? prefixIcon,
        String? labelText,
        bool obscureText = false,
        Widget? suffixIcon}) {
    return TextFormField(
      controller: controller,
      validator: validator,
      obscureText: obscureText,
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        labelText: labelText,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
      ),
    );
  }
}
