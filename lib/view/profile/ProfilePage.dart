import 'package:e_commerce_app/service/AuthService.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'dart:convert';
import '../../model/user_model.dart';
import '../../controller/UserController.dart';
import '../../routes/AppRoutes.dart';
import 'AddressPage.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final userController = Get.put(UserController());

    return SafeArea(
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        appBar: AppBar(
          scrolledUnderElevation: 0,
          title: Text(
            'My Account',
            style: GoogleFonts.roboto(
              fontWeight: FontWeight.w500,
              fontSize: 20,
              color: theme.colorScheme.onPrimary,
            ),
          ),
          backgroundColor: theme.colorScheme.primary,
          elevation: 0,
        ),
        body: Obx(() {
          if (userController.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          final user = userController.user.value;
          return Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.only(
                    top: 15, bottom: 30, left: 20, right: 20),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary,
                  borderRadius: const BorderRadius.vertical(
                    bottom: Radius.circular(24),
                  ),
                ),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: CircleAvatar(
                        radius: 40,
                        backgroundColor: Colors.grey.shade200,
                        backgroundImage: _getImageProvider(user?.profileImage),
                        child: _getImageProvider(user?.profileImage) == null
                            ? Icon(Icons.person,
                                size: 40, color: theme.colorScheme.primary)
                            : null,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      user?.name ?? 'User Name',
                      style: GoogleFonts.poppins(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.onPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      user?.phoneNumber ?? '',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: theme.colorScheme.onPrimary.withOpacity(0.8),
                      ),
                    ),
                  ],
                ),
              ),

              // 2. Scrollable Content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Quick Actions Grid
                      Row(
                        children: [
                          Expanded(
                            child: _buildActionCard(
                              context,
                              icon: Icons.inventory_2_outlined,
                              title: "My Orders",
                              subtitle: "Track & manage",
                              color: Colors.blue.shade50,
                              iconColor: Colors.blue,
                              onTap: () =>
                                  Get.toNamed(AppRoutes.orderHistoryPage),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildActionCard(
                              context,
                              icon: Icons.favorite_border,
                              title: "Wishlist",
                              subtitle: "Your favorites",
                              color: Colors.pink.shade50,
                              iconColor: Colors.pink,
                              onTap: () => Get.toNamed(AppRoutes.wishlistPage),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),

                      // Account Settings Section
                      Text(
                        "Account Settings",
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surface,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                          border: Border.all(color: Colors.grey.shade100),
                        ),
                        child: Column(
                          children: [
                            _buildModernListTile(
                              context,
                              icon: Icons.person_outline_rounded,
                              title: "Edit Profile",
                              onTap: () => _showEditProfileBottomSheet(
                                  context, userController),
                            ),
                            Divider(height: 1, color: Colors.grey.shade100),
                            _buildModernListTile(
                              context,
                              icon: Icons.location_on_outlined,
                              title: "Saved Addresses",
                              onTap: () => Get.to(() => const AddressPage()),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 40),

                      // Logout Button
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          onPressed: () => AuthService().logout(),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            side: BorderSide(
                                color:
                                    theme.colorScheme.error.withOpacity(0.5)),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            "Log Out",
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: theme.colorScheme.error,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildActionCard(BuildContext context,
      {required IconData icon,
      required String title,
      required String subtitle,
      required Color color,
      required Color iconColor,
      required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: iconColor, size: 24),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModernListTile(BuildContext context,
      {required IconData icon,
      required String title,
      required VoidCallback onTap}) {
    final theme = Theme.of(context);
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: theme.colorScheme.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: theme.colorScheme.primary, size: 20),
      ),
      title: Text(
        title,
        style: GoogleFonts.poppins(
          fontSize: 15,
          fontWeight: FontWeight.w500,
          color: theme.colorScheme.onSurface,
        ),
      ),
      trailing: Icon(Icons.arrow_forward_ios_rounded,
          size: 16, color: Colors.grey.shade400),
    );
  }

  void _showEditProfileBottomSheet(
      BuildContext context, UserController controller) {
    if (controller.user.value == null) return;

    final nameController =
        TextEditingController(text: controller.user.value!.name);
    final phoneController =
        TextEditingController(text: controller.user.value!.phoneNumber);
    final theme = Theme.of(context);

    Get.bottomSheet(
      StatefulBuilder(builder: (context, setState) {
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Center(
                  child: Text(
                    'Edit Profile',
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Center(
                  child: Stack(
                    children: [
                      Obx(() {
                        final user = controller.user.value;
                        return CircleAvatar(
                          radius: 50,
                          backgroundColor:
                              theme.colorScheme.primary.withOpacity(0.1),
                          backgroundImage:
                              _getImageProvider(user?.profileImage),
                          child: _getImageProvider(user?.profileImage) == null
                              ? Icon(Icons.person,
                                  size: 50, color: theme.colorScheme.primary)
                              : null,
                        );
                      }),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: GestureDetector(
                          onTap: () async {
                            await controller.pickImage();
                          },
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primary,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 2),
                            ),
                            child: const Icon(
                              Icons.camera_alt,
                              color: Colors.white,
                              size: 16,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: 'Full Name',
                    labelStyle: GoogleFonts.poppins(color: Colors.grey),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: theme.colorScheme.primary),
                    ),
                    prefixIcon: Icon(CupertinoIcons.person,
                        color: theme.colorScheme.primary),
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    labelText: 'Phone Number',
                    labelStyle: GoogleFonts.poppins(color: Colors.grey),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: theme.colorScheme.primary),
                    ),
                    prefixIcon: Icon(CupertinoIcons.phone,
                        color: theme.colorScheme.primary),
                  ),
                ),
                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      final updatedUser = User(
                          id: controller.user.value!.id,
                          name: nameController.text,
                          email: controller.user.value!.email,
                          phoneNumber: phoneController.text,
                          role: controller.user.value!.role,
                          profileImage: controller.user.value!.profileImage,
                          isPhoneVerified:
                              controller.user.value!.isPhoneVerified,
                          addresses: controller.user.value!.addresses);
                      await controller.updateUser(updatedUser);
                      Get.back();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.colorScheme.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      'Save Changes',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        );
      }),
      isScrollControlled: true,
    );
  }

  ImageProvider? _getImageProvider(String? image) {
    if (image == null || image.isEmpty) return null;

    try {
      if (image.startsWith('http')) {
        return NetworkImage(image);
      } else {
        // Check if it's a data URI scheme or raw base64
        String base64String = image;
        if (image.contains(',')) {
          base64String = image.split(',').last;
        }
        return MemoryImage(base64Decode(base64String));
      }
    } catch (e) {
      print('Error loading profile image: $e');
      return null;
    }
  }
}
