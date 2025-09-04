import 'package:medicine_application/ui/ui.dart';

import '../../feature/initialization/dependency/dependency_container.dart';

class DependeciesScope extends InheritedWidget {
  const DependeciesScope({
    required this.dependencyContainer,
    required super.child,
    super.key,
  });

  final DependencyContainer dependencyContainer;

  static DependencyContainer of(BuildContext context, {bool listen = false}) {
    if (listen) {
      return context
          .dependOnInheritedWidgetOfExactType<DependeciesScope>()!
          .dependencyContainer;
    } else {
      final widget = context
          .getElementForInheritedWidgetOfExactType<DependeciesScope>()!
          .widget;

      return (widget as DependeciesScope).dependencyContainer;
    }
  }

  @override
  bool updateShouldNotify(covariant DependeciesScope oldWidget) =>
      !identical(dependencyContainer, oldWidget.dependencyContainer);
}
