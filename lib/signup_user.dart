import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SignupUser extends StatefulWidget {
  const SignupUser({super.key});

  @override
  _SignupUserState createState() => _SignupUserState();
}

class _SignupUserState extends State<SignupUser> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> createAccount()async{
    await FirebaseAuth.instance.createUserWithEmailAndPassword(email: _emailController.text.trim().toLowerCase(), password: _passwordController.text.trim());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              "assets/subtle_pattern.png",
              fit: BoxFit.cover,
              opacity: const AlwaysStoppedAnimation(0.5),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xFFEDE7F6),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            blurRadius: 15,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.event_available,
                        size: 80,
                        color: Color(0xFF64B5F6),
                      ),
                    ),
                    const SizedBox(height: 25),
                    Text(
                      "Create an Account",
                      style: GoogleFonts.poppins(
                        color: const Color(0xFF4A4A4A),
                        fontSize: 28,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      decoration: _inputDecoration(),
                      child: TextField(
                        controller: _nameController,
                        style: const TextStyle(color: Color(0xFF4A4A4A)),
                        decoration: _inputFieldDecoration(Icons.person, "Name"),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      decoration: _inputDecoration(),
                      child: TextField(
                        controller: _emailController,
                        style: const TextStyle(color: Color(0xFF4A4A4A)),
                        decoration: _inputFieldDecoration(Icons.email, "Email ID"),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      decoration: _inputDecoration(),
                      child: TextField(
                        controller: _passwordController,
                        obscureText: true,
                        style: const TextStyle(color: Color(0xFF4A4A4A)),
                        decoration: _inputFieldDecoration(Icons.lock, "Password"),
                      ),
                    ),
                    const SizedBox(height: 30),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        gradient: const LinearGradient(
                          colors: [Color(0xFF64B5F6), Color(0xFF4FC3F7)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF64B5F6).withOpacity(0.3),
                            blurRadius: 15,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        onPressed: ()async {
                          await createAccount();
                        },
                        child: Text(
                          "SIGN UP",
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Already have an account? ",
                            style: GoogleFonts.poppins(
                              color: Colors.grey.shade600,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            "Login",
                            style: GoogleFonts.poppins(
                              color: const Color(0xFF64B5F6),
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(height: 1, width: 40, color: Colors.grey.shade300),
                        const SizedBox(width: 10),
                        const Icon(Icons.circle, size: 6, color: Color(0xFF64B5F6)),
                        const SizedBox(width: 10),
                        Container(height: 1, width: 40, color: Colors.grey.shade300),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  BoxDecoration _inputDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(15),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.1),
          blurRadius: 10,
          spreadRadius: 2,
        ),
      ],
      border: Border.all(
        color: const Color(0xFFEDE7F6),
        width: 1.5,
      ),
    );
  }

  InputDecoration _inputFieldDecoration(IconData icon, String hintText) {
    return InputDecoration(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      prefixIcon: Icon(icon, color: const Color(0xFF64B5F6)),
      hintText: hintText,
      hintStyle: TextStyle(color: Colors.grey.shade500),
      border: InputBorder.none,
    );
  }
}
