import 'package:dartz/dartz.dart';
import '../../../../core/failures/failure.dart';
import '../entities/documentation.dart';
import '../repositories/documentation_repository.dart';

class GetAllDocumentation {
  final DocumentationRepository repository;

  GetAllDocumentation(this.repository);

  Future<Either<Failure, List<Documentation>>> call({
    String? category,
    bool? isPublished,
  }) => repository.getAllDocumentation(
    category: category,
    isPublished: isPublished,
  );
}
