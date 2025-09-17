import 'package:flutter/material.dart';

import '/constants/__constants.dart';
import '/core/__core.dart';
import '/styles/__styles.dart';
import 'custom_dropdown.dart';

class CategoryDropdown extends StatelessWidget {
  final GroupCategory? value;
  final ValueChanged<GroupCategory?>? onChanged;
  final String? Function(GroupCategory?)? validator;
  final String? hintText;
  final bool isRequired;

  const CategoryDropdown({
    super.key,
    required this.value,
    this.onChanged,
    this.validator,
    this.hintText,
    this.isRequired = true,
  });

  @override
  Widget build(BuildContext context) {
    return CustomDropdown<GroupCategory>(
      items: GroupCategory.allCategories,
      value: value,
      onChanged: onChanged,
      validator: validator,
      hintText: hintText ?? 'Select a category',
      isRequired: isRequired,
      label: 'Category',
      emptyIcon: Icons.category_rounded,
      itemBuilder: (context, category, isSelected) {
        return Row(
          children: [
            Text(category.emoji, style: const TextStyle(fontSize: 18)),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Text(
                category.displayName,
                style: AppTypography.bodyLarge.copyWith(
                  color: isSelected
                      ? AppColors.primary
                      : context.colors.onSurface,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (isSelected)
              const Icon(
                Icons.check_rounded,
                color: AppColors.primary,
                size: 20,
              ),
          ],
        );
      },
      displayBuilder: (category) {
        if (category == null) return const SizedBox.shrink();
        return Row(
          children: [
            Text(category.emoji, style: const TextStyle(fontSize: 20)),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Text(
                category.displayName,
                style: AppTypography.bodyLarge.copyWith(
                  color: context.colors.onSurface,
                  fontWeight: FontWeight.w500,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        );
      },
    );
  }
}
