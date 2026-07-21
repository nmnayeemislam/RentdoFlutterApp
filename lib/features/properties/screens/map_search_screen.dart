import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';

import '../../../core/services/location_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/formatters.dart';
import '../../../routes/app_routes.dart';
import '../../../shared/extensions/context_extensions.dart';
import '../../../shared/widgets/network_image_widget.dart';
import '../controllers/property_list_controller.dart';
import '../controllers/property_providers.dart';
import '../models/property_model.dart';

/// Full-screen OpenStreetMap of listings in view. Panning/zooming refetches the
/// visible viewport via the `sw/ne` bounds params; tapping a price pin previews
/// the listing and opens its detail.
class MapSearchScreen extends ConsumerStatefulWidget {
  const MapSearchScreen({super.key});

  @override
  ConsumerState<MapSearchScreen> createState() => _MapSearchScreenState();
}

class _MapSearchScreenState extends ConsumerState<MapSearchScreen> {
  final MapController _map = MapController();
  final List<PropertyModel> _pins = [];
  bool _loading = false;
  PropertyModel? _selected;
  Timer? _debounce;
  CancelToken? _inflight;

  static const LatLng _fallbackCenter = LatLng(23.7808, 90.4074); // Dhaka

  @override
  void dispose() {
    _debounce?.cancel();
    _inflight?.cancel();
    _map.dispose();
    super.dispose();
  }

  LatLng get _initialCenter {
    final me = ref.read(userLocationProvider);
    return me == null ? _fallbackCenter : LatLng(me.lat, me.lng);
  }

  Future<void> _onReady() async {
    final me = ref.read(userLocationProvider);
    if (me != null) {
      await _fetchVisible();
    } else {
      await _loadAllAndFit();
    }
  }

  /// No known user location: pull a page of listings and frame the map to them.
  Future<void> _loadAllAndFit() async {
    setState(() => _loading = true);
    try {
      final filter = ref.read(propertyListControllerProvider).filter;
      final res = await ref
          .read(propertyRepositoryProvider)
          .fetchProperties(filter, perPage: 80);
      final located = res.items.where(_hasCoords).toList(growable: false);
      if (!mounted) return;
      setState(() {
        _pins
          ..clear()
          ..addAll(located);
        _loading = false;
      });
      _fitTo(located);
    } catch (_) {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _fetchVisible() async {
    final b = _map.camera.visibleBounds;
    _inflight?.cancel();
    final token = _inflight = CancelToken();
    setState(() => _loading = true);
    try {
      final filter = ref.read(propertyListControllerProvider).filter;
      final res = await ref.read(propertyRepositoryProvider).fetchInBounds(
            swLat: b.southWest.latitude,
            swLng: b.southWest.longitude,
            neLat: b.northEast.latitude,
            neLng: b.northEast.longitude,
            filter: filter,
            cancelToken: token,
          );
      if (!mounted) return;
      setState(() {
        _pins
          ..clear()
          ..addAll(res.where(_hasCoords));
        _loading = false;
      });
    } on DioException catch (e) {
      if (CancelToken.isCancel(e)) return; // superseded by a newer viewport
      if (mounted) {
        setState(() => _loading = false);
        context.showSnack('Couldn\'t load this area.', error: true);
      }
    }
  }

  void _onPositionChanged(MapCamera camera, bool hasGesture) {
    if (!hasGesture) return;
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 600), _fetchVisible);
  }

  void _fitTo(List<PropertyModel> list) {
    if (list.isEmpty) return;
    var minLat = 90.0, maxLat = -90.0, minLng = 180.0, maxLng = -180.0;
    for (final p in list) {
      minLat = p.latitude! < minLat ? p.latitude! : minLat;
      maxLat = p.latitude! > maxLat ? p.latitude! : maxLat;
      minLng = p.longitude! < minLng ? p.longitude! : minLng;
      maxLng = p.longitude! > maxLng ? p.longitude! : maxLng;
    }
    _map.fitCamera(
      CameraFit.bounds(
        bounds: LatLngBounds(LatLng(minLat, minLng), LatLng(maxLat, maxLng)),
        padding: const EdgeInsets.all(60),
        maxZoom: 15,
      ),
    );
  }

