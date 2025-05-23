import 'package:schola/barrel.dart';

class Util {
  Util._();

  static Future<bool> userModelExists() async {
    try {
      final currentUser = await Amplify.Auth.getCurrentUser();
      final userId = currentUser.userId;
      final users = await Amplify.DataStore.query(
        User.classType,
        where: User.ID.eq(userId),
      );
      final exists = users.isNotEmpty;
      return exists;
    } catch (e) {
      return false;
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

  static Future<User> getUserByID(String userId) async {
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

  static Future<String> getIDByUsername(String username) async {
    final userQuery = await Amplify.DataStore.query(
      User.classType,
      where: User.DISPLAYUSERNAME.eq(username),
    );

    if (userQuery.isNotEmpty) {
      return userQuery.first.id;
    } else {
      throw Exception('User model not found');
    }
  }
}
