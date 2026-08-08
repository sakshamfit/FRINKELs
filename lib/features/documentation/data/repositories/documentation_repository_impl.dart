import 'package:dartz/dartz.dart';
import '../../../../core/failures/failure.dart';
import '../../domain/entities/documentation.dart';
import '../../domain/repositories/documentation_repository.dart';
import '../datasources/abstracts/documentation_remote_data_source.dart';
import '../datasources/supabase_documentation_remote_data_source.dart';

class DocumentationRepositoryImpl implements DocumentationRepository {
  final DocumentationRemoteDataSource remoteDataSource;

  DocumentationRepositoryImpl({
    DocumentationRemoteDataSource? remoteDataSource,
  }) : remoteDataSource =
        remoteDataSource ?? SupabaseDocumentationRemoteDataSource();

  @override
  Future<Either<Failure, Documentation>> getDocumentation(String id) =>
      remoteDataSource.getDocumentation(id);

  @override
  Future<Either<Failure, List<Documentation>>> getAllDocumentation({
    String? category,
    bool? isPublished,
  }) =>
      remoteDataSource.getAllDocumentation(
        category: category,
        isPublished: isPublished,
      );

  @override
  Future<Either<Failure, List<Documentation>>> searchDocumentation(
    String query, {
    String? category,
  }) =>
      remoteDataSource.searchDocumentation(query, category: category);

  @override
  Future<Either<Failure, Documentation>> createDocumentation(
    Documentation documentation,
  ) =>
      remoteDataSource.createDocumentation(documentation);

  @override
  Future<Either<Failure, Documentation>> updateDocumentation(
    Documentation documentation,
  ) =>
      remoteDataSource.updateDocumentation(documentation);

  @override
  Future<Either<Failure, void>> deleteDocumentation(String id) =>
      remoteDataSource.deleteDocumentation(id);

  @override
  Future<Either<Failure, List<String>>> getDocumentationCategories() =>
      remoteDataSource.getDocumentationCategories();
}