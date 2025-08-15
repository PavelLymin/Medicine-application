import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medicine_application/common/bloc/auth_bloc/auth_bloc.dart';
import 'package:medicine_application/common/extencions/build_context.dart';
import 'package:medicine_application/common/ui.dart';
import 'package:medicine_application/presentation/profile/page/update_email_screen.dart';
import 'package:medicine_application/presentation/profile/page/update_phone_number_screen.dart';
import 'profile_tile.dart';

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
              loading: (_) => ShimmerLoading(
                isLoading: true,
                child: const _TilesPersonalInformation(),
              ),
              authenticated: (state) {
                final user = state.user;
                return _TilesPersonalInformation(
                  photoURL: user.photoURL,
                  displayName: user.displayName,
                  email: user.email,
                  phoneNumber: user.email,
                  addres: user.email,
                );
              },
            );
          },
        ),
      ],
    );
  }
}

class _TilesPersonalInformation extends StatelessWidget {
  const _TilesPersonalInformation({
    this.photoURL,
    this.displayName,
    this.email,
    this.phoneNumber,
    this.addres,
  });

  final String? photoURL;
  final String? displayName;
  final String? email;
  final String? phoneNumber;
  final String? addres;

  @override
  Widget build(BuildContext context) => Column(
    children: [
      Stack(
        alignment: Alignment.bottomCenter,
        children: [
          CircleAvatar(
            radius: 64,
            foregroundImage: photoURL == null
                ? AssetImage('assets/icons/user.png')
                : NetworkImage(photoURL!),
          ),
          Align(
            alignment: Alignment(0.3, 1),
            child: const Icon(Icons.mode_edit_outline),
          ),
        ],
      ),
      const SizedBox(height: 24),
      Text(displayName ?? '', style: context.themeText.titleLarge),
      const SizedBox(height: 32),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Personal Information', style: context.themeText.titleMedium),
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
            subtitle: email ?? '',
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
            subtitle: phoneNumber ?? '',
          ),
          const SizedBox(height: 16),
          ProfileTile(
            onTap: () {},
            icon: Icons.map_outlined,
            title: 'Addres',
            subtitle: addres ?? '',
          ),
        ],
      ),
    ],
  );
}
