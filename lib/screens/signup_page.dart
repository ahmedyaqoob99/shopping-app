import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'login_page.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({Key? key}) : super(key: key);

  @override
  _SignupPageState createState() => _SignupPageState();
}

String p =
    r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

RegExp regExp = new RegExp(p);
String pattern = r'^(?:[+0][1-9])?[0-9]{10,12}$';
RegExp regExps = new RegExp(pattern);

class _SignupPageState extends State<SignupPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passController = TextEditingController();
  TextEditingController rePassController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool passHide = true;
  bool isChange = false;
  @override
  Widget build(BuildContext context) {
    Future send() async {
      try {
        // Authentication For Create User
        UserCredential userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: usernameController.text,
          password: passController.text,
        );

        // Send Data To Firestore
        await FirebaseFirestore.instance
            .collection("users")
            .doc(userCredential.user!.uid)
            .set({
          "name": nameController.text.trim(),
          "email": usernameController.text.trim(),
          "password": passController.text.trim(),
          "uid": userCredential.user!.uid,
        });
        // Clear TextField
        nameController.clear();
        usernameController.clear();
        passController.clear();
        rePassController.clear();
        // Navigate to Login Screen
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const LoginPage(),
          ),
        );

        setState(() {
          isChange = false;
        });
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("The password provided is too weak."),
            ),
          );
          print("'weak-password' ==> The password provided is too weak.");
        } else if (e.code == 'email-already-in-use') {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text("The account already exists for that email.")),
          );
          print(
              "'email-already-in-use' ==>The account already exists for that email.");
        }
      } catch (e) {
        print("error ==> $e");
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("$e")));
      }
    }

    void validation() {
      final _form = _formKey.currentState;
      if (_form!.validate()) {
        send();
      } else {
        setState(() {
          isChange = false;
        });
      }
    }

    return SafeArea(
      child: Scaffold(
        body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                const SizedBox(height: 100),
                Text(
                  "SIGN UP",
                  style: Theme.of(context).textTheme.headline3,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),
                TextFormField(
                  validator: (value) {
                    if (value == "" || value == null) {
                      return "Please fill Username";
                    } else if (value.length < 3) {
                      return "Username is too short";
                    }
                  },
                  decoration: const InputDecoration(
                    labelText: "Username",
                    border: OutlineInputBorder(),
                  ),
                  controller: nameController,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  validator: (value) {
                    if (value == "" || value == null) {
                      return "Please fill Email";
                    } else if (!regExp.hasMatch(value)) {
                      return "Email is Invalid";
                    }
                  },
                  decoration: const InputDecoration(
                    labelText: "Email",
                    border: OutlineInputBorder(),
                  ),
                  controller: usernameController,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  validator: (value) {
                    if (value == "" || value == null) {
                      return "Please fill Password";
                    } else if (value.length < 8) {
                      return "Password is less than 8";
                    }
                  },
                  obscureText: passHide,
                  decoration: InputDecoration(
                    labelText: "Password",
                    border: const OutlineInputBorder(),
                    suffixIcon: GestureDetector(
                      onTap: () {
                        // FocusScope.of(context).unfocus();
                        setState(() {
                          passHide = !passHide;
                        });
                      },
                      child: passHide
                          ? const Icon(Icons.visibility)
                          : const Icon(Icons.visibility_off),
                    ),
                  ),
                  controller: passController,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  validator: (value) {
                    if (value == "" || value == null) {
                      return "Please fill Password";
                    } else if (value.length < 8) {
                      return "Password is less than 8";
                    } else if (value != passController.text) {
                      return "Password doesn't match";
                    }
                  },
                  obscureText: passHide,
                  decoration: InputDecoration(
                    labelText: "Password",
                    border: const OutlineInputBorder(),
                    suffixIcon: GestureDetector(
                      onTap: () {
                        setState(() {
                          passHide = !passHide;
                        });
                      },
                      child: passHide
                          ? const Icon(Icons.visibility)
                          : const Icon(Icons.visibility_off),
                    ),
                  ),
                  controller: rePassController,
                ),
                const SizedBox(height: 30),
                InkWell(
                  onTap: () async {
                    setState(() {
                      isChange = true;
                    });

                    await Future.delayed(const Duration(seconds: 1));
                    validation();
                  },
                  child: AnimatedContainer(
                    duration: const Duration(seconds: 1),
                    width: isChange ? 45 : 160,
                    height: isChange ? 45 : 45,
                    alignment: Alignment.center,
                    child: isChange
                        ? const Icon(Icons.done_all)
                        : const FittedBox(
                            child: Text(
                              "SignUp",
                            ),
                          ),
                    decoration: BoxDecoration(
                        color: Colors.lightGreen,
                        borderRadius: BorderRadius.circular(isChange ? 45 : 8)),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Already have an account? "),
                    InkWell(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginPage(),
                        ),
                      ),
                      child: const Text(
                        "Login",
                        style: TextStyle(
                            color: Colors.lightGreen,
                            fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
