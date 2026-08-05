import 'package:flutter/material.dart';

/// In-memory search history provider.
/// Persists up to [maxItems] queries in reverse-chronological order.
/// Deduplicates: re-searching an existing term moves it to the top.
class SearchHistoryProvider extends ChangeNotifier {
  final int maxItems;

  SearchHistoryProvider({this.maxItems = 10});

  final List<String> _history = [];

  List<String> get history => List.unmodifiable(_history);

  bool get isEmpty => _history.isEmpty;

  void addQuery(String query) {
    final trimmed = query.trim();
    if (trimmed.isEmpty) { return; }
    _history.remove(trimmed);
    _history.insert(0, trimmed);
    if (_history.length > maxItems) {
      _history.removeLast();
    }
    notifyListeners();
  }

  void removeQuery(String query) {
    _history.remove(query);
    notifyListeners();
  }

  void clearAll() {
    _history.clear();
    notifyListeners();
  }
}
