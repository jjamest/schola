import 'package:schola/barrel.dart';

class FriendshipService {
  // Singleton instance
  static final FriendshipService _instance = FriendshipService._internal();
  factory FriendshipService() => _instance;
  FriendshipService._internal();

  Future<User?> _getUserById(String userId) async {
    try {
      final users = await Amplify.DataStore.query(
        User.classType,
        where: User.ID.eq(userId),
      );
      return users.isNotEmpty ? users.first : null;
    } catch (e) {
      throw Exception('Failed to fetch user: $e');
    }
  }

  Future<Friendship> sendFriendRequest(
    String initiatorId,
    String recipientId,
  ) async {
    try {
      final initiator = await _getUserById(initiatorId);
      final recipient = await _getUserById(recipientId);
      if (initiator == null || recipient == null) {
        throw Exception('Invalid initiator or recipient');
      }

      final friendship = Friendship(
        initiator: initiator,
        recipient: recipient,
        status: FriendshipStatus.PENDING,
      );
      await Amplify.DataStore.save(friendship);
      return friendship;
    } catch (e) {
      throw Exception('Failed to send friend request: $e');
    }
  }

  Future<Friendship> acceptFriendRequest(Friendship friendship) async {
    try {
      final updatedFriendship = friendship.copyWith(
        status: FriendshipStatus.ACCEPTED,
      );
      await Amplify.DataStore.save(updatedFriendship);
      return updatedFriendship;
    } catch (e) {
      throw Exception('Failed to accept friend request: $e');
    }
  }

  Future<Friendship> rejectFriendRequest(Friendship friendship) async {
    try {
      final updatedFriendship = friendship.copyWith(
        status: FriendshipStatus.REJECTED,
      );
      await Amplify.DataStore.save(updatedFriendship);
      return updatedFriendship;
    } catch (e) {
      throw Exception('Failed to reject friend request: $e');
    }
  }

  Future<void> deleteFriendship(Friendship friendship) async {
    try {
      await Amplify.DataStore.delete(friendship);
    } catch (e) {
      throw Exception('Failed to delete friendship: $e');
    }
  }

  Future<List<Friendship>> getFriendships(String userId) async {
    try {
      // When user is the initiator
      final initiatorFriendships = await Amplify.DataStore.query(
        Friendship.classType,
        where: Friendship.INITIATOR.eq(userId),
      );

      // When user is the recipient
      final recipientFriendships = await Amplify.DataStore.query(
        Friendship.classType,
        where: Friendship.RECIPIENT.eq(userId),
      );

      return [...initiatorFriendships, ...recipientFriendships];
    } catch (e) {
      throw Exception('Failed to fetch friendships: $e');
    }
  }

  Future<List<Friendship>> getPendingFriendRequests(String userId) async {
    try {
      return await Amplify.DataStore.query(
        Friendship.classType,
        where: Friendship.RECIPIENT
            .eq(userId)
            .and(Friendship.STATUS.eq(FriendshipStatus.PENDING)),
      );
    } catch (e) {
      throw Exception('Failed to fetch pending friend requests: $e');
    }
  }

  Future<List<Friendship>> getAcceptedFriends(String userId) async {
    try {
      final friendships = await Amplify.DataStore.query(
        Friendship.classType,
        where: Friendship.INITIATOR
            .eq(userId)
            .or(Friendship.RECIPIENT.eq(userId))
            .and(Friendship.STATUS.eq(FriendshipStatus.ACCEPTED)),
      );
      return friendships;
    } catch (e) {
      throw Exception('Failed to fetch accepted friends: $e');
    }
  }

  // Get the user for a friendship
  Future<User?> getFriendUser(
    Friendship friendship,
    String currentUserId,
  ) async {
    try {
      final isInitiator = friendship.initiator?.id == currentUserId;
      return isInitiator ? friendship.recipient : friendship.initiator;
    } catch (e) {
      throw Exception('Failed to fetch friend user: $e');
    }
  }
}
