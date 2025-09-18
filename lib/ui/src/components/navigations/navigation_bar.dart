import 'dart:io';
import 'package:auto_route/auto_route.dart';
import 'package:ui/ui.dart';
import '../../../../src/common/extensions/build_context.dart';

class RootScreen extends StatelessWidget {
  const RootScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AutoTabsRouter(
      routes: const [
        NamedRoute('Home'),
        NamedRoute('Consultations'),
        NamedRoute('Chat'),
        NamedRoute('Profile'),
      ],
      lazyLoad: true,
      builder: (context, child) => Scaffold(
        appBar: AppBar(
          title: Text(AutoTabsRouter.of(context).current.name),
          centerTitle: true,
        ),
        drawer: Platform.isMacOS && MediaQuery.sizeOf(context).width < 620
            ? Drawer(
                child: ListView.builder(
                  itemCount: 4,
                  itemBuilder: (context, index) => TabItem(
                    icon: Icons.home_outlined,
                    activeIcon: Icons.home,
                    index: index,
                    title: 'Home',
                  ),
                ),
              )
            : null,
        bottomNavigationBar: Platform.isIOS || Platform.isAndroid
            ? const BottomNavigation()
            : null,
        body: Platform.isMacOS && MediaQuery.sizeOf(context).width >= 620
            ? Row(
                children: [
                  NavigationRail(
                    destinations: const [
                      NavigationRailDestination(
                        icon: Icon(Icons.home_outlined),
                        selectedIcon: Icon(Icons.home),
                        label: Text('Home'),
                      ),
                      NavigationRailDestination(
                        icon: Icon(Icons.calendar_month_outlined),
                        selectedIcon: Icon(Icons.calendar_month),
                        label: Text('Consultations'),
                      ),
                      NavigationRailDestination(
                        icon: Icon(Icons.chat_outlined),
                        selectedIcon: Icon(Icons.chat),
                        label: Text('Chat'),
                      ),
                      NavigationRailDestination(
                        icon: Icon(Icons.person_outlined),
                        selectedIcon: Icon(Icons.person),
                        label: Text('Profile'),
                      ),
                    ],
                    selectedIndex: AutoTabsRouter.of(context).activeIndex,
                  ),
                  Expanded(child: child),
                ],
              )
            : child,
      ),
    );
  }
}

class BottomNavigation extends StatelessWidget {
  const BottomNavigation({super.key});

  @override
  Widget build(BuildContext context) => SafeArea(
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
            children: const [
              TabItem(
                icon: Icons.home_outlined,
                activeIcon: Icons.home,
                index: 0,
                title: 'Home',
              ),
              TabItem(
                icon: Icons.favorite_border_outlined,
                activeIcon: Icons.favorite,
                index: 1,
                title: 'Consultations',
              ),
              TabItem(
                icon: Icons.chat_bubble_outline,
                activeIcon: Icons.chat_bubble,
                index: 2,
                title: 'Chat',
              ),
              TabItem(
                icon: Icons.person_outline,
                activeIcon: Icons.person,
                index: 3,
                title: 'Profile',
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

class TabItem extends StatefulWidget {
  const TabItem({
    super.key,
    required this.icon,
    required this.activeIcon,
    required this.index,
    required this.title,
  });

  final IconData icon;
  final IconData activeIcon;
  final int index;
  final String title;

  @override
  State<TabItem> createState() => _TabItemState();
}

class _TabItemState extends State<TabItem> {
  bool _isActive = false;

  @override
  void didChangeDependencies() {
    _isActive =
        AutoTabsRouter.of(context, watch: true).activeIndex == widget.index;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        AutoTabsRouter.of(context).setActiveIndex(widget.index);
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            _isActive ? widget.activeIcon : widget.icon,
            size: 28,
            color: _isActive ? AppColors.green : Colors.grey[600],
          ),
          Text(
            widget.title,
            style: context.extentions.themeText.bodySmall?.copyWith(
              color: _isActive ? AppColors.green : Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}
