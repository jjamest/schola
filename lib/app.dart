import 'package:schola/barrel.dart';

import 'package:flutter/material.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return Authenticator(
      authenticatorBuilder: (context, state) {
        if (state.currentStep == AuthenticatorStep.signIn) {
          return LoginPage(state: state);
        } else if (state.currentStep == AuthenticatorStep.signUp) {
          return SignUpPage(state: state);
        }
        return null;
      },
      child: MaterialApp(
        builder: Authenticator.builder(),
        theme: ScholaTheme.darkTheme,
        home: FutureBuilder<bool>(
          future: Util.userModelExists(),
          builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              Log.e('Snapshot error: ${snapshot.error}');
            } else if (snapshot.hasData) {
              if (snapshot.data == false) {
                return const WelcomePage();
              } else {
                return const Navigation();
              }
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
