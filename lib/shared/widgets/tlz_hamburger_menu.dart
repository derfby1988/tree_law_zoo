import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

/// Hamburger Menu Button Widget
/// Custom hamburger menu with orange-yellow middle line
class TlzHamburgerMenu extends StatelessWidget {
  final VoidCallback? onPressed;
  final BuildContext? scaffoldContext;

  const TlzHamburgerMenu({
    super.key,
    this.onPressed,
    this.scaffoldContext,
  });

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (builderContext) => GestureDetector(
        onTap: onPressed ??
            () {
              try {
                Scaffold.of(scaffoldContext ?? builderContext).openDrawer();
              } catch (e) {
                // Drawer ยังไม่ได้สร้าง
                debugPrint('Drawer not available: $e');
              }
            },
        child: Container(
          width: 29,
          height: 20,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 23,
                height: 2.5,
                decoration: BoxDecoration(
                  color: AppColors.textOnPrimary,
                  borderRadius: BorderRadius.circular(1.5),
                ),
              ),
              Container(
                width: 29,
                height: 2.5,
                decoration: BoxDecoration(
                  color: AppColors.accent, // สีส้ม-เหลือง
                  borderRadius: BorderRadius.circular(1.5),
                ),
              ),
              Container(
                width: 12.5,
                height: 2.5,
                decoration: BoxDecoration(
                  color: AppColors.textOnPrimary,
                  borderRadius: BorderRadius.circular(1.5),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
