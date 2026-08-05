import 'package:equatable/equatable.dart';

/// Job lifecycle states — must stay in sync with `public.job_status`
/// PostgreSQL enum (see supabase/migrations/20260804000100_enums.sql).
enum JobStatus {
  draft,
  open,
  filled,
  completed,
  cancelled,
  closed;

  /// Convert a Postgres enum label (e.g. `'open'`) into a [JobStatus].
  /// Falls back to [JobStatus.open] if the label is unknown.
  static JobStatus fromString(String? value) {
    if (value == null) return JobStatus.open;
    for (final s in JobStatus.values) {
      if (s.name == value) return s;
    }
    return JobStatus.open;
  }
}

class Job extends Equatable {
  final String id;
  final String title;
  final String companyName;
  final String? companyLogoUrl;
  final String description;
  final String location;
  final String salary;
  final String type; // e.g. Full-time, Remote
  final String postedById;
  final JobStatus status;
  final DateTime createdAt;

  const Job({
    required this.id,
    required this.title,
    required this.companyName,
    this.companyLogoUrl,
    required this.description,
    required this.location,
    required this.salary,
    required this.type,
    required this.postedById,
    this.status = JobStatus.open,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
    id, title, companyName, companyLogoUrl, description, location,
    salary, type, postedById, status, createdAt
  ];
}
