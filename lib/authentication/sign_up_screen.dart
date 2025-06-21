import 'package:brainybeam/authentication/login_screen.dart';
import 'package:brainybeam/components/custom_button.dart';
import 'package:brainybeam/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../components/custom_container.dart';
import '../components/custom_textfield.dart';

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
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 3.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.only(top: 4.h, left: 2.w),
                child: Image.asset(
                  "assets/pooh.png",
                  height: 25.h,
                ),
              ),
              Text(
                "Get On Board!",
                style: TextStyle(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "Create your profile to start your journey.",
                style: TextStyle(fontSize: 16.sp),
              ),
              SizedBox(height: 4.h),
              Form(
                key: _key,
                child: Column(
                  children: [
                    CustomTextFormField(
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
                      keyboardType: TextInputType.text,
                      obscureText: false,
                    ),
                    SizedBox(height: 1.5.h),
                    CustomTextFormField(
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
                      keyboardType: TextInputType.text,
                    ),
                    SizedBox(height: 3.h),
                    CustomButton(
                      buttonName: "SIGNUP",
                      backgroundColor: Colors.black,
                      textColor: Colors.white,
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
                    ),
                    SizedBox(height: 1.5.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomContainer(
                            data: "Already have an Account? ", fontSize: 16.sp),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return LoginScreen();
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
                            "LOGIN",
                            style:
                                TextStyle(color: Colors.blue, fontSize: 16.sp),
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
}
