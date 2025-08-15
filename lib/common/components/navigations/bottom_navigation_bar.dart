import 'package:auto_route/auto_route.dart';
import 'package:medicine_application/common/extencions/build_context.dart';
import 'package:medicine_application/common/ui.dart';

class RootScreen extends StatelessWidget {
  const RootScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AutoTabsScaffold(
      routes: const [
        NamedRoute('HomeScreen'),
        NamedRoute('ConsultationsScreen'),
        NamedRoute('ChatScreen'),
        NamedRoute('ProfileScreen'),
      ],
      bottomNavigationBuilder: (_, tabsRouter) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
          child: Container(
            height: 68,
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(32),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  blurRadius: 12,
                  offset: const Offset(0, 0),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  TabItem(
                    icon: Icons.home_outlined,
                    activeIcon: Icons.home,
                    index: 0,
                    router: tabsRouter,
                    title: 'Home',
                  ),
                  TabItem(
                    icon: Icons.favorite_border_outlined,
                    activeIcon: Icons.favorite,
                    index: 1,
                    router: tabsRouter,
                    title: 'Consultations',
                  ),
                  TabItem(
                    icon: Icons.chat_bubble_outline,
                    activeIcon: Icons.chat_bubble,
                    index: 2,
                    router: tabsRouter,
                    title: 'Chat',
                  ),
                  TabItem(
                    icon: Icons.person_outline,
                    activeIcon: Icons.person,
                    index: 3,
                    router: tabsRouter,
                    title: 'Profile',
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class TabItem extends StatelessWidget {
  const TabItem({
    super.key,
    required this.icon,
    required this.activeIcon,
    required this.index,
    required this.router,
    required this.title,
  });

  final IconData icon;
  final IconData activeIcon;
  final int index;
  final TabsRouter router;
  final String title;

  bool get isActive => router.activeIndex == index;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => router.setActiveIndex(index),
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            isActive ? activeIcon : icon,
            size: 28,
            color: isActive ? AppColors.green : Colors.grey[600],
          ),
          Text(
            title,
            style: context.themeText.bodySmall?.copyWith(
              color: isActive ? AppColors.green : Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}
