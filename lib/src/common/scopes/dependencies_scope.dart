import 'package:medicine_application/ui/ui.dart';

import '../../feature/initialization/dependency/dependency_container.dart';

class DepenciesScope extends InheritedWidget {
  const DepenciesScope({
    required this.dependencyContainer,
    required super.child,
    super.key,
  });

  final DependencyContainer dependencyContainer;

  static DependencyContainer of(BuildContext context, {bool listen = false}) {
    if (listen) {
      return context
          .dependOnInheritedWidgetOfExactType<DepenciesScope>()!
          .dependencyContainer;
    } else {
      final widget = context
          .getElementForInheritedWidgetOfExactType<DepenciesScope>()!
          .widget;

      return (widget as DepenciesScope).dependencyContainer;
    }
  }

  @override
  bool updateShouldNotify(covariant DepenciesScope oldWidget) =>
      !identical(dependencyContainer, oldWidget.dependencyContainer);
}
