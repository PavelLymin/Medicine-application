import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medicine_application/src/common/extensions/build_context.dart';
import '../../../../ui/ui.dart';
import '../../authentication/model/user_entity.dart';
import '../../authentication/state_manegament/auth_bloc/auth_bloc.dart';
import 'profile_tile.dart';
import 'update_email_screen.dart';
import 'update_phone_number_screen.dart';

class PersonalInformation extends StatelessWidget {
  const PersonalInformation({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        BlocBuilder<AuthenticationBloc, AuthenticationState>(
          builder: (context, state) {
            return state.maybeMap(
              orElse: () => Container(),
              loading: (_) =>
                  ShimmerLoading(isLoading: true, child: Container()),
              authenticated: (state) {
                final user = state.user;
                return _TilesPersonalInformation(user: user);
              },
            );
          },
        ),
      ],
    );
  }
}

class _TilesPersonalInformation extends StatelessWidget {
  const _TilesPersonalInformation({required this.user});

  final AuthenticatedUser user;

  @override
  Widget build(BuildContext context) => Column(
    children: [
      Stack(
        alignment: Alignment.bottomCenter,
        children: [
          UserAvatar(user: user),
          Align(
            alignment: Alignment(0.3, 1),
            child: const Icon(Icons.mode_edit_outline),
          ),
        ],
      ),
      const SizedBox(height: 24),
      Text(user.displayName!, style: context.extentions.themeText.titleLarge),
      const SizedBox(height: 32),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Personal Information',
            style: context.extentions.themeText.titleMedium,
          ),
          const SizedBox(height: 16),
          ProfileTile(
            onTap: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                builder: (context) => const UpdateEmailScreen(),
              );
            },
            icon: Icons.email_outlined,
            title: 'Email',
            subtitle: user.email,
          ),
          const SizedBox(height: 16),
          ProfileTile(
            onTap: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                builder: (context) => const UpdatePhoneNumberScreen(),
              );
            },
            icon: Icons.phone,
            title: 'Phone number',
            subtitle: user.email,
          ),
          const SizedBox(height: 16),
          ProfileTile(
            onTap: () {},
            icon: Icons.map_outlined,
            title: 'Addres',
            subtitle: user.email,
          ),
        ],
      ),
    ],
  );
}
