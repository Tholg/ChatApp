import 'package:chat_app/Authenticate/Methods.dart';
import 'package:flutter/material.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final TextEditingController _name = TextEditingController();
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
                height: size.height / 20,
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
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  width: size.width / 1.3,
                  child: Text(
                    "Create Account to Contiue",
                    style: TextStyle(
                        color: Colors.grey,
                        fontSize: 20,
                        fontWeight: FontWeight.w500),
                  ),
                ),
                SizedBox(height: size.height / 20),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  child: Container(
                    width: size.width,
                    alignment: Alignment.center,
                    child: field(size, "Name", Icons.account_box, _name),
                  ),
                ),
                Container(
                    width: size.width,
                    alignment: Alignment.center,
                    child: field(size, "Email", Icons.account_box, _email)),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  child: Container(
                    width: size.width,
                    alignment: Alignment.center,
                    child: field(size, "Pass", Icons.lock, _pass),
                  ),
                ),
                SizedBox(
                  height: size.height / 15,
                ),
                CustomeButon(size),
                GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Text(
                      "Login",
                      style: TextStyle(
                          color: Colors.blue,
                          fontSize: 16,
                          fontWeight: FontWeight.w500),
                    ))
              ],
            )),
    );
  }

  Widget CustomeButon(Size size) {
    return GestureDetector(
      onTap: () {
        if (_name.text.isNotEmpty &&
            _email.text.isNotEmpty &&
            _pass.text.isNotEmpty) {
          setState(() {
            isLoading = true;
          });
          createAccount(_name.text, _email.text, _pass.text).then((user) {
            if (user != null) {
              setState(() {
                isLoading = false;
              });
              print("Create Success");
            } else {
              print("Create Field");
            }
          });
        } else {
          print("Please enter Fields");
        }
      },
      child: Container(
        height: size.height / 20,
        width: size.width / 1.2,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5), color: Colors.blue),
        alignment: Alignment.center,
        child: Text(
          "Create Account",
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
