import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/documentation.dart';
import '../../presentation/controllers/documentation_provider.dart';

class DocumentationDetail extends ConsumerWidget {
  const DocumentationDetail({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = GoRouterState.of(context);
    final id = state.pathParameters['id'] ?? '';
    final documentationState = ref.watch(documentationStateNotifierProvider);

    return documentationState.when(
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (error, stackTrace) => Scaffold(
        appBar: AppBar(
          title: const Text('Error'),
          backgroundColor: AppColors.backgroundDark,
        ),
        body: Center(child: Text('Error: $error')),
      ),
      data: (documentation) {
        final doc = documentation.firstWhere(
          (d) => d.id == id,
          orElse: () => documentation.first,
        );

        return Scaffold(
          backgroundColor: AppColors.backgroundDark,
          appBar: AppBar(
            title: Text(doc.title),
            backgroundColor: AppColors.backgroundDark,
            elevation: 0,
            actions: [
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () => _showEditDocumentationDialog(context, ref, doc),
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  doc.title,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 16),
                Chip(
                  label: Text(doc.category),
                  backgroundColor: AppColors.primary.withOpacity(0.1),
                  labelStyle: TextStyle(color: AppColors.primary),
                ),
                const SizedBox(height: 16),
                if (doc.tags.isNotEmpty) ...[
                  Wrap(
                    spacing: 8,
                    children: doc.tags
                        .map((tag) => Chip(
                              label: Text(tag),
                              backgroundColor: AppColors.secondary.withOpacity(0.1),
                              labelStyle: TextStyle(color: AppColors.secondary),
                            ))
                        .toList(),
                  ),
                  const SizedBox(height: 16),
                ],
                Text(
                  doc.content,
                  style: const TextStyle(
                    fontSize: 16,
                    height: 1.5,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 24),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    'Last updated: ${doc.updatedAt.toLocal()}',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () => _showEditDocumentationDialog(context, ref, doc),
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            child: const Icon(Icons.edit),
          ),
        );
      },
    );
  }

  void _showEditDocumentationDialog(
      BuildContext context, WidgetRef ref, Documentation doc) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.cardDark,
        title: const Text(
          'Edit Documentation',
          style: TextStyle(color: AppColors.textPrimary),
        ),
        content: const Text(
          'Feature not implemented yet.',
          style: TextStyle(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => GoRouter.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => GoRouter.of(context).pop(),
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}