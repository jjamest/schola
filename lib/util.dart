import 'package:schola/barrel.dart';

class Util {
  Util._();

  static Future<bool> userModelExists() async {
    final currentUser = await Amplify.Auth.getCurrentUser();
    final userId = currentUser.userId;
    final userQuery = await Amplify.DataStore.query(
      User.classType,
      where: User.ID.eq(userId),
    );

    if (userQuery.isEmpty) {
      return false;
    } else {
      return true;
    }
  }

  static Future<String> getUserId() async {
    final currentUser = await Amplify.Auth.getCurrentUser();
    return currentUser.userId;
  }

  static Future<User> getUserModel() async {
    final userId = await getUserId();
    final userQuery = await Amplify.DataStore.query(
      User.classType,
      where: User.ID.eq(userId),
    );

    if (userQuery.isNotEmpty) {
      return userQuery.first;
    } else {
      throw Exception('User model not found');
    }
  }
}
