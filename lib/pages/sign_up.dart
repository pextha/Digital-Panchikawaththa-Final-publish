import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'login_page.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  Color myGreenColor = const Color(0xFF02B91A);

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  final _phoneController = TextEditingController();
  final _nameController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isLoading = false;
  File? _imageFile;

  Future<void> _pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => _imageFile = File(picked.path));
    }
  }

  void _signUp() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final confirm = _confirmController.text.trim();

    if (password != confirm) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Passwords do not match")),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      String profileImageUrl = '';

      if (_imageFile != null) {
        final storageRef = FirebaseStorage.instance
            .ref()
            .child('profile_images/${userCredential.user!.uid}.jpg');

        try {
          UploadTask uploadTask = storageRef.putFile(_imageFile!);
          TaskSnapshot snapshot = await uploadTask;
          profileImageUrl = await snapshot.ref.getDownloadURL();
        } catch (e) {
          debugPrint("Image upload failed: $e");
        }
      }

      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .set({
        'Name': _nameController.text.trim(),
        'phone': _phoneController.text.trim(),
        'email': email,
        'profileImage': profileImageUrl,
        'createdAt': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Account created successfully")),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    } on FirebaseAuthException catch (e) {
      String msg = "Sign up failed";
      if (e.code == 'email-already-in-use')
        msg = "Email already in use";
      else if (e.code == 'weak-password')
        msg = "Weak password";
      else if (e.code == 'invalid-email') msg = "Invalid email";

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Error: $e")));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [myGreenColor, Colors.green[200]!],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 80),
              const Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text("SignUp",
                        style: TextStyle(color: Colors.white, fontSize: 40)),
                    SizedBox(height: 10),
                    Text("Register your account",
                        style: TextStyle(color: Colors.white, fontSize: 18)),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(60)),
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    _buildInput("Name", controller: _nameController),
                    const SizedBox(height: 20),
                    _buildInput("Phone Number", controller: _phoneController),
                    const SizedBox(height: 20),
                    _buildInput("Email", controller: _emailController),
                    const SizedBox(height: 20),
                    PasswordField(controller: _passwordController),
                    const SizedBox(height: 20),
                    ConfirmPasswordField(controller: _confirmController),
                    const SizedBox(height: 20),
                    GestureDetector(
                      onTap: _pickImage,
                      child: CircleAvatar(
                        radius: 30,
                        backgroundImage:
                            _imageFile != null ? FileImage(_imageFile!) : null,
                        child: _imageFile == null
                            ? const Icon(Icons.camera_alt, size: 20)
                            : null,
                      ),
                    ),
                    const SizedBox(height: 30),
                    const Text(
                      "Fill those details to create an account.",
                      style: TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 25),
                    ElevatedButton(
                      onPressed: _isLoading ? null : _signUp,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: myGreenColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 60, vertical: 15),
                      ),
                      child: _isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text("Sign Up",
                              style:
                                  TextStyle(fontSize: 18, color: Colors.white)),
                    ),
                    const SizedBox(height: 20),
                    const Text("or SignUp with",
                        style: TextStyle(color: Colors.grey)),
                    const SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _socialIcon("assets/facebook.png"),
                        const SizedBox(width: 15),
                        _socialIcon("assets/google.png"),
                        const SizedBox(width: 15),
                        _socialIcon("assets/apple.png"),
                      ],
                    ),
                    const SizedBox(height: 10),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const LoginPage()));
                      },
                      child: Text("I already have an account.",
                          style: TextStyle(fontSize: 16, color: myGreenColor)),
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

  Widget _buildInput(String hint, {TextEditingController? controller}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
              color: Colors.green[200]!,
              blurRadius: 20,
              offset: const Offset(0, 10))
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: TextField(
          controller: controller,
          keyboardType:
              hint == "Phone Number" ? TextInputType.phone : TextInputType.text,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: Colors.grey),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.only(left: 10),
          ),
        ),
      ),
    );
  }

  Widget _socialIcon(String path) {
    return GestureDetector(
      onTap: () => print("$path Sign-In clicked!"),
      child: SizedBox(width: 40, height: 40, child: Image.asset(path)),
    );
  }
}

// === PasswordField Widget ===
class PasswordField extends StatefulWidget {
  final TextEditingController controller;
  const PasswordField({super.key, required this.controller});

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _obscure = true;

  @override
  Widget build(BuildContext context) {
    return _build("Password", widget.controller);
  }

  Widget _build(String hint, TextEditingController controller) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
              color: Colors.green[200]!,
              blurRadius: 20,
              offset: const Offset(0, 10))
        ],
      ),
      child: TextField(
        controller: controller,
        obscureText: _obscure,
        decoration: InputDecoration(
          hintText: hint,
          border: InputBorder.none,
          hintStyle: const TextStyle(color: Colors.grey),
          contentPadding: const EdgeInsets.only(left: 10, top: 9),
          suffixIcon: IconButton(
            icon: Icon(_obscure ? Icons.visibility : Icons.visibility_off,
                color: Colors.grey),
            onPressed: () => setState(() => _obscure = !_obscure),
          ),
        ),
      ),
    );
  }
}

// === ConfirmPasswordField Widget ===
class ConfirmPasswordField extends StatefulWidget {
  final TextEditingController controller;
  const ConfirmPasswordField({super.key, required this.controller});

  @override
  State<ConfirmPasswordField> createState() => _ConfirmPasswordFieldState();
}

class _ConfirmPasswordFieldState extends State<ConfirmPasswordField> {
  bool _obscure = true;

  @override
  Widget build(BuildContext context) {
    return _build("Confirm Password", widget.controller);
  }

  Widget _build(String hint, TextEditingController controller) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
              color: Colors.green[200]!,
              blurRadius: 20,
              offset: const Offset(0, 10))
        ],
      ),
      child: TextField(
        controller: controller,
        obscureText: _obscure,
        decoration: InputDecoration(
          hintText: hint,
          border: InputBorder.none,
          hintStyle: const TextStyle(color: Colors.grey),
          contentPadding: const EdgeInsets.only(left: 10, top: 9),
          suffixIcon: IconButton(
            icon: Icon(_obscure ? Icons.visibility : Icons.visibility_off,
                color: Colors.grey),
            onPressed: () => setState(() => _obscure = !_obscure),
          ),
        ),
      ),
    );
  }
}
