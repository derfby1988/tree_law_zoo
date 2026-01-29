import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import 'tlz_hamburger_menu.dart';
import 'tlz_search_bar.dart';
import 'tlz_notification_button.dart';
import 'tlz_cart_button.dart';

/// App Top Bar Widget
/// Reusable top navigation bar with hamburger menu, search bar, notification, and cart
/// รองรับหลายธีมสีเพื่อใช้งานได้ทุกหน้า
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
  
  /// ธีมสีของ Search Bar
  final TlzSearchBarColorTheme searchBarTheme;
  
  /// แสดงปุ่ม QR Scanner หรือไม่
  final bool showQRButton;

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
    this.searchBarTheme = TlzSearchBarColorTheme.onPrimary,
    this.showQRButton = true,
  });

  /// สร้าง Top Bar สำหรับพื้นหลังสีเข้ม (primary)
  factory TlzAppTopBar.onPrimary({
    Key? key,
    VoidCallback? onMenuPressed,
    VoidCallback? onSearchTap,
    VoidCallback? onQRTap,
    VoidCallback? onNotificationTap,
    VoidCallback? onCartTap,
    ValueChanged<String>? onSearchChanged,
    TextEditingController? searchController,
    String? searchHintText,
    int notificationCount = 0,
    int? cartItemCount,
    bool searchEnabled = false,
    bool showQRButton = true,
  }) {
    return TlzAppTopBar(
      key: key,
      onMenuPressed: onMenuPressed,
      onSearchTap: onSearchTap,
      onQRTap: onQRTap,
      onNotificationTap: onNotificationTap,
      onCartTap: onCartTap,
      onSearchChanged: onSearchChanged,
      searchController: searchController,
      searchHintText: searchHintText,
      notificationCount: notificationCount,
      cartItemCount: cartItemCount,
      searchEnabled: searchEnabled,
      searchBarTheme: TlzSearchBarColorTheme.onPrimary,
      showQRButton: showQRButton,
    );
  }

  /// สร้าง Top Bar สำหรับพื้นหลังสีอ่อน (light/white)
  factory TlzAppTopBar.onLight({
    Key? key,
    VoidCallback? onMenuPressed,
    VoidCallback? onSearchTap,
    VoidCallback? onQRTap,
    VoidCallback? onNotificationTap,
    VoidCallback? onCartTap,
    ValueChanged<String>? onSearchChanged,
    TextEditingController? searchController,
    String? searchHintText,
    int notificationCount = 0,
    int? cartItemCount,
    bool searchEnabled = false,
    bool showQRButton = true,
  }) {
    return TlzAppTopBar(
      key: key,
      onMenuPressed: onMenuPressed,
      onSearchTap: onSearchTap,
      onQRTap: onQRTap,
      onNotificationTap: onNotificationTap,
      onCartTap: onCartTap,
      onSearchChanged: onSearchChanged,
      searchController: searchController,
      searchHintText: searchHintText,
      notificationCount: notificationCount,
      cartItemCount: cartItemCount,
      searchEnabled: searchEnabled,
      searchBarTheme: TlzSearchBarColorTheme.onLight,
      showQRButton: showQRButton,
    );
  }

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
            onSearchTap: onSearchTap ?? () => _navigateToSearch(context),
            onQRTap: onQRTap,
            onChanged: onSearchChanged,
            controller: searchController,
            enabled: searchEnabled,
            theme: searchBarTheme,
            showQRButton: showQRButton,
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
  
  /// Navigate ไปหน้า Search โดยอัตโนมัติ
  void _navigateToSearch(BuildContext context) {
    Navigator.pushNamed(
      context,
      '/search',
      arguments: {
        'hintText': searchHintText,
      },
    );
  }
}
