import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/failures/failure.dart';
import '../../domain/entities/documentation.dart';
import '../../domain/repositories/documentation_repository.dart';
import '../../domain/usecases/get_all_documentation.dart';
import '../../domain/usecases/get_documentation.dart';
import '../../domain/usecases/search_documentation.dart';
import '../repositories/documentation_repository_impl.dart';

// StateNotifier for documentation state
class DocumentationStateNotifier
    extends StateNotifier<AsyncValue<List<Documentation>>> {
  final GetAllDocumentation _getAllDocumentation;
  final GetDocumentation _getDocumentation;
  final SearchDocumentation _searchDocumentation;

  DocumentationStateNotifier({
    required this._getAllDocumentation,
    required GetDocumentation getDocumentation,
    required this._searchDocumentation,
  }) : _getDocumentation = getDocumentation,
       super(const AsyncValue.loading());

  Future<void> loadAllDocumentation({
    String? category,
    bool? isPublished,
  }) async {
    state = const AsyncValue.loading();
    final result = await _getAllDocumentation.call(
      category: category,
      isPublished: isPublished,
    );
    state = result.fold(
      (failure) => AsyncValue.error(failure, StackTrace.current),
      (documentation) => AsyncValue.data(documentation),
    );
  }

  Future<void> loadDocumentation(String id) async {
    state = const AsyncValue.loading();
    final result = await _getDocumentation.call(id);
    state = result.fold(
      (failure) => AsyncValue.error(failure, StackTrace.current),
      (documentation) => AsyncValue.data([documentation]),
    );
  }

  Future<void> searchDocumentation(String query, {String? category}) async {
    state = const AsyncValue.loading();
    final result = await _searchDocumentation.call(query, category: category);
    state = result.fold(
      (failure) => AsyncValue.error(failure, StackTrace.current),
      (documentation) => AsyncValue.data(documentation),
    );
  }
}

// Provider for the repository
final documentationRepositoryProvider = Provider<DocumentationRepository>((
  ref,
) {
  return DocumentationRepositoryImpl();
});

// Provider for the use cases
final getAllDocumentationProvider = Provider<GetAllDocumentation>((ref) {
  final repository = ref.read(documentationRepositoryProvider);
  return GetAllDocumentation(repository);
});

final getDocumentationProvider = Provider<GetDocumentation>((ref) {
  final repository = ref.read(documentationRepositoryProvider);
  return GetDocumentation(repository);
});

final searchDocumentationProvider = Provider<SearchDocumentation>((ref) {
  final repository = ref.read(documentationRepositoryProvider);
  return SearchDocumentation(repository);
});

// Provider for the state notifier
final documentationStateNotifierProvider =
    StateNotifierProvider<
      DocumentationStateNotifier,
      AsyncValue<List<Documentation>>
    >((ref) {
      return DocumentationStateNotifier(
        getAllDocumentation: ref.read(getAllDocumentationProvider),
        getDocumentation: ref.read(getDocumentationProvider),
        searchDocumentation: ref.read(searchDocumentationProvider),
      );
    });
