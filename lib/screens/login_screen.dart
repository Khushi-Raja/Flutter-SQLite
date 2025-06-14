import 'package:brainybeam/screens/home_screen.dart';
import 'package:brainybeam/screens/sign_up_screen.dart';
import 'package:brainybeam/services/auth_service.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailCtrl = TextEditingController();
  final TextEditingController passCtrl = TextEditingController();
  final AuthService auth = AuthService();
  final _key = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.only(left: 10.0, right: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.only(top: 25, left: 10),
                child: Image.asset(
                  "assets/pooh.png",
                  height: 200,
                ),
              ),
              const Text(
                "Welcome Back,",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text(
                "Make it work, make it right, make it fast",
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 50),
              Form(
                key: _key,
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
                    SizedBox(height: 10),
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
                    customContainer(
                      data: "Forget Password ?",
                      color: Colors.blue,
                      padding: const EdgeInsets.all(15),
                      alignment: Alignment.topRight,
                      fontSize: 15,
                    ),
                    SizedBox(
                      height: 50,
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: ElevatedButton(
                        onPressed: () async {
                          if (_key.currentState!.validate()) {
                            bool success =
                                await auth.login(emailCtrl.text, passCtrl.text);
                            if (success) {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return HomeScreen();
                                  },
                                ),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text("Invalid Credentials"),
                                ),
                              );
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          backgroundColor: Colors.black,
                        ),
                        child: Text("LOGIN", style: TextStyle(color: Colors.white, fontSize: 16),),
                      ),
                    ),
                    const SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        customContainer(data: "Don't have an Account? ", fontSize: 15),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return SignUpScreen();
                                },
                              ),
                            );
                          },
                          style: ButtonStyle(
                            overlayColor:
                                WidgetStateProperty.all(Colors.transparent),
                            padding: WidgetStateProperty.all(EdgeInsets.zero),
                            tapTargetSize:
                                MaterialTapTargetSize.shrinkWrap, // optional
                          ),
                          child: Text(
                            "Sign up",
                            style: TextStyle(
                              color: Colors.blue,
                              fontSize: 16
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
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
            borderSide: BorderSide(color: Colors.grey),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.grey),
          ),
          labelText: labelText,
          prefixIcon: prefixIcon,
          prefixIconColor: Colors.grey,
          suffixIcon: suffixIcon,
          suffixIconColor: Colors.grey),
    );
  }

  Widget customContainer(
      {required String data,
      Color? color,
      EdgeInsetsGeometry? padding,
      AlignmentGeometry? alignment,
      double? fontSize}) {
    return Container(
      padding: padding,
      alignment: alignment ?? Alignment.center,
      child: Text(
        data,
        style: TextStyle(
            fontWeight: FontWeight.w500, color: color, fontSize: fontSize),
      ),
    );
  }
}
