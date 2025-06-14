import 'package:brainybeam/screens/login_screen.dart';
import 'package:brainybeam/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<void> _logout(BuildContext context) async {
    await AuthService().logout();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => const LoginScreen(),
      ),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Home Page"),
          actions: [
            IconButton(
              onPressed: () {
                _logout(context);
              },
              icon: Icon(Icons.logout),
            ),
          ],
        ),
        body: Center(
          child: Text("Welcome to the Home Screen", style: TextStyle(fontSize: 20.sp),),
        ),
      ),
    );
  }
}
