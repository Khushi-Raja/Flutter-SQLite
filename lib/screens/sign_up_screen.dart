import 'package:brainybeam/screens/login_screen.dart';
import 'package:brainybeam/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

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
                    SizedBox(height: 1.5.h),
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
                    SizedBox(height: 3.h),
                    SizedBox(
                      height: 6.h,
                      width: 90.w,
                      child: ElevatedButton(
                        onPressed: () async {
                          if (_key.currentState!.validate()) {
                            bool success = await auth.signup(
                                emailCtrl.text, passCtrl.text);
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
                              borderRadius: BorderRadius.circular(3.w),
                            ),
                            backgroundColor: Colors.black),
                        child: Text(
                          "SIGNUP",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.sp,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 1.5.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        customContainer(data: "Already have an Account? ",fontSize: 16.sp),
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
                            "Login",
                            style: TextStyle(
                                color: Colors.blue,
                                fontSize: 17.sp
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
            borderRadius: BorderRadius.circular(3.w),
            borderSide: BorderSide(color: Colors.grey),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(3.w),
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
