import 'dart:convert';
import 'dart:math';

import 'package:html/dom.dart' show Document, Element, Node;
import 'package:html/parser.dart' show parse;
import 'package:intl/intl.dart';
import 'package:shadertoy/shadertoy_api.dart';

/// Parses the number of results out of the Shadertoy browse
/// [page](https://www.shadertoy.com/browse)
final RegExp numResultsRegExp = RegExp(r'\s*Results\s\((-?\d*)\):\s*');

/// Parses the number of shaders out of the Shadertoy playlist page,
/// for example this week playlist [page](https://www.shadertoy.com/playlist/week)
final RegExp numShadersRegExp = RegExp(r'(-?\d*)\s(Shaders:)');

/// Parses the id's from the Shadertoy results, for example on
/// a search for "elevated" this regular expression parses the
/// id's from this [page](https://www.shadertoy.com/results?query=elevated)
final RegExp idArrayRegExp = RegExp(r"\[(\s*'(\w{6})'\s*,?)+\]");

/// Parses a Shadertoy id after sucessfully aplying the regex [idArrayRegExp]
final RegExp shaderIdRegExp = RegExp(r"'(\w{6})'");

/// Parses the shaders from the Shadertoy results, for example on
/// a search for "elevated" this regular expression parses the
/// shaders from this [page](https://www.shadertoy.com/results?query=elevated)
final RegExp shaderArrayRegExp = RegExp(r'var\sgShaders=(\[.*\])');

/// Used to remove the '\' on the userpicture field of the comment
/// Ex: '\/img\/profile.jpg' becomes '/img/profile.jpg'
final RegExp userPictureRegExp = RegExp(r'\\');

/// Parses the number of returned shader's from the html
/// returned in the Shadertoy browse [page](https://www.shadertoy.com/browse)
/// the results [page](https://www.shadertoy.com/results) or the playlist page
/// [week](https://www.shadertoy.com/playlist/week) for example
///
/// [doc]: The [Document] with the page DOM
///
/// Returns null in case of a unsucessful match
int? _parseResultsPager(Document doc) {
  var elements = doc.querySelectorAll(
      '#content>#controls>div>span,#content>#controls>div>div');
  if (elements.isNotEmpty) {
    for (var element in elements) {
      final numResultsMatch = numResultsRegExp.firstMatch(element.text);
      if (numResultsMatch != null) {
        final group = numResultsMatch.group(1);

        if (group != null) {
          return int.tryParse(group);
        }
      }
    }
  }

  return null;
}

/// Parses the number of returned shader's from the html
/// returned in the Shadertoy playlist [week](https://www.shadertoy.com/playlist/week)
/// playlist for example
///
/// [doc]: The [Document] with the page DOM
///
/// Returns null in case of a unsucessful match
int? _parseShadersPager(Document doc) {
  final elements = doc.querySelectorAll('#content>#controls>*>div');
  if (elements.isNotEmpty) {
    for (var element in elements) {
      final numShadersMatch = numShadersRegExp.firstMatch(element.text);
      if (numShadersMatch != null) {
        final group = numShadersMatch.group(1);

        if (group != null) {
          return int.tryParse(group);
        }
      }
    }
  }

  return null;
}

/// Validates [doc] and returns a [ResponseError] when invalid
///
/// * [doc]: The document
/// * [context]: The context of execution when the error ocurred
/// * [target]: The target entity of the API that triggered this error
///
/// Returns [ResponseError] for a invalid document or null otherwise.
ResponseError? _validate(Document doc, {String? context, String? target}) {
  var body = doc.querySelector('body');
  if (body == null || body.children.isEmpty) {
    return ResponseError.backendResponse(
        message: 'Unexpected HTML response body: ${body?.text}',
        context: context,
        target: target);
  }

  return null;
}

/// Parses the shaders from the returned html
///
/// * [doc]: The [Document] with the page DOM
/// * [maxShaders]: The maximum number of shaders
/// * [context]: The context of execution when the error ocurred
/// * [target]: The target entity of the API that triggered this error
///
/// It should be used to parse the html of
/// browse, results, user and playlist pages
FindShadersResponse parseShaders(Document doc, int maxShaders,
    {String? context, String? target}) {
  final error = _validate(doc, context: context, target: target);
  if (error != null) {
    return FindShadersResponse(error: error);
  }

  final count = _parseShadersPager(doc) ?? _parseResultsPager(doc);
  final results = <FindShaderResponse>[];

  if (count == null) {
    return FindShadersResponse(
        error: ResponseError.backendResponse(
            message: 'Unable to parse the number of results',
            context: context,
            target: target));
  } else if (count < 0) {
    return FindShadersResponse(
        error: ResponseError.backendResponse(
            message: 'Obtained an invalid number of results: $count',
            context: context,
            target: target));
  } else if (count == 0) {
    return FindShadersResponse(total: 0, shaders: const []);
  }

  var elements = doc.querySelectorAll('script');
  if (elements.isNotEmpty) {
    for (var element in elements) {
      final shaderArrayMatch = shaderArrayRegExp.firstMatch(element.text);

      if (shaderArrayMatch != null) {
        final shaderMatchGroup = shaderArrayMatch.group(1);

        if (shaderMatchGroup != null) {
          Iterable jsonList = json.decode(shaderMatchGroup);
          results.addAll(List<FindShaderResponse>.from(jsonList.map(
              (json) => FindShaderResponse(shader: Shader.fromJson(json)))));
        }
      }
    }

    if (results.isEmpty) {
      return FindShadersResponse(
          error: ResponseError.backendResponse(
              message: 'No script block matches with the pattern',
              context: context,
              target: target));
    }
  } else {
    return FindShadersResponse(
        error: ResponseError.backendResponse(
            message: 'Unable to get the script blocks from the document',
            context: context,
            target: target));
  }

  return FindShadersResponse(total: count, shaders: results);
}

