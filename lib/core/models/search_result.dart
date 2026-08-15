class SearchResult {
  final List<dynamic> items;
  final String query;
  final String type; // 'user', 'post', 'job', 'professional', etc.
  final DateTime timestamp;

  SearchResult({
    required this.items,
    required this.query,
    required this.type,
    required this.timestamp,
  });

  factory SearchResult.fromJson(Map<String, dynamic> json) {
    return SearchResult(
      items: json['items'] ?? [],
      query: json['query'] ?? '',
      type: json['type'] ?? '',
      timestamp: DateTime.parse(json['timestamp']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'items': items,
      'query': query,
      'type': type,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}
