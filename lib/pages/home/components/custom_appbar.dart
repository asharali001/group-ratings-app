import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/core/__core.dart';
import '/styles/__styles.dart';

class CustomAppbar extends StatefulWidget {
  const CustomAppbar({super.key});

  @override
  State<CustomAppbar> createState() => _CustomAppbarState();
}

class _CustomAppbarState extends State<CustomAppbar> {
  OverlayEntry? _overlayEntry;
  final LayerLink _layerLink = LayerLink();

  @override
  void dispose() {
    _removeOverlay();
    super.dispose();
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  void _showDropdown() {
    if (_overlayEntry != null) {
      _removeOverlay();
      return;
    }

    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);
  }

  OverlayEntry _createOverlayEntry() {
    return OverlayEntry(
      builder: (context) => Positioned(
        width: 200,
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          offset: const Offset(-125, 60), // Position below the button
          child: Material(
            elevation: 8,
            borderRadius: BorderRadius.circular(AppBorderRadius.lg),
            color: context.colors.surfaceContainer,
            child: Container(
              decoration: BoxDecoration(
                color: context.colors.surfaceContainer,
                borderRadius: BorderRadius.circular(AppBorderRadius.lg),
                border: Border.all(
                  color: context.colors.outline.withValues(alpha: 0.1),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: context.colors.onSurface.withValues(alpha: 0.1),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildMenuItem(
                    icon: Icons.person_outline,
                    label: 'Profile',
                    onTap: () {
                      _removeOverlay();
                      // TODO: Navigate to profile
                    },
                  ),
                  _buildMenuItem(
                    icon: Icons.settings_outlined,
                    label: 'Settings',
                    onTap: () {
                      _removeOverlay();
                      // TODO: Navigate to settings
                    },
                  ),
                  const Divider(
                    height: 1,
                    thickness: 1,
                    color: AppColors.outline,
                    indent: AppSpacing.md,
                    endIndent: AppSpacing.md,
                  ),
                  _buildMenuItem(
                    icon: Icons.logout,
                    label: 'Sign Out',
                    onTap: () {
                      _removeOverlay();
                      final authService = Get.find<AuthService>();
                      authService.signOut();
                    },
                    isDestructive: true,
                  ),
                  const SizedBox(height: AppSpacing.xs),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppBorderRadius.md),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          child: Row(
            children: [
              Icon(
                icon,
                size: 20,
                color: isDestructive ? AppColors.error : AppColors.textLight,
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  label,
                  style: AppTypography.bodyMedium.copyWith(
                    color: isDestructive ? AppColors.error : AppColors.text,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              color: context.colors.primaryContainer,
              borderRadius: BorderRadius.circular(AppBorderRadius.md),
            ),
            child: Icon(
              Icons.rate_review,
              color: context.colors.primary,
              size: 24,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Group Ratings',
                  style: AppTypography.titleLarge.copyWith(
                    color: context.colors.onPrimaryContainer,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  'Rate and review together',
                  style: AppTypography.bodySmall.copyWith(
                    color: context.colors.onPrimaryContainer,
                  ),
                ),
              ],
            ),
          ),
          Builder(
            builder: (context) {
              final authService = Get.find<AuthService>();
              return CompositedTransformTarget(
                link: _layerLink,
                child: GestureDetector(
                  onTap: _showDropdown,
                  child: Container(
                    padding: const EdgeInsets.all(AppSpacing.sm),
                    decoration: BoxDecoration(
                      color: context.colors.surfaceContainer,
                      borderRadius: BorderRadius.circular(AppBorderRadius.lg),
                      border: Border.all(
                        color: context.colors.outline.withValues(alpha: 0.1),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircleAvatar(
                          radius: 16,
                          backgroundColor: context.colors.primary,
                          child: Text(
                            authService.userDisplayName[0].toUpperCase(),
                            style: TextStyle(
                              color: context.colors.onPrimary,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.xs),
                        Icon(
                          Icons.keyboard_arrow_down,
                          color: context.colors.onSurface,
                          size: 16,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

// Custom painter for the dropdown arrow
class ArrowPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.surface
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(8, 0)
      ..lineTo(0, 8)
      ..lineTo(16, 8)
      ..close();

    canvas.drawPath(path, paint);

    // Draw border for the arrow
    final borderPaint = Paint()
      ..color = AppColors.outline
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    final borderPath = Path()
      ..moveTo(8, 0)
      ..lineTo(0, 8)
      ..lineTo(16, 8)
      ..close();

    canvas.drawPath(borderPath, borderPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
