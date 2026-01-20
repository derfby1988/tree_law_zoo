import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

/// Shopping Cart Button Widget
/// Shows cart icon with optional badge count
class TlzCartButton extends StatelessWidget {
  final int? itemCount;
  final VoidCallback? onPressed;
  final Color? iconColor;
  final Color? badgeColor;

  const TlzCartButton({
    super.key,
    this.itemCount,
    this.onPressed,
    this.iconColor,
    this.badgeColor,
  });

  @override
  Widget build(BuildContext context) {
    if (itemCount != null && itemCount! > 0) {
      return Stack(
        clipBehavior: Clip.none,
        children: [
          IconButton(
            icon: Icon(
              Icons.shopping_cart_outlined,
              color: iconColor ?? AppColors.cartIcon, // สีเทา-ม่วงอ่อน
              size: 24,
            ),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            onPressed: onPressed ?? () {
              // TODO: Navigate to cart page
              debugPrint('Cart pressed');
            },
          ),
          Positioned(
            right: 2,
            top: 2,
            child: Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                color: badgeColor ?? AppColors.primary,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  itemCount! > 9 ? '9+' : '$itemCount',
                  style: const TextStyle(
                    color: AppColors.textOnPrimary,
                    fontSize: 8,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    }

    return IconButton(
      icon: Icon(
        Icons.shopping_cart_outlined,
        color: iconColor ?? AppColors.cartIcon, // สีเทา-ม่วงอ่อน
        size: 24,
      ),
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(),
      onPressed: onPressed ?? () {
        // TODO: Navigate to cart page
        debugPrint('Cart pressed');
      },
    );
  }
}
