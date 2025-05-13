import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:frontend1/pages/login_page.dart';
import 'package:http/http.dart' as http;
import '../config.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController passwordController2 = TextEditingController();
  bool _isNotValidate = false;
  bool _isLoading = false;

  void signUserUp() async {
  print("Sign up button pressed");

  // Check if email and password are filled
  if (emailController.text.isNotEmpty && passwordController.text.isNotEmpty) {
    if (passwordController.text != passwordController2.text) {
      // If passwords do not match
      setState(() {
        _isNotValidate = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Passwords do not match', style: TextStyle(color: Colors.red))),
      );
      return;  // Stop the function execution
    }

    print("Email and passwords are valid");
    setState(() {
      _isLoading = true;  // Show loading indicator
      _isNotValidate = false;  // Reset validation error
    });

    var regBody = {
      "email": emailController.text,
      "password": passwordController.text
    };

    try {
      print("Sending request to server...");
      var response = await http.post(
        Uri.parse('http://$localhost/register'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(regBody),
      );

      print("Received response from server");
      print("Response status code: ${response.statusCode}");
      print("Response body: ${response.body}");

      var jsonResponse = jsonDecode(response.body);
      if (jsonResponse['status'] == true) {
        print("Sign up successful");
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
        );
      } else {
        print("Sign up failed: ${jsonResponse['message']}");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login failed: ${jsonResponse['message']}')),
        );
      }
    } catch (e) {
      print("Error occurred: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred. Please try again.')),
      );
    } finally {
      setState(() {
        _isLoading = false;  // Stop loading indicator
      });
    }
  } else {
    print("Email or password is empty");
    setState(() {
      _isNotValidate = true;
    });
  }
}

  


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
                 children: [
      
        
        const Text(
                'Create your account',
                style: TextStyle(
                color: Color.fromARGB(255, 179, 179, 179), 
                fontSize: 18,
                fontWeight: FontWeight.bold,
                ),
                ),
        
        //username
        const SizedBox(height: 25),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
         child: TextField(
            controller: emailController,
            decoration: const InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blue),
              ),
              fillColor: Color.fromARGB(255, 251, 246, 246)
              ,
              filled: true,
              hintText: "Email",
              hintStyle: TextStyle(color: Color.fromARGB(255, 214, 214, 214))
            ),
          ),
        ),

        //password
        const SizedBox(height: 25),
         Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: TextField(
            obscureText: true,
            controller: passwordController,
            decoration: const InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blue),
              ),
              fillColor: Color.fromARGB(255, 251, 246, 246)
              ,
              filled: true,
              hintText: "Password",
              hintStyle: TextStyle(color: Color.fromARGB(255, 214, 214, 214))

            ),
          )
        ),
       
        //Confirm password
        const SizedBox(height: 25),
         Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: TextField(
            obscureText: true,
            controller: passwordController2,
            decoration: const InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blue),
              ),
              fillColor: Color.fromARGB(255, 251, 246, 246)
              ,
              filled: true,
              hintText: "Confirm password",
              hintStyle: TextStyle(color: Color.fromARGB(255, 214, 214, 214))

            ),
          )
        ),
  

  
        //sign in button
        const SizedBox(height: 25),
        GestureDetector(
           onTap: signUserUp,
                   
        child: Container(
          padding: const EdgeInsets.all(25),
          margin: const EdgeInsets.symmetric(horizontal: 25),
          decoration: BoxDecoration(
            color:Colors.blue,
            borderRadius: BorderRadius.circular(8), 
          ),
          child: const Center(child: Text(
            'Register',
             style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
             )),)
        )
        ),

        // or continue
        // const SizedBox(height: 50),
        // Padding(
        //   padding: const EdgeInsets.symmetric(horizontal: 25.0),
        //   child: Row(children: [
        //   Expanded(child: Divider(
        //     thickness: 0.5,
        //     color: Colors.grey[400],
        //   ),
        //   ),
        //   const Text('Or continue with'),
        //   Expanded(child: Divider(
        //     thickness: 0.5,
        //     color: Colors.grey[400],),)
        // ],)
        // ),
        // //google + apple sign in 
        // Row(
        //   mainAxisAlignment: MainAxisAlignment.center,
        //   children: [
        //     Container(
        //       padding: const EdgeInsets.all(20),
        //       decoration: BoxDecoration(
        //         border: Border.all(color: Colors.white),
        //         borderRadius: BorderRadius.circular(16),
               
        //       ),
        //       child: Image.asset('lib/images/google.png', height: 40,),
        //     ),

        //     const SizedBox(width:  25),

        //     Container(
        //       padding: const EdgeInsets.all(20),
        //       decoration: BoxDecoration(
        //         border: Border.all(color: Colors.white),
        //         borderRadius: BorderRadius.circular(16),
               
        //       ),
        //       child: Image.asset('lib/images/apple.png', height: 40,),
        //     )
            
        //   ],),

        const SizedBox(height: 50),
        //not memeber regerster now 
        Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Already a Member?"),
              const SizedBox(width: 4),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginPage()), // Replace SignUpPage with your sign-up page widget
                  );
                },
                child: const Text(
                  'Login now',
                  style: TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          )

  





  ],)
        ),
   
      )
    );
  }
  

  }