import 'package:flutter/material.dart';
import 'dart:ui'; // For the blur effect
import 'package:project_pam/Helper/hiveDatabase.dart';
import 'package:project_pam/Model/dataModel.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();

  final HiveDatabase _hive = HiveDatabase();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background Image with blur
          Image.asset(
            'assets/coffee_background.jpg', // Add your image asset
            fit: BoxFit.cover,
          ),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0), // Blur effect
            child: Container(
              color: Colors.black
                  .withOpacity(0.5), // Slight overlay for better readability
            ),
          ),
          // The main content
          SingleChildScrollView(
            child: Center(
              child: Container(
                padding: EdgeInsets.all(12),
                constraints:
                    BoxConstraints(maxWidth: 400), // Max width for form
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Icon Gelas Berisi Kopi
                      Icon(
                        Icons.local_cafe,
                        size: 80,
                        color: const Color.fromARGB(255, 254, 254, 253),
                      ),
                      SizedBox(height: 20),

                      // Welcome Text
                      Text(
                        "Welcome to Coffee Drink!",
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                          color: const Color.fromARGB(255, 255, 254, 254),
                        ),
                      ),
                      SizedBox(height: 10),

                      // Subheading
                      Text(
                        "Sign up to get your day started",
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 16,
                          color: Colors.brown[400],
                        ),
                      ),
                      SizedBox(height: 30),

                      // Username Field
                      TextFormField(
                        controller: _usernameController,
                        style:
                            TextStyle(color: Colors.white), // White text color
                        decoration: const InputDecoration(
                          hintText: "Username",
                          hintStyle: TextStyle(
                            fontFamily: 'Montserrat',
                            color: Colors.white, // White hint text color
                          ),
                          contentPadding: EdgeInsets.all(8),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            borderSide: BorderSide(
                              color: Color.fromARGB(255, 255, 255, 255),
                            ),
                          ),
                        ),
                        validator: (String? value) {
                          if (value!.trim().isEmpty) {
                            return 'Username is required';
                          }
                          return null;
                        },
                      ),
                      Padding(padding: const EdgeInsets.only(bottom: 10)),

                      // Password Field
                      TextFormField(
                        controller: _passwordController,
                        obscureText: true,
                        style:
                            TextStyle(color: Colors.white), // White text color
                        decoration: const InputDecoration(
                          hintText: "Password",
                          hintStyle: TextStyle(
                            fontFamily: 'Montserrat',
                            color: Colors.white, // White hint text color
                          ),
                          contentPadding: EdgeInsets.all(8),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            borderSide: BorderSide(
                              color: Color.fromARGB(255, 255, 255, 255),
                            ),
                          ),
                        ),
                        validator: (String? value) {
                          if (value!.trim().isEmpty) {
                            return 'Password is required';
                          }
                          return null;
                        },
                      ),
                      Padding(padding: const EdgeInsets.only(bottom: 10)),

                      // Confirm Password Field
                      TextFormField(
                        controller: _confirmPasswordController,
                        obscureText: true,
                        style:
                            TextStyle(color: Colors.white), // White text color
                        decoration: const InputDecoration(
                          hintText: "Confirm Password",
                          hintStyle: TextStyle(
                            fontFamily: 'Montserrat',
                            color: Colors.white, // White hint text color
                          ),
                          contentPadding: EdgeInsets.all(8),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            borderSide: BorderSide(
                              color: Color.fromARGB(255, 251, 250, 250),
                            ),
                          ),
                        ),
                        validator: (String? value) {
                          if (value!.trim().isEmpty) {
                            return 'Please confirm your password';
                          } else if (value != _passwordController.text) {
                            return 'Passwords do not match';
                          }
                          return null;
                        },
                      ),
                      Padding(padding: const EdgeInsets.only(bottom: 25)),

                      // Sign Up Button
                      _buildRegisterButton(),

                      // "Or" Text
                      SizedBox(height: 20), // Spacing before "Or"
                      Text(
                        "Or",
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 20), // Spacing before social icons

                      // Social Media Login Icons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Facebook Button with icon
                          _socialMediaButton(
                            icon: Icons.facebook,
                            color: Colors.blue,
                            label: 'Facebook',
                            onPressed: () {
                              print('Facebook login');
                            },
                          ),
                          SizedBox(width: 20), // Spacing between icons

                          // Google Button with icon
                          _socialMediaButton(
                            icon: Icons
                                .email, // Use Google logo here if available
                            color: Colors.red,
                            label: 'Google',
                            onPressed: () {
                              print('Google login');
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Common button for social media login
  Widget _socialMediaButton({
    required IconData icon,
    required Color color,
    required String label,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color, // Background color for button
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      ),
      icon: Icon(
        icon,
        size: 30,
        color: Colors.white,
      ),
      label: Text(
        label,
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _commonSubmitButton({
    required String labelButton,
    required Function(String) submitCallback,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      width: MediaQuery.of(context).size.width,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.brown, // Button color
          padding: EdgeInsets.all(10.0),
          fixedSize: Size(180, 40),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15), // <-- Radius
          ),
        ),
        child: Text(
          labelButton,
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.w600,
            fontSize: 12,
            color: Colors.white, // Text color white
          ),
        ),
        onPressed: () {
          submitCallback(labelButton);
        },
      ),
    );
  }

  Widget _buildRegisterButton() {
    return _commonSubmitButton(
      labelButton: "Sign Up",
      submitCallback: (value) {
        if (_formKey.currentState!.validate()) {
          // If form is valid, perform registration
          var encryptedPassword =
              DataModel.encryptPassword(_passwordController.text);

          print('Username: ${_usernameController.text}');
          print('Password: ${_passwordController.text}');
          print('Encrypted Password: $encryptedPassword');

          _hive.addData(DataModel(
            username: _usernameController.text,
            password: _passwordController.text,
            encryptedPassword: encryptedPassword,
          ));

          _usernameController.clear();
          _passwordController.clear();
          _confirmPasswordController.clear();

          setState(() {});

          Navigator.pop(context);
        }
      },
    );
  }
}
