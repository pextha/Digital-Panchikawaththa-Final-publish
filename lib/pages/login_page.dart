import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:panchikawaththa/models/user_model.dart';
import 'package:panchikawaththa/pages/admin_dashboard_page.dart';
import 'package:panchikawaththa/pages/main_layout.dart';
import 'package:panchikawaththa/pages/sign_up.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  static const Color primaryColor = Color.fromARGB(255, 20, 211, 3);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _passwordVisible = false;
  final _auth = FirebaseAuth.instance;

  void _login() async {
    setState(() => _isLoading = true);
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      User? firebaseUser = userCredential.user;

      if (firebaseUser != null) {
        final userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(firebaseUser.uid)
            .get();

        if (userDoc.exists) {
          UserModel user = UserModel.fromDocument(userDoc);

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Login Successful')),
          );

          if (user.status == 'admin') {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const AdminDashboardPage(),
              ),
            );
          } else {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => MainLayout(userData: user),
              ),
            );
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('User profile not found.')),
          );
        }
      }
    } on FirebaseAuthException catch (e) {
      String message = 'Login failed';
      if (e.code == 'user-not-found')
        message = 'User not found';
      else if (e.code == 'wrong-password') message = 'Wrong password';

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(message)));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = LoginPage.primaryColor;
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              colors: [primaryColor, primaryColor],
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 40),
              const Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('Login',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 40,
                            fontFamily: 'Poppins')),
                    SizedBox(height: 10),
                    Text('Welcome Back',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontFamily: 'Poppins')),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(60),
                      topRight: Radius.circular(60),
                    ),
                  ),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(vertical: 30),
                    child: Column(
                      children: [
                        const SizedBox(height: 60),
                        Column(
                          children: [
                            _buildInputField(
                              controller: _emailController,
                              hintText: "Email",
                              isPassword: false,
                            ),
                            const SizedBox(height: 40),
                            _buildInputField(
                              controller: _passwordController,
                              hintText: "Password",
                              isPassword: true,
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        const Text("Forgot Password?",
                            style: TextStyle(color: Colors.grey)),
                        const SizedBox(height: 40),
                        GestureDetector(
                          onTap: _login,
                          child: Container(
                            height: 50,
                            margin: const EdgeInsets.symmetric(horizontal: 50),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: primaryColor,
                            ),
                            child: Center(
                              child: _isLoading
                                  ? const CircularProgressIndicator(
                                      color: Colors.white,
                                    )
                                  : const Text("Login",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15)),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        RichText(
                          text: TextSpan(
                            children: [
                              const TextSpan(
                                text: "New Member? ",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              TextSpan(
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const SignUpPage()),
                                    );
                                  },
                                text: "Register",
                                style: const TextStyle(
                                  color: primaryColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 60),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _socialIcon('assets/google.png'),
                            const SizedBox(width: 20),
                            _circleIcon(Icons.apple, Colors.black),
                            const SizedBox(width: 20),
                            _circleIcon(Icons.facebook, Colors.blue),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String hintText,
    required bool isPassword,
  }) {
    return Container(
      height: 55,
      margin: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.green[200]!,
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        obscureText: isPassword && !_passwordVisible,
        style:
            const TextStyle(color: Colors.black54, fontWeight: FontWeight.w400),
        decoration: InputDecoration(
          hintText: "   $hintText",
          hintStyle: const TextStyle(color: Colors.grey),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.only(left: 10, top: 16, bottom: 16),
          suffixIcon: isPassword
              ? IconButton(
                  icon: Icon(
                    _passwordVisible ? Icons.visibility : Icons.visibility_off,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    setState(() {
                      _passwordVisible = !_passwordVisible;
                    });
                  },
                )
              : null,
        ),
      ),
    );
  }

  Widget _circleIcon(IconData icon, Color color) {
    return Container(
      height: 50,
      width: 50,
      decoration:
          BoxDecoration(borderRadius: BorderRadius.circular(50), color: color),
      child: Icon(icon, color: Colors.white),
    );
  }

  Widget _socialIcon(String assetPath) {
    return Container(
      height: 50,
      width: 50,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50), color: Colors.white),
      child: Center(
        child: Image.asset(assetPath, height: 30, width: 30),
      ),
    );
  }
}

class MainLayout extends StatelessWidget {
  final UserModel userData;

  const MainLayout({Key? key, required this.userData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Your MainLayout implementation
    return Scaffold(
      appBar: AppBar(
        title: Text('Main Layout'),
      ),
    );
  }
}
