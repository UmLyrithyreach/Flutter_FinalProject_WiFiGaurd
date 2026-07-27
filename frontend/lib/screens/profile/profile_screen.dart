import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../services/review_service.dart';
import '../auth/login_screen.dart';
import '../home/home_screen.dart';
import '../history/history_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // gets the display name from the current user, falls back if empty
  String getUserName(AuthProvider authProvider) {
    if (authProvider.authService.getCurrentUser() == null) {
      return "Guest";
    } else {
      String? email = authProvider.authService.getCurrentUser()!.email;
      if (email == null) {
        return "Guest";
      } else {
        return email.split("@")[0];
      }
    }
  }

  String getUserEmail(AuthProvider authProvider) {
    if (authProvider.authService.getCurrentUser() == null) {
      return "Not signed in";
    } else {
      String? email = authProvider.authService.getCurrentUser()!.email;
      if (email == null) {
        return "Not signed in";
      } else {
        return email;
      }
    }
  }

  int getReviewCount(AuthProvider authProvider) {
    if (authProvider.authService.getCurrentUser() == null) {
      return 0;
    } else {
      String userId = authProvider.authService.getCurrentUser()!.uid;
      ReviewService reviewService = ReviewService();
      return reviewService.countReviewsByUser(userId);
    }
  }

  void handleLogout(AuthProvider authProvider) async {
    await authProvider.logout();

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    AuthProvider authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      backgroundColor: const Color(0xFF0D0710),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Profile",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Color(0xFF7B2FF7), Color(0xFFB721FF)],
                      ),
                    ),
                    child: const Icon(
                      Icons.wifi,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF1A1420),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [Color(0xFFEC4899), Color(0xFF7B2FF7)],
                        ),
                      ),
                      child: const Icon(
                        Icons.person,
                        color: Colors.white,
                        size: 26,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            getUserName(authProvider),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            getUserEmail(authProvider),
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 14),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF1A1420),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xFFEC4899).withOpacity(0.15),
                      ),
                      child: const Icon(
                        Icons.star,
                        color: Color(0xFFEC4899),
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 14),
                    const Expanded(
                      child: Text(
                        "Reviews Submitted",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Text(
                      getReviewCount(authProvider).toString(),
                      style: const TextStyle(
                        color: Color(0xFFEC4899),
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 14),

              GestureDetector(
                onTap: () {
                  handleLogout(authProvider);
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.redAccent.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.logout, color: Colors.redAccent, size: 20),
                      SizedBox(width: 10),
                      Text(
                        "Logout",
                        style: TextStyle(
                          color: Colors.redAccent,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),

      bottomNavigationBar: Container(
        decoration: const BoxDecoration(color: Color(0xFF1A1420)),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            buildNavItem(
              icon: Icons.wifi,
              label: "Scan",
              isSelected: false,
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const HomeScreen()),
                );
              },
            ),
            buildNavItem(
              icon: Icons.history,
              label: "History",
              isSelected: false,
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const HistoryScreen(),
                  ),
                );
              },
            ),
            buildNavItem(
              icon: Icons.person_outline,
              label: "Profile",
              isSelected: true,
              onTap: () {
                // already here, do nothing
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget buildNavItem({
    required IconData icon,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    if (isSelected == true) {
      return GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: const LinearGradient(
              colors: [Color(0xFFEC4899), Color(0xFF7B2FF7)],
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: Colors.white, size: 20),
              const SizedBox(height: 2),
              Text(
                label,
                style: const TextStyle(color: Colors.white, fontSize: 11),
              ),
            ],
          ),
        ),
      );
    } else {
      return GestureDetector(
        onTap: onTap,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.grey, size: 20),
            const SizedBox(height: 2),
            Text(
              label,
              style: const TextStyle(color: Colors.grey, fontSize: 11),
            ),
          ],
        ),
      );
    }
  }
}
