import 'package:medicine_application/common/ui.dart';
import 'package:medicine_application/model/user_entity.dart';

class UserAvatar extends StatelessWidget {
  const UserAvatar({super.key, required this.user, this.radius = 64});

  final AuthenticatedUser user;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      foregroundImage: user.photoURL == null
          ? AssetImage('assets/icons/user.png')
          : NetworkImage(user.photoURL!),
    );
  }
}
