
import 'package:flutter/material.dart';
import 'package:frontend1/config.dart';
import 'package:frontend1/pages/DashBoard.dart';
import 'package:frontend1/pages/signup_page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool _isNotValidate = false;
  bool _isLoading = false;

  void signUserIn() async {
    if (emailController.text.isNotEmpty && passwordController.text.isNotEmpty) {
      setState(() {
        _isLoading = true;
      });

      var regBody = {
        "email": emailController.text,
        "password": passwordController.text
      };

      try {
        var response = await http.post(
          Uri.parse('http://$localhost/login'),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(regBody),
        );

        var jsonResponse = jsonDecode(response.body);
        if (jsonResponse['status'] == true) {
          String token = jsonResponse['token'];
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('token', token);
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => DashboardPage()),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(jsonResponse['message'], style: const TextStyle(color: Colors.red))),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('An error occurred. Please try again.', style: TextStyle(color: Colors.red))),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    } else {
      setState(() {
        _isNotValidate = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in both email and password', style: TextStyle(color: Colors.red))),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: constraints.maxWidth > 600 ? 100.0 : 25.0,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 50),
                      Text(
                        'Think it. Make it.',
                        style: GoogleFonts.montserrat(
                          color: Colors.black,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Login to your account',
                        style: GoogleFonts.montserrat(
                          color: const Color.fromARGB(255, 179, 179, 179),
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 25),
                      TextField(
                        controller: emailController,
                        decoration: InputDecoration(
                          enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue),
                          ),
                          fillColor: const Color.fromARGB(255, 251, 246, 246),
                          filled: true,
                          hintText: "Email",
                          hintStyle: GoogleFonts.montserrat(
                            color: const Color.fromARGB(255, 214, 214, 214),
                          ),
                        ),
                      ),
                      const SizedBox(height: 25),
                      TextField(
                        obscureText: true,
                        controller: passwordController,
                        decoration: InputDecoration(
                          enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue),
                          ),
                          fillColor: const Color.fromARGB(255, 251, 246, 246),
                          filled: true,
                          hintText: "Password",
                          hintStyle: GoogleFonts.montserrat(
                            color: const Color.fromARGB(255, 214, 214, 214),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          GestureDetector(
                            onTap: () {
                              // Navigate to the Forget Password page
                            },
                            child: Text(
                              'Forgot Password?',
                              style: GoogleFonts.montserrat(
                                color: const Color.fromARGB(255, 179, 179, 179),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 25),
                      GestureDetector(
                        onTap: signUserIn,
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            child: Text(
                              'Sign In',
                              style: GoogleFonts.montserrat(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 50),
                      Row(
                        children: [
                          Expanded(
                            child: Divider(
                              thickness: 0.5,
                              color: Colors.grey[400],
                            ),
                          ),
                          const Text('Or continue with'),
                          Expanded(
                            child: Divider(
                              thickness: 0.5,
                              color: Colors.grey[400],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.white),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Image.asset('lib/images/google.png', height: 40),
                          ),
                          const SizedBox(width: 25),
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.white),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Image.asset('lib/images/apple.png', height: 40),
                          ),
                        ],
                      ),
                      const SizedBox(height: 25),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Not a Member?"),
                          const SizedBox(width: 4),
                          GestureDetector(
                            onTap: () { Navigator.push(
      context,
      MaterialPageRoute(builder: (context) =>SignInPage()), // Replace `RegisterPage` with the actual widget for your registration page
    );},
                            child: Text(
                              'Register now',
                              style: GoogleFonts.montserrat(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

//-----------------------------------------------
/*
import 'package:flutter/material.dart';
import 'package:frontend1/config.dart';
import 'package:frontend1/pages/BrowseTemplatesPage.dart';
import 'package:frontend1/pages/DashBoard.dart';
import 'package:frontend1/pages/signup_page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool _isNotValidate = false;
  bool _isLoading = false;


  void signUserIn() async {
    if (emailController.text.isNotEmpty && passwordController.text.isNotEmpty) {
      setState(() {
        _isLoading = true;
      });

      var regBody = {
        "email": emailController.text,
        "password": passwordController.text
      };

      try {
        var response = await http.post(
          Uri.parse('http://$localhost/login'),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(regBody),
        );

        var jsonResponse = jsonDecode(response.body);
        if (jsonResponse['status'] == true) {
          String token = jsonResponse['token'];
        //  print("token is $token" );
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('token', token);
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => DashboardPage()),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(jsonResponse['message'], style: const TextStyle(color: Colors.red))),
          );
        }
      } catch (e) {
        print(e);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('An error occurred. Please try again.', style: TextStyle(color: Colors.red))),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    } else {
      setState(() {
        _isNotValidate = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in both email and password', style: TextStyle(color: Colors.red))),
      );
    }
  }

  /*
@override
void dispose() {
  emailFocusNode.dispose();
  passwordFocusNode.dispose();
  super.dispose();
}
*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isLargeScreen = constraints.maxWidth > 800;
            return Center(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: isLargeScreen ? 150.0 : 20.0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Optional side panel for large screens
                    if (isLargeScreen)
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Welcome Back!',
                              style: GoogleFonts.montserrat(
                                fontSize: 36,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'Sign in to access your account and stay connected.',
                              style: GoogleFonts.montserrat(
                                fontSize: 18,
                                color: Colors.grey[600],
                              ),
                            ),
                            const SizedBox(height: 20),
                            /*
                            Image.asset(
                              'lib/images/google.png',
                              fit: BoxFit.contain,
                              height: 200,
                            ),
                            */ // Add your illustration/image here
                          ],
                        ),
                      ),
                    SizedBox(width: isLargeScreen ? 50 : 0),
                    // Login form
                    Expanded(
                      flex: isLargeScreen ? 1 : 2,
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Think it. Make it.',
                              style: GoogleFonts.montserrat(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'Login to your account',
                              style: GoogleFonts.montserrat(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey[600],
                              ),
                            ),
                            const SizedBox(height: 30),
                            TextField(
                              controller: emailController,
                              decoration: InputDecoration(
                                hintText: 'Email',
                                hintStyle: GoogleFonts.montserrat(),
                                filled: true,
                                fillColor: Colors.grey[200],
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.blue),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            TextField(
                              obscureText: true,
                              controller: passwordController,
                              decoration: InputDecoration(
                                hintText: 'Password',
                                hintStyle: GoogleFonts.montserrat(),
                                filled: true,
                                fillColor: Colors.grey[200],
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.blue),
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                'Forgot Password?',
                                style: GoogleFonts.montserrat(
                                  color: Colors.blue,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            const SizedBox(height: 30),
                            GestureDetector(
                              onTap: signUserIn,
                              child: Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(15),
                                decoration: BoxDecoration(
                                  color: Colors.blue,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Center(
                                  child: Text(
                                    'Sign In',
                                    style: GoogleFonts.montserrat(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            Row(
                              children: [
                                Expanded(
                                  child: Divider(
                                    thickness: 1,
                                    color: Colors.grey[400],
                                  ),
                                ),
                                const SizedBox(width: 10),
                                const Text('Or continue with'),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Divider(
                                    thickness: 1,
                                    color: Colors.grey[400],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(15),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Image.asset(
                                    'lib/images/google.png',
                                    height: 30,
                                  ),
                                ),
                                const SizedBox(width: 20),
                                Container(
                                  padding: const EdgeInsets.all(15),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Image.asset(
                                    'lib/images/apple.png',
                                    height: 30,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text('Not a Member?'),
                                const SizedBox(width: 5),
                                GestureDetector(
                                  onTap: () {
                                    // Navigate to the registration page
                                  },
                                  child: Text(
                                    'Register now',
                                    style: GoogleFonts.montserrat(
                                      color: Colors.blue,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
*/