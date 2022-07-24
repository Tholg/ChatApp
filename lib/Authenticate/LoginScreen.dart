import 'package:chat_app/Screen/HomeScreen.dart';
import 'package:chat_app/Authenticate/Methods.dart';
import 'package:chat_app/Authenticate/SignUpScreen.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _pass = TextEditingController();
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: isLoading
          ? Center(
              child: Container(
                height: size.height / 30,
                width: size.width / 20,
                child: CircularProgressIndicator(),
              ),
            )
          : SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: size.height / 20,
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    width: size.width / 1.2,
                    child: IconButton(
                      icon: Icon(Icons.arrow_back_ios),
                      onPressed: () {},
                    ),
                  ),
                  SizedBox(
                    height: size.height / 50,
                  ),
                  Container(
                    width: size.width / 1.3,
                    child: Text(
                      "Welcome",
                      style:
                          TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    width: size.width / 1.3,
                    child: Text(
                      "Sign to Contiue",
                      style: TextStyle(
                          color: Colors.grey,
                          fontSize: 28,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                  SizedBox(height: size.height / 15),
                  Container(
                      width: size.width,
                      alignment: Alignment.center,
                      child: field(size, "email", Icons.account_box, _email)),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    child: Container(
                      width: size.width,
                      alignment: Alignment.center,
                      child: field(size, "pass", Icons.lock, _pass),
                    ),
                  ),
                  SizedBox(
                    height: size.height / 15,
                  ),
                  CustomeButon(size),
                  SizedBox(
                    height: size.height / 40,
                  ),
                  GestureDetector(
                    onTap: () => Navigator.of(context)
                        .push(MaterialPageRoute(builder: (_) => Signup())),
                    child: Text(
                      "Create Account",
                      style: TextStyle(
                          color: Colors.blue,
                          fontSize: 16,
                          fontWeight: FontWeight.w500),
                    ),
                  )
                ],
              ),
            ),
    );
  }

  Widget CustomeButon(Size size) {
    return GestureDetector(
      onTap: (() {
        if (_email.text.isNotEmpty && _pass.text.isNotEmpty) {
          setState(() {
            isLoading = true;
          });
          LogIn(_email.text, _pass.text).then((user) {
            if (user != null) {
              print("Login SuccessFull");
              setState(() {
                isLoading = false;
              });
              Navigator.push(
                  context, MaterialPageRoute(builder: (_) => HomeScreen()));
            } else {
              print("Login Field");
              setState(() {
                isLoading = false;
              });
            }
          });
        } else {
          print("Please fill form correctly");
        }
      }),
      child: Container(
        height: size.height / 20,
        width: size.width / 1.2,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5), color: Colors.blue),
        alignment: Alignment.center,
        child: Text(
          "Login",
          style: TextStyle(
              color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget field(Size size, String hintText, IconData icon,
      TextEditingController controller) {
    return Container(
      height: size.height / 15,
      width: size.width / 1.1,
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
            prefixIcon: Icon(icon),
            hintText: hintText,
            hintStyle: TextStyle(color: Colors.grey),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
      ),
    );
  }
}
