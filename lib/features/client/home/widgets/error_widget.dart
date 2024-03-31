import 'package:flutter/material.dart';
import 'package:smart_real_estate/core/utils/images.dart';

class InternetErrorWidget extends StatelessWidget {
  final String description;
  final VoidCallback? onRetry;

  const InternetErrorWidget({
    super.key,
    required this.description,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            Images.errorNetwork,
            width: 200,
            height: 200,
          ),
          const SizedBox(height: 20),
          Text(
            description,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          if (onRetry != null)
            ElevatedButton(
              onPressed: onRetry,
              child: const Text('Retry'),
            ),
        ],
      ),
    );
  }
}
