import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';

/// Notification Button Widget with Badge
/// Shows notification icon with badge count
class TlzNotificationButton extends StatelessWidget {
  final int badgeCount;
  final VoidCallback? onPressed;
  final Color? iconColor;
  final Color? badgeColor;

  const TlzNotificationButton({
    super.key,
    this.badgeCount = 0,
    this.onPressed,
    this.iconColor,
    this.badgeColor,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        IconButton(
          icon: Icon(
            Icons.chat_bubble_outline,
            color: iconColor ?? AppColors.accent, // สีส้ม-เหลือง
            size: 24,
          ),
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
          onPressed: onPressed ?? () {
            // TODO: Navigate to notification page
            debugPrint('Notification pressed');
          },
        ),
        if (badgeCount > 0)
          Positioned(
            right: 2,
            top: 2,
            child: Container(
              width: 18,
              height: 18,
              decoration: BoxDecoration(
                color: badgeColor ?? AppColors.accent, // สีส้ม-เหลือง
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  badgeCount > 9 ? '9+' : '$badgeCount',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.textOnPrimary,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
