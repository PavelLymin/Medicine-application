import 'package:medicine_application/src/common/extensions/build_context.dart';
import 'package:medicine_application/ui/ui.dart';

class ProfileTile extends StatelessWidget {
  const ProfileTile({
    super.key,
    this.subtitle,
    required this.onTap,
    required this.icon,
    required this.title,
  });
  final Function() onTap;
  final IconData icon;
  final String title;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: AppColors.lightgrey,
            ),
            child: Center(child: Icon(icon, size: 32)),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: ListTile(
              title: Text(title, style: context.extentions.themeText.bodyLarge),
              subtitle: subtitle == null ? null : Text(subtitle!),
            ),
          ),
        ],
      ),
    );
  }
}
