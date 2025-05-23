import 'package:flutter/material.dart';
import 'package:schola/barrel.dart';

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
    // Needed but don't know why
    await Amplify.DataStore.stop();
    await Amplify.DataStore.start();

    Amplify.DataStore.observe(Friendship.classType).listen((event) {
      Log.i(
        'DataStore event: ${event.eventType} on model: ${event.item.runtimeType}',
      );
    });

    Amplify.Hub.listen(HubChannel.Auth, (hubEvent) async {
      if (hubEvent.eventName == 'SIGNED_IN') {
        // Needed or else DataStore won't sync
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
