import 'package:alfred_workflow/alfred_workflow.dart';
import 'package:shadertoy/shadertoy_api.dart';
import 'package:shadertoy_alfred/src/command/script_filter.dart';
import 'package:shadertoy_client/shadertoy_client.dart';

class SearchCommand extends ScriptFilterCommand {
  @override
  final name = 'search';
  @override
  final description = 'Search shaders';

  /// Builds a [SearchCommand]
  SearchCommand() {
    argParser
      ..addOption('term', abbr: 't', help: 'The search term', valueHelp: 'term')
      ..addMultiOption('filter',
          abbr: 'f', help: 'Search filter', valueHelp: 'filter')
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

  String _getCacheKey(
      {String? term, Set<String>? filters, Sort? sort, int? from, int? num}) {
    final queryParameters = [];
    if (term != null && term.isNotEmpty) {
      queryParameters.add('query=$term');
    }

    if (filters != null) {
      for (var filter in filters) {
        queryParameters.add('filter=$filter');
      }
    }

    if (sort != null) {
      queryParameters.add('sort=${sort.name}');
    }

    if (from != null) {
      queryParameters.add('from=$from');
    }

    if (num != null) {
      queryParameters.add('num=$num');
    }

    var sb = StringBuffer('search');
    for (var i = 0; i < queryParameters.length; i++) {
      sb.write(i == 0 ? '?' : '&');
      sb.write(queryParameters[i]);
    }

    return sb.toString();
  }

  @override
  Future<void> prepareWorflow(AlfredWorkflow workflow) async {
    final String? termArg = argResults?['term'];
    final String? term =
        termArg?.replaceAll(RegExp(r'\s+'), ' ').trim().toLowerCase();
    final List<String>? filtersArg = argResults?['filter'];
    final Set<String>? filters = filtersArg?.toSet();
    final String? sortArg = argResults?['sort'];
    final sort = sortArg != null ? Sort.values.byName(sortArg) : null;

    final String? fromArg = argResults?['from'];
    final from = fromArg != null ? int.parse(fromArg) : null;
    final numArg = argResults?['num'];
    final num = numArg != null ? int.parse(numArg) : null;

    final client = newShadertoySiteClient();
    workflow.cacheKey = _getCacheKey(
        term: term, filters: filters, sort: sort, from: from, num: num);

    logger.d('Setting cache key with:${workflow.cacheKey}');
    return workflow.getItems().then((items) {
      if (items == null) {
        logger.i('Cache key not present fetching shaders');
        return client
            .findShaders(
                term: term, filters: filters, sort: sort, from: from, num: num)
            .then((results) {
          final shaders = results.shaders
                  ?.map((response) => response.shader?.info)
                  .whereType<Info>()
                  .toList() ??
              [];
          logger.d(
              'Obtained ${shaders.length} shader(s): ${shaders.map((info) => info.id).join(',')}');
          return Future.wait(shaders.map((shader) {
            return downloadShaderPicture(client, shader.id)
                .then((shaderPicture) => AlfredItem(
                      uid: shader.id,
                      title: shader.name,
                      subtitle: shader.description,
                      arg: client.context.getShaderViewUrl(shader.id),
                      text: AlfredItemText(
                        copy: shader.id,
                        largeType: shader.id,
                      ),
                      icon: AlfredItemIcon(
                        path: shaderPicture != null
                            ? shaderPicture.absolute.path
                            : 'question.png',
                      ),
                      quickLookUrl: shaderPicture != null
                          ? shaderPicture.absolute.path
                          : 'question.png',
                      valid: true,
                    ));
          })).then((items) {
            workflow.addItems(items);

            return Future.value();
          });
        });
      }
      logger.i('Using cached response');

      return Future.value();
    });
  }
}