/// Parses the list of shader id's returned
///
/// * [doc]: The [Document] with the page DOM
/// * [maxShaders]: The maximum number of shaders
/// * [context]: The context of execution when the error ocurred
/// * [target]: The target entity of the API that triggered this error
///
/// It should be used to parse the html of
/// browse, results, user and playlist pages
FindShaderIdsResponse parseShaderIds(Document doc, int maxShaders,
    {String? context, String? target}) {
  final error = _validate(doc, context: context, target: target);
  if (error != null) {
    return FindShaderIdsResponse(error: error);
  }

  final count = _parseShadersPager(doc) ?? _parseResultsPager(doc);
  final results = <String>[];

  if (count == null) {
    return FindShaderIdsResponse(
        error: ResponseError.backendResponse(
            message: 'Unable to parse the number of results'));
  } else if (count < 0) {
    return FindShaderIdsResponse(
        error: ResponseError.backendResponse(
            message: 'Obtained an invalid number of results: $count'));
  } else if (count == 0) {
    return FindShaderIdsResponse(count: 0, ids: const []);
  }

  var elements = doc.querySelectorAll('script');
  if (elements.isNotEmpty) {
    for (var element in elements) {
      final elementMatch = idArrayRegExp.firstMatch(element.text);

      if (elementMatch != null) {
        var shaderListText = elementMatch.group(0);
        if (shaderListText != null) {
          Iterable<Match> shaderIdMatches =
              shaderIdRegExp.allMatches(shaderListText);

          for (var i = 0; i < min(shaderIdMatches.length, maxShaders); i++) {
            final shaderIdMatch = shaderIdMatches.elementAt(i);
            final shaderIdMatchGroup = shaderIdMatch.group(1);
            if (shaderIdMatchGroup != null) {
              results.add(shaderIdMatchGroup);
            }
          }
        }
      }
    }

    if (results.isEmpty) {
      return FindShaderIdsResponse(
          error: ResponseError.backendResponse(
              message:
                  'No script block matches with "${idArrayRegExp.pattern}" pattern'));
    }
  } else {
    return FindShaderIdsResponse(
        error: ResponseError.backendResponse(
            message: 'Unable to get the script blocks from the document'));
  }

  return FindShaderIdsResponse(count: count, ids: results);
}

/// Helper methods which parses a [String] out of a [Node]
String? _userString(Node node) {
  return node.text?.substring(1).trim();
}

/// Helper methods which parses a [int] out of a [Node]
int? _userInt(Node node) {
  final userString = _userString(node);
  return userString != null ? int.tryParse(userString) : null;
}

/// Helper methods which parses a [DateTime] out of a [Node]
DateTime? _userDate(Node node) {
  final userString = _userString(node);
  return userString != null ? DateFormat('MMMM d, y').parse(userString) : null;
}

