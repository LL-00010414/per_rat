import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:per_rat/components/my_button.dart';
import 'package:per_rat/components/my_textfield.dart';
import 'package:per_rat/components/square_tile.dart';
import 'package:per_rat/screens/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({
    super.key,
    required this.onTap,
  });

  final Function()? onTap;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void signUserIn() async {
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      Navigator.of(context).maybePop();
    } on FirebaseAuthException catch (e) {
      //quit loading circle
      Navigator.maybePop(context);

      if (e.code == 'channel-error') {
        Navigator.pop(context);
        showErrorMessage('Please fill both login and password');
      } else {
        showErrorMessage(e.code);
      }
    }
  }

  void showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.white,
        content: Text(message),
        action: SnackBarAction(
          label: '',
          onPressed: () {
            // Code to execute.
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        // leading: TextButton(
        //   style: const ButtonStyle(
        //     iconColor: MaterialStatePropertyAll(Colors.white),
        //     backgroundColor:
        //         MaterialStatePropertyAll(Color.fromARGB(255, 169, 152, 55)),
        //   ),
        //   onPressed: () {
        //     Navigator.pop(context);
        //   },
        //   child: const SizedBox(
        //     width: 30,
        //     height: 10,
        //     child: Icon(Icons.arrow_back),
        //   ),
        // ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 30,
              ),
              Image.asset(
                'assets/icon/playstore.png',
                height: 150,
                fit: BoxFit.cover,
                //colorBlendMode: BlendMode.src,
              ),
              const SizedBox(
                height: 30,
              ),
              Text(
                'Welcome back, user!',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onTertiary,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              MyTextField(
                controller: emailController,
                hintText: '${AutofillHints.username} or ${AutofillHints.email}',
                obscureText: false,
              ),
              const SizedBox(
                height: 10,
              ),
              MyTextField(
                controller: passwordController,
                hintText: AutofillHints.password,
                obscureText: true,
              ),
              const SizedBox(
                height: 25,
              ),
              const Text(
                'Forgot password?',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              MyButton(
                onTap: signUserIn,
                buttonText: 'Sign In',
              ),
              const SizedBox(
                height: 50,
              ),
              Padding(
                padding: const EdgeInsets.all(25),
                child: Row(
                  children: [
                    Expanded(
                      child: Divider(
                        thickness: 1,
                        color: Colors.red.shade300,
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10,
                      ),
                      child: Text(
                        'Or continue with...',
                        style: TextStyle(fontSize: 16, color: Colors.black54),
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        thickness: 1,
                        color: Colors.red.shade300,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SquareTile(
                    onTap: () => AuthService().signInWithGoogle(),
                    imagePath: 'assets/sign_in/google.png',
                  ),
                  const SizedBox(
                    width: 40,
                  ),
                  SquareTile(
                    onTap: () {},
                    imagePath: 'assets/sign_in/apple.png',
                  ),
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Not a user?'),
                  const SizedBox(
                    width: 5,
                  ),
                  Center(
                    child: GestureDetector(
                      onTap: widget.onTap,
                      child: const Text(
                        'Register now',
                        style: TextStyle(
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 50,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
