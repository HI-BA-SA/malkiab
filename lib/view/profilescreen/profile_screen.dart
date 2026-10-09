import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../configs/app.dart';
import '../../../configs/configs.dart';
import '../../../model/controllers/profile_controller.dart';
import '../../../model/controllers/theme_controller.dart';
import '../widgets/design/design.dart';
import 'address_screen/address_screen.dart';
import 'auth_screen/authentication_screen.dart';
import 'favourites_screen/favorite_screen.dart';
import 'order_screen/order_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    App.init(context);
    final profileController = Get.find<ProfileController>();
    final themeController = Get.find<ThemeController>();
    final scheme = Theme.of(context).colorScheme;
    final loggedIn =
        profileController.authenticationFunctions.isUserLogin();

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Profile'),
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 130),
        children: [
          // ------------------------------------------------ identity card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  scheme.primary.withOpacity(0.14),
                  scheme.secondary.withOpacity(0.10),
                ],
              ),
              borderRadius: BorderRadius.circular(26),
            ),
            child: Row(
              children: [
                _Avatar(profileController: profileController),
                const SizedBox(width: 16),
                Expanded(
                  child: Obx(() {
                    final isLogin = profileController.islogin;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isLogin
                              ? profileController.information.name
                              : 'Welcome, gorgeous',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.playfairDisplay(
                            fontSize: 21,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          isLogin
                              ? profileController.information.userName
                              : 'Sign in to sync your bag & orders',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.manrope(
                            fontSize: 13,
                            color: scheme.onSurfaceVariant,
                          ),
                        ),
                        if (!isLogin) ...[
                          const SizedBox(height: 12),
                          GlowButton(
                            label: 'Sign in / Create account',
                            gradient: true,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 18, vertical: 12),
                            onPressed: () =>
                                Get.to(() => const AuthenticationScreen()),
                          ),
                        ],
                      ],
                    );
                  }),
                ),
              ],
            ),
          ),

          const SizedBox(height: 22),

          // ------------------------------------------------ quick tiles
          Row(
            children: [
              Expanded(
                child: _QuickTile(
                  icon: Icons.favorite_outline_rounded,
                  label: 'Favourites',
                  onTap: () => Get.to(() => const FavoriteScreen()),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _QuickTile(
                  icon: Icons.inventory_2_outlined,
                  label: 'Orders',
                  onTap: () => _guard(
                    loggedIn,
                    () => Get.to(() => const OrderScreen()),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _QuickTile(
                  icon: Icons.location_on_outlined,
                  label: 'Addresses',
                  onTap: () => _guard(
                    loggedIn,
                    () => Get.to(() => const AddressScreen()),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 26),
          Text(
            'Preferences',
            style: GoogleFonts.playfairDisplay(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          SoftCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                Obx(() => SwitchListTile(
                      secondary: Icon(
                        themeController.isDarkMode.value
                            ? Icons.dark_mode_outlined
                            : Icons.light_mode_outlined,
                        color: scheme.primary,
                      ),
                      title: Text(
                        'Dark mode',
                        style: GoogleFonts.manrope(
                            fontSize: 14.5, fontWeight: FontWeight.w700),
                      ),
                      subtitle: Text(
                        'Soft plum nights',
                        style: GoogleFonts.manrope(
                          fontSize: 12,
                          color: scheme.onSurfaceVariant,
                        ),
                      ),
                      value: themeController.isDarkMode.value,
                      onChanged: (_) => themeController.toggleTheme(),
                    )),
                const Divider(height: 1, indent: 16, endIndent: 16),
                SwitchListTile(
                  secondary: Icon(Icons.notifications_none_rounded,
                      color: scheme.primary),
                  title: Text(
                    'Drop alerts',
                    style: GoogleFonts.manrope(
                        fontSize: 14.5, fontWeight: FontWeight.w700),
                  ),
                  subtitle: Text(
                    'New shades & offers',
                    style: GoogleFonts.manrope(
                      fontSize: 12,
                      color: scheme.onSurfaceVariant,
                    ),
                  ),
                  value: true,
                  onChanged: (_) {},
                ),
              ],
            ),
          ),

          const SizedBox(height: 22),
          Text(
            'Account',
            style: GoogleFonts.playfairDisplay(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          SoftCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                _MenuTile(
                  icon: Icons.history_rounded,
                  label: 'Order history',
                  onTap: () => _guard(
                      loggedIn, () => Get.to(() => const OrderScreen())),
                ),
                const Divider(height: 1, indent: 16, endIndent: 16),
                _MenuTile(
                  icon: Icons.star_outline_rounded,
                  label: 'Rate malkiab',
                  onTap: () => Get.snackbar(
                    'Thank you!',
                    'You rating helps us bloom.',
                    snackPosition: SnackPosition.BOTTOM,
                    margin: const EdgeInsets.all(12),
                    backgroundColor: scheme.primary,
                    colorText: Colors.white,
                  ),
                ),
                const Divider(height: 1, indent: 16, endIndent: 16),
                _MenuTile(
                  icon: Icons.help_outline_rounded,
                  label: 'Help & support',
                  onTap: () => Get.dialog(
                    Dialog(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24)),
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'We’re here for you',
                              style: GoogleFonts.playfairDisplay(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'Questions about shades, orders or returns?\n'
                              'hello@malkiab.com',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.manrope(
                                fontSize: 14,
                                height: 1.6,
                                color: scheme.onSurfaceVariant,
                              ),
                            ),
                            const SizedBox(height: 16),
                            GlowButton(
                              label: 'Close',
                              outlined: true,
                              onPressed: Get.back,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 22),

          // ------------------------------------------------ auth action
          if (loggedIn)
            GlowButton(
              label: 'Log out',
              outlined: true,
              color: scheme.error,
              onPressed: () => Get.dialog(
                Dialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24)),
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Log out?',
                          style: GoogleFonts.playfairDisplay(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Your bag stays saved on this device.',
                          style: GoogleFonts.manrope(
                              fontSize: 13.5,
                              color: scheme.onSurfaceVariant),
                        ),
                        const SizedBox(height: 18),
                        GlowButton(
                          label: 'Yes, log out',
                          gradient: true,
                          onPressed: () async {
                            Get.back();
                            await profileController
                                .authenticationFunctions
                                .signOut();
                          },
                        ),
                        TextButton(
                          onPressed: Get.back,
                          child: const Text('Stay'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

          const SizedBox(height: 26),
          Center(
            child: Text(
              '${AppStrings.brandName} • v1.0.0',
              style: GoogleFonts.manrope(
                fontSize: 12,
                color: scheme.outline,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _guard(bool loggedIn, VoidCallback action) {
    if (loggedIn) {
      action();
    } else {
      Get.to(() => const AuthenticationScreen());
    }
  }
}

// ---------------------------------------------------------------- pieces

class _Avatar extends StatelessWidget {
  final ProfileController profileController;
  const _Avatar({required this.profileController});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return GetX<ProfileController>(
      builder: (controller) {
        Widget inner;
        if (controller.userSetImage) {
          final File file = controller.profileFunctions.imageFile()!;
          inner = ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: Image.file(file, fit: BoxFit.cover),
          );
        } else {
          final name = controller.islogin
              ? controller.information.name
              : '';
          inner = Text(
            (name.isEmpty ? 'm' : name.substring(0, 1)).toUpperCase(),
            style: GoogleFonts.playfairDisplay(
              fontSize: 34,
              fontWeight: FontWeight.w600,
              color: scheme.primary,
            ),
          );
        }
        return Stack(
          children: [
            Container(
              width: 78,
              height: 78,
              decoration: BoxDecoration(
                color: scheme.surface,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: scheme.shadow.withOpacity(0.08),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              alignment: Alignment.center,
              child: inner,
            ),
            Positioned(
              right: 0,
              bottom: 0,
              child: GestureDetector(
                onTap: () async {
                  await controller.profileFunctions.getUserImage();
                  controller.userSetImageInstance.update((val) {});
                },
                child: Container(
                  padding: const EdgeInsets.all(7),
                  decoration: BoxDecoration(
                    color: scheme.primary,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.camera_alt_rounded,
                    size: 14,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _QuickTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _QuickTile(
      {required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return SoftCard(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      onTap: onTap,
      child: Column(
        children: [
          Icon(icon, color: scheme.primary, size: 24),
          const SizedBox(height: 8),
          Text(
            label,
            style: GoogleFonts.manrope(
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _MenuTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _MenuTile(
      {required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return ListTile(
      onTap: onTap,
      leading: Icon(icon, color: scheme.primary, size: 21),
      title: Text(
        label,
        style: GoogleFonts.manrope(
          fontSize: 14.5,
          fontWeight: FontWeight.w700,
        ),
      ),
      trailing: Icon(Icons.chevron_right_rounded,
          color: scheme.outline),
    );
  }
}
