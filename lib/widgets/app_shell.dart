import 'package:flutter/material.dart';

import '../screens/admission_screen.dart';
import '../screens/dashboard_screen.dart';
import '../screens/menu_screen.dart';
import '../screens/messages_screen.dart';
import '../screens/residents_screen.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';

class AppShell extends StatefulWidget {
  final AppState appState;
  final VoidCallback onLogout;

  const AppShell({
    super.key,
    required this.appState,
    required this.onLogout,
  });

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _index = 0;
  String _residentSearchQuery = '';
  ResidentFilter _residentFilter = ResidentFilter.all;
  int _residentSearchRequestId = 0;

  void _setIndex(int index) {
    FocusManager.instance.primaryFocus?.unfocus();
    setState(() => _index = index);
  }

  void _openResidentSearch(String query) {
    FocusManager.instance.primaryFocus?.unfocus();
    setState(() {
      _residentSearchQuery = query.trim();
      _residentFilter = ResidentFilter.all;
      _residentSearchRequestId++;
      _index = 1;
    });
  }

  void _openResidents(ResidentFilter filter) {
    FocusManager.instance.primaryFocus?.unfocus();
    setState(() {
      _residentSearchQuery = '';
      _residentFilter = filter;
      _residentSearchRequestId++;
      _index = 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      DashboardScreen(
        appState: widget.appState,
        onSearchResident: _openResidentSearch,
        onOpenResidents: _openResidents,
      ),
      ResidentsScreen(
        appState: widget.appState,
        initialSearchQuery: _residentSearchQuery,
        initialFilter: _residentFilter,
        searchRequestId: _residentSearchRequestId,
      ),
      AdmissionScreen(
        appState: widget.appState,
        onFinished: () {
          setState(() {
            _residentSearchQuery = '';
            _residentFilter = ResidentFilter.all;
            _residentSearchRequestId++;
            _index = 1;
          });
        },
      ),
      MessagesScreen(appState: widget.appState),
      MenuScreen(
        appState: widget.appState,
        onLogout: widget.onLogout,
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final useRail = constraints.maxWidth >= 900;

        if (useRail) {
          return Scaffold(
            body: SafeArea(
              child: Row(
                children: [
                  Container(
                    width: 104,
                    margin: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: AppColors.border),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withOpacity(0.05),
                          blurRadius: 24,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: NavigationRail(
                      backgroundColor: Colors.transparent,
                      groupAlignment: -0.72,
                      selectedIndex: _index,
                      onDestinationSelected: _setIndex,
                      labelType: NavigationRailLabelType.all,
                      indicatorColor: AppColors.primary.withOpacity(0.12),
                      leading: Padding(
                        padding: const EdgeInsets.only(top: 10, bottom: 22),
                        child: Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [AppColors.primary, AppColors.primaryDark],
                            ),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Icon(
                            Icons.health_and_safety_rounded,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      destinations: const [
                        NavigationRailDestination(
                          icon: Icon(Icons.home_outlined),
                          selectedIcon: Icon(Icons.home_rounded),
                          label: Text('Home'),
                        ),
                        NavigationRailDestination(
                          icon: Icon(Icons.people_outline_rounded),
                          selectedIcon: Icon(Icons.people_rounded),
                          label: Text('Residents'),
                        ),
                        NavigationRailDestination(
                          icon: Icon(Icons.add_circle_outline_rounded),
                          selectedIcon: Icon(Icons.add_circle_rounded),
                          label: Text('Add'),
                        ),
                        NavigationRailDestination(
                          icon: Icon(Icons.chat_bubble_outline_rounded),
                          selectedIcon: Icon(Icons.chat_bubble_rounded),
                          label: Text('Messages'),
                        ),
                        NavigationRailDestination(
                          icon: Icon(Icons.menu_rounded),
                          selectedIcon: Icon(Icons.menu_open_rounded),
                          label: Text('Menu'),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 1100),
                        child: IndexedStack(index: _index, children: pages),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        return Scaffold(
          body: SafeArea(
            bottom: false,
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 760),
                child: IndexedStack(index: _index, children: pages),
              ),
            ),
          ),
          bottomNavigationBar: SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 4, 12, 10),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(22),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF102A43).withOpacity(0.09),
                      blurRadius: 22,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(22),
                  child: NavigationBar(
                    height: 70,
                    selectedIndex: _index,
                    onDestinationSelected: _setIndex,
                    backgroundColor: Colors.white,
                    indicatorColor: AppColors.primary.withOpacity(0.13),
                    destinations: const [
                      NavigationDestination(
                        icon: Icon(Icons.home_outlined),
                        selectedIcon: Icon(Icons.home_rounded),
                        label: 'Home',
                      ),
                      NavigationDestination(
                        icon: Icon(Icons.people_outline_rounded),
                        selectedIcon: Icon(Icons.people_rounded),
                        label: 'Residents',
                      ),
                      NavigationDestination(
                        icon: Icon(Icons.add_circle_outline_rounded),
                        selectedIcon: Icon(Icons.add_circle_rounded),
                        label: 'Add',
                      ),
                      NavigationDestination(
                        icon: Icon(Icons.chat_bubble_outline_rounded),
                        selectedIcon: Icon(Icons.chat_bubble_rounded),
                        label: 'Messages',
                      ),
                      NavigationDestination(
                        icon: Icon(Icons.menu_rounded),
                        selectedIcon: Icon(Icons.menu_open_rounded),
                        label: 'Menu',
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
