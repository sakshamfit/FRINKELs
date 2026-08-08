import 'package:dartz/dartz.dart';
import '../../../../core/failures/failure.dart';
import '../entities/documentation.dart';
import '../repositories/documentation_repository.dart';

class GetDocumentation {
  final DocumentationRepository repository;

  GetDocumentation(this.repository);

  Future<Either<Failure, Documentation>> call(String id) =>
      repository.getDocumentation(id);
}