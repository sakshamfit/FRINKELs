import 'package:dartz/dartz.dart';
import '../../../../core/failures/failure.dart';
import '../../domain/entities/documentation.dart';

abstract class DocumentationRemoteDataSource {
  // Get documentation by ID
  Future<Either<Failure, Documentation>> getDocumentation(String id);

  // Get all documentation
  Future<Either<Failure, List<Documentation>>> getAllDocumentation({
    String? category,
    bool? isPublished,
  });

  // Search documentation
  Future<Either<Failure, List<Documentation>>> searchDocumentation(
    String query, {
    String? category,
  });

  // Create documentation
  Future<Either<Failure, Documentation>> createDocumentation(
    Documentation documentation,
  );

  // Update documentation
  Future<Either<Failure, Documentation>> updateDocumentation(
    Documentation documentation,
  );

  // Delete documentation
  Future<Either<Failure, void>> deleteDocumentation(String id);

  // Get documentation categories
  Future<Either<Failure, List<String>>> getDocumentationCategories();
}