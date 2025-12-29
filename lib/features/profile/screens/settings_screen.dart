import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/colors.dart';
import '../../../core/routes/app_router.dart';
import '../../../features/auth/providers/auth_provider.dart';
import '../../../shared/providers/language_provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _pushNotifications = true;
  bool _studyReminders = true;
  bool _scholarshipAlerts = false;
  bool _tutoringSession = true;
  bool _achievementUnlocks = true;
  bool _weeklyProgressReports = true;
  bool _enrollNotifications = true;
  bool _smsNotifications = false;
  bool _autoDownloadWifi = true;

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final user = authProvider.currentUser;
    final languageProvider = context.watch<LanguageProvider>();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            _buildAppBar(user),
            SliverList(
              delegate: SliverChildListDelegate([
                _buildProfileSection(user),
                _buildAccountSection(),
                _buildPreferencesSection(languageProvider),
                _buildStudySettingsSection(),
                _buildNotificationsSection(),
                _buildPaymentsSection(),
                _buildDownloadsSection(),
                _buildHelpSection(),
                _buildAboutSection(),
                _buildLogoutButton(),
                const SizedBox(height: 40),
              ]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar(user) {
    return SliverAppBar(
      expandedHeight: 120,
      pinned: true,
      backgroundColor: AppColors.primary,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => Navigator.pop(context),
      ),
      flexibleSpace: FlexibleSpaceBar(
        title: const Text(
          'Settings',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.primary, AppColors.primaryDark],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileSection(user) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Stack(
            children: [
              CircleAvatar(
                radius: 40,
                backgroundColor: AppColors.primary,
                child: Text(
                  user?.name?.substring(0, 1).toUpperCase() ?? 'U',
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: const Icon(Icons.camera_alt, color: Colors.white, size: 16),
                ),
              ),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user?.name ?? 'User',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  user?.email ?? 'user@example.com',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.info.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.verified, size: 14, color: AppColors.info),
                          const SizedBox(width: 4),
                          Text(
                            'Verified',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: AppColors.info,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Icon(Icons.chevron_right, color: AppColors.textSecondary),
        ],
      ),
    );
  }

  Widget _buildAccountSection() {
    return _buildSection(
      title: 'Account',
      icon: Icons.person,
      items: [
        _buildSettingTile(
          icon: Icons.edit,
          title: 'Edit Profile Information',
          onTap: () {},
        ),
        _buildSettingTile(
          icon: Icons.lock,
          title: 'Change Password',
          onTap: () {},
        ),
        _buildSettingTile(
          icon: Icons.phone,
          title: 'Enroll & Phone Verification',
          onTap: () {},
        ),
        _buildSettingTile(
          icon: Icons.delete_outline,
          title: 'Delete Account',
          textColor: AppColors.error,
          onTap: () {
            _showDeleteAccountDialog();
          },
        ),
      ],
    );
  }

  Widget _buildPreferencesSection(LanguageProvider languageProvider) {
    return _buildSection(
      title: 'Preferences',
      icon: Icons.tune,
      items: [
        _buildDropdownTile(
          icon: Icons.language,
          title: 'Language',
          value: languageProvider.isEnglish ? 'English' : 'Français',
          items: ['English', 'Français'],
          onChanged: (value) {
            languageProvider.changeLanguage(value == 'English' ? 'en' : 'fr');
          },
        ),
        _buildDropdownTile(
          icon: Icons.language,
          title: 'System',
          value: 'Anglophone GCE',
          items: ['Anglophone GCE', 'Francophone (BEPC/BAC)'],
          onChanged: (value) {},
        ),
        _buildDropdownTile(
          icon: Icons.brightness_6,
          title: 'Theme',
          value: 'Light',
          items: ['Light', 'Dark', 'Auto'],
          onChanged: (value) {},
        ),
      ],
    );
  }

  Widget _buildStudySettingsSection() {
    return _buildSection(
      title: 'Study Settings',
      icon: Icons.school,
      items: [
        _buildSettingTile(
          icon: Icons.timer,
          title: 'Default Study Duration',
          trailing: const Text('45 min'),
          onTap: () {},
        ),
        _buildSettingTile(
          icon: Icons.flag,
          title: 'Exam Dates & Countdown',
          onTap: () {},
        ),
        _buildSettingTile(
          icon: Icons.check_circle_outline,
          title: 'Study Goals',
          onTap: () {},
        ),
        _buildSettingTile(
          icon: Icons.access_time,
          title: 'Reminder Times',
          onTap: () {},
        ),
      ],
    );
  }

  Widget _buildNotificationsSection() {
    return _buildSection(
      title: 'Notifications',
      icon: Icons.notifications,
      items: [
        _buildSwitchTile(
          icon: Icons.notifications_active,
          title: 'Push Notifications',
          value: _pushNotifications,
          onChanged: (value) {
            setState(() => _pushNotifications = value);
          },
        ),
        _buildSwitchTile(
          icon: Icons.alarm,
          title: 'Study Reminders',
          value: _studyReminders,
          onChanged: (value) {
            setState(() => _studyReminders = value);
          },
        ),
        _buildSwitchTile(
          icon: Icons.card_giftcard,
          title: 'Scholarship Alerts',
          value: _scholarshipAlerts,
          onChanged: (value) {
            setState(() => _scholarshipAlerts = value);
          },
        ),
        _buildSwitchTile(
          icon: Icons.school,
          title: 'Tutoring Sessions',
          value: _tutoringSession,
          onChanged: (value) {
            setState(() => _tutoringSession = value);
          },
        ),
        _buildSwitchTile(
          icon: Icons.emoji_events,
          title: 'Achievement Unlocks',
          value: _achievementUnlocks,
          onChanged: (value) {
            setState(() => _achievementUnlocks = value);
          },
        ),
        _buildSwitchTile(
          icon: Icons.analytics,
          title: 'Weekly Progress Reports',
          value: _weeklyProgressReports,
          onChanged: (value) {
            setState(() => _weeklyProgressReports = value);
          },
        ),
        _buildSwitchTile(
          icon: Icons.notifications,
          title: 'Enroll Notifications',
          value: _enrollNotifications,
          onChanged: (value) {
            setState(() => _enrollNotifications = value);
          },
        ),
        _buildSwitchTile(
          icon: Icons.sms,
          title: 'SMS Notifications',
          value: _smsNotifications,
          onChanged: (value) {
            setState(() => _smsNotifications = value);
          },
        ),
      ],
    );
  }

  Widget _buildPaymentsSection() {
    return _buildSection(
      title: 'Payments',
      icon: Icons.payment,
      items: [
        _buildSettingTile(
          icon: Icons.credit_card,
          title: 'Saved Payment Methods',
          onTap: () {},
        ),
        _buildSettingTile(
          icon: Icons.history,
          title: 'Transaction History',
          onTap: () {},
        ),
        _buildSettingTile(
          icon: Icons.receipt_long,
          title: 'Invoices & Receipts',
          onTap: () {},
        ),
      ],
    );
  }

  Widget _buildDownloadsSection() {
    return _buildSection(
      title: 'Downloads',
      icon: Icons.download,
      items: [
        _buildSettingTile(
          icon: Icons.folder,
          title: 'Manage Offline Content',
          trailing: Text('2.4 GB used', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
          onTap: () {},
        ),
        _buildSettingTile(
          icon: Icons.storage,
          title: 'Storage Used',
          trailing: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.warning.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '2.4 GB / 5 GB',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: AppColors.warning,
              ),
            ),
          ),
          onTap: () {},
        ),
        _buildSwitchTile(
          icon: Icons.wifi,
          title: 'Auto-Download on WiFi',
          value: _autoDownloadWifi,
          onChanged: (value) {
            setState(() => _autoDownloadWifi = value);
          },
        ),
        _buildSettingTile(
          icon: Icons.cleaning_services,
          title: 'Clear Cache',
          onTap: () {},
        ),
      ],
    );
  }

  Widget _buildHelpSection() {
    return _buildSection(
      title: 'Help & Support',
      icon: Icons.help,
      items: [
        _buildSettingTile(
          icon: Icons.contact_support,
          title: 'Contact Support',
          onTap: () {},
        ),
        _buildSettingTile(
          icon: Icons.bug_report,
          title: 'Report a Problem',
          onTap: () {},
        ),
        _buildSettingTile(
          icon: Icons.lightbulb,
          title: 'Feature Requests',
          onTap: () {},
        ),
        _buildSettingTile(
          icon: Icons.play_circle,
          title: 'Tutorial/Walkthrough',
          onTap: () {},
        ),
      ],
    );
  }

  Widget _buildAboutSection() {
    return _buildSection(
      title: 'About',
      icon: Icons.info,
      items: [
        _buildSettingTile(
          icon: Icons.info_outline,
          title: 'App Version',
          trailing: const Text('1.2.3', style: TextStyle(fontSize: 12)),
        ),
        _buildSettingTile(
          icon: Icons.description,
          title: 'Terms of Service',
          onTap: () {},
        ),
        _buildSettingTile(
          icon: Icons.privacy_tip,
          title: 'Privacy Policy',
          onTap: () {},
        ),
        _buildSettingTile(
          icon: Icons.gavel,
          title: 'Licenses',
          onTap: () {},
        ),
        _buildSettingTile(
          icon: Icons.store,
          title: 'Rate App on Play Store',
          trailing: const Icon(Icons.open_in_new, size: 18),
          onTap: () {},
        ),
        _buildSettingTile(
          icon: Icons.share,
          title: 'Share App with Friends',
          trailing: const Icon(Icons.share, size: 18),
          onTap: () {},
        ),
      ],
    );
  }

  Widget _buildSection({
    required String title,
    required IconData icon,
    required List<Widget> items,
  }) {
    return Container(
      margin: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(icon, size: 20, color: AppColors.primary),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
          ...items,
        ],
      ),
    );
  }

  Widget _buildSettingTile({
    required IconData icon,
    required String title,
    Widget? trailing,
    Color? textColor,
    VoidCallback? onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Icon(icon, size: 20, color: textColor ?? AppColors.textSecondary),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    color: textColor ?? AppColors.textPrimary,
                  ),
                ),
              ),
              if (trailing != null) trailing,
              if (onTap != null && trailing == null)
                Icon(Icons.chevron_right, size: 20, color: AppColors.textSecondary),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSwitchTile({
    required IconData icon,
    required String title,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppColors.textSecondary),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: AppColors.primary,
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownTile({
    required IconData icon,
    required String title,
    required String value,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppColors.textSecondary),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          DropdownButton<String>(
            value: value,
            underline: const SizedBox(),
            items: items.map((item) {
              return DropdownMenuItem(
                value: item,
                child: Text(item, style: const TextStyle(fontSize: 14)),
              );
            }).toList(),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  Widget _buildLogoutButton() {
    return Container(
      margin: const EdgeInsets.all(16),
      child: ElevatedButton.icon(
        onPressed: () async {
          final confirm = await _showLogoutDialog();
          if (confirm == true && mounted) {
            final authProvider = context.read<AuthProvider>();
            await authProvider.signOut();
            Navigator.pushReplacementNamed(context, AppRouter.login);
          }
        },
        icon: const Icon(Icons.logout),
        label: const Text('Logout'),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.error,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  Future<bool?> _showLogoutDialog() {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }

  void _showDeleteAccountDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.warning, color: AppColors.error),
            const SizedBox(width: 8),
            const Text('Delete Account'),
          ],
        ),
        content: const Text(
          'This action cannot be undone. All your data will be permanently deleted.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}