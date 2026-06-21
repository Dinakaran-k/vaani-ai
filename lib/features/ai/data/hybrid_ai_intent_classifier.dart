import '../domain/ai_client.dart';
import '../domain/assistant_intent.dart';
import 'custom_intent_model.dart';

class HybridAiIntentClassifier {
  const HybridAiIntentClassifier(this._client, [this._customModel]);

  final AiClient _client;
  final Future<CustomIntentModel>? _customModel;

  Future<AssistantIntent> classify({
    required String utterance,
    required String locale,
    Map<String, Object?> businessContext = const {},
  }) async {
    final normalized = _normalize(utterance);
    final localIntent = _fastPath(normalized);
    if (localIntent != null) return localIntent;

    final customModel = _customModel;
    if (customModel != null) {
      try {
        final customIntent = (await customModel).predict(normalized);
        if (customIntent != null) {
          final customClassified = _fromCustomModelIntent(
            customIntent,
            utterance,
          );
          if (customClassified != null) return customClassified;
        }
      } catch (_) {
        // If the custom model is unavailable, fall back to Melange.
      }
    }

    final response = await _client.classifyIntent(
      utterance: utterance,
      locale: locale,
      businessContext: businessContext,
    );
    return _fromToolCall(response, utterance);
  }

  AssistantIntent? _fastPath(String text) {
    final inventoryIntent = _parseInventoryAddition(text);
    if (inventoryIntent != null) return inventoryIntent;

    if (_containsAny(text, const [
      'low stock',
      'running low',
      'stock kam',
      'kam stock',
      'low inventory',
    ])) {
      return const LowStockIntent();
    }
    if (_containsAny(text, const [
      'sales today',
      'today sales',
      'aaj ki sales',
      'aaj ka sale',
      'today sale',
    ])) {
      return const SalesTodayIntent();
    }
    if (_containsAny(text, const [
      'pending payment',
      'pending payments',
      'unpaid invoices',
      'unpaid payment',
      'udhaar',
      'dues pending',
      'payment due',
    ])) {
      return const PendingPaymentsIntent();
    }
    return null;
  }

  AssistantIntent? _parseInventoryAddition(String text) {
    for (final pattern in _inventoryPatterns) {
      final match = pattern.firstMatch(text);
      if (match == null) continue;

      final quantity = double.tryParse(match.group(1) ?? '');
      final rawUnit = match.group(2) ?? '';
      final rawProduct = match.group(3) ?? '';
      final unit = _normalizeUnit(rawUnit);
      final productName = _normalizeProductName(rawProduct);
      if (quantity == null || unit == null || productName.isEmpty) continue;

      return AddInventoryIntent(
        productName: productName,
        quantity: quantity,
        unit: unit,
      );
    }

    return null;
  }

  AssistantIntent _fromToolCall(
    Map<String, Object?> json,
    String originalText,
  ) {
    switch (json['intent']) {
      case 'add_inventory':
        final productName = json['productName'];
        final quantity = json['quantity'];
        final unit = json['unit'];
        if (productName is! String ||
            productName.isEmpty ||
            quantity is! num ||
            unit is! String ||
            unit.isEmpty) {
          return UnknownIntent(originalText);
        }
        return AddInventoryIntent(
          productName: productName,
          quantity: quantity.toDouble(),
          unit: unit,
        );
      case 'sales_today':
        return const SalesTodayIntent();
      case 'low_stock':
        return const LowStockIntent();
      case 'pending_payments':
        return const PendingPaymentsIntent();
      default:
        return UnknownIntent(originalText);
    }
  }

  AssistantIntent? _fromCustomModelIntent(
    String intent,
    String originalText,
  ) {
    switch (intent) {
      case 'add_inventory':
        return _parseInventoryAddition(_normalize(originalText)) ??
            UnknownIntent(originalText);
      case 'sales_today':
        return const SalesTodayIntent();
      case 'low_stock':
        return const LowStockIntent();
      case 'pending_payments':
        return const PendingPaymentsIntent();
      default:
        return null;
    }
  }
}

String _normalize(String text) {
  return text
      .trim()
      .toLowerCase()
      .replaceAll(RegExp(r'[^a-z0-9.\s-]'), ' ')
      .replaceAll(RegExp(r'\s+'), ' ');
}

bool _containsAny(String text, List<String> phrases) {
  return phrases.any(text.contains);
}

String? _normalizeUnit(String rawUnit) {
  return switch (rawUnit) {
    'kg' || 'kgs' || 'kilo' || 'kilos' => 'kg',
    'g' || 'gram' || 'grams' => 'g',
    'l' || 'ltr' || 'liter' || 'liters' || 'litre' || 'litres' => 'l',
    'bag' || 'bags' => 'bags',
    'box' || 'boxes' => 'boxes',
    'packet' || 'packets' || 'pack' || 'packs' => 'packets',
    'bottle' || 'bottles' => 'bottles',
    'unit' || 'units' || 'piece' || 'pieces' || 'pc' || 'pcs' => 'units',
    _ => null,
  };
}

String _normalizeProductName(String rawProduct) {
  return rawProduct
      .trim()
      .replaceAll(RegExp(r'\b(of|ko|mein|me|ka|ki)\b'), ' ')
      .replaceAll(RegExp(r'\s+'), ' ');
}

final _inventoryPatterns = <RegExp>[
  RegExp(
    r'(?:add|restock|increase|put)\s+(\d+(?:\.\d+)?)\s+([a-z]+)\s+(?:of\s+)?(.+)',
  ),
  RegExp(
    r'(\d+(?:\.\d+)?)\s+([a-z]+)\s+(.+?)\s+(?:add|restock|dalo|daalo|jodo|badhao|karo)$',
  ),
];
