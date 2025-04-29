import 'package:schola/barrel.dart';

import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Log.init();

  await Amplify.addPlugins([
    AmplifyDataStore(modelProvider: ModelProvider.instance),
    AmplifyAPI(),
    AmplifyAuthCognito(),
  ]);
  await Amplify.configure(amplifyconfig);
  // await Amplify.DataStore.clear();
  await Amplify.DataStore.start();

  Amplify.DataStore.observe(User.classType).listen((event) {
    Log.i('GLOBAL SYNC for User ${event.item.toJson()}');
  });

  Amplify.Hub.listen(HubChannel.Auth, (hubEvent) async {
    if (hubEvent.eventName == 'SIGNED_IN') {
      Log.i('Waiting for DataScore to sync');

      bool isSynced = false;
      final syncSubscription = Amplify.DataStore.observe(User.classType).listen(
        (event) {
          Log.i('Sync received for user: ${event.item.id}');
          isSynced = true;
        },
      );

      for (int i = 0; i < 20; i++) {
        if (isSynced) break;
        await Future.delayed(const Duration(milliseconds: 500));
      }
      syncSubscription.cancel();
    } else if (hubEvent.eventName == 'SIGNED_OUT') {
      Log.i('Clearing DataStore');
      await Amplify.DataStore.clear();
    }
  });

  runApp(const App());
}
