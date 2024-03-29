import 'package:alfred_workflow/alfred_workflow.dart';
import 'package:shadertoy/shadertoy_api.dart';
import 'package:shadertoy_alfred/src/command/script_filter.dart';
import 'package:shadertoy_client/shadertoy_client.dart';

class PlaylistCommand extends ScriptFilterCommand {
  @override
  final name = 'playlist';
  @override
  final description = 'Browse playlist';

  /// Builds a [PlaylistCommand]
  PlaylistCommand() {
    argParser
      ..addOption('id',
          abbr: 'i',
          help: 'The playlist id',
          valueHelp: 'id',
          defaultsTo: 'week')
      ..addOption('from',
          help: 'Start from', valueHelp: 'from', defaultsTo: '0')
      ..addOption('num',
          help: 'Number of results', valueHelp: 'num', defaultsTo: '12');
  }

  String _getCacheKey(String playlistId, {int? from, int? num}) {
    final queryParameters = [];

    if (from != null) {
      queryParameters.add('from=$from');
    }

    if (num != null) {
      queryParameters.add('num=$num');
    }

    var sb = StringBuffer('playlist/$playlistId');
    for (var i = 0; i < queryParameters.length; i++) {
      sb.write(i == 0 ? '?' : '&');
      sb.write(queryParameters[i]);
    }

    return sb.toString();
  }

  @override
  Future<void> prepareWorflow(AlfredWorkflow workflow) async {
    final String? playlistIdArg = argResults?['id'];
    final String playlistId =
        playlistIdArg?.replaceAll(RegExp(r'\s+'), ' ').trim().toLowerCase() ??
            'week';
    final String? fromArg = argResults?['from'];
    final from = fromArg != null ? int.parse(fromArg) : null;
    final numArg = argResults?['num'];
    final num = numArg != null ? int.parse(numArg) : null;

    final client = newShadertoySiteClient();
    workflow.cacheKey = _getCacheKey(playlistId, from: from, num: num);

    logger.d('Setting cache key with: ${workflow.cacheKey}');
    return workflow.getItems().then((items) {
      logger.i('Cache key not present fetching shaders');
      if (items == null) {
        return client
            .findShadersByPlaylistId(playlistId, from: from, num: num)
            .then((results) {
          final shaders = results.shaders
                  ?.map((response) => response.shader?.info)
                  .whereType<Info>()
                  .toList() ??
              [];
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
                      icon: getShaderIcon(shaderPicture),
                      quickLookUrl: getShaderPicture(shaderPicture),
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
