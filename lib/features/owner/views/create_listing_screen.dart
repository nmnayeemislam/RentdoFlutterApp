import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/network/api_exception.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../shared/extensions/context_extensions.dart';
import '../../../shared/widgets/app_text_field.dart';
import '../../../shared/widgets/network_image_widget.dart';
import '../../../shared/widgets/primary_button.dart';
import '../../config/providers/config_providers.dart';
import '../../properties/models/property_model.dart';
import '../../properties/viewmodels/property_providers.dart';
import '../../zones/widgets/zone_picker_sheet.dart';
import '../viewmodels/owner_viewmodel.dart';

/// Form to post a new property listing, or edit an existing one when
/// [existing] is provided.
class CreateListingScreen extends ConsumerStatefulWidget {
  const CreateListingScreen({super.key, this.existing});

  final PropertyModel? existing;

  @override
  ConsumerState<CreateListingScreen> createState() =>
      _CreateListingScreenState();
}

class _CreateListingScreenState extends ConsumerState<CreateListingScreen> {
  final _formKey = GlobalKey<FormState>();
  final _title = TextEditingController();
  final _description = TextEditingController();
  final _price = TextEditingController();
  final _bedrooms = TextEditingController();
  final _bathrooms = TextEditingController();
  final _area = TextEditingController();
  final _address = TextEditingController();

  String? _type;
  int? _zoneId;
  String? _zoneName;
  String? _allowedFor;
  bool _furnished = false;
  bool _parking = false;
  final List<XFile> _images = [];
  bool _submitting = false;

  bool get _isEdit => widget.existing != null;

  @override
  void initState() {
    super.initState();
    final e = widget.existing;
    if (e == null) return;
    _title.text = e.title;
    _description.text = e.description ?? '';
    if (e.price != null) _price.text = '${e.price!.toInt()}';
    if (e.beds != null) _bedrooms.text = '${e.beds}';
    if (e.baths != null) _bathrooms.text = '${e.baths}';
    if (e.sizeSqft != null) _area.text = '${e.sizeSqft!.toInt()}';
    _address.text = e.address ?? '';
    _type = e.type == ListingType.unknown ? null : e.type.apiValue;
    _zoneId = e.zoneId;
    _zoneName = e.zoneName;
    _allowedFor = e.allowedFor;
    _furnished = e.furnished;
    _parking = e.parking;
  }

  @override
  void dispose() {
    _title.dispose();
    _description.dispose();
    _price.dispose();
    _bedrooms.dispose();
    _bathrooms.dispose();
    _area.dispose();
    _address.dispose();
    super.dispose();
  }

  Future<void> _pickImages() async {
    final picked = await ImagePicker().pickMultiImage(imageQuality: 80);
    if (picked.isEmpty) return;
    setState(() => _images.addAll(picked.take(10 - _images.length)));
  }

