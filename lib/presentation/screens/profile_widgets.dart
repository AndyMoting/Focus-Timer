part of 'profile_screen.dart';

Widget _buildProfileHeader(ColorScheme colorScheme) {
  return Center(
    child: Column(
      children: [
        CircleAvatar(
          radius: 36,
          backgroundColor: colorScheme.primaryContainer,
          child: Icon(
            Icons.person,
            size: 36,
            color: colorScheme.onPrimaryContainer,
          ),
        ),
        const SizedBox(height: 12),
        const Text(
          'Focus Timer',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 4),
        Text(
          'v${AppConstants.appVersion}',
          style: TextStyle(color: colorScheme.onSurfaceVariant),
        ),
      ],
    ),
  );
}

Widget _buildProfileSection(
  BuildContext context,
  String title,
  List<Widget> items,
) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ),
      ...items,
    ],
  );
}

Widget _buildProfileItem(
  IconData icon,
  String title,
  VoidCallback? onTap, {
  String? subtitle,
  Widget? trailing,
}) {
  return ListTile(
    leading: Icon(icon),
    title: Text(title),
    subtitle: subtitle == null ? null : Text(subtitle),
    trailing:
        trailing ?? (onTap != null ? const Icon(Icons.chevron_right) : null),
    onTap: onTap,
  );
}
