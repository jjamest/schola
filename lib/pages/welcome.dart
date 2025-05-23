import 'package:schola/barrel.dart';
import 'package:flutter/material.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<WelcomePage> {
  final _formKey = GlobalKey<FormState>();
  final _displayUsernameController = TextEditingController();
  final _schoolController = TextEditingController();

  void _onFormSubmit() async {
    if (_formKey.currentState!.validate()) {
      final newUser = User(
        id: await Util.getUserId(),
        displayUsername: _displayUsernameController.text,
        school: _schoolController.text,
      );

      await Amplify.DataStore.save(newUser);

      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Navigation()),
      );
    }
  }

  @override
  void dispose() {
    _displayUsernameController.dispose();
    _schoolController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Let\'s set up your profile'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 50, 20, 10),
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: SingleChildScrollView(
            child: Center(
              child: Column(
                children: [
                  Lottie.asset(
                    'assets/lottie/student_globe.json',
                    width: 200,
                    height: 200,
                    fit: BoxFit.fill,
                  ),
                  const SizedBox(height: 55),
                  Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        TextFormField(
                          controller: _displayUsernameController,
                          keyboardType: TextInputType.name,
                          decoration: InputDecoration(
                            labelText: 'Display Username',
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your username name';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 30),
                        TextFormField(
                          controller: _schoolController,
                          keyboardType: TextInputType.name,
                          decoration: InputDecoration(labelText: 'School'),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your school name';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 30),
                        TextButton(
                          onPressed: _onFormSubmit,
                          style: ButtonStyle(
                            backgroundColor: WidgetStateProperty.all(
                              ScholaTheme.accentBlue,
                            ),
                          ),
                          child: Text(
                            "Save & Continue",
                            style: TextStyle(color: ScholaTheme.accentWhite),
                          ),
                        ),
                      ],
                    ),
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
