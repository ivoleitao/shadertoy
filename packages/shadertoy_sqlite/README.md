# shadertoy_sqlite
A [shadertoy](https://github.com/ivoleitao/shadertoy) storage implementation on sqlite using the [drift](https://pub.dev/packages/drift) package

[![Pub Package](https://img.shields.io/pub/v/shadertoy_sqlite.svg?style=flat-square)](https://pub.dartlang.org/packages/shadertoy_sqlite)
[![Coverage Status](https://codecov.io/gh/ivoleitao/shadertoy/graph/badge.svg?flag=shadertoy_sqlite)](https://codecov.io/gh/ivoleitao/shadertoy)
[![Package Documentation](https://img.shields.io/badge/doc-shadertoy_sqlite-blue.svg)](https://www.dartdocs.org/documentation/shadertoy_sqlite/latest)
[![GitHub License](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

## Overview

This package implements the storage APIs defined in the [shadertoy](https://pub.dev/packages/shadertoy) package on sqlite through the [drift](https://pub.dev/packages/drift) package

## Getting Started

Add `shadertoy_sqlite` to your `pubspec.yaml` replacing x.x.x with the latest version available:

```dart
dependencies:
    shadertoy_sqlite: ^x.x.x
```

Run the following command to install dependencies:

```dart
dart pub get
```

Finally, to start developing import the library:

```dart
import 'package:shadertoy_sqlite/shadertoy_sqlite.dart';
```

## Usage

To create a new store the `ShadertoyStore` implementation needs to be instanciated. The example bellow creates a new `drift` store with an in memory implementation (mostly used for test purposes)

```dart
final store = newShadertoySqliteStore(VmDatabase.memory(logStatements: logStatements));
```

A more real example would entail de creation of a database backed by a file like so:

```dart
final store = newShadertoyDriftStore(VmDatabase(File('shadertoy.db')))
```

This allows the execution of persistent operations, for example storing the definition of a shader with:

```dart
final shader = Shader(...);
final ssr = await store.saveShader(shader);
if (ssr.ok) {
    print('Shader stored');
} else {
    print('Error: ${response.error.message}')
}
```

A more complete example bellow:

```dart
import 'package:drift/ffi.dart';
import 'package:drift/drift.dart';
import 'package:shadertoy/shadertoy_api.dart';
import 'package:shadertoy_sqlite/shadertoy_sqlite.dart';

// In-memory executor
QueryExecutor memoryExecutor({bool logStatements = false}) {
  return VmDatabase.memory(logStatements: logStatements);
}

// File executor
QueryExecutor diskExecutor({bool logStatements = false}) {
  return VmDatabase(File('shadertoy.db'), logStatements: logStatements);
}

void main(List<String> arguments) async {
  // Creates a new store with an in-memory executor
  final store = newShadertoySqliteStore(memoryExecutor());

  // Creates user 1
  final userId1 = 'UzZ0Z1';
  final user1 =
      User(id: userId1, about: 'About user 1', memberSince: DateTime.now());
  await store.saveUser(user1);

  // Retrieves user 1
  await store.findUserById(userId1);

  // Creates user 2
  final userId2 = 'UzZ0Z2';
  final user2 =
      User(id: userId2, about: 'About user 2', memberSince: DateTime.now());
  await store.saveUser(user2);

  // Retrieves user 2
  await store.findUserById(userId2);

  // Creates a shader with two render passes
  final shaderId1 = 'SzZ0Zz';
  final shader1 = Shader(
      version: '0.1',
      info: Info(
          id: shaderId1,
          date: DateTime.fromMillisecondsSinceEpoch(1360495251),
          views: 131083,
          name: 'Example',
          userId: userId1,
          description: 'A shader example',
          likes: 570,
          privacy: ShaderPrivacy.publicApi,
          flags: 32,
          tags: [
            'procedural',
            '3d',
            'raymarching',
            'distancefield',
            'terrain',
            'motionblur',
            'vr'
          ],
          hasLiked: false),
      renderPasses: [
        RenderPass(
            name: 'Image',
            type: RenderPassType.image,
            description: '',
            code: 'code 0',
            inputs: [
              Input(
                  id: '257',
                  src: '/media/previz/buffer00.png',
                  type: InputType.texture,
                  channel: 0,
                  sampler: Sampler(
                      filter: FilterType.linear,
                      wrap: WrapType.clamp,
                      vflip: true,
                      srgb: true,
                      internal: 'byte'),
                  published: 1)
            ],
            outputs: [
              Output(id: '37', channel: 0)
            ]),
        RenderPass(
            name: 'Buffer A',
            type: RenderPassType.buffer,
            description: '',
            code: 'code 1',
            inputs: [
              Input(
                  id: '17',
                  src: '/media/a/zs098rere0323u85534ukj4.png',
                  type: InputType.texture,
                  channel: 0,
                  sampler: Sampler(
                      filter: FilterType.mipmap,
                      wrap: WrapType.repeat,
                      vflip: false,
                      srgb: false,
                      internal: 'byte'),
                  published: 1)
            ],
            outputs: [
              Output(id: '257', channel: 0)
            ])
      ]);

  // Saves the shader
  await store.saveShader(shader1);

  // Retrieves the saved shader
  await store.findShaderById(shaderId1);

  // Creates the first comment
  final comment1 = Comment(
      id: 'CaA0A1',
      shaderId: shaderId1,
      userId: userId2,
      picture: '/img/profile.jpg',
      date: DateTime.now(),
      text: 'Great shader!');

  // Creates the second comment
  final comment2 = Comment(
      id: 'CaA0A2',
      shaderId: shaderId1,
      userId: userId1,
      picture: '/img/profile.jpg',
      date: DateTime.now(),
      text: 'Thanks');

  // Save shader comments
  await store.saveShaderComments([comment1, comment2]);

  // Retrieves the shader comments
  await store.findCommentsByShaderId(shaderId1);

  // Creates a playlist
  final playlistId1 = 'week';
  final playlist1 = Playlist(
      id: playlistId1,
      userId: 'shadertoy',
      name: 'Shaders of the Week',
      description: 'Playlist with every single shader of the week ever.');

  // Save the playlist
  await store.savePlaylist(playlist1);

  // Retrieves the playlist
  await store.findPlaylistById(playlistId1);

  // Stores the shader on the playlist
  await store.savePlaylistShaders(playlistId1, [shaderId1]);

  // Retrieves the playlist shader ids
  await store.findShaderIdsByPlaylistId(playlistId1);
}
```

# APIs

## Storage API

| Operation | Description |
| --------- | ----------- |
| `findUserById` | Finds a Shadertoy user by id |
| `findAllUserIds` | Returns all the user ids stored |
| `findAllUsers` | Returns all the users stored |
| `saveUser` | Saves a user |
| `saveUsers` | Saves a list of users |
| `deleteUserById` | Deletes a user by id |
| `findShaderById` | Finds a shader by id |
| `findAllShaderIds` | Fetches all the shader ids |
| `findShaderIds` | Queries shader ids by term, tags and sort them by *name*, *likes*, *views*, *newness* and by *hotness* (proportional to popularity and inversely proportional to lifetime). All the query results are paginated through the `from` and `num` parameters |
| `findShadersByIdSet` | Finds shaders by a set of ids|
| `findShaders` | Queries shaders by term, tags and sort them by *name*, *likes*, *views*, *newness* and by *hotness* (proportional to popularity and inversely proportional to lifetime). All the query results are paginated through the `from` and `num` parameters |
| `findAllShaders` | Returns all the shaders stored |
| `saveShader` | Saves a shader |
| `saveShaders` | Saves a list of shaders |
| `deleteShaderById` | Deletes a shader by id |
| `findCommentById` | Fetches a comment by id |
| `findAllCommentIds` | Fetches all the comment ids |
| `findCommentsByShaderId` | Fetches the comments of a shader id |
| `findAllComments` | Returns all the comments stored |
| `saveShaderComments` | Saves the comments of a shader |
| `deleteCommentById` | Deletes a comment by id |
| `findShadersByUserId` | Queries shaders by user id, tags and allows sorting by *name*, *likes*, *views*, *newness* and *hotness* (proportional to popularity and inversely proportional to lifetime). All the query results are paginated and the pages fetched with the `from` and `num` parameters |
|`findShaderIdsByUserId`|Queries shader ids by user id, tags and allows sorting by *name*, *likes*, *views*, *newness* and *hotness* (proportional to popularity and inversely proportional to lifetime). All the query results are paginated and the pages fetched with the `from` and `num` parameters |
| `findAllShaderIdsByUserId` | Fetches all the shader ids by user id |
| `findPlaylistById` | Fetches a playlist by id |
| `findAllPlaylistIds` | Fetches all the playlist ids |
| `findAllPlaylists` | Returns all the playlists stored |
| `findShadersByPlaylistId` | Fetches the shaders of a playlist id. All the query results are paginated through the `from` and `num` parameters |
| `findShaderIdsByPlaylistId` | Fetches the shader ids of a playlist id. All the query results are paginated through the `from` and `num` parameters |
| `findAllShaderIdsByPlaylistId` | Fetches all the shader ids of playlist id |
| `savePlaylist` | Saves a playlist |
| `savePlaylistShaders` | Saves the playlist shader ids |
| `deletePlaylistById` | Deletes a playlist by id |

## Model

![Shadertoy Model](https://github.com/ivoleitao/shadertoy/blob/develop/packages/shadertoy_sqlite/model.svg?raw=true)

## Contributing

This is a unofficial [Shadertoy](https://www.shadertoy.com) storage API. It is developed by best effort, in the motto of "Scratch your own itch!", meaning APIs that are meaningful for the author use cases.

If you would like to contribute with other parts of the API, feel free to make a Github [pull request](https://github.com/ivoleitao/shadertoy/pulls) as I'm always looking for contributions for:
* Tests
* Documentation
* New APIs

See [CONTRIBUTING.md](https://github.com/ivoleitao/shadertoy/blob/develop/CONTRIBUTING.md) for ways to get started.

## Features and Bugs

Please file feature requests and bugs at the [issue tracker][tracker].

[tracker]: https://github.com/ivoleitao/shadertoy/issues/new

## License

This project is licensed under the MIT License - see the [LICENSE](https://github.com/ivoleitao/shadertoy/blob/develop/packages/shadertoy_sqlite/LICENSE) file for details