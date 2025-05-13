import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:frontend1/pages/login_page.dart';
import 'package:http/http.dart' as http;




class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  TextEditingController emailController = TextEditingController();
  bool _isLoading = false;

  void requestPasswordReset() async {
    if (emailController.text.isNotEmpty) {
      setState(() {
        _isLoading = true;
      });

      var requestBody = {"email": emailController.text};

      try {
        var response = await http.post(
          Uri.parse('http://192.168.1.23:3000/forgot-password'),  // Your backend API
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(requestBody),
        );

        var jsonResponse = jsonDecode(response.body);
        if (jsonResponse['status'] == true) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Check your email for a password reset link')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: ${jsonResponse['message']}')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('An error occurred. Please try again.')),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter your email')),
      );
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
      
        const SizedBox(height: 50),
    
        const Text(
                'Forgot Password?',
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
       
  
        //sign in button
        const SizedBox(height: 25),
        GestureDetector(
         
        onTap: requestPasswordReset,
        child: Container(
          padding: const EdgeInsets.all(25),
          margin: const EdgeInsets.symmetric(horizontal: 25),
          decoration: BoxDecoration(
            color:Colors.blue,
            borderRadius: BorderRadius.circular(8), 
          ),
          child: const Center(
            child: Text('Request Password Reset',
             style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
             )),)
        )
        ),

      
        const SizedBox(height: 25),
        //not memeber regerster now 
        Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
            
              const SizedBox(width: 4),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginPage()), // Replace SignUpPage with your sign-up page widget
                  );
                },
                child: const Text(
                  'Login',
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