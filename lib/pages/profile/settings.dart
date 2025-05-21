import 'package:schola/barrel.dart';

import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  User? user;
  bool isLoading = true;

  Future<void> fetchCurrentUser() async {
    try {
      final currentUser = await Amplify.Auth.getCurrentUser();
      final userId = currentUser.userId;

      final users = await Amplify.DataStore.query(
        User.classType,
        where: User.ID.eq(userId),
      );

      setState(() {
        if (users.isNotEmpty) {
          user = users.first;
        }
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      Log.e('Error fetching user: $e');
    }
  }

  void _navigateToEditPage(String field, String? currentValue) {
    if (user == null) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => EditFieldPage(
              field: field,
              currentValue: currentValue,
              user: user!,
            ),
      ),
    ).then((_) => fetchCurrentUser());
  }

  @override
  void initState() {
    super.initState();
    fetchCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        title: const Text('Settings'),
        elevation: 0,
        backgroundColor: Colors.grey[900],
        foregroundColor: Colors.white,
      ),
      body:
          isLoading
              ? const Center(
                child: CircularProgressIndicator(color: Colors.white),
              )
              : user == null
              ? const Center(
                child: Text(
                  'No profile found',
                  style: TextStyle(color: Colors.white),
                ),
              )
              : ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  _buildSectionTitle('Profile'),
                  _buildProfileCard(),
                  const SizedBox(height: 24),
                  _buildSectionTitle('App'),
                  _buildAppCard(),
                ],
              ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Colors.grey[400],
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildProfileCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Colors.grey[850],
      child: Column(
        children: [
          _buildProfileItem(
            title: 'Username',
            subtitle: user!.displayUsername,
            onTap: () => _navigateToEditPage('Username', user!.displayUsername),
          ),
        ],
      ),
    );
  }

  Widget _buildAppCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Colors.grey[850],
      child: Column(
        children: [
          _buildProfileItem(
            title: 'Schedule URL',
            subtitle: user!.scheduleURL ?? 'Not set',
            onTap: () => _navigateToEditPage('Schedule URL', user!.scheduleURL),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileItem({
    required String title,
    String? subtitle,
    VoidCallback? onTap,
  }) {
    return ListTile(
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Colors.white,
        ),
      ),
      subtitle:
          subtitle != null
              ? Text(
                subtitle,
                style: TextStyle(color: Colors.grey[400], fontSize: 14),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              )
              : null,
      trailing: const Icon(Icons.chevron_right, color: Colors.grey),
      onTap: onTap,
      dense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    );
  }
}
