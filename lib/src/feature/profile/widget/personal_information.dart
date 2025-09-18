import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medicine_application/src/feature/profile/widget/update_phone_number_screen.dart';
import 'package:ui/ui.dart';
import '../../../../ui/ui.dart';
import '../../../common/extensions/build_context.dart';
import '../../../common/scopes/dependencies_scope.dart';
import '../../authentication/model/user_entity.dart';
import '../../authentication/state_manegament/auth_bloc/auth_bloc.dart';
import '../state_management/bloc/verification_phone_bloc.dart';
import 'profile_tile.dart';
import 'update_email_screen.dart';

class PersonalInformation extends StatelessWidget {
  const PersonalInformation({super.key});

  @override
  Widget build(BuildContext context) => Column(
    children: [
      BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
          return state.maybeMap(
            orElse: () => Container(),
            loading: (_) => ShimmerLoading(isLoading: true, child: Container()),
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

class _TilesPersonalInformation extends StatefulWidget {
  const _TilesPersonalInformation({required this.user});

  final AuthenticatedUser user;

  @override
  State<_TilesPersonalInformation> createState() =>
      _TilesPersonalInformationState();
}

class _TilesPersonalInformationState extends State<_TilesPersonalInformation> {
  late final VerificationPhoneBloc _verificationPhoneBloc;

  @override
  void initState() {
    super.initState();
    _verificationPhoneBloc = DependeciesScope.of(context).verificationPhoneBloc;
  }

  @override
  Widget build(BuildContext context) => Column(
    children: [
      Stack(
        alignment: Alignment.bottomCenter,
        children: [
          UserAvatar(user: widget.user),
          Align(
            alignment: Alignment(0.3, 1),
            child: const Icon(Icons.mode_edit_outline),
          ),
        ],
      ),
      const SizedBox(height: 24),
      Text(
        widget.user.displayName ?? '',
        style: context.extentions.themeText.titleLarge,
      ),
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
            subtitle: widget.user.email,
          ),
          const SizedBox(height: 16),
          ProfileTile(
            onTap: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                useRootNavigator: true,
                builder: (context) => BlocProvider.value(
                  value: _verificationPhoneBloc,
                  child: UpdatePhoneNumberScreen(),
                ),
              );
            },
            icon: Icons.phone,
            title: 'Phone number',
            subtitle: widget.user.email,
          ),
          const SizedBox(height: 16),
          ProfileTile(
            onTap: () {},
            icon: Icons.map_outlined,
            title: 'Addres',
            subtitle: widget.user.email,
          ),
        ],
      ),
    ],
  );
}
