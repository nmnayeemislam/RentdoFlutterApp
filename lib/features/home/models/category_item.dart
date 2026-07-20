import 'package:flutter/material.dart';

import '../../properties/models/property_model.dart';

/// A "Featured Category" tile on the Home screen. Static presentation data that
/// deep-links into the filtered property list.
class CategoryItem {
  const CategoryItem({
    required this.label,
    required this.icon,
    required this.type,
  });

  final String label;
  final IconData icon;
  final ListingType type;

  static const List<CategoryItem> all = [
    CategoryItem(
        label: 'For Sale', icon: Icons.sell_outlined, type: ListingType.sale),
    CategoryItem(
        label: 'For Rent',
        icon: Icons.vpn_key_outlined,
        type: ListingType.rent),
    CategoryItem(
        label: 'Short Stay',
        icon: Icons.hotel_outlined,
        type: ListingType.hotel),
    CategoryItem(
        label: 'Land',
        icon: Icons.landscape_outlined,
        type: ListingType.land),
    CategoryItem(
        label: 'Office',
        icon: Icons.business_outlined,
        type: ListingType.office),
    CategoryItem(
        label: 'Rooms',
        icon: Icons.meeting_room_outlined,
        type: ListingType.room),
  ];
}
