import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../shared/extensions/context_extensions.dart';
import '../../../shared/widgets/app_loading_indicator.dart';

/// Keyless Google Maps embed URL. The classic `output=embed` endpoint renders
/// real Google Maps tiles inside a WebView without any API key.
String _embedUrl(double lat, double lng, {int zoom = 15}) =>
    'https://maps.google.com/maps?q=$lat,$lng&z=$zoom&hl=en&output=embed';

/// A compact, non-interactive Google Maps preview. Tapping opens a full-screen
/// interactive map. No API key required (uses the Google Maps embed URL).
class MapPreview extends StatefulWidget {
  const MapPreview({
    super.key,
    required this.lat,
    required this.lng,
    this.label,
    this.height = 170,
  });

  final double lat;
  final double lng;
  final String? label;
  final double height;

  @override
  State<MapPreview> createState() => _MapPreviewState();
}

class _MapPreviewState extends State<MapPreview> {
  bool _opening = false;
  OverlayEntry? _openingOverlay;

  late final WebViewController _controller = WebViewController()
    ..setJavaScriptMode(JavaScriptMode.unrestricted)
    ..setBackgroundColor(const Color(0x00000000))
    ..loadRequest(Uri.parse(_embedUrl(widget.lat, widget.lng)));

  Future<void> _openFull() async {
    if (_opening) return;
    setState(() => _opening = true);
    _showOpeningOverlay();
    await Future<void>.delayed(const Duration(milliseconds: 700));
    if (!mounted) return;
    _removeOpeningOverlay();
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => MapFullScreen(
          lat: widget.lat,
          lng: widget.lng,
          label: widget.label,
        ),
      ),
    );
    if (mounted) setState(() => _opening = false);
  }

  void _showOpeningOverlay() {
    _openingOverlay?.remove();
    _openingOverlay = OverlayEntry(
      builder: (_) => const Positioned.fill(
        child: ColoredBox(
          color: Color(0x66000000),
          child: Center(
            child: AppLoadingIndicator(color: Colors.white, size: 64),
          ),
        ),
      ),
    );
    Overlay.of(context, rootOverlay: true).insert(_openingOverlay!);
  }

  void _removeOpeningOverlay() {
    _openingOverlay?.remove();
    _openingOverlay = null;
  }

  @override
  void dispose() {
    _removeOpeningOverlay();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _openFull,
      child: ClipRRect(
        borderRadius: AppRadius.brLg,
        child: SizedBox(
          height: widget.height,
          child: Stack(
            fit: StackFit.expand,
            children: [
              // No gesture recognizers (the default) → the preview stays
              // display-only and doesn't steal the list's scroll gestures.
              WebViewWidget(controller: _controller),
              if (_opening)
                const Positioned.fill(
                  child: ColoredBox(
                    color: Color(0x66000000),
                    child: Center(
                      child: AppLoadingIndicator(color: Colors.white, size: 40),
                    ),
                  ),
                ),
              _MapPill(
                label: context.l10n.mapViewMap,
                icon: Icons.open_in_full_rounded,
                loading: _opening,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Full-screen, interactive Google Maps view (still keyless).
class MapFullScreen extends StatefulWidget {
  const MapFullScreen({
    super.key,
    required this.lat,
    required this.lng,
    this.label,
  });

  final double lat;
  final double lng;
  final String? label;

  @override
  State<MapFullScreen> createState() => _MapFullScreenState();
}

class _MapFullScreenState extends State<MapFullScreen> {
  bool _pageLoading = true;
  DateTime? _loadStartedAt;

  late final WebViewController _controller = WebViewController()
    ..setJavaScriptMode(JavaScriptMode.unrestricted)
    ..setNavigationDelegate(
      NavigationDelegate(
        onPageStarted: (_) {
          _loadStartedAt = DateTime.now();
          if (mounted) setState(() => _pageLoading = true);
        },
        onPageFinished: (_) => _hideLoader(),
        onWebResourceError: (_) => _hideLoader(),
      ),
    )
    ..loadRequest(Uri.parse(_embedUrl(widget.lat, widget.lng, zoom: 16)));

  Future<void> _hideLoader() async {
    final startedAt = _loadStartedAt;
    if (startedAt != null) {
      final elapsed = DateTime.now().difference(startedAt);
      const minVisible = Duration(milliseconds: 700);
      if (elapsed < minVisible) {
        await Future<void>.delayed(minVisible - elapsed);
      }
    }
    if (mounted) setState(() => _pageLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.label ?? context.l10n.mapLocationFallback),
      ),
      body: Stack(
        children: [
          WebViewWidget(
            controller: _controller,
            // Eager recognizer → the interactive full-screen map claims all
            // pan/zoom gestures.
            gestureRecognizers: {
              Factory<OneSequenceGestureRecognizer>(
                () => EagerGestureRecognizer(),
              ),
            },
          ),
          if (_pageLoading)
            const Positioned.fill(
              child: ColoredBox(
                color: Color(0x66000000),
                child: Center(
                  child: AppLoadingIndicator(color: Colors.white, size: 64),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _MapPill extends StatelessWidget {
  const _MapPill({
    required this.label,
    required this.icon,
    required this.loading,
  });
  final String label;
  final IconData icon;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomRight,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: AppRadius.brPill,
            boxShadow: [
              BoxShadow(
                color: Color(0x33000000),
                blurRadius: 8,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (loading)
                const SizedBox(
                  width: 46,
                  height: 18,
                  child: Center(
                    child: AppLoadingIndicator(
                      color: AppColors.primary,
                      size: 24,
                    ),
                  ),
                )
              else ...[
                Icon(icon, size: 14, color: AppColors.primary),
                const SizedBox(width: 6),
                Text(
                  label,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
