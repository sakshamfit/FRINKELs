import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/entities/job.dart';

abstract class JobRemoteDataSource {
  Future<List<Job>> getJobs({int limit = 20, int offset = 0});
  Future<Job> postJob(Job job);
  Future<void> applyForJob(String jobId);
}

class SupabaseJobRemoteDataSource implements JobRemoteDataSource {
  final SupabaseClient _supabase;

  SupabaseJobRemoteDataSource(this._supabase);

  @override
  Future<List<Job>> getJobs({int limit = 20, int offset = 0}) async {
    final response = await _supabase
        .from('jobs')
        .select('*')
        .order('created_at', ascending: false)
        .range(offset, offset + limit - 1);

    final List<dynamic> data = response as List<dynamic>;
    return data
        .map(
          (json) => Job(
            id: json['id'],
            title: json['title'],
            companyName: json['company_name'],
            companyLogoUrl: json['company_logo_url'],
            description: json['description'],
            location: json['location'],
            salary: json['salary'],
            type: json['type'],
            postedById: json['posted_by_id'],
            status: JobStatus.fromString(json['status']),
            createdAt: DateTime.parse(json['created_at']),
          ),
        )
        .toList();
  }

  @override
  Future<Job> postJob(Job job) async {
    final response = await _supabase
        .from('jobs')
        .insert({
          'title': job.title,
          'company_name': job.companyName,
          'company_logo_url': job.companyLogoUrl,
          'description': job.description,
          'location': job.location,
          'salary': job.salary,
          'type': job.type,
          'posted_by_id': job.postedById,
          'status': job.status.name,
        })
        .select()
        .single();

    return Job(
      id: response['id'],
      title: response['title'],
      companyName: response['company_name'],
      companyLogoUrl: response['company_logo_url'],
      description: response['description'],
      location: response['location'],
      salary: response['salary'],
      type: response['type'],
      postedById: response['posted_by_id'],
      status: JobStatus.fromString(response['status']),
      createdAt: DateTime.parse(response['created_at']),
    );
  }

  @override
  Future<void> applyForJob(String jobId) async {
    final userId = _supabase.auth.currentUser!.id;
    await _supabase.from('job_applications').insert({
      'job_id': jobId,
      'user_id': userId,
    });
  }
}
