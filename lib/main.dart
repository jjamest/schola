import 'package:schola/barrel.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Log.init();

  try {
    await Amplify.addPlugins([
      AmplifyDataStore(modelProvider: ModelProvider.instance),
      AmplifyAPI(),
      AmplifyAuthCognito(),
    ]);
    await Amplify.configure(amplifyconfig);
    await Amplify.DataStore.stop();
    await Amplify.DataStore.start();
    Log.i('Initial DataStore started');

    Amplify.Hub.listen(HubChannel.Auth, (hubEvent) async {
      if (hubEvent.eventName == 'SIGNED_IN') {
        await Amplify.DataStore.stop();
        await Amplify.DataStore.start();
      }
      if (hubEvent.eventName == 'SIGNED_OUT') {
        Log.i('Clearing DataStore');
        await Amplify.DataStore.clear();
      }
    });

    runApp(const App());
  } catch (e) {
    Log.e('Error initializing Amplify: $e');
    runApp(const Center(child: Text('Failed to start app')));
  }
}
