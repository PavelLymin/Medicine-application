import 'package:ui/ui.dart';

class ButtonDown extends StatefulWidget {
  const ButtonDown({super.key, required ScrollController scrollController})
    : _scrollController = scrollController;

  final ScrollController _scrollController;

  @override
  State<ButtonDown> createState() => _ButtonDownState();
}

class _ButtonDownState extends State<ButtonDown> {
  bool _isButtonVisible = false;

  @override
  void initState() {
    super.initState();
    final controller = widget._scrollController;
    controller.addListener(() {
      if (controller.offset > 50 && !_isButtonVisible) {
        setState(() {
          _isButtonVisible = true;
        });
      }
      if (controller.offset < 50 && _isButtonVisible) {
        setState(() {
          _isButtonVisible = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) => _isButtonVisible
      ? Padding(
          padding: const EdgeInsets.only(bottom: 16, right: 8),
          child: IconButton(
            style: ButtonStyle(
              shape: WidgetStatePropertyAll(
                CircleBorder(side: const BorderSide(color: AppColors.black)),
              ),
            ),
            onPressed: () {
              if (widget._scrollController.hasClients) {
                widget._scrollController.animateTo(
                  widget._scrollController.position.minScrollExtent,
                  duration: const Duration(microseconds: 100),
                  curve: Curves.fastOutSlowIn,
                );
              }
            },
            icon: const Icon(
              Icons.arrow_downward_rounded,
              size: 32,
              color: AppColors.black,
            ),
          ),
        )
      : const SizedBox.shrink();
}
