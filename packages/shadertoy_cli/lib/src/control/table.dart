String tabulate(List<List<String>> models, List<String> header) {
  var retString = '';
  final cols = header.length;
  final colLength = List.filled(cols, 0, growable: true);
  if (models.any((model) => model.length != cols)) {
    throw Exception('Column\'s no. of each model does not match.');
  }

  //preparing colLength.
  for (var i = 0; i < cols; i++) {
    final _chunk = <String>[];
    _chunk.add(header[i]);
    for (var model in models) {
      _chunk.add(model[i]);
    }
    colLength[i] = ([for (var c in _chunk) c.length]..sort()).last;
  }
  // here we got prepared colLength.

  String fillSpace(int maxSpace, String text) {
    return text.padLeft(maxSpace) + ' | ';
  }

  void addRow(List<String> model, List<List<String>> row) {
    final l = <String>[];
    for (var i = 0; i < cols; i++) {
      final max = colLength[i];
      l.add(fillSpace(max, model[i]));
    }
    row.add(l);
  }

  final rowList = <List<String>>[];
  addRow(header, rowList);
  final topBar = List.generate(cols, (i) => '-' * colLength[i]);
  addRow(topBar, rowList);
  for (final model in models) {
    addRow(model, rowList);
  }
  for (final row in rowList) {
    var rowText = row.join();
    rowText = rowText.substring(0, rowText.length - 2);
    retString += rowText + '\n';
  }

  return retString;
}
