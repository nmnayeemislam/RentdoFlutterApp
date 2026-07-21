import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_text_styles.dart';

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
  late final WebViewController _controller = WebViewController()
    ..setJavaScriptMode(JavaScriptMode.unrestricted)
    ..setBackgroundColor(const Color(0x00000000))
    ..loadRequest(Uri.parse(_embedUrl(widget.lat, widget.lng)));

  void _openFull() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => MapFullScreen(
          lat: widget.lat,
          lng: widget.lng,
          label: widget.label,
        ),
      ),
    );
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
              const _MapPill(label: 'View map', icon: Icons.open_in_full_rounded),
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
  late final WebViewController _controller = WebViewController()
    ..setJavaScriptMode(JavaScriptMode.unrestricted)
    ..loadRequest(Uri.parse(_embedUrl(widget.lat, widget.lng, zoom: 16)));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.label ?? 'Location')),
      body: WebViewWidget(
        controller: _controller,
        // Eager recognizer → the interactive full-screen map claims all
        // pan/zoom gestures.
        gestureRecognizers: {
          Factory<OneSequenceGestureRecognizer>(
              () => EagerGestureRecognizer()),
        },
      ),
    );
  }
}

class _MapPill extends StatelessWidget {
  const _MapPill({required this.label, required this.icon});
  final String label;
  final IconData icon;

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
                  color: Color(0x33000000), blurRadius: 8, offset: Offset(0, 2)),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 14, color: AppColors.primary),
              const SizedBox(width: 6),
              Text(label,
                  style: AppTextStyles.caption.copyWith(
                      color: AppColors.primary, fontWeight: FontWeight.w700)),
            ],
          ),
        ),
      ),
    );
  }
}
