import 'package:flutter/material.dart';

import '../../properties/models/property_model.dart';

/// A "Featured Category" tile on the Home screen. Static presentation data that
/// deep-links into the filtered property list. The label is resolved from
/// [type] at render time so it can be translated (see `CategoryRail`).
class CategoryItem {
  const CategoryItem({
    required this.icon,
    required this.type,
  });

  final IconData icon;
  final ListingType type;

  static const List<CategoryItem> all = [
    CategoryItem(icon: Icons.sell_outlined, type: ListingType.sale),
    CategoryItem(icon: Icons.vpn_key_outlined, type: ListingType.rent),
    CategoryItem(icon: Icons.hotel_outlined, type: ListingType.hotel),
    CategoryItem(icon: Icons.landscape_outlined, type: ListingType.land),
    CategoryItem(icon: Icons.business_outlined, type: ListingType.office),
    CategoryItem(icon: Icons.meeting_room_outlined, type: ListingType.room),
  ];
}
