import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

/// Search Bar Widget with QR Code Scanner
/// Rounded search bar with search icon and QR code scanner
class TlzSearchBar extends StatelessWidget {
  final String? hintText;
  final VoidCallback? onSearchTap;
  final VoidCallback? onQRTap;
  final ValueChanged<String>? onChanged;
  final TextEditingController? controller;
  final bool enabled;

  const TlzSearchBar({
    super.key,
    this.hintText,
    this.onSearchTap,
    this.onQRTap,
    this.onChanged,
    this.controller,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      decoration: BoxDecoration(
        color: AppColors.primaryLight.withOpacity(0.3), // สีเขียวอ่อน
        borderRadius: BorderRadius.circular(22), // มุมโค้งมนมาก
        border: Border.all(
          color: AppColors.textOnPrimary.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          const SizedBox(width: 16),
          GestureDetector(
            onTap: onSearchTap,
            child: const Icon(
              Icons.search,
              color: AppColors.textOnPrimary,
              size: 20,
            ),
          ),
          if (enabled && (controller != null || onChanged != null)) ...[
            const SizedBox(width: 12),
            Expanded(
              child: TextField(
                controller: controller,
                onChanged: onChanged,
                enabled: enabled,
                style: const TextStyle(
                  color: AppColors.textOnPrimary,
                  fontSize: 14,
                ),
                decoration: InputDecoration(
                  hintText: hintText ?? 'ค้นหา...',
                  hintStyle: TextStyle(
                    color: AppColors.textOnPrimary.withOpacity(0.6),
                    fontSize: 14,
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ),
          ] else
            const Spacer(),
          GestureDetector(
            onTap: onQRTap,
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(
                Icons.qr_code_scanner,
                color: AppColors.textOnPrimary,
                size: 20,
              ),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
    );
  }
}
