import 'package:get/get.dart';
import 'package:flutter/material.dart';

import '/core/__core.dart';
import '/styles/__styles.dart';
import '/ui_components/__ui_components.dart';

import 'edit_group_controller.dart';

class EditGroupPage extends StatefulWidget {
  final Group group;

  const EditGroupPage({super.key, required this.group});

  @override
  State<EditGroupPage> createState() => _EditGroupPageState();
}

class _EditGroupPageState extends State<EditGroupPage>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _groupController = Get.put(EditGroupController());

  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _fadeController, curve: Curves.easeOut));

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
          CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
        );

    // Initialize form with existing group data
    _nameController.text = widget.group.name;
    _descriptionController.text = widget.group.description ?? '';

    _fadeController.forward();
    _slideController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final image = await _groupController.pickImageWithSource();
    if (image != null) {
      setState(() {});
    }
  }

  Future<void> _updateGroup() async {
    if (!_formKey.currentState!.validate()) return;

    final success = await _groupController.updateGroup(
      groupId: widget.group.id,
      name: _nameController.text.trim(),
      description: _descriptionController.text.trim().isEmpty
          ? null
          : _descriptionController.text.trim(),
      imageFile: _groupController.selectedImage,
    );

    if (success) {
      Get.back();
      Get.snackbar(
        'Success',
        _groupController.successMessage.value,
        backgroundColor: AppColors.green,
        colorText: AppColors.white,
        snackPosition: SnackPosition.BOTTOM,
        borderRadius: AppBorderRadius.md,
        margin: const EdgeInsets.all(AppSpacing.md),
      );
    } else {
      Get.snackbar(
        'Error',
        _groupController.errorMessage.value,
        backgroundColor: AppColors.red,
        colorText: AppColors.white,
        snackPosition: SnackPosition.BOTTOM,
        borderRadius: AppBorderRadius.md,
        margin: const EdgeInsets.all(AppSpacing.md),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Edit Group',
          style: AppTypography.titleLarge.copyWith(fontWeight: FontWeight.w600),
        ),
        elevation: 0,
        foregroundColor: AppColors.text,
        centerTitle: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(AppBorderRadius.lg),
          ),
        ),
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header Section
                  _buildHeader(),
                  const SizedBox(height: AppSpacing.xl),

                  // Group Image Section
                  _buildImageSection(),
                  const SizedBox(height: AppSpacing.xl),

                  // Image Upload Progress
                  Obx(
                    () => _groupController.isUploadingImage.value
                        ? Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(AppSpacing.lg),
                            decoration: BoxDecoration(
                              color: context.colors.primary.withValues(
                                alpha: 0.1,
                              ),
                              borderRadius: BorderRadius.circular(
                                AppBorderRadius.lg,
                              ),
                              border: Border.all(
                                color: context.colors.primary.withValues(
                                  alpha: 0.3,
                                ),
                                width: 1,
                              ),
                            ),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                              context.colors.primary,
                                            ),
                                      ),
                                    ),
                                    const SizedBox(width: AppSpacing.md),
                                    Expanded(
                                      child: Text(
                                        'Processing and uploading image...',
                                        style: AppTypography.bodyMedium
                                            .copyWith(
                                              color: context.colors.primary,
                                              fontWeight: FontWeight.w500,
                                            ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: AppSpacing.sm),
                                Text(
                                  'This may take a few moments depending on your internet connection.',
                                  style: AppTypography.bodySmall.copyWith(
                                    color: context.colors.onSurfaceVariant,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          )
                        : const SizedBox.shrink(),
                  ),
                  if (_groupController.isUploadingImage.value)
                    const SizedBox(height: AppSpacing.lg),

                  // Form Section
                  _buildFormSection(),
                  const SizedBox(height: AppSpacing.xl),

                  // Update Button
                  _buildUpdateButton(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            context.colors.primary.withValues(alpha: 0.3),
            context.colors.primary.withValues(alpha: 0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(AppBorderRadius.lg),
        border: Border.all(color: context.colors.outline, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.edit_rounded, size: 32, color: context.colors.primary),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Update Your Group',
            style: AppTypography.headlineSmall.copyWith(
              color: context.colors.onSurface,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Modify your group details to keep it fresh and engaging for your members.',
            style: AppTypography.bodyMedium.copyWith(
              color: context.colors.onSurfaceVariant,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(AppBorderRadius.lg),
        border: Border.all(color: context.colors.outline, width: 1),
      ),
      child: Column(
        children: [
          Text(
            'Group Photo',
            style: AppTypography.titleMedium.copyWith(
              color: context.colors.onSurface,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Update the photo to keep your group looking fresh',
            style: AppTypography.bodySmall.copyWith(
              color: context.colors.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.lg),

          // Current Image Display
          if (widget.group.imageUrl != null) ...[
            Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppBorderRadius.xl),
                boxShadow: [
                  BoxShadow(
                    color: context.colors.outline.withValues(alpha: 0.2),
                    blurRadius: 15,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(AppBorderRadius.xl),
                child: Image.network(
                  widget.group.imageUrl!,
                  fit: BoxFit.cover,
                  width: 140,
                  height: 140,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 140,
                      height: 140,
                      decoration: BoxDecoration(
                        color: context.colors.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(AppBorderRadius.xl),
                      ),
                      child: const Icon(
                        Icons.image_not_supported,
                        size: 48,
                        color: AppColors.gray,
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
          ],

          GestureDetector(
            onTap: _pickImage,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                color: _groupController.hasSelectedImage
                    ? AppColors.transparent
                    : context.colors.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(AppBorderRadius.xl),
                border: Border.all(
                  color: _groupController.hasSelectedImage
                      ? context.colors.primary.withValues(alpha: 0.3)
                      : context.colors.outline.withValues(alpha: 0.3),
                  width: 2,
                ),
                boxShadow: _groupController.hasSelectedImage
                    ? [
                        BoxShadow(
                          color: context.colors.primary.withValues(alpha: 0.2),
                          blurRadius: 15,
                          offset: const Offset(0, 6),
                        ),
                      ]
                    : null,
              ),
              child: _groupController.hasSelectedImage
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(AppBorderRadius.xl),
                      child: Stack(
                        children: [
                          Image.file(
                            _groupController.selectedImage!,
                            fit: BoxFit.cover,
                            width: 140,
                            height: 140,
                          ),
                          Positioned(
                            top: AppSpacing.sm,
                            right: AppSpacing.sm,
                            child: Container(
                              padding: const EdgeInsets.all(AppSpacing.xs),
                              decoration: BoxDecoration(
                                color: context.colors.primary,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.check,
                                size: 16,
                                color: context.colors.onPrimary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(AppSpacing.md),
                          decoration: BoxDecoration(
                            color: context.colors.primary.withValues(
                              alpha: 0.1,
                            ),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.add_a_photo_rounded,
                            size: 32,
                            color: context.colors.primary,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Text(
                          'Change Photo',
                          style: AppTypography.bodyMedium.copyWith(
                            color: context.colors.primary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
          if (_groupController.hasSelectedImage) ...[
            const SizedBox(height: AppSpacing.md),
            Obx(
              () => _groupController.isUploadingImage.value
                  ? Container(
                      padding: const EdgeInsets.all(AppSpacing.sm),
                      decoration: BoxDecoration(
                        color: context.colors.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(AppBorderRadius.md),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                context.colors.primary,
                              ),
                            ),
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          Text(
                            'Uploading image...',
                            style: AppTypography.bodySmall.copyWith(
                              color: context.colors.primary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton.icon(
                          onPressed: () =>
                              _groupController.clearSelectedImage(),
                          icon: const Icon(Icons.delete_outline, size: 18),
                          label: const Text('Remove Photo'),
                          style: TextButton.styleFrom(
                            foregroundColor: context.colors.error,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.md),
                        TextButton.icon(
                          onPressed: _pickImage,
                          icon: const Icon(Icons.edit, size: 18),
                          label: const Text('Change Photo'),
                          style: TextButton.styleFrom(
                            foregroundColor: context.colors.primary,
                          ),
                        ),
                      ],
                    ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildFormSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(AppBorderRadius.lg),
        boxShadow: [
          BoxShadow(
            color: context.colors.outline.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: context.colors.outline, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Group Details',
            style: AppTypography.titleLarge.copyWith(
              color: context.colors.onSurface,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),

          // Group Name Field
          _buildFormField(
            label: 'Group Name',
            hint: 'Enter a memorable group name',
            controller: _nameController,
            icon: Icons.group_rounded,
            isRequired: true,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Group name is required';
              }
              if (value.trim().length < 3) {
                return 'Group name must be at least 3 characters';
              }
              if (value.trim().length > 50) {
                return 'Group name must be less than 50 characters';
              }
              return null;
            },
          ),

          const SizedBox(height: AppSpacing.lg),

          // Group Description Field
          _buildFormField(
            label: 'Description',
            hint: 'Tell people what your group is about (optional)',
            controller: _descriptionController,
            icon: Icons.description_rounded,
            isRequired: false,
            maxLines: 4,
            validator: (value) {
              if (value != null &&
                  value.trim().isNotEmpty &&
                  value.trim().length > 200) {
                return 'Description must be less than 200 characters';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFormField({
    required String label,
    required String hint,
    required TextEditingController controller,
    required IconData icon,
    required bool isRequired,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: AppTypography.titleMedium.copyWith(
                color: context.colors.onSurface,
                fontWeight: FontWeight.w600,
              ),
            ),
            if (isRequired) ...[
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
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: AppTypography.bodyMedium.copyWith(
              color: context.colors.onSurfaceVariant.withValues(alpha: 0.6),
            ),
            prefixIcon: Icon(
              icon,
              color: context.colors.onSurfaceVariant.withValues(alpha: 0.7),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppBorderRadius.md),
              borderSide: BorderSide(
                color: context.colors.outline.withValues(alpha: 0.3),
                width: 1.5,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppBorderRadius.md),
              borderSide: BorderSide(
                color: context.colors.outline.withValues(alpha: 0.3),
                width: 1.5,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppBorderRadius.md),
              borderSide: BorderSide(color: context.colors.primary, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppBorderRadius.md),
              borderSide: BorderSide(color: context.colors.error, width: 1.5),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppBorderRadius.md),
              borderSide: BorderSide(color: context.colors.error, width: 2),
            ),
            filled: true,
            fillColor: context.colors.surfaceContainerHighest.withValues(
              alpha: 0.3,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.md,
            ),
          ),
          style: AppTypography.bodyLarge.copyWith(
            color: context.colors.onSurface,
          ),
          textInputAction: maxLines == 1
              ? TextInputAction.next
              : TextInputAction.done,
          onFieldSubmitted: maxLines == 1
              ? (_) => FocusScope.of(context).nextFocus()
              : null,
          validator: validator,
        ),
      ],
    );
  }

  Widget _buildUpdateButton() {
    return Obx(
      () => Container(
        width: double.infinity,
        height: 56,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppBorderRadius.lg),
          boxShadow: [
            BoxShadow(
              color: context.colors.primary.withValues(alpha: 0.3),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: CustomButton(
          onPressed: _groupController.isUpdatingGroup.value
              ? null
              : _updateGroup,
          text: 'Update Group',
          isLoading: _groupController.isUpdatingGroup.value,
          backgroundColor: context.colors.primary,
          textColor: context.colors.onPrimary,
        ),
      ),
    );
  }
}
