import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/language_provider.dart';

class ErrorBoundary extends StatelessWidget {
  final Widget child;
  final String message;
  final void Function() onRetry;

  const ErrorBoundary({
    super.key,
    required this.child,
    required this.onRetry,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return ErrorBoundaryBuilder(
      builder: (context) => child,
      errorBuilder: (context, error) {
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 48,
                  color: Theme.of(context).colorScheme.error,
                ),
                const SizedBox(height: 16),
                Text(
                  'An error occurred: ${error.toString()}',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed:
                      onRetry, // Call onRetry instead of creating a new ErrorBoundary
                  icon: const Icon(Icons.refresh),
                  label: const Text('Retry'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class ErrorBoundaryBuilder extends StatefulWidget {
  final Widget Function(BuildContext context) builder;
  final Widget Function(BuildContext context, Object error)? errorBuilder;

  const ErrorBoundaryBuilder({
    super.key,
    required this.builder,
    this.errorBuilder,
  });

  @override
  State<ErrorBoundaryBuilder> createState() => _ErrorBoundaryBuilderState();
}

class _ErrorBoundaryBuilderState extends State<ErrorBoundaryBuilder> {
  Object? _error;

  @override
  Widget build(BuildContext context) {
    if (_error != null) {
      return widget.errorBuilder?.call(context, _error!) ??
          _buildErrorWidget(context, _error!);
    }

    return Builder(
      builder: (context) {
        try {
          return widget.builder(context);
        } catch (e) {
          _error = e;
          return _buildErrorWidget(context, e);
        }
      },
    );
  }

  Widget _buildErrorWidget(BuildContext context, Object error) {
    final languageProvider = Provider.of<LanguageProvider>(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 48,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              languageProvider.getText(
                'त्रुटि भयो: ${error.toString()}',
                'An error occurred: ${error.toString()}',
              ),
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () => setState(() => _error = null),
              icon: const Icon(Icons.refresh),
              label: Text(
                languageProvider.getText('पुन: प्रयास', 'Retry'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
