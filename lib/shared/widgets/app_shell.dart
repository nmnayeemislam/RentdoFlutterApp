import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_shadows.dart';
import '../../routes/app_routes.dart';
import '../extensions/context_extensions.dart';

/// Persistent bottom-navigation scaffold wrapping the main tabbed sections.
///
/// A floating white bar; the active tab's icon sits in a navy "squircle" with
/// its label below. "Messages" opens the (full-screen) conversations list.
class AppShell extends StatelessWidget {
  const AppShell({super.key, required this.child});

  final Widget child;

  static List<_TabItem> _tabsFor(BuildContext context) {
    final l10n = context.l10n;
    return [
      _TabItem(AppRoutes.home, Icons.home_outlined, Icons.home_rounded,
          l10n.home),
      _TabItem(AppRoutes.properties, Icons.search_outlined,
          Icons.search_rounded, l10n.search),
      _TabItem(AppRoutes.saved, Icons.favorite_border_rounded,
          Icons.favorite_rounded, l10n.saved),
      _TabItem(AppRoutes.conversations, Icons.chat_bubble_outline_rounded,
          Icons.chat_bubble_rounded, l10n.messages, push: true),
      _TabItem(AppRoutes.profile, Icons.person_outline_rounded,
          Icons.person_rounded, l10n.profile),
    ];
  }

  int _indexFor(BuildContext context, List<_TabItem> tabs) {
    final loc = GoRouterState.of(context).matchedLocation;
    final i = tabs.indexWhere((t) => !t.push && loc.startsWith(t.path));
    return i < 0 ? 0 : i;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tabs = _tabsFor(context);
    final current = _indexFor(context, tabs);
    final bool isDark = theme.brightness == Brightness.dark;

    void onTap(_TabItem tab) {
      if (tab.push) {
        context.push(tab.path);
      } else {
        context.go(tab.path);
      }
    }

    return Scaffold(
      body: child,
      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 12),
          child: Container(
            padding: const EdgeInsetsDirectional.symmetric(horizontal: 6, vertical: 8),
            decoration: BoxDecoration(
              color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
              borderRadius: AppRadius.brXl,
              border: Border.all(color: theme.colorScheme.outline),
              boxShadow: isDark ? null : AppShadows.card,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                for (var i = 0; i < tabs.length; i++)
                  _NavButton(
                    item: tabs[i],
                    selected: i == current,
                    onTap: () => onTap(tabs[i]),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NavButton extends StatelessWidget {
  const _NavButton({
    required this.item,
    required this.selected,
    required this.onTap,
  });

  final _TabItem item;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    // Active tab uses the brand primary (indigo) in both themes.
    const Color activeColor = AppColors.primary;
    const Color idle = AppColors.textTertiary;

    return Semantics(
      button: true,
      selected: selected,
      label: item.label,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          if (!selected) HapticFeedback.selectionClick();
          onTap();
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 240),
                curve: Curves.easeOutCubic,
                padding: const EdgeInsets.all(9),
                decoration: BoxDecoration(
                  color: selected ? activeColor : Colors.transparent,
                  borderRadius: AppRadius.brMd,
                ),
                child: Icon(
                  selected ? item.activeIcon : item.icon,
                  color: selected ? Colors.white : idle,
                  size: 24,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                item.label,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                  color: selected ? activeColor : idle,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TabItem {
  const _TabItem(this.path, this.icon, this.activeIcon, this.label,
      {this.push = false});
  final String path;
  final IconData icon;
  final IconData activeIcon;
  final String label;

  /// When true the tab opens a full-screen (non-shell) route via push.
  final bool push;
}
