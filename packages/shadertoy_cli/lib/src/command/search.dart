import 'package:enum_to_string/enum_to_string.dart';
import 'package:shadertoy/shadertoy_api.dart';

import 'multi.dart';

class SearchCommand extends MultiCommand {
  @override
  final name = 'search';
  @override
  final description = 'Search shaders';

  SearchCommand() {
    argParser
      ..addOption('term', abbr: 't', help: 'The search term', valueHelp: 'term')
      ..addMultiOption('tag',
          abbr: 'i', help: 'Search filter', valueHelp: 'filter')
      ..addOption('sort',
          abbr: 's',
          help: 'Search sort',
          valueHelp: 'sort',
          allowed: [
            'name',
            'love',
            'popular',
            'newest',
            'hot'
          ],
          allowedHelp: {
            'name': 'Name',
            'love': 'Love',
            'popular': 'Popularity',
            'newest': 'Newness',
            'hot': 'Hotness'
          })
      ..addOption('from',
          help: 'Start from', valueHelp: 'from', defaultsTo: '0')
      ..addOption('num',
          help: 'Number of results', valueHelp: 'num', defaultsTo: '12');
  }

  @override
  void call(ShadertoyExtendedClient client) async {
    final String? term = argResults?['term'];
    final List<String>? filter = argResults?['filter'];
    final String? sort = argResults?['sort'];

    final String? fromArg = argResults?['from'];
    final from = fromArg != null ? int.parse(fromArg) : null;
    final numArg = argResults?['num'];
    final num = numArg != null ? int.parse(numArg) : null;

    final qr = await client.findShaderIds(
        term: term,
        filters: filter != null ? filter.toSet() : null,
        sort: sort != null ? EnumToString.fromString(Sort.values, sort) : null,
        from: from,
        num: num);

    if (qr.total > 0) {
      final ids = qr.ids;
      if (ids != null) {
        logJson(ids);
      }
    }
  }
}
