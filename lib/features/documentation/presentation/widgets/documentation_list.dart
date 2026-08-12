import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/documentation.dart';

class DocumentationList extends ConsumerWidget {
  final List<Documentation> documentation;
  final void Function(Documentation) onTap;

  const DocumentationList({
    super.key,
    required this.documentation,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (documentation.isEmpty) {
      return const Center(
        child: Text(
          'No documentation available',
          style: TextStyle(color: AppColors.textSecondary),
        ),
      );
    }

    return ListView.builder(
      itemCount: documentation.length,
      itemBuilder: (context, index) {
        final doc = documentation[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: ListTile(
            leading: const Icon(Icons.description, color: AppColors.primary),
            title: Text(
              doc.title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            subtitle: Text(
              doc.category,
              style: TextStyle(color: AppColors.textSecondary),
            ),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => onTap(doc),
          ),
        );
      },
    );
  }
}
