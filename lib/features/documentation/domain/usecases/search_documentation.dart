import 'package:dartz/dartz.dart';
import '../../../../core/failures/failure.dart';
import '../entities/documentation.dart';
import '../repositories/documentation_repository.dart';

class SearchDocumentation {
  final DocumentationRepository repository;

  SearchDocumentation(this.repository);

  Future<Either<Failure, List<Documentation>>> call(
    String query, {
    String? category,
  }) => repository.searchDocumentation(query, category: category);
}
