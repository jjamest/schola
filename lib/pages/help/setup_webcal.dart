import 'package:flutter/material.dart';
import 'package:schola/barrel.dart';

class SetupWebcal extends StatefulWidget {
  const SetupWebcal({super.key});

  @override
  State<SetupWebcal> createState() => _SetupWebcalState();
}

class _SetupWebcalState extends State<SetupWebcal> {
  void _onTapAppleby(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ApplebySetup()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Select Your School',
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
        ),
        elevation: 0,
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () => _onTapAppleby(context),
                child: Image.asset('assets/schools/appleby.png', height: 100),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ApplebySetup extends StatefulWidget {
  const ApplebySetup({super.key});

  @override
  State<ApplebySetup> createState() => _ApplebySetupState();
}

class _ApplebySetupState extends State<ApplebySetup> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Setup Your School Schedule',
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildStepCard(
                context,
                stepNumber: '1',
                title: 'Navigate to BBK',
                description: 'Click on My Day, and then Schedule',
                imagePlaceholder: ClickableImage(
                  imagePath: 'assets/support/schedule/1.png',
                ),
              ),
              const SizedBox(height: 16),
              _buildStepCard(
                context,
                stepNumber: '2',
                title: 'Switch from Week to Month View',
                description:
                    'On the top right, click on the month tab to switch to month view',
                imagePlaceholder: ClickableImage(
                  imagePath: 'assets/support/schedule/2.png',
                ),
              ),
              const SizedBox(height: 16),
              _buildStepCard(
                context,
                stepNumber: '3',
                title: 'Press the share button',
                description: 'On the left, press share',
                imagePlaceholder: ClickableImage(
                  imagePath: 'assets/support/schedule/3.png',
                ),
              ),
              const SizedBox(height: 16),
              _buildStepCard(
                context,
                stepNumber: '4',
                title: 'Copy the WebCal URL',
                description: 'Copy the second link that starts with webcal://',
                imagePlaceholder: ClickableImage(
                  imagePath: 'assets/support/schedule/4.png',
                ),
              ),
              const SizedBox(height: 16),
              _buildStepCard(
                context,
                stepNumber: '5',
                title: 'Go back to Schola',
                description:
                    'Navigate to the Profile tab and press on the gear icon',
                imagePlaceholder: ClickableImage(
                  imagePath: 'assets/support/schedule/5.png',
                ),
              ),
              const SizedBox(height: 16),
              _buildStepCard(
                context,
                stepNumber: '6',
                title: 'Press the tab for Calendar URL',
                description: '',
                imagePlaceholder: ClickableImage(
                  imagePath: 'assets/support/schedule/6.png',
                ),
              ),
              const SizedBox(height: 16),
              _buildStepCard(
                context,
                stepNumber: '7',
                title: 'Paste the WebCal URL',
                description:
                    'Paste the WebCal URL you copied from BBK into the text box',
                imagePlaceholder: ClickableImage(
                  imagePath: 'assets/support/schedule/7.png',
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStepCard(
    BuildContext context, {
    required String stepNumber,
    required String title,
    required String description,
    Widget? imagePlaceholder,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: Theme.of(context).primaryColor,
                  child: Text(
                    stepNumber,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            imagePlaceholder ?? SizedBox.shrink(),
            const SizedBox(height: 12),
            Text(description, style: Theme.of(context).textTheme.bodyMedium),
          ],
        ),
      ),
    );
  }
}
