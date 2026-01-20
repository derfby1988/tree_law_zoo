import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../shared/widgets/widgets.dart';

/// Home Page - "ช่องทางธรรมชาติ"
/// Main menu for Tree Law Zoo
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Header with Logo
              _buildHeader(),
              
              const SizedBox(height: 24),
              
              // Main Menu Grid
              _buildMainMenu(context),
              
              const SizedBox(height: 24),
              
              // Accommodation Button
              _buildAccommodationButton(context),
              
              const SizedBox(height: 32),
              
              // Bottom Links
              _buildBottomLinks(context),
              
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.primary,
            AppColors.primaryLight.withOpacity(0.8),
          ],
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          const TlzLogo(
            size: 1.0,
            showSubtitle: true,
            isDark: true,
          ),
          const SizedBox(height: 16),
          Text(
            'ช่องทางธรรมชาติ',
            style: AppTextStyles.heading4.copyWith(
              color: AppColors.textOnPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainMenu(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          // Row 1: สั่งอาหาร & จองโต๊ะ
          Row(
            children: [
              Expanded(
                child: TlzMenuCard(
                  title: 'สั่งอาหาร',
                  icon: Icons.restaurant_menu,
                  iconColor: AppColors.primary,
                  onTap: () {
                    _showComingSoon(context, 'สั่งอาหาร');
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TlzMenuCard(
                  title: 'จองโต๊ะ',
                  icon: Icons.table_restaurant,
                  iconColor: AppColors.secondary,
                  onTap: () {
                    _showComingSoon(context, 'จองโต๊ะ');
                  },
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 12),
          
          // Row 2: ติดตามคิว & ข้อมูลการจองโต๊ะ
          Row(
            children: [
              Expanded(
                child: TlzMenuCard(
                  title: 'ติดตามคิว',
                  icon: Icons.access_time,
                  iconColor: AppColors.queueCooking,
                  onTap: () {
                    _showComingSoon(context, 'ติดตามคิว');
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TlzMenuCard(
                  title: 'ข้อมูลการจองโต๊ะ',
                  icon: Icons.event_note,
                  iconColor: AppColors.info,
                  onTap: () {
                    _showComingSoon(context, 'ข้อมูลการจองโต๊ะ');
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAccommodationButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            _showComingSoon(context, 'จองที่พัก');
          },
          borderRadius: BorderRadius.circular(16),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: AppColors.valleyGradient,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: AppColors.valley.withOpacity(0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.textOnPrimary.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.hotel,
                    size: 32,
                    color: AppColors.textOnPrimary,
                  ),
                ),
                const SizedBox(width: 16),
                Text(
                  'จองที่พัก',
                  style: AppTextStyles.heading4.copyWith(
                    color: AppColors.textOnPrimary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomLinks(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Gold Member
          TlzMenuItem(
            title: 'สมัคร Gold Member',
            icon: Icons.workspace_premium,
            iconColor: AppColors.accent,
            onTap: () {
              _showComingSoon(context, 'สมัคร Gold Member');
            },
          ),
          
          // Location / Navigation
          TlzMenuItem(
            title: 'ที่อยู่ / นำทาง',
            icon: Icons.location_on,
            iconColor: AppColors.error,
            onTap: () {
              _showComingSoon(context, 'ที่อยู่ / นำทาง');
            },
          ),
          
          // Careers
          TlzMenuItem(
            title: 'ร่วมงานกับเรา',
            icon: Icons.work,
            iconColor: AppColors.info,
            onTap: () {
              _showComingSoon(context, 'ร่วมงานกับเรา');
            },
          ),
          
          // Admin
          TlzMenuItem(
            title: 'Admin',
            icon: Icons.admin_panel_settings,
            iconColor: AppColors.textSecondary,
            showArrow: true,
            onTap: () {
              _showComingSoon(context, 'Admin Dashboard');
            },
          ),
        ],
      ),
    );
  }

  void _showComingSoon(BuildContext context, String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$feature - เร็วๆ นี้!'),
        backgroundColor: AppColors.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
