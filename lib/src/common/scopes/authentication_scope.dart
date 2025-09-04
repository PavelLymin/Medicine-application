import 'dart:async';
import 'package:flutter/material.dart';
import 'package:medicine_application/src/feature/authentication/state_manegament/auth_bloc/auth_bloc.dart';
import 'dependencies_scope.dart';

class AuthenticationScope extends StatefulWidget {
  const AuthenticationScope({super.key, required this.child});

  static AuthenticationState authenticationOf(
    BuildContext context, {
    bool listen = true,
  }) {
    if (listen) {
      return context
          .dependOnInheritedWidgetOfExactType<_AuthenticationScopeInherited>()!
          .state;
    } else {
      return context
          .getInheritedWidgetOfExactType<_AuthenticationScopeInherited>()!
          .state;
    }
  }

  final Widget child;

  @override
  State<AuthenticationScope> createState() => _AuthenticationScopeState();
}

class _AuthenticationScopeState extends State<AuthenticationScope> {
  late final AuthenticationBloc _bloc;
  late AuthenticationState _state;
  StreamSubscription? _streamSubscription;

  @override
  void initState() {
    super.initState();
    _bloc = DependeciesScope.of(context).authenticationBloc;
    _state = _bloc.state;
    _streamSubscription = _bloc.stream.listen((state) {
      if (state == _state) return;
      setState(() {
        _state = state;
      });
    });
  }

  @override
  void dispose() {
    _streamSubscription?.cancel();
    _streamSubscription = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) =>
      _AuthenticationScopeInherited(state: _state, child: widget.child);
}

class _AuthenticationScopeInherited extends InheritedWidget {
  const _AuthenticationScopeInherited({
    required super.child,
    required this.state,
  });

  final AuthenticationState state;

  @override
  bool updateShouldNotify(covariant _AuthenticationScopeInherited oldWidget) =>
      !identical(state, oldWidget.state);
}
