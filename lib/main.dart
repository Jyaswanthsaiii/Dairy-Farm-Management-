import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diary_farm/admin.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'models/user_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp(
        options: FirebaseOptions(
            apiKey: 'AIzaSyASAY9kzt5xirmckqxt8VUlV6oGT6aS6Jc',
            appId: '1:285897096632:android:58d602a5499e33eebca34d',
            messagingSenderId: '285897096632',
            projectId: 'diary-farm-final'));
  }
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  LoginPage_state createState() => LoginPage_state();
}

class LoginPage_state extends State<LoginPage> {
  //final _formkey = GlobalKey<FormState>();
  final email_controller = TextEditingController();
  final password_controller = TextEditingController();
  bool isLogin = false;
  bool isLoading = false;

  Future signInWithEmailAndPassword() async {
    try {
      setState(() {
        isLoading = true;
      });
      print('hello');
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email_controller.text, password: password_controller.text);

      setState(() {
        isLoading = false;
        isLogin = true;
      });

      print('hello');
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => AdminDashboard()),
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        isLoading = false;
      });
      if (e.code == 'user-not-found') {
        return ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('user not found')),
        );
      } else if (e.code == 'wrong-password') {
        return ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('wrong password')),
        );
      } else if (e.code == 'invalid-email') {
        return ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('invalid email format')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
                'assets/diary.jpg'), // Replace 'assets/diary.jpg' with your actual image asset path
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Card(
              elevation: 8.0,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Welcome to Dairy Farm Shop',
                      style: TextStyle(
                          fontSize: 24.0, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 20.0),
                    Text(
                      'Login',
                      style: TextStyle(fontSize: 20.0),
                    ),
                    SizedBox(height: 20.0),
                    TextField(
                      controller: email_controller,
                      decoration: InputDecoration(
                        hintText: 'Username',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 10.0),
                    TextField(
                      controller: password_controller,
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: 'Password',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 20.0),
                    ElevatedButton(
                      onPressed: () {
                        signInWithEmailAndPassword();
                        // Add your login functionality here
                      },
                      child: Text('Login'),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(Colors
                            .blue), // Change the color to whatever you like
                      ),
                    ),
                    SizedBox(height: 10.0),
                    Text("Don't have an account?"),
                    SizedBox(height: 5.0),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  SignupPage()), // Navigate to the signup screen
                        );
                        // Add your signup page navigation here
                      },
                      child: Text('Sign Up'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class SignupPage extends StatefulWidget {
  @override
  SignupPage_state createState() => SignupPage_state();
}

class SignupPage_state extends State<SignupPage> {
  final reg_email_controller = TextEditingController();
  final reg_password_controller = TextEditingController();
  final reg_username_controller = TextEditingController();

  bool isLoading = false;

  Future createUserWithEmailAndPassword() async {
    try {
      setState(() {
        isLoading = true;
      });
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: reg_email_controller.text,
              password: reg_password_controller.text);

      String uid = userCredential.user?.uid ?? '';

      UserModel user = UserModel(
        email: reg_email_controller.text,
        name: reg_username_controller.text,
        password: reg_password_controller.text,
        imageurl: '',
        uid: uid,
      );

      CollectionReference userdata =
          FirebaseFirestore.instance.collection('user');
      userdata.add(user.toJson());

      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Registeration succesful')),
      );

      return AdminDashboard();
      //Navigator.pop(context, 'home');
      /*Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HomePage(),
        ),
      );*/
    } on FirebaseAuthException catch (e) {
      setState(() {
        isLoading = false;
      });
      if (e.code == 'email-already-in-use') {
        return ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('email already in use')),
        );
      } else if (e.code == 'weak-password') {
        return ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('password should contain 6 characters')),
        );
      } else if (e.code == 'invalid-email') {
        return ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('invalid email format')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
                'assets/diary.jpg'), // Replace 'assets/diary.jpg' with your actual image asset path
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Card(
              elevation: 8.0,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Welcome to Dairy Farm Shop',
                      style: TextStyle(
                          fontSize: 24.0, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 20.0),
                    Text(
                      'Signup',
                      style: TextStyle(fontSize: 20.0),
                    ),
                    SizedBox(height: 20.0),
                    TextField(
                      decoration: InputDecoration(
                        hintText: 'Username',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 10.0),
                    TextField(
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: 'Create Password',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 10.0),
                    TextField(
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: 'Confirm Password',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 20.0),
                    ElevatedButton(
                      onPressed: () {
                        // Add your login functionality here
                      },
                      child: Text('Signup'),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(Colors
                            .blue), // Change the color to whatever you like
                      ),
                    ),
                    SizedBox(height: 10.0),
                    Text("Already have an account?"),
                    SizedBox(height: 5.0),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  LoginPage()), // Navigate to the signup screen
                        );
                        // Add your signup page navigation here
                      },
                      child: Text('Login'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
