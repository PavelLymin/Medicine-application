import 'package:auto_route/auto_route.dart';
import 'package:medicine_application/common/bloc/auth_bloc/auth_bloc.dart';
import 'package:medicine_application/presentation/authentication/page/signin.dart';
import 'package:medicine_application/presentation/chat/page/list_of_chats_screen.dart';
import 'package:medicine_application/presentation/consultations/page/consultations_screen.dart';
import 'package:medicine_application/presentation/home/page/home_screen.dart';
import 'package:medicine_application/presentation/profile/page/profile_sreen.dart';
import 'package:medicine_application/presentation/profile/page/update_phone_number_screen.dart';
import '../../presentation/chat/page/chat_screen.dart';
import '../../presentation/profile/page/sms_code_screen.dart';
import '../components/navigations/bottom_navigation_bar.dart';

@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  AppRouter({required AuthenticationBloc authenticationBloc})
    : _authenticationBloc = authenticationBloc;

  final AuthenticationBloc _authenticationBloc;

  @override
  List<AutoRoute> get routes => [
    NamedRouteDef(
      name: 'SignInScreen',
      builder: (context, _) => const SignIn(),
    ),
    NamedRouteDef(
      name: 'UpdatePhoneNumberScreen',
      builder: (context, _) => const UpdatePhoneNumberScreen(),
    ),
    NamedRouteDef(
      name: 'SmsCodeScreen',
      builder: (context, _) => const SmsCodeScreen(),
    ),
    NamedRouteDef(
      name: 'ChatScreen',
      builder: (context, data) =>
          ChatScreen(chatEntity: data.params.get('chatEntity')),
    ),
    NamedRouteDef(
      initial: true,
      guards: [AuthGuard(authenticationBloc: _authenticationBloc)],
      name: 'BottomNavigationBar',
      builder: (context, _) => const RootScreen(),
      children: [
        NamedRouteDef(
          initial: true,
          name: 'HomeScreen',
          builder: (context, _) => const HomeScreen(),
        ),
        NamedRouteDef(
          name: 'ProfileScreen',
          builder: (context, _) => const ProfileScreen(),
        ),
        NamedRouteDef(
          name: 'ChatScreen',
          builder: (context, _) => const ListOfChatsScreen(),
        ),
        NamedRouteDef(
          name: 'ConsultationsScreen',
          builder: (context, data) => const ConsultationsScreen(),
        ),
      ],
    ),
  ];
}

class AuthGuard extends AutoRouteGuard {
  const AuthGuard({required AuthenticationBloc authenticationBloc})
    : _authenticationBloc = authenticationBloc;

  final AuthenticationBloc _authenticationBloc;

  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) {
    final isAuthenticated = _authenticationBloc.state.isAuthenticated;
    if (isAuthenticated) {
      resolver.next(true);
    } else {
      router.navigate(NamedRoute('SignInScreen'));
    }
  }
}
