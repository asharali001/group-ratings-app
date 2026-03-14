import 'package:flutter/material.dart';

import '/ui_components/__ui_components.dart';
import '/styles/__styles.dart';

class ProfileStatsSection extends StatelessWidget {
  final String groupsCount;
  final String memberSince;
  final String ratingsCount;
  final String peersCount;

  const ProfileStatsSection({
    super.key,
    required this.groupsCount,
    required this.memberSince,
    this.ratingsCount = '0',
    this.peersCount = '0',
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: StatPill(
            value: ratingsCount,
            label: 'Ratings',
            usePrimaryColor: true,
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: StatPill(
            value: groupsCount,
            label: 'Groups',
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: StatPill(
            value: peersCount,
            label: 'Peers',
          ),
        ),
      ],
    );
  }
}
