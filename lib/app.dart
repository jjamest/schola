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
        theme: ScholaTheme.darkTheme,
        builder: Authenticator.builder(),
        home: HomeOrWelcome(),
      ),
    );
  }
}

class HomeOrWelcome extends StatefulWidget {
  const HomeOrWelcome({super.key});

  @override
  State<HomeOrWelcome> createState() => HomeOrWelcomeState();
}

class HomeOrWelcomeState extends State<HomeOrWelcome> {
  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    Amplify.Hub.listen(HubChannel.DataStore, (hubEvent) {
      if (hubEvent.eventName == "ready") {
        Log.i("Finally ready");
        setState(() {
          isLoading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(child: CircularProgressIndicator())
        : FutureBuilder<bool>(
          future: Util.userModelExists(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Scaffold(body: Center(child: CircularProgressIndicator()));
            }
            if (snapshot.hasData && snapshot.data == true) {
              return Navigation();
            }
            return WelcomePage();
          },
        );
  }
}
