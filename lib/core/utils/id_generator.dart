String generateId(String prefix) =>
    '$prefix-${DateTime.now().microsecondsSinceEpoch}';
