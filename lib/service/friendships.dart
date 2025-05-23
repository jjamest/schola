import 'package:schola/barrel.dart';

class FriendshipService {
  FriendshipService._();

  static void sendFriendRequest(String senderId, String receiverId) async {
    final friendship = Friendship(
      initiator: await Util.getUserByID(senderId),
      recipient: await Util.getUserByID(receiverId),
      status: FriendshipStatus.PENDING,
    );
    await Amplify.DataStore.save(friendship);
  }

  // Get list of requests pending for me
  static Future<List<Friendship>> getFriendRequests(String userId) async {
    final friendRequests = await Amplify.DataStore.query(
      Friendship.classType,
      where:
          Friendship.RECIPIENT.eq(userId) &
          Friendship.STATUS.eq(FriendshipStatus.PENDING),
    );
    return friendRequests;
  }

  static Future<List<User>> getFriends(String userId) async {
    final friends = await Amplify.DataStore.query(
      Friendship.classType,
      where:
          (Friendship.INITIATOR.eq(userId) | Friendship.RECIPIENT.eq(userId)) &
          Friendship.STATUS.eq(FriendshipStatus.ACCEPTED),
    );
    return friends.map((friendship) => friendship.recipient!).toList();
  }
}
