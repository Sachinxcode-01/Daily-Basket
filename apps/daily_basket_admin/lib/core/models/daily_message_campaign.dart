/// Daily Message Campaign Model for Enterprise Admin
class DailyMessageCampaign {
  final String id;
  final String title;
  final String body;
  final String contentHash;
  final String audienceRole;
  final bool enabled;
  final DateTime createdAt;
  final int outboxCount;
  final bool isDefaultFallback;

  DailyMessageCampaign({
    required this.id,
    required this.title,
    required this.body,
    required this.contentHash,
    required this.audienceRole,
    required this.enabled,
    required this.createdAt,
    this.outboxCount = 0,
    this.isDefaultFallback = false,
  });

  factory DailyMessageCampaign.fromJson(Map<String, dynamic> json) {
    return DailyMessageCampaign(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      body: json['body']?.toString() ?? '',
      contentHash: json['contentHash']?.toString() ?? '',
      audienceRole: json['audienceRole']?.toString() ?? 'CUSTOMER',
      enabled: json['enabled'] == true,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString()) ?? DateTime.now()
          : DateTime.now(),
      outboxCount: json['_count'] != null && json['_count']['outboxRows'] != null
          ? (json['_count']['outboxRows'] as num).toInt()
          : (json['outboxCount'] as num?)?.toInt() ?? 0,
      isDefaultFallback: json['isDefaultFallback'] == true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'body': body,
      'contentHash': contentHash,
      'audienceRole': audienceRole,
      'enabled': enabled,
      'createdAt': createdAt.toIso8601String(),
      'outboxCount': outboxCount,
      'isDefaultFallback': isDefaultFallback,
    };
  }

  DailyMessageCampaign copyWith({
    String? id,
    String? title,
    String? body,
    String? contentHash,
    String? audienceRole,
    bool? enabled,
    DateTime? createdAt,
    int? outboxCount,
    bool? isDefaultFallback,
  }) {
    return DailyMessageCampaign(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      contentHash: contentHash ?? this.contentHash,
      audienceRole: audienceRole ?? this.audienceRole,
      enabled: enabled ?? this.enabled,
      createdAt: createdAt ?? this.createdAt,
      outboxCount: outboxCount ?? this.outboxCount,
      isDefaultFallback: isDefaultFallback ?? this.isDefaultFallback,
    );
  }
}
