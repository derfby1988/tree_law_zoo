import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import 'tlz_hamburger_menu.dart';
import 'tlz_search_bar.dart';
import 'tlz_notification_button.dart';
import 'tlz_cart_button.dart';

/// App Top Bar Widget
/// Reusable top navigation bar with hamburger menu, search bar, notification, and cart
class TlzAppTopBar extends StatelessWidget {
  final VoidCallback? onMenuPressed;
  final VoidCallback? onSearchTap;
  final VoidCallback? onQRTap;
  final VoidCallback? onNotificationTap;
  final VoidCallback? onCartTap;
  final ValueChanged<String>? onSearchChanged;
  final TextEditingController? searchController;
  final String? searchHintText;
  final int notificationCount;
  final int? cartItemCount;
  final bool searchEnabled;

  const TlzAppTopBar({
    super.key,
    this.onMenuPressed,
    this.onSearchTap,
    this.onQRTap,
    this.onNotificationTap,
    this.onCartTap,
    this.onSearchChanged,
    this.searchController,
    this.searchHintText,
    this.notificationCount = 0,
    this.cartItemCount,
    this.searchEnabled = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Hamburger Menu
        TlzHamburgerMenu(
          onPressed: onMenuPressed,
          scaffoldContext: context,
        ),
        
        const SizedBox(width: 12),
        
        // Search Bar
        Expanded(
          child: TlzSearchBar(
            hintText: searchHintText,
            onSearchTap: onSearchTap,
            onQRTap: onQRTap,
            onChanged: onSearchChanged,
            controller: searchController,
            enabled: searchEnabled,
          ),
        ),
        
        const SizedBox(width: 12),
        
        // Notification Button
        TlzNotificationButton(
          badgeCount: notificationCount,
          onPressed: onNotificationTap,
        ),
        
        const SizedBox(width: 8),
        
        // Cart Button
        TlzCartButton(
          itemCount: cartItemCount,
          onPressed: onCartTap,
        ),
      ],
    );
  }
}
