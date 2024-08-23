import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shoezo/screens/home.dart';
import 'package:shoezo/screens/navig.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          color: Color(0xff9daf9b),
          width: screenSize.width,
          height: isPortrait ? screenSize.height : null, // Set height only for portrait mode
          child: Center(
            child: Container(
              margin: EdgeInsets.all(12),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: isPortrait ? 30 : 10),
                    Text(
                      "Register",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: isPortrait ? 40 : 30,
                      ),
                    ),
                    SizedBox(height: isPortrait ? 20 : 10),
                    buildTextFormField(nameController, 'Name', TextInputType.name, 'Name is required'),
                    SizedBox(height: 20),
                    buildTextFormField(emailController, 'Email', TextInputType.emailAddress, 'Email is required'),
                    SizedBox(height: 20),
                    buildTextFormField(phoneController, 'Phone', TextInputType.phone, 'Phone is required'),
                    SizedBox(height: 20),
                    buildTextFormField(addressController, 'Address', TextInputType.streetAddress, 'Address is required'),
                    SizedBox(height: 20),
                    buildTextFormField(passwordController, 'Password', TextInputType.text, 'Password is required', obscureText: true),
                    SizedBox(height: 20),
                    buildTextFormField(confirmPasswordController, 'Confirm Password', TextInputType.text, 'Confirm Password is required', obscureText: true),
                    SizedBox(height: 20),
                    _isLoading
                        ? CircularProgressIndicator(color: Colors.white)
                        : MaterialButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20.0))),
                      elevation: 5.0,
                      height: 40,
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          setState(() {
                            _isLoading = true;
                          });
                          register(
                            nameController.text,
                            emailController.text,
                            phoneController.text,
                            addressController.text,
                            passwordController.text,
                            confirmPasswordController.text,
                          );
                        }
                      },
                      child: Text(
                        "Continue",
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                      color: Colors.white,
                    ),
                    SizedBox(height: 10),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  TextFormField buildTextFormField(
      TextEditingController controller, String hintText, TextInputType keyboardType, String validationMessage,
      {bool obscureText = false}) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        hintText: hintText,
        contentPadding: const EdgeInsets.only(left: 14.0, bottom: 8.0, top: 8.0),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
          borderRadius: BorderRadius.circular(10),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      keyboardType: keyboardType,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return validationMessage;
        }
        return null;
      },
    );
  }

  void register(String name, String email, String phone, String address, String password, String confirmPassword) async {
    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Passwords do not match")),
      );
      setState(() {
        _isLoading = false;
      });
      return;
    }

    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Add user details to Firestore
      await FirebaseFirestore.instance.collection('users').doc(userCredential.user?.uid).set({
        'name': name,
        'email': email,
        'phone': phone,
        'address': address,
      });

      print("User registered");
      Navigator.push(context, MaterialPageRoute(builder: (context) => const Navig()));
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      if (e.code == 'weak-password') {
        errorMessage = 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        errorMessage = 'The account already exists for that email.';
      } else {
        errorMessage = 'An error occurred. Please try again.';
      }
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(errorMessage)));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An unexpected error occurred. Please try again.')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
}
