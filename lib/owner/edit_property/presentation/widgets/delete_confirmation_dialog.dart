import 'package:flutter/material.dart';
import 'package:smart_real_estate/core/utils/styles.dart';

class DeleteConfirmationDialog extends StatelessWidget {
  final VoidCallback onConfirm;
  final VoidCallback onCancel;
  bool isDeleted;

   DeleteConfirmationDialog({super.key,
    required this.onConfirm,
    required this.onCancel,
    required this.isDeleted
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Confirm Deletion'),
      content: const Text('Are you sure to delete?'),
      actions: [
        TextButton(
          onPressed: onCancel,
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: onConfirm,
          child: !isDeleted? Text('Delete' , style: fontSmall.copyWith(color: Colors.white),):const CircularProgressIndicator(color: Colors.white),
        ),
      ],
    );
  }
}