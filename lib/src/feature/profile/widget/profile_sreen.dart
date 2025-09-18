import 'package:auto_route/auto_route.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ui/ui.dart';
import '../../../common/extensions/build_context.dart';
import '../../authentication/state_manegament/auth_bloc/auth_bloc.dart';
import 'personal_information.dart';
import 'profile_tile.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

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