/// Parses a user out of the DOM representation
///
/// * [userId]: The user id
/// * [doc]: The [Document] with the page DOM
///
/// Return a [FindUserResponse] with a [User] or a [ResponseError]
FindUserResponse parseUser(String userId, Document doc) {
  var error = _validate(doc, context: contextUser, target: userId);
  if (error != null) {
    return FindUserResponse(error: error);
  }

  String? picture;
  var memberSince = DateTime(2013, 1, 11);
  var following = 0;
  var followers = 0;
  final aboutBuffer = StringBuffer();

  var elements = doc.querySelectorAll('#content>#divUser>table>tbody>tr>td');
  if (elements.length < 3) {
    return FindUserResponse(
        error: ResponseError.backendResponse(
            message:
                'Obtained an invalid number of user sections: ${elements.length}',
            context: contextUser,
            target: userId));
  }

  final pictureSection = elements[0];
  picture = pictureSection.querySelector('#userPicture')?.attributes['src'];
  final fieldsSection = elements[1];
  List<Node> nodes = fieldsSection.nodes;
  for (var i = 0; i < nodes.length; i++) {
    final text = nodes[i].text;

    if (text != null) {
      if ('Joined'.compareTo(text) == 0 && i < nodes.length - 1) {
        final userMemberSince = _userDate(nodes[i + 1]);
        if (userMemberSince != null) {
          memberSince = userMemberSince;
        }
      }

      if ('Following'.compareTo(text) == 0 && i < nodes.length - 1) {
        final userFollowing = _userInt(nodes[i + 1]);
        if (userFollowing != null) {
          following = userFollowing;
        }
      }

      if ('Followers'.compareTo(text) == 0 && i < nodes.length - 1) {
        final userFollowers = _userInt(nodes[i + 1]);
        if (userFollowers != null) {
          followers = userFollowers;
        }
      }
    }
  }

  final aboutSection = elements[2];
  nodes = aboutSection.nodes;
  for (var i = 0; i < nodes.length; i++) {
    final node = nodes[i];
    final text = node.text?.trim();

    if (node.nodeType == Node.ELEMENT_NODE) {
      var element = node as Element;
      var tag = element.localName;

      if (tag == 'br') {
        aboutBuffer.write('\n');
      } else if (tag == 'strong') {
        aboutBuffer.write('[b]$text[/b]');
      } else if (tag == 'em') {
        aboutBuffer.write('[i]$text[/i]');
      } else if (tag == 'a') {
        var href = element.attributes['href'];
        if (href != null) {
          if (href == text) {
            aboutBuffer.write('[url]$href[/url]');
          } else {
            aboutBuffer.write('[url=$href]$text[/url]');
          }
        }
      } else if (tag == 'pre') {
        aboutBuffer.write('[code]$text[/code]');
      } else if (tag == 'img') {
        final src = element.attributes['src'];
        if (src != null) {
          if (src.endsWith('emoticonHappy.png')) {
            aboutBuffer.write(':)');
          } else if (src.endsWith('emoticonSad.png')) {
            aboutBuffer.write(':(');
          } else if (src.endsWith('emoticonLaugh.png')) {
            aboutBuffer.write(':D');
          } else if (src.endsWith('emoticonLove.png')) {
            aboutBuffer.write(':love:');
          } else if (src.endsWith('emoticonOctopus.png')) {
            aboutBuffer.write(':octopus:');
          } else if (src.endsWith('emoticonOctopusBalloon.png')) {
            aboutBuffer.write(':octopusballoon:');
          }
        }
      }
    } else if (node.nodeType == Node.TEXT_NODE) {
      if (text == 'α') {
        aboutBuffer.write(':alpha:');
      } else if (text == 'β') {
        aboutBuffer.write(':beta:');
      } else if (text == '⏑') {
        aboutBuffer.write(':delta');
      } else if (text == 'ε') {
        aboutBuffer.write(':epsilon:');
      } else if (text == '∇') {
        aboutBuffer.write(':nabla:');
      } else if (text == '²') {
        aboutBuffer.write(':square:');
      } else if (text == '≐') {
        aboutBuffer.write(':limit:');
      } else {
        aboutBuffer.write(text);
      }
    }
  }

  return FindUserResponse(
      user: User(
          id: userId,
          picture: picture,
          memberSince: memberSince,
          following: following,
          followers: followers,
          about: aboutBuffer.toString()));
}

/// Parses the list of shader id's returned
///
/// * [playlistId]: The id of the playlist
/// * [doc]: The [Document] with the page DOM
///
/// It should be used to parse the html of
/// the playlist pages
FindPlaylistResponse parsePlaylist(String playlistId, Document doc) {
  var error = _validate(doc, context: contextPlaylist, target: playlistId);
  if (error != null) {
    return FindPlaylistResponse(error: error);
  }

  String? name;
  String? userId;
  String? description;

  description = doc.querySelector('#content>div>span')?.nodes.last.text?.trim();
  if (description == null) {
    return FindPlaylistResponse(
        error: ResponseError.backendResponse(
            message: 'Unable to get the playlist description from the document',
            context: contextPlaylist,
            target: playlistId));
  }

  name = doc.querySelector('#content>div>span>span')?.text;
  if (name == null) {
    return FindPlaylistResponse(
        error: ResponseError.backendResponse(
            message: 'Unable to get the playlist name from the document',
            context: contextPlaylist,
            target: playlistId));
  }

  userId = doc.querySelector('#content>div>span>a')?.text.trim();
  if (userId == null) {
    return FindPlaylistResponse(
        error: ResponseError.backendResponse(
            message: 'Unable to get the playlist user id from the document',
            context: contextPlaylist,
            target: playlistId));
  }

  return FindPlaylistResponse(
      playlist: Playlist(
          id: playlistId,
          userId: userId,
          name: name,
          description: description));
}

/// Parses an html document
///
/// [input]: The html string
///
/// Returns the parsed [Document]
Document parseDocument(String input) {
  return parse(input);
}
