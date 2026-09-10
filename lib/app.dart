import 'package:flutter/material.dart';

import 'screens/login_screen.dart';
import 'state/app_state.dart';
import 'theme/app_theme.dart';
import 'widgets/app_shell.dart';

class AgeCareApp extends StatefulWidget {
  const AgeCareApp({super.key});

  @override
  State<AgeCareApp> createState() => _AgeCareAppState();
}

class _AgeCareAppState extends State<AgeCareApp> {
  late final AppState appState;
  bool _isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    appState = AppState();
  }

  @override
  void dispose() {
    appState.dispose();
    super.dispose();
  }

  void _login() {
    setState(() => _isLoggedIn = true);
  }

  void _logout() {
    setState(() => _isLoggedIn = false);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AgeCare',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: AnimatedSwitcher(
        duration: const Duration(milliseconds: 260),
        child: _isLoggedIn
            ? AppShell(
                key: const ValueKey('app-shell'),
                appState: appState,
                onLogout: _logout,
              )
            : LoginScreen(
                key: const ValueKey('login-screen'),
                onLogin: _login,
              ),
      ),
    );
  }
}
