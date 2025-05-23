import 'package:flutter/material.dart';
import 'package:schola/barrel.dart';

class FriendsPage extends StatefulWidget {
  const FriendsPage({super.key});

  @override
  State<FriendsPage> createState() => _FriendsPageState();
}

class _FriendsPageState extends State<FriendsPage> {
  final TextEditingController _friendUsernameController =
      TextEditingController();

  List<Friendship> _friendRequests = [];
  List<User> _friends = [];

  @override
  void initState() {
    super.initState();
    initialize();
  }

  Future<void> initialize() async {
    // Get requests for me
    String userId = await Util.getUserId();
    List<Friendship> friendRequests = await FriendshipService.getFriendRequests(
      userId,
    );

    // Get friends
    List<User> friends = await FriendshipService.getFriends(userId);

    setState(() {
      _friendRequests = friendRequests;
      _friends = friends;
    });
  }

  Future<void> _sendFriendRequest() async {
    final String friendId = await Util.getIDByUsername(
      _friendUsernameController.text,
    );

    FriendshipService.sendFriendRequest(await Util.getUserId(), friendId);
  }

  Future<void> _cancelFriendRequest(Friendship request) async {
    await Amplify.DataStore.delete(request);
    setState(() {
      _friendRequests.remove(request);
    });
  }

  Future<void> _acceptFriendRequest(Friendship request) async {
    final Friendship updatedRequest = request.copyWith(
      status: FriendshipStatus.ACCEPTED,
    );
    await Amplify.DataStore.save(updatedRequest);
    setState(() {
      _friendRequests.remove(request);
      _friends.add(request.recipient!);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Friends',
          style: Theme.of(context).textTheme.displayMedium,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Add Friend', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 8),
              TextField(
                controller: _friendUsernameController,
                decoration: const InputDecoration(
                  labelText: 'Enter Friend\'s Username',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: _sendFriendRequest,
                child: const Text('Send Friend Request'),
              ),
              const SizedBox(height: 20),
              Text(
                'Friend Requests',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              _friendRequests.isEmpty
                  ? Text(
                    'You have no pending friend requests.',
                    style: Theme.of(context).textTheme.displaySmall,
                  )
                  : ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _friendRequests.length,
                    itemBuilder: (context, index) {
                      final request = _friendRequests[index];
                      return ListTile(
                        title: Text(
                          request.initiator?.displayUsername ?? 'Unknown',
                        ),
                        subtitle: Text(request.initiator?.school ?? ''),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.check),
                              onPressed: () => {_acceptFriendRequest(request)},
                            ),
                            IconButton(
                              icon: const Icon(Icons.close),
                              onPressed: () => {_cancelFriendRequest(request)},
                            ),
                          ],
                        ),
                      );
                    },
                  ),

              const SizedBox(height: 20),
              Text('Friends', style: Theme.of(context).textTheme.titleLarge),
              _friends.isEmpty
                  ? Text(
                    'No friends',
                    style: Theme.of(context).textTheme.displaySmall,
                  )
                  : ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _friends.length,
                    itemBuilder: (context, index) {
                      final friend = _friends[index];
                      return ListTile(
                        title: Text(
                          friend.displayUsername,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        subtitle: Text(
                          friend.school,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        onTap: () {},
                      );
                    },
                  ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _friendUsernameController.dispose();
    super.dispose();
  }
}
