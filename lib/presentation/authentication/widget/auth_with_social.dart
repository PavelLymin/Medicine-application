import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medicine_application/common/bloc/auth_bloc/auth_bloc.dart';
import 'package:medicine_application/common/extencions/build_context.dart';
import '../../../common/ui.dart';

class AuthWithSocial extends StatelessWidget {
  const AuthWithSocial({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              width: 100,
              child: Divider(color: AppColors.grey, thickness: 3),
            ),
            const SizedBox(width: 8),
            const Text('OR'),
            const SizedBox(width: 8),
            const SizedBox(
              width: 100,
              child: Divider(color: AppColors.grey, thickness: 3),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll<Color>(
                    context.color.buttonSocialColor,
                  ),
                  backgroundBuilder: (context, state, child) => Container(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColors.grey, width: 1.3),
                    ),
                    child: Image(
                      image: AssetImage('assets/icons/google.png'),
                      height: 32,
                      width: 32,
                    ),
                  ),
                ),
                onPressed: () {
                  context.read<AuthenticationBloc>().add(
                    AuthenticationEvent.signInWithGoogle(),
                  );
                },
                child: Container(),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll<Color>(
                    context.color.buttonSocialColor,
                  ),
                  backgroundBuilder: (context, state, child) => Container(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColors.grey, width: 1.3),
                    ),
                    child: Image(
                      image: AssetImage('assets/icons/apple.png'),
                      height: 32,
                      width: 32,
                    ),
                  ),
                ),
                onPressed: () {},
                child: Container(),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
