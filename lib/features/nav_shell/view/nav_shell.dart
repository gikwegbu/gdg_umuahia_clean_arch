import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// NavShell is the master persistent bottom navigation controller container.
/// It wraps a [StatefulNavigationShell] to preserve each tab's scroll position and navigation state.
class NavShell extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const NavShell({
    super.key,
    required this.navigationShell,
  });

  void _onTabTap(int index) {
    // Navigate to the target branch while respecting state rules.
    // Setting initialLocation to true forces a reset to root of the tab if tapped while active.
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: Semantics(
        label: 'Main application navigation bar',
        child: BottomNavigationBar(
          currentIndex: navigationShell.currentIndex,
          onTap: _onTabTap,
          selectedItemColor: theme.colorScheme.primary,
          unselectedItemColor: theme.colorScheme.onSurfaceVariant,
          backgroundColor: theme.colorScheme.surface,
          elevation: 8.0,
          type: BottomNavigationBarType.fixed,
          selectedLabelStyle: theme.textTheme.labelMedium?.copyWith(fontWeight: FontWeight.bold),
          unselectedLabelStyle: theme.textTheme.labelMedium,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined, semanticLabel: 'Home tab icon'),
              activeIcon: Icon(Icons.home, semanticLabel: 'Active Home tab icon'),
              label: 'Home',
              tooltip: 'Home Dashboard',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline, semanticLabel: 'Profile tab icon'),
              activeIcon: Icon(Icons.person, semanticLabel: 'Active Profile tab icon'),
              label: 'Profile',
              tooltip: 'User Profile & Settings',
            ),
          ],
        ),
      ),
    );
  }
}
