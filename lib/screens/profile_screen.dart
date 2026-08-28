import 'package:flutter/material.dart';
import '../widgets/profile_header.dart';
import '../widgets/profile_tile.dart';
import 'edit_profile_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50, // Light background for a clean look
      appBar: AppBar(
        title: const Text('My Profile'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // ✅ 1. PROFILE HEADER
            const ProfileHeader(
              name: 'John Doe',
              email: 'john.doe@example.com',
              imagePath: 'assets/images/profile_placeholder.png', 
              // Note: If using a real image URL, change AssetImage to NetworkImage in the header file
              onEditPhoto: null, 
            ),

            const SizedBox(height: 20),

            // ✅ 2. PROFILE TILES (With Subtitles!)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  ProfileTile(
                    icon: Icons.person,
                    title: "Edit Profile",
                    subtitle: "Update your profile information",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const EditProfileScreen(),
                        ),
                      );
                    },
                  ),
                  ProfileTile(
                    icon: Icons.shopping_bag,
                    title: "My Orders",
                    subtitle: "View your orders",
                    onTap: () {},
                  ),
                  ProfileTile(
                    icon: Icons.favorite,
                    title: "Wishlist",
                    subtitle: "Saved products",
                    onTap: () {},
                  ),
                  ProfileTile(
                    icon: Icons.logout,
                    title: "Logout",
                    subtitle: "Logout from account",
                    onTap: () {
                      // Add your logout logic here
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Logged out successfully!')),
                      );
                    },
                    showDivider: false, // Hides divider for the last item
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}