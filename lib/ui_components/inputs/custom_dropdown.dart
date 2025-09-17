import 'package:flutter/material.dart';

import '/core/__core.dart';
import '/styles/__styles.dart';

class CustomDropdown<T> extends StatefulWidget {
  final List<T> items;
  final T? value;
  final ValueChanged<T?>? onChanged;
  final String? Function(T?)? validator;
  final String? hintText;
  final bool isRequired;
  final String? label;
  final Widget Function(BuildContext context, T item, bool isSelected)
  itemBuilder;
  final Widget Function(T? value) displayBuilder;
  final double? maxHeight;
  final bool showLabel;
  final IconData? emptyIcon;
  final IconData? dropdownIcon;

  const CustomDropdown({
    super.key,
    required this.items,
    required this.value,
    required this.itemBuilder,
    required this.displayBuilder,
    this.onChanged,
    this.validator,
    this.hintText,
    this.isRequired = false,
    this.label,
    this.maxHeight,
    this.showLabel = true,
    this.emptyIcon,
    this.dropdownIcon,
  });

  @override
  State<CustomDropdown<T>> createState() => _CustomDropdownState<T>();
}

class _CustomDropdownState<T> extends State<CustomDropdown<T>>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  bool _isOpen = false;
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _removeOverlay();
    super.dispose();
  }

  void _toggleDropdown() {
    if (_isOpen) {
      _closeDropdown();
    } else {
      _openDropdown();
    }
  }

  void _openDropdown() {
    setState(() {
      _isOpen = true;
    });
    _animationController.forward();
    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);
  }

  void _closeDropdown() {
    _animationController.reverse();
    _removeOverlay();
    setState(() {
      _isOpen = false;
    });
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  void _selectItem(T item) {
    widget.onChanged?.call(item);
    _closeDropdown();
  }

  OverlayEntry _createOverlayEntry() {
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    var size = renderBox.size;

    return OverlayEntry(
      builder: (context) => Positioned(
        width: size.width,
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          offset: Offset(0.0, size.height - 26.0),
          child: Material(
            color: Colors.transparent,
            child: AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return Transform.scale(
                  scaleY: _animation.value,
                  alignment: Alignment.topCenter,
                  child: Opacity(
                    opacity: _animation.value,
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(AppBorderRadius.md),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.black.withValues(alpha: 0.1),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                          BoxShadow(
                            color: AppColors.black.withValues(alpha: 0.05),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                        border: Border.all(
                          color: AppColors.outline.withValues(alpha: 0.2),
                          width: 1,
                        ),
                      ),
                      constraints: BoxConstraints(
                        maxHeight: widget.maxHeight ?? 300,
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(AppBorderRadius.md),
                        child: ListView.builder(
                          padding: const EdgeInsets.symmetric(
                            vertical: AppSpacing.xs,
                          ),
                          shrinkWrap: true,
                          itemCount: widget.items.length,
                          itemBuilder: (context, index) {
                            final item = widget.items[index];
                            final isSelected = widget.value == item;

                            return InkWell(
                              onTap: () => _selectItem(item),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: AppSpacing.md,
                                  vertical: AppSpacing.sm,
                                ),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? AppColors.primary.withValues(alpha: 0.1)
                                      : Colors.transparent,
                                ),
                                child: widget.itemBuilder(
                                  context,
                                  item,
                                  isSelected,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.showLabel && widget.label != null) ...[
          Row(
            children: [
              Text(
                widget.label!,
                style: AppTypography.titleMedium.copyWith(
                  color: context.colors.onSurface,
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (widget.isRequired) ...[
                const SizedBox(width: AppSpacing.xs),
                Text(
                  '*',
                  style: AppTypography.titleMedium.copyWith(
                    color: context.colors.error,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
        ],
        CompositedTransformTarget(
          link: _layerLink,
          child: GestureDetector(
            onTap: _toggleDropdown,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppBorderRadius.md),
                border: Border.all(
                  color: _isOpen
                      ? AppColors.primary
                      : context.colors.outline.withValues(alpha: 0.3),
                  width: _isOpen ? 2 : 1.5,
                ),
                color: AppColors.white.withValues(alpha: 0.3),
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.md,
              ),
              child: Row(
                children: [
                  if (widget.value != null) ...[
                    Expanded(child: widget.displayBuilder(widget.value)),
                  ] else ...[
                    if (widget.emptyIcon != null) ...[
                      Icon(
                        widget.emptyIcon!,
                        color: context.colors.onSurfaceVariant.withValues(
                          alpha: 0.7,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                    ],
                    Expanded(
                      child: Text(
                        widget.hintText ?? 'Select an option',
                        style: AppTypography.bodyLarge.copyWith(
                          color: context.colors.onSurfaceVariant.withValues(
                            alpha: 0.6,
                          ),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                  AnimatedRotation(
                    turns: _isOpen ? 0.5 : 0,
                    duration: const Duration(milliseconds: 200),
                    child: Icon(
                      widget.dropdownIcon ?? Icons.keyboard_arrow_down_rounded,
                      color: context.colors.onSurfaceVariant.withValues(
                        alpha: 0.7,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        if (widget.validator != null || widget.isRequired) ...[
          const SizedBox(height: AppSpacing.xs),
          Builder(
            builder: (context) {
              final error =
                  widget.validator?.call(widget.value) ??
                  (widget.isRequired ? _defaultValidator(widget.value) : null);
              if (error != null) {
                return Text(
                  error,
                  style: AppTypography.bodySmall.copyWith(
                    color: context.colors.error,
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ],
    );
  }

  String? _defaultValidator(T? value) {
    if (value == null) {
      return 'Please select an option';
    }
    return null;
  }
}
