import 'dart:convert';

class SyncOperation {
  const SyncOperation({
    required this.id,
    required this.collection,
    required this.documentId,
    required this.type,
    required this.payload,
    required this.createdAt,
    this.retryCount = 0,
  });

  final String id;
  final String collection;
  final String documentId;
  final SyncOperationType type;
  final Map<String, Object?> payload;
  final DateTime createdAt;
  final int retryCount;

  Map<String, Object?> toJson() => {
        'id': id,
        'collection': collection,
        'documentId': documentId,
        'type': type.name,
        'payload': jsonEncode(payload),
        'createdAt': createdAt.toIso8601String(),
        'retryCount': retryCount,
      };

  factory SyncOperation.fromJson(Map<String, Object?> json) {
    return SyncOperation(
      id: json['id']! as String,
      collection: json['collection']! as String,
      documentId: json['documentId']! as String,
      type: SyncOperationType.values.byName(json['type']! as String),
      payload: jsonDecode(json['payload']! as String) as Map<String, Object?>,
      createdAt: DateTime.parse(json['createdAt']! as String),
      retryCount: json['retryCount']! as int,
    );
  }
}

enum SyncOperationType { create, update, delete }
