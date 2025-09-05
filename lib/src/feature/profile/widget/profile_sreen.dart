import 'package:auto_route/auto_route.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medicine_application/src/common/extensions/build_context.dart';
import 'package:medicine_application/ui/ui.dart';
import '../../authentication/state_manegament/auth_bloc/auth_bloc.dart';
import 'personal_information.dart';
import 'profile_tile.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) =>
      BlocListener<AuthenticationBloc, AuthenticationState>(
        listener: (context, state) {
          state.mapOrNull(
            error: (state) => ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message))),
            notAuthenticated: (_) =>
                context.router.replace(NamedRoute('SignInScreen')),
          );
        },
        child: Scaffold(
          body: Shimmer(
            child: CustomScrollView(
              slivers: [
                const SliverAppBar(
                  title: Text('Profile'),
                  pinned: true,
                  floating: true,
                  snap: true,
                ),
                SliverPadding(
                  padding: const EdgeInsets.all(16),
                  sliver: SliverList.list(
                    children: [
                      const PersonalInformation(),
                      const SizedBox(height: 16),
                      Text(
                        'Medical Hostory',
                        style: context.extentions.themeText.titleMedium,
                      ),
                      const SizedBox(height: 16),
                      ProfileTile(
                        onTap: () {},
                        icon: Icons.medication_outlined,
                        title: 'Allergies',
                        subtitle: 'None',
                      ),
                      const SizedBox(height: 16),
                      ProfileTile(
                        onTap: () {},
                        icon: Icons.medication_outlined,
                        title: 'Allergies',
                        subtitle: 'None',
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Settings',
                        style: context.extentions.themeText.titleMedium,
                      ),
                      const SizedBox(height: 16),
                      ProfileTile(
                        onTap: () {},
                        icon: Icons.payment,
                        title: 'Payment Information',
                      ),
                      const SizedBox(height: 16),
                      ProfileTile(
                        onTap: () {},
                        icon: Icons.notifications_active,
                        title: 'Notifications',
                      ),
                      const SizedBox(height: 16),
                      ProfileTile(
                        onTap: () {},
                        icon: Icons.help,
                        title: 'Help & Support',
                      ),
                      const SizedBox(height: 32),
                      Align(
                        alignment: Alignment.center,
                        child: GestureDetector(
                          onTap: () {
                            context.read<AuthenticationBloc>().add(
                              AuthenticationEvent.signOut(),
                            );
                          },
                          child: Text(
                            'Log Out',
                            style: context.extentions.themeText.titleMedium
                                ?.copyWith(color: AppColors.red[400]),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}
