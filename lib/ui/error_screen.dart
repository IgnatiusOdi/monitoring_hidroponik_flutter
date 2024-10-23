import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ErrorScreen extends StatelessWidget {
  final GoException? error;

  const ErrorScreen({super.key, this.error});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor:
          theme.colorScheme.primaryContainer,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '404',
              style: TextStyle(
                  fontSize: 100,
                  color: theme.colorScheme.error),
            ),
            Text(
              'Page Not Found',
              style: TextStyle(
                  fontSize: 40,
                  color: theme.colorScheme.error),
            ),
            const SizedBox(height: 60),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    theme.colorScheme.secondary,
                foregroundColor:
                    theme.colorScheme.onSecondary,
                padding: const EdgeInsets.all(24),
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(10),
                ),
              ),
              onPressed: () => context.go('/'),
              child: const Text(
                '< Back to Login',
                style: TextStyle(fontSize: 20),
              ),
            )
          ],
        ),
      ),
    );
  }
}
