    String generateJsonKey(String header) {
    final parts = header.split('|');
    final kolom = parts[0].split('/').first.trim();
    final subkolom = parts.length == 2 ? parts[1].split('/').first.trim() : '';

    String clean(String input) =>
        input.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), '');

    return subkolom.isNotEmpty
        ? '${clean(kolom)}_${clean(subkolom)}'
        : clean(kolom);
  }