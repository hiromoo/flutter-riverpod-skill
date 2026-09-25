import 'package:flutter/material.dart';

import '../domain/app_failure.dart';
import '../l10n/build_context_l10n.dart';

class LoadError extends StatelessWidget {
  const LoadError({required this.error, required this.onRetry, super.key});

  final Object error;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final message = switch (error) {
      AppFailureException(:final failure) => switch (failure.kind) {
          AppFailureKind.network => context.l.networkError,
          AppFailureKind.notFound => context.l.notFoundError,
          AppFailureKind.invalidData => context.l.invalidDataError,
          AppFailureKind.unknown => context.l.unknownError,
        },
      _ => context.l.loadFailed,
    };
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Icon(Icons.cloud_off_outlined, size: 40, color: Theme.of(context).colorScheme.error),
            const SizedBox(height: 12),
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            OutlinedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded),
              label: Text(context.l.retry),
            ),
          ]),
        ),
      ),
    );
  }
}