  bool _hasCoords(PropertyModel p) => p.latitude != null && p.longitude != null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Map'),
        actions: [
          if (_loading)
            const Padding(
              padding: EdgeInsets.only(right: 8),
              child: Center(
                child: SizedBox(
                  height: 18,
                  width: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
            ),
          // List⇄map toggle: the list screen's FAB opens the map; this returns.
          TextButton.icon(
            onPressed: () =>
                context.canPop() ? context.pop() : context.go(AppRoutes.properties),
            icon: const Icon(Icons.view_list_rounded, size: 20),
            label: const Text('List'),
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: Stack(
        children: [
          FlutterMap(
            mapController: _map,
            options: MapOptions(
              initialCenter: _initialCenter,
              initialZoom: 12,
              minZoom: 3,
              maxZoom: 18,
              onMapReady: _onReady,
              onTap: (_, _) => setState(() => _selected = null),
              onPositionChanged: _onPositionChanged,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.rentdo.app',
              ),
              MarkerClusterLayerWidget(
                options: MarkerClusterLayerOptions(
                  maxClusterRadius: 48,
                  size: const Size(44, 44),
                  padding: const EdgeInsets.all(50),
                  markers: [
                    for (final p in _pins)
                      Marker(
                        point: LatLng(p.latitude!, p.longitude!),
                        width: 96,
                        height: 34,
                        alignment: Alignment.topCenter,
                        child: _PricePin(
                          property: p,
                          selected: _selected?.id == p.id,
                          onTap: () => setState(() => _selected = p),
                        ),
                      ),
                  ],
                  builder: (context, markers) => _ClusterBubble(
                    count: markers.length,
                  ),
                ),
              ),
            ],
          ),
          if (_pins.isEmpty && !_loading)
            const Positioned(
              top: 12,
              left: 0,
              right: 0,
              child: Center(child: _Hint('No properties in this area')),
            ),
          if (_selected != null)
            Positioned(
              left: 12,
              right: 12,
              bottom: 16,
              child: _PreviewCard(
                property: _selected!,
                onClose: () => setState(() => _selected = null),
                onOpen: () => context.pushNamed(
                  AppRoutes.propertyDetailName,
                  pathParameters: {'id': '${_selected!.id}'},
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _PricePin extends StatelessWidget {
  const _PricePin({
    required this.property,
    required this.selected,
    required this.onTap,
  });

  final PropertyModel property;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final bg = selected ? AppColors.navy : AppColors.primary;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: AppRadius.brPill,
          border: Border.all(color: Colors.white, width: 1.5),
          boxShadow: const [
            BoxShadow(color: Color(0x33000000), blurRadius: 4, offset: Offset(0, 2)),
          ],
        ),
        child: Text(
          property.priceDisplay ?? Formatters.price(property.price),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.caption.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

class _ClusterBubble extends StatelessWidget {
  const _ClusterBubble({required this.count});
  final int count;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColors.primary,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2),
        boxShadow: const [
          BoxShadow(color: Color(0x33000000), blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      child: Text(
        '$count',
        style: AppTextStyles.titleSm.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _PreviewCard extends StatelessWidget {
  const _PreviewCard({
    required this.property,
    required this.onClose,
    required this.onOpen,
  });

  final PropertyModel property;
  final VoidCallback onClose;
  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 6,
      borderRadius: AppRadius.brLg,
      color: context.colors.surface,
      child: InkWell(
        borderRadius: AppRadius.brLg,
        onTap: onOpen,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: AppRadius.brMd,
                child: NetworkImageWidget(
                  url: property.imageUrl,
                  width: 92,
                  height: 72,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      property.priceDisplay ?? Formatters.price(property.price),
                      style: AppTextStyles.price.copyWith(fontSize: 16),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      property.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.titleSm,
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: onClose,
                icon: const Icon(Icons.close_rounded,
                    size: 20, color: AppColors.textTertiary),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Hint extends StatelessWidget {
  const _Hint(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: AppRadius.brPill,
        border: Border.all(color: context.colors.outline),
      ),
      child: Text(text, style: AppTextStyles.bodySm),
    );
  }
}
