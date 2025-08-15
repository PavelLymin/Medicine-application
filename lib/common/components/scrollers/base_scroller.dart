import 'package:medicine_application/common/ui.dart';

class BaseScroller extends StatelessWidget {
  const BaseScroller({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 170,
      height: 5,
      decoration: BoxDecoration(
        color: AppColors.grey,
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }
}
