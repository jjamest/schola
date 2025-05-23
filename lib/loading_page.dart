import 'package:flutter/material.dart';
import 'package:schola/barrel.dart';

class LoadingPage extends StatefulWidget {
  const LoadingPage({super.key});

  @override
  State<LoadingPage> createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset(
              'assets/lottie/loading_circle.json',
              height: 200,
              fit: BoxFit.fill,
            ),
            Text('Loading...', style: Theme.of(context).textTheme.labelSmall),
          ],
        ),
      ),
    );
  }
}
