import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter/services.dart';

class CustomIntentModel {
  CustomIntentModel._(this._data);

  factory CustomIntentModel.fromJson(Map<String, dynamic> data) {
    return CustomIntentModel._(data);
  }

  static const _assetPath = 'assets/models/custom_intent_model.json';
  static Future<CustomIntentModel>? _cachedLoader;

  final Map<String, dynamic> _data;

  static Future<CustomIntentModel> load() {
    return _cachedLoader ??= _loadAsset();
  }

  static Future<CustomIntentModel> _loadAsset() async {
    final raw = await rootBundle.loadString(_assetPath);
    return CustomIntentModel.fromJson(
      jsonDecode(raw) as Map<String, dynamic>,
    );
  }

  String? predict(String text, {double threshold = 0.58}) {
    final classes = _data['classes'] as Map<String, dynamic>? ?? const {};
    final vocabSize = (_data['vocabSize'] as num?)?.toDouble() ?? 0.0;
    final alpha = (_data['alpha'] as num?)?.toDouble() ?? 1.0;
    final tokens = _tokenize(text);
    if (classes.isEmpty || tokens.isEmpty) return null;

    final scores = <String, double>{};

    for (final entry in classes.entries) {
      final classData = entry.value as Map<String, dynamic>;
      final prior = (classData['prior'] as num?)?.toDouble() ?? 0.0;
      final totalTokens = (classData['totalTokens'] as num?)?.toDouble() ?? 0.0;
      final tokenCounts = Map<String, dynamic>.from(
        classData['tokenCounts'] as Map? ?? const {},
      );

      var score = prior > 0 ? _safeLog(prior) : double.negativeInfinity;
      for (final token in tokens) {
        final count = (tokenCounts[token] as num?)?.toDouble() ?? 0.0;
        final probability = (count + alpha) / (totalTokens + alpha * vocabSize);
        score += _safeLog(probability);
      }

      scores[entry.key] = score;
    }

    if (scores.isEmpty) return null;
    final bestEntry = scores.entries.reduce(
      (a, b) => a.value >= b.value ? a : b,
    );
    final confidence = _softmaxProbability(scores, bestEntry.key);
    return confidence >= threshold ? bestEntry.key : null;
  }

  static List<String> _tokenize(String text) {
    final normalized = text.toLowerCase().replaceAll(
          RegExp(r'[^a-z0-9.\s]+'),
          ' ',
        );
    return RegExp(r'[a-z0-9.]+')
        .allMatches(normalized)
        .map((match) => match.group(0)!)
        .where((token) => token.isNotEmpty)
        .map((token) => RegExp(r'^\d+$').hasMatch(token) ? 'num_$token' : token)
        .toList(growable: false);
  }

  static double _safeLog(double value) {
    return value <= 0 ? double.negativeInfinity : math.log(value);
  }

  static double _softmaxProbability(
    Map<String, double> scores,
    String selectedLabel,
  ) {
    final finiteScores =
        scores.values.where((value) => value.isFinite).toList();
    if (finiteScores.isEmpty) return 0;
    final maxScore = finiteScores.reduce(math.max);
    var denominator = 0.0;
    var numerator = 0.0;
    for (final entry in scores.entries) {
      if (!entry.value.isFinite) continue;
      final expValue = math.exp(entry.value - maxScore);
      denominator += expValue;
      if (entry.key == selectedLabel) {
        numerator = expValue;
      }
    }
    if (denominator == 0) return 0;
    return (numerator / denominator).clamp(0.0, 1.0);
  }
}
