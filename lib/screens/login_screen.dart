import 'package:brainybeam/screens/home_screen.dart';
import 'package:brainybeam/screens/sign_up_screen.dart';
import 'package:brainybeam/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

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
                "Welcome Back,",
                style: TextStyle(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "Make it work, make it right, make it fast",
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
                    Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) =>
                                  _buildForgotPasswordDialog(context),
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
                            "Forget Password?",
                            style: TextStyle(
                              fontSize: 16.sp,
                              color: Colors.blue,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 6.h,
                      width: 90.w,
                      child: ElevatedButton(
                        onPressed: () async {
                          if (_key.currentState!.validate()) {
                            bool success =
                                await auth.login(emailCtrl.text, passCtrl.text);
                            if (success) {
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const HomeScreen(),
                                ),
                                (route) =>
                                    false, // Removes all previous routes including LoginScreen
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
                            borderRadius: BorderRadius.circular(2.w),
                          ),
                          backgroundColor: Colors.black,
                        ),
                        child: Text(
                          "LOGIN",
                          style:
                              TextStyle(color: Colors.white, fontSize: 16.sp),
                        ),
                      ),
                    ),
                    SizedBox(height: 1.5.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        customContainer(
                            data: "Don't have an Account? ", fontSize: 16.sp),
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
                            "SIGNUP",
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
            borderRadius: BorderRadius.circular(2.w),
            borderSide: BorderSide(color: Colors.grey),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(2.w),
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

  Widget _buildForgotPasswordDialog(BuildContext context) {
    final emailController = TextEditingController();
    final newPasswordController = TextEditingController();
    final _formKey = GlobalKey<FormState>();

    return AlertDialog(
      title: const Text("Reset Password"),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            customTextFormField(
              controller: emailController,
              labelText: "Email",
              validator: (value) => value!.isEmpty ? 'Enter email' : null,
            ),
            SizedBox(height: 1.5.h),
            customTextFormField(
              controller: newPasswordController,
              obscureText: true,
              labelText: "New Password",
              validator: (value) =>
                  value!.length < 6 ? 'Min 6 characters' : null,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          style: ButtonStyle(
            overlayColor: WidgetStateProperty.all(Colors.transparent),
            padding: WidgetStateProperty.all(EdgeInsets.zero),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap, // optional
          ),
          child: Text(
            "Cancel",
            style: TextStyle(fontSize: 16.sp),
          ),
        ),
        Spacer(),
        TextButton(
          onPressed: () async {
            if (_formKey.currentState!.validate()) {
              final success = await auth.updatePassword(
                emailController.text.trim(),
                newPasswordController.text.trim(),
              );
              Navigator.pop(context);

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    success ? "Password updated" : "Email not found",
                  ),
                ),
              );
            }
          },
          style: ButtonStyle(
            overlayColor: WidgetStateProperty.all(Colors.transparent),
            padding: WidgetStateProperty.all(EdgeInsets.zero),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap, // optional
          ),
          child: Text(
            "Update",
            style: TextStyle(fontSize: 16.sp),
          ),
        ),
      ],
    );
  }
}