  Future<void> _pickZone() async {
    final zone = await ZonePickerSheet.show(context);
    if (zone == null) return;
    setState(() {
      if (zone.id == 0) {
        _zoneId = null;
        _zoneName = null;
      } else {
        _zoneId = zone.id;
        _zoneName = zone.displayName;
      }
    });
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_type == null) {
      context.showSnack(context.l10n.ownerChoosePropertyType, error: true);
      return;
    }
    if (_zoneId == null) {
      context.showSnack(context.l10n.ownerChooseLocation, error: true);
      return;
    }
    FocusScope.of(context).unfocus();
    setState(() => _submitting = true);
    try {
      final service = ref.read(propertyServiceProvider);
      if (_isEdit) {
        await service.updateListing(
          widget.existing!.id,
          zoneId: _zoneId!,
          type: _type!,
          title: _title.text.trim(),
          price: int.parse(_price.text.trim()),
          description: _description.text.trim(),
          bedrooms: int.tryParse(_bedrooms.text.trim()),
          bathrooms: int.tryParse(_bathrooms.text.trim()),
          areaSqft: int.tryParse(_area.text.trim()),
          allowedFor: _allowedFor,
          furnished: _furnished,
          parking: _parking,
          address: _address.text.trim(),
        );
      } else {
        await service.createListing(
          zoneId: _zoneId!,
          type: _type!,
          title: _title.text.trim(),
          price: int.parse(_price.text.trim()),
          description: _description.text.trim(),
          bedrooms: int.tryParse(_bedrooms.text.trim()),
          bathrooms: int.tryParse(_bathrooms.text.trim()),
          areaSqft: int.tryParse(_area.text.trim()),
          allowedFor: _allowedFor,
          furnished: _furnished,
          parking: _parking,
          address: _address.text.trim(),
          imagePaths: _images.map((x) => x.path).toList(),
        );
      }
      if (!mounted) return;
      ref.invalidate(myListingsProvider);
      if (_isEdit) ref.invalidate(propertyDetailProvider(widget.existing!.id));
      context.pop();
      context.showSnack(_isEdit
          ? context.l10n.ownerListingUpdated
          : context.l10n.ownerListingSubmittedForReview);
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() => _submitting = false);
      context.showSnack(e.message, error: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final types = ref.watch(propertyTypeOptionsProvider);

    return Scaffold(
      appBar: AppBar(
          title: Text(_isEdit
              ? context.l10n.ownerEditPropertyTitle
              : context.l10n.ownerPostPropertyTitle)),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (_isEdit)
                  _EditPhotos(listingId: widget.existing!.id)
                else
                  _PhotoStrip(
                    images: _images,
                    onAdd: _pickImages,
                    onRemove: (i) => setState(() => _images.removeAt(i)),
                  ),
                AppSpacing.vGapLg,
                if (types.isNotEmpty)
                  DropdownButtonFormField<String>(
                    initialValue: _type,
                    decoration: InputDecoration(
                        labelText: context.l10n.ownerPropertyTypeLabel),
                    items: [
                      for (final t in types)
                        DropdownMenuItem(value: t.key, child: Text(t.label)),
                    ],
                    onChanged: (v) => setState(() => _type = v),
                  ),
                AppSpacing.vGapLg,
                AppTextField(
                  label: context.l10n.title,
                  hint: context.l10n.ownerTitleHint,
                  controller: _title,
                  validator: (v) => (v == null || v.trim().length < 5)
                      ? context.l10n.ownerAtLeast5Chars
                      : null,
                ),
                AppSpacing.vGapLg,
                _LocationField(name: _zoneName, onTap: _pickZone),
                AppSpacing.vGapLg,
                AppTextField(
                  label: context.l10n.price,
                  hint: context.l10n.ownerAmountHint,
                  controller: _price,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  validator: (v) => (int.tryParse(v?.trim() ?? '') == null)
                      ? context.l10n.ownerEnterPrice
                      : null,
                ),
                AppSpacing.vGapLg,
                Row(
                  children: [
                    Expanded(
                      child: AppTextField(
                        label: context.l10n.compareAttrBedrooms,
                        controller: _bedrooms,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: AppTextField(
                        label: context.l10n.compareAttrBathrooms,
                        controller: _bathrooms,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                      ),
                    ),
                  ],
                ),
                AppSpacing.vGapLg,
                AppTextField(
                  label: context.l10n.ownerAreaSqftLabel,
                  controller: _area,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                ),
                AppSpacing.vGapLg,
                DropdownButtonFormField<String>(
                  initialValue: _allowedFor,
                  decoration:
                      InputDecoration(labelText: context.l10n.ownerAllowedFor),
                  items: [
                    DropdownMenuItem(
                        value: 'family', child: Text(context.l10n.ownerFamily)),
                    DropdownMenuItem(
                        value: 'bachelor',
                        child: Text(context.l10n.ownerBachelor)),
                    DropdownMenuItem(
                        value: 'both', child: Text(context.l10n.ownerBoth)),
                  ],
                  onChanged: (v) => setState(() => _allowedFor = v),
                ),
                AppSpacing.vGapLg,
                AppTextField(
                  label: context.l10n.address,
                  hint: context.l10n.ownerAddressHint,
                  controller: _address,
                  maxLines: 2,
                ),
                SwitchListTile.adaptive(
                  contentPadding: EdgeInsets.zero,
                  value: _furnished,
                  activeThumbColor: AppColors.primary,
                  title: Text(context.l10n.compareAttrFurnished,
                      style: AppTextStyles.titleSm),
                  onChanged: (v) => setState(() => _furnished = v),
                ),
                SwitchListTile.adaptive(
                  contentPadding: EdgeInsets.zero,
                  value: _parking,
                  activeThumbColor: AppColors.primary,
                  title: Text(context.l10n.compareAttrParking,
                      style: AppTextStyles.titleSm),
                  onChanged: (v) => setState(() => _parking = v),
                ),
                AppSpacing.vGapXl,
                PrimaryButton(
                  label: _isEdit
                      ? context.l10n.accountSaveChanges
                      : context.l10n.ownerSubmitListing,
                  isLoading: _submitting,
                  onPressed: _submit,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Photo management for an existing listing: shows current photos (with delete)
/// and uploads new ones to `POST /listings/{id}/media`.
class _EditPhotos extends ConsumerStatefulWidget {
  const _EditPhotos({required this.listingId});
  final int listingId;

  @override
  ConsumerState<_EditPhotos> createState() => _EditPhotosState();
}

class _EditPhotosState extends ConsumerState<_EditPhotos> {
  bool _busy = false;

  Future<void> _add() async {
    final picked = await ImagePicker().pickMultiImage(imageQuality: 80);
    if (picked.isEmpty) return;
    setState(() => _busy = true);
    try {
      await ref.read(propertyServiceProvider).uploadMedia(
            widget.listingId,
            picked.map((x) => x.path).toList(),
          );
      ref.invalidate(propertyDetailProvider(widget.listingId));
      if (mounted) context.showSnack(context.l10n.ownerPhotosAdded);
    } on ApiException catch (e) {
      if (mounted) context.showSnack(e.message, error: true);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _remove(int mediaId) async {
    setState(() => _busy = true);
    try {
      await ref
          .read(propertyServiceProvider)
          .deleteMedia(widget.listingId, mediaId);
      ref.invalidate(propertyDetailProvider(widget.listingId));
      if (mounted) context.showSnack(context.l10n.ownerPhotoRemoved);
    } on ApiException catch (e) {
      if (mounted) context.showSnack(e.message, error: true);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final detail = ref.watch(propertyDetailProvider(widget.listingId));
    final photos = detail.valueOrNull?.images ?? const <ListingImage>[];

    return SizedBox(
      height: 96,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          GestureDetector(
            onTap: _busy ? null : _add,
            child: Container(
              width: 96,
              margin: const EdgeInsets.only(right: 10),
              decoration: BoxDecoration(
                borderRadius: AppRadius.brMd,
                border: Border.all(color: context.colors.outline),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _busy
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2.2),
                        )
                      : const Icon(Icons.add_a_photo_outlined,
                          color: AppColors.primary),
                  const SizedBox(height: 4),
                  Text(context.l10n.add, style: AppTextStyles.caption),
                ],
              ),
            ),
          ),
          for (final photo in photos)
            Stack(
              children: [
                Container(
                  width: 96,
                  margin: const EdgeInsets.only(right: 10),
                  clipBehavior: Clip.antiAlias,
                  decoration: const BoxDecoration(borderRadius: AppRadius.brMd),
                  child: NetworkImageWidget(url: photo.url, width: 96),
                ),
                Positioned(
                  top: 4,
                  right: 14,
                  child: InkResponse(
                    onTap: _busy ? null : () => unawaited(_remove(photo.id)),
                    child: const CircleAvatar(
                      radius: 11,
                      backgroundColor: Colors.black54,
                      child: Icon(Icons.close_rounded,
                          size: 14, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}

class _PhotoStrip extends StatelessWidget {
  const _PhotoStrip(
      {required this.images, required this.onAdd, required this.onRemove});
  final List<XFile> images;
  final VoidCallback onAdd;
  final ValueChanged<int> onRemove;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 96,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          GestureDetector(
            onTap: onAdd,
            child: Container(
              width: 96,
              margin: const EdgeInsets.only(right: 10),
              decoration: BoxDecoration(
                borderRadius: AppRadius.brMd,
                border: Border.all(color: context.colors.outline),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.add_a_photo_outlined,
                      color: AppColors.primary),
                  const SizedBox(height: 4),
                  Text(context.l10n.add, style: AppTextStyles.caption),
                ],
              ),
            ),
          ),
          for (var i = 0; i < images.length; i++)
            Stack(
              children: [
                Container(
                  width: 96,
                  margin: const EdgeInsets.only(right: 10),
                  clipBehavior: Clip.antiAlias,
                  decoration:
                      const BoxDecoration(borderRadius: AppRadius.brMd),
                  child: Image.file(File(images[i].path), fit: BoxFit.cover),
                ),
                Positioned(
                  top: 4,
                  right: 14,
                  child: InkResponse(
                    onTap: () => onRemove(i),
                    child: const CircleAvatar(
                      radius: 11,
                      backgroundColor: Colors.black54,
                      child: Icon(Icons.close_rounded,
                          size: 14, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}

class _LocationField extends StatelessWidget {
  const _LocationField({required this.name, required this.onTap});
  final String? name;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: AppRadius.brMd,
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
        decoration: BoxDecoration(
          borderRadius: AppRadius.brMd,
          border: Border.all(color: Theme.of(context).colorScheme.outline),
        ),
        child: Row(
          children: [
            const Icon(Icons.location_on_outlined,
                size: 20, color: AppColors.primary),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                name ?? context.l10n.ownerChooseLocationPlaceholder,
                style: AppTextStyles.bodyMd.copyWith(
                  color: name == null
                      ? AppColors.textTertiary
                      : Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ),
            const Icon(Icons.chevron_right_rounded,
                color: AppColors.textTertiary),
          ],
        ),
      ),
    );
  }
}
