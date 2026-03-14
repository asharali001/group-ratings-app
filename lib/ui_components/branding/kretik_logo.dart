import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '/styles/__styles.dart';

enum KretikLogoVariant { markOnly, markWithWordmark }

class KretikLogo extends StatelessWidget {
  final double size;
  final KretikLogoVariant variant;
  final Color? color;

  const KretikLogo({
    super.key,
    this.size = 40,
    this.variant = KretikLogoVariant.markOnly,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final logoMark = SvgPicture.asset(
      'assets/images/kretik-logo-mark.svg',
      width: size,
      height: size,
    );

    if (variant == KretikLogoVariant.markOnly) {
      return logoMark;
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        logoMark,
        const SizedBox(height: AppSpacing.sm),
        Text(
          'Kretik',
          style: GoogleFonts.dmSans(
            fontSize: size * 0.6,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.02 * size * 0.6,
            color: color ?? AppColors.primary,
          ),
        ),
      ],
    );
  }
}
