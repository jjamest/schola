import 'package:flutter/material.dart';
import 'package:schola/barrel.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key, required this.state});

  final AuthenticatorState state;

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
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
                      'assets/lottie/student_globe.json',
                      width: 200,
                      height: 200,
                      fit: BoxFit.fill,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Join Schola',
                    style: Theme.of(context).textTheme.displayMedium,
                  ),
                  const SizedBox(height: 24),
                  SignUpForm.custom(
                    fields: [
                      SignUpFormField.username(),
                      SignUpFormField.password(),
                      SignUpFormField.passwordConfirmation(),
                    ],
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed:
                        () => widget.state.changeStep(AuthenticatorStep.signIn),
                    style: Theme.of(context).textButtonTheme.style,
                    child: const Text('Already have an account? Sign In'),
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
