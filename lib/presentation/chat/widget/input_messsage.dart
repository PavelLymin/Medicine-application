import 'package:flutter/material.dart';
import 'package:medicine_application/common/components/theme/theme.dart';

class InputMesssage extends StatelessWidget {
  const InputMesssage({
    super.key,
    required this.messageController,
    required this.messageFocusNode,
  });

  final TextEditingController messageController;
  final FocusNode messageFocusNode;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          const Icon(Icons.attach_file, color: AppColors.green, size: 36),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: messageController,
              focusNode: messageFocusNode,
              maxLines: null,
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(32),
                  borderSide: const BorderSide(color: AppColors.grey),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(32),
                  borderSide: const BorderSide(color: AppColors.darkGrey),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          const Icon(Icons.send, color: AppColors.green, size: 36),
        ],
      ),
    );
  }
}
