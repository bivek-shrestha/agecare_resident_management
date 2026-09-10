import 'package:flutter/material.dart';

import '../state/app_state.dart';
import '../theme/app_theme.dart';

class MenuScreen extends StatefulWidget {
  final AppState appState;
  final VoidCallback onLogout;

  const MenuScreen({
    super.key,
    required this.appState,
    required this.onLogout,
  });

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  bool _notifications = true;
  bool _biometricLock = true;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 28),
      children: [
        const Text(
          'Menu',
          style: TextStyle(
            fontSize: 25,
            height: 1.1,
            letterSpacing: -0.4,
            fontWeight: FontWeight.w900,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 15),
        Container(
          padding: const EdgeInsets.all(17),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [AppColors.primaryDark, AppColors.primary],
            ),
            borderRadius: BorderRadius.circular(26),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.14),
                blurRadius: 22,
                offset: const Offset(0, 9),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 54,
                height: 54,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.person_rounded,
                  color: Colors.white,
                  size: 27,
                ),
              ),
              const SizedBox(width: 13),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Bivek Shrestha',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        fontSize: 16.5,
                      ),
                    ),
                    SizedBox(height: 3),
                    Text(
                      'Care Staff',
                      style: TextStyle(
                        fontSize: 11.5,
                        color: Color(0xFFEAF4FF),
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                tooltip: 'Profile',
                onPressed: () => _showInfo('Profile', 'Bivek Shrestha • Care Staff'),
                icon: const Icon(Icons.chevron_right_rounded, color: Colors.white),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        _MenuTile(
          icon: Icons.calendar_month_outlined,
          title: 'Schedule',
          onTap: () => _showInfo(
            'Schedule',
            'Morning shift • 7:00 AM–3:00 PM\nHandover • 2:45 PM',
          ),
        ),
        _MenuTile(
          icon: Icons.notifications_none_rounded,
          title: 'Notifications',
          trailing: Switch(
            value: _notifications,
            onChanged: (value) => setState(() => _notifications = value),
          ),
          onTap: () => setState(() => _notifications = !_notifications),
        ),
        _MenuTile(
          icon: Icons.privacy_tip_outlined,
          title: 'Privacy',
          onTap: () => _showInfo(
            'Privacy',
            'Resident information is available to authorised staff only.',
          ),
        ),
        _MenuTile(
          icon: Icons.security_rounded,
          title: 'Security',
          trailing: Switch(
            value: _biometricLock,
            onChanged: (value) => setState(() => _biometricLock = value),
          ),
          onTap: () => setState(() => _biometricLock = !_biometricLock),
        ),
        _MenuTile(
          icon: Icons.help_outline_rounded,
          title: 'Help',
          onTap: () => _showInfo(
            'Help',
            'Use the main navigation to access residents, admissions and messages.',
          ),
        ),
        const SizedBox(height: 14),
        OutlinedButton.icon(
          style: OutlinedButton.styleFrom(
            foregroundColor: const Color(0xFFB4232B),
            side: BorderSide(color: AppColors.red.withOpacity(0.22)),
            minimumSize: const Size.fromHeight(50),
          ),
          onPressed: _confirmLogout,
          icon: const Icon(Icons.logout_rounded, size: 19),
          label: const Text('Log out'),
        ),
      ],
    );
  }

  Future<void> _confirmLogout() async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Log out?'),
        content: const Text('Return to the staff sign-in screen.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: AppColors.red),
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Log out'),
          ),
        ],
      ),
    );

    if (shouldLogout == true && mounted) widget.onLogout();
  }

  void _showInfo(String title, String message) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}

class _MenuTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final Widget? trailing;

  const _MenuTile({
    required this.icon,
    required this.title,
    required this.onTap,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(22),
          onTap: onTap,
          child: Ink(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: const Color(0xFFE7EDF4)),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF1D3557).withOpacity(0.035),
                  blurRadius: 14,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.075),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(icon, color: AppColors.primary, size: 20),
                ),
                const SizedBox(width: 13),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                trailing ?? const Icon(
                  Icons.chevron_right_rounded,
                  color: Color(0xFFB4BFCC),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
