import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../presentation/controllers/documentation_provider.dart';
import '../../presentation/widgets/documentation_list.dart';

class DocumentationScreen extends ConsumerWidget {
  static const String routeName = '/documentation';

  const DocumentationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final documentationState = ref.watch(documentationStateNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Documentation'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => _showSearchDialog(context, ref),
          ),
        ],
      ),
      body: documentationState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(child: Text('Error: $error')),
        data: (documentation) => DocumentationList(
          documentation: documentation,
          onTap: (doc) => GoRouter.of(context).push('/documentation/${doc.id}'),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddDocumentationDialog(context, ref),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showSearchDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Search Documentation'),
        content: Consumer(
          builder: (context, ref, child) {
            final state = ref.watch(documentationStateNotifierProvider);
            return state.when(
              loading: () => const CircularProgressIndicator(),
              error: (e, stackTrace) => Text('Error: $e'),
              data: (documentation) => TextField(
                decoration: const InputDecoration(
                  labelText: 'Search',
                  border: OutlineInputBorder(),
                ),
                onChanged: (query) {
                  if (query.isEmpty) {
                    ref
                        .read(documentationStateNotifierProvider.notifier)
                        .loadAllDocumentation();
                  } else {
                    ref
                        .read(documentationStateNotifierProvider.notifier)
                        .searchDocumentation(query);
                  }
                },
              ),
            );
          },
        ),
        actions: [
          TextButton(
            onPressed: () => GoRouter.of(context).pop(),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _showAddDocumentationDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Documentation'),
        content: const Text('Feature not implemented yet.'),
        actions: [
          TextButton(
            onPressed: () => GoRouter.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
