import 'package:equatable/equatable.dart';

enum JobStatus { open, closed, cancelled, completed }

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
