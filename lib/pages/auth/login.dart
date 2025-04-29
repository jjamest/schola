import 'package:schola/barrel.dart';

import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key, required this.state});

  final AuthenticatorState state;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: ScholaTheme.deepBlack,
        body: Center(
          child: Container(
            padding: const EdgeInsets.all(24),
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 40),
            decoration: BoxDecoration(
              color: ScholaTheme.darkGray,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: ScholaTheme.mediumGray, width: 0.5),
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Center(
                    child: Lottie.asset(
                      'assets/student_globe.json',
                      width: 200,
                      height: 200,
                      fit: BoxFit.fill,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Welcome to Schola',
                    style: Theme.of(context).textTheme.displayMedium,
                  ),
                  const SizedBox(height: 24),
                  SignInForm(),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed:
                        () => widget.state.changeStep(AuthenticatorStep.signUp),
                    style: Theme.of(context).textButtonTheme.style,
                    child: const Text("Don't have an account? Sign Up"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
