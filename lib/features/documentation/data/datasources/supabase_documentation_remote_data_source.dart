import 'package:dartz/dartz.dart';
import '../../../../core/failures/failure.dart';
import '../../../../core/services/supabase_service.dart';
import '../../domain/entities/documentation.dart';
import 'documentation_remote_data_source.dart';

class SupabaseDocumentationRemoteDataSource
    implements DocumentationRemoteDataSource {
  final SupabaseService _supabaseService = SupabaseService();

  @override
  Future<Either<Failure, Documentation>> getDocumentation(String id) async {
    try {
      final response = await _supabaseService.supabaseClient
          .from('documentation')
          .select()
          .eq('id', id)
          .single();

      final doc = Documentation(
        id: response['id'],
        title: response['title'],
        content: response['content'],
        category: response['category'],
        tags: List<String>.from(response['tags'] ?? []),
        createdAt: DateTime.parse(response['created_at']),
        updatedAt: DateTime.parse(response['updated_at']),
        isPublished: response['is_published'],
      );

      return Right(doc);
    } catch (e) {
      return Left(ServerFailure(message: 'Failed to get documentation: $e'));
    }
  }

  @override
  Future<Either<Failure, List<Documentation>>> getAllDocumentation({
    String? category,
    bool? isPublished,
  }) async {
    try {
      var query = _supabaseService.supabaseClient
          .from('documentation')
          .select();

      if (category != null) {
        query = query.eq('category', category);
      }
      if (isPublished != null) {
        query = query.eq('is_published', isPublished);
      }

      final response = await query;

      final List<Documentation> docs = (response as List)
          .map(
            (doc) => Documentation(
              id: doc['id'],
              title: doc['title'],
              content: doc['content'],
              category: doc['category'],
              tags: List<String>.from(doc['tags'] ?? []),
              createdAt: DateTime.parse(doc['created_at']),
              updatedAt: DateTime.parse(doc['updated_at']),
              isPublished: doc['is_published'],
            ),
          )
          .toList();

      return Right(docs);
    } catch (e) {
      return Left(
        ServerFailure(message: 'Failed to get all documentation: $e'),
      );
    }
  }

  @override
  Future<Either<Failure, List<Documentation>>> searchDocumentation(
    String query, {
    String? category,
  }) async {
    try {
      var searchQuery = _supabaseService.supabaseClient
          .from('documentation')
          .select()
          .ilike('title', '%$query%');

      if (category != null) {
        searchQuery = searchQuery.eq('category', category);
      }

      final response = await searchQuery;

      final List<Documentation> docs = (response as List)
          .map(
            (doc) => Documentation(
              id: doc['id'],
              title: doc['title'],
              content: doc['content'],
              category: doc['category'],
              tags: List<String>.from(doc['tags'] ?? []),
              createdAt: DateTime.parse(doc['created_at']),
              updatedAt: DateTime.parse(doc['updated_at']),
              isPublished: doc['is_published'],
            ),
          )
          .toList();

      return Right(docs);
    } catch (e) {
      return Left(ServerFailure(message: 'Failed to search documentation: $e'));
    }
  }

  @override
  Future<Either<Failure, Documentation>> createDocumentation(
    Documentation documentation,
  ) async {
    try {
      final response = await _supabaseService.supabaseClient
          .from('documentation')
          .insert({
            'id': documentation.id,
            'title': documentation.title,
            'content': documentation.content,
            'category': documentation.category,
            'tags': documentation.tags,
            'created_at': documentation.createdAt.toIso8601String(),
            'updated_at': documentation.updatedAt.toIso8601String(),
            'is_published': documentation.isPublished,
          })
          .select()
          .single();

      final doc = Documentation(
        id: response['id'],
        title: response['title'],
        content: response['content'],
        category: response['category'],
        tags: List<String>.from(response['tags'] ?? []),
        createdAt: DateTime.parse(response['created_at']),
        updatedAt: DateTime.parse(response['updated_at']),
        isPublished: response['is_published'],
      );

      return Right(doc);
    } catch (e) {
      return Left(ServerFailure(message: 'Failed to create documentation: $e'));
    }
  }

  @override
  Future<Either<Failure, Documentation>> updateDocumentation(
    Documentation documentation,
  ) async {
    try {
      final response = await _supabaseService.supabaseClient
          .from('documentation')
          .update({
            'title': documentation.title,
            'content': documentation.content,
            'category': documentation.category,
            'tags': documentation.tags,
            'updated_at': documentation.updatedAt.toIso8601String(),
            'is_published': documentation.isPublished,
          })
          .eq('id', documentation.id)
          .select()
          .single();

      final doc = Documentation(
        id: response['id'],
        title: response['title'],
        content: response['content'],
        category: response['category'],
        tags: List<String>.from(response['tags'] ?? []),
        createdAt: DateTime.parse(response['created_at']),
        updatedAt: DateTime.parse(response['updated_at']),
        isPublished: response['is_published'],
      );

      return Right(doc);
    } catch (e) {
      return Left(ServerFailure(message: 'Failed to update documentation: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteDocumentation(String id) async {
    try {
      await _supabaseService.supabaseClient
          .from('documentation')
          .delete()
          .eq('id', id);

      return Right(null);
    } catch (e) {
      return Left(ServerFailure(message: 'Failed to delete documentation: $e'));
    }
  }

  @override
  Future<Either<Failure, List<String>>> getDocumentationCategories() async {
    try {
      final response = await _supabaseService.supabaseClient
          .from('documentation')
          .select('category');

      final List<String> categories = (response as List)
          .map((doc) => doc['category'] as String)
          .toSet()
          .toList();

      return Right(categories);
    } catch (e) {
      return Left(ServerFailure(message: 'Failed to get categories: $e'));
    }
  }
}
