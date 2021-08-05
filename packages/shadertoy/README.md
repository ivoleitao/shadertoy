# shadertoy

[![Build Status](https://github.com/ivoleitao/shadertoy/actions/workflows/build.yml/badge.svg)](https://github.com/ivoleitao/shadertoy/actions/workflows/build.yml)
[![Pub Package](https://img.shields.io/pub/v/shadertoy.svg?style=flat-square)](https://pub.dartlang.org/packages/shadertoy)
[![Coverage Status](https://codecov.io/gh/ivoleitao/shadertoy/graph/badge.svg?flag=shadertoy)](https://codecov.io/gh/ivoleitao/shadertoy)
[![Package Documentation](https://img.shields.io/badge/doc-shadertoy-blue.svg)](https://www.dartdocs.org/documentation/shadertoy/latest)
[![Github Stars](https://img.shields.io/github/stars/ivoleitao/shadertoy.svg)](https://github.com/ivoleitao/shadertoy)
[![GitHub License](https://img.shields.io/badge/license-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

## Overview

The `shadertoy` library provides the support to interact with the [Shadertoy](https://www.shadertoy.com) site and REST API's defining the data model and contracts to query and store the shaders, comments, users, playlists and website media.

## Features

* :pushpin: **REST API** - Supports all the Shadertoy REST APIs (as defined [here](https://www.shadertoy.com/howto#q2))
* :globe_with_meridians: **Site API** - Supports scrapping of data directly from the [Shadertoy](https://www.shadertoy.com) site allowing the retrieval of users query comments, users, playlists and website media. 
* :link: **Hybrid API** - Respects `public+api` privacy settings of the shaders while providing support for additional operations, namely the retrieval of shader comments, user, playlists and website media
* :loop: **Extensible** - Plug novel storage and client implementations reusing the APIs and entities defined on the `shadertoy` package

## Client Implementations

The following client implementations are available

|Package|Pub|Description|
|-------|---|-----------|
| [shadertoy_client](https://github.com/ivoleitao/shadertoy/tree/develop/packages/shadertoy_client) | [![Pub](https://img.shields.io/pub/v/shadertoy_client.svg?style=flat-square)](https://pub.dartlang.org/packages/shadertoy_client) | HTTP client to the Shadertoy REST and Site API using the [dio](https://pub.dev/packages/dio) package|


## Storage Implementations

The following storage implementations are available

|Package|Pub|Description|
|-------|---|-----------|
| [shadertoy_sqlite](https://github.com/ivoleitao/shadertoy/tree/develop/packages/shadertoy_sqlite) | [![Pub](https://img.shields.io/pub/v/shadertoy_sqlite.svg?style=flat-square)](https://pub.dartlang.org/packages/shadertoy_sqlite) | A Sqlite storage implementation using the [moor](https://pub.dev/packages/moor) package|

## Tools

The following tools relly on the use of the client and / or storage APIs

|Package|Pub|Description|
|-------|---|-----------|
| [shadertoy_cli](https://github.com/ivoleitao/shadertoy/tree/develop/packages/shadertoy_cli) | [![Pub](https://img.shields.io/pub/v/shadertoy_cli.svg?style=flat-square)](https://pub.dartlang.org/packages/shadertoy_cli) | A command line tool to interact with storage and client implementations of the `Shadertoy` API's|

## Getting Started


Select one of the client or storage implementations (or both) and add the package to your `pubspec.yaml` replacing x.x.x with the latest version of the implementation. The example below uses the `shadertoy_client` package which implements the `shadertoy` REST and site APIs:


```dart
dependencies:
    shadertoy_client: ^x.x.x
```

Run the following command to install dependencies:

```dart
dart pub get
```

Finally, to start developing import the library:

```dart
import 'package:shadertoy_client/shadertoy_client.dart';
```

## Usage

Instantiate a `ShadertoyClient` implementation, for example the one provided by the package [shadertoy_client](https://pub.dev/packages/shadertoy_client) to access the client API:

```dart
// Created a client to the REST API using the API key `apiKey`
final client = newShadertoyWSClient(apiKey);
```
and execute one of the methods provided, for example to obtain a shader by id execute the `findShaderById` method providing the id of the shader as parameter:

```dart
// Execute the call to the REST API
final result = await client.findShaderById('Mt3XW8');
// Check if there's errors
if (result.ok) {
    // Print the shader name if not
    print(fsr?.shader.name);
} else {
    // Prints the error message otherwise
    print('Error: ${result.error.message}')
}
```
In alternative instantiate a `ShadertoyExtendedClient` implementation, for example the one provided by the package [shadertoy_client](https://pub.dev/packages/shadertoy_client), to access the site API:

```dart
final client = newShadertoySiteClient();
```
and execute one of the methods provided, for example to obtain the shader comments by shader id execute the `findCommentsByShaderId` method providing the id of the shader as parameter:

```dart
// Execute the call to the site API
final result = await client.findCommentsByShaderId('MdX3Rr');
// Check if there's errors
if (result.ok) {
    // Prints the shader comments
  print(jsonEncode(result.comments));
} else {
    // Prints the error message otherwise
    print('Error: ${fsr.error.message}')
}
```

As mentioned in the feature list, to (optionally) respect the shader privacy constraints but still benefit from a larger set of operations (some of them available only through the site API), the hybrid API can be used. Start by instancianting a suitable hybrid API implementation, for example the one provided by the `shadertoy_client` package:

```dart
// Creates a hybrid client using the REST API key `apiKey`
// This effectivly filters the shaders and provides only the ones respecting the shader 
// `public+api` privacy settings
final client = newShadertoyHybridClient(apiKey: apiKey);
```

and execute one of the methods provided, for example to obtain a shader by id execute `findShaderById` providing the id of the shader as parameter:

```dart
// Execute the call to the hybrid API
final result = await client.findShaderById('3lsSzf');
// Check if there's errors
if (result.ok) {
    // Prints the shader id
    print(result.shader?.info.id);
} else {
    // Prints the error message otherwise
    print('Error: ${result.error.message}')
}
```

To create a database providing the same set of read operations as the previous APIs but also the ability to save shaders as well as other entities a `ShadertoyStore` contract is also provided. To make use of the `ShadertoyStore` a suitable implementation should be provided, for example, the one available on [shadertoy_sqlite](https://pub.dev/packages/shadertoy_sqlite):

```dart
// Creates a new store with an in-memory executor
final store = newShadertoySqliteStore(memoryExecutor());
```

and execute one of the operations, for example storing a user:

```dart
// Create a user
final user = User(id: 'UzZ0Z1', about: 'About user 1', memberSince: DateTime.now());
// Save the user
final result = await store.saveUser(user);
// Check if there's errors
if (result.ok) {
    // Prints a success message
    print('Shader stored');
} else {
    // Prints the error message otherwise
    print('Error: ${response.error.message}')
}
```
## APIs

* The **client API** targetting the REST interfaces defined in the Shadertoy [howto](https://www.shadertoy.com/howto#q2) which allow the user to browse shaders available with `public+api` privacy settings. Note that the number of operations available with this API are limited albeit enough for simple browsing usage. To start using an API key needs to be obtained through a properly registered user on the [apps](https://www.shadertoy.com/myapps) page of the user section on the Shadertoy [website](https://www.shadertoy.com).
* The **extended client API** provides access to the same methods as the previous API but adds features that are only available on the site API, namely, the support to fetch users, playlists, shader comments and website media. Note that the shaders returned by this API are not constrained by the `public+api` privacy settings.
* The **hybrid API** complements the basic **client API** allowing the base REST API client to benefit from the additional features os the **extended client API** still (optionally) respecting the `public+api` constrains imposed by the shader creators. In a nutshell it allows the REST API users to access user, shader comments and website media of the `public+api` shaders if configured with an API key
* The **store API**, defines contracts supporting the creation of data stores thus providing a way to work offline with the downloaded shaders instead of relying on the Shadertoy APIs. It supports all the methods as the previous API plus the storage primitives.

### Client API

| Operation | Description |
| --------- | ----------- |
| `findShaderById` | Finds a shader by id |
| `findShadersByIdSet` | Finds shaders by a set of ids|
| `findShaders` | Queries shaders by term, tags and sort them by *name*, *likes*, *views*, *newness* and by *hotness* (proportional to popularity and inversely proportional to lifetime). All the query results are paginated through the `from` and `num` parameters |
| `findAllShaderIds` | Fetches all the shader ids |
| `findShaderIds` | Queries shader ids by term, tags and sort them by *name*, *likes*, *views*, *newness* and by *hotness* (proportional to popularity and inversely proportional to lifetime). All the query results are paginated through the `from` and `num` parameters |

### Extended Client API

All the client API features plus the following:


| Operation | Description |
| --------- | ----------- |
| `findUserById` | Finds a Shadertoy user by id |
| `findShadersByUserId` | Queries shaders by user id, tags and allows sorting by *name*, *likes*, *views*, *newness* and *hotness* (proportional to popularity and inversely proportional to lifetime). All the query results are paginated and the pages fetched with the `from` and `num` parameters |
|`findShaderIdsByUserId`|Queries shader ids by user id, tags and allows sorting by *name*, *likes*, *views*, *newness* and *hotness* (proportional to popularity and inversely proportional to lifetime). All the query results are paginated and the pages fetched with the `from` and `num` parameters |
| `findAllShaderIdsByUserId` | Fetches all the shader ids by user id |
| `findCommentsByShaderId` | Fetches the comments of a shader id |
| `findPlaylistById` | Fetches a playlist by id |
| `findShadersByPlaylistId` | Fetches the shaders of a playlist id. All the query results are paginated through the `from` and `num` parameters |
| `findShaderIdsByPlaylistId` | Fetches the shader ids of a playlist id. All the query results are paginated through the `from` and `num` parameters |
| `findShaderIdsByPlaylistId` | Fetches all the shader ids of a playlist id |

### Hybrid Client

All the client and extendec client features but optionally constraining the requests to shaders with `public+api` privacy settings.

### Store API

All the base and extended client API features plus the following:

| Operation | Description |
| --------- | ----------- |
| `findAllUserIds` | Returns all the stored user ids |
| `findAllUsers` | Returns all the stored users |
| `saveUser` | Saves a user |
| `saveUsers` | Saves a list of users |
| `deleteUserById` | Deletes a user by id |
| `findAllShaders` | Fetches all the shaders |
| `saveShader` | Saves a shader |
| `saveShaders` | Saves a list of shaders |
| `deleteShaderById` | Deletes a shader by id |
| `findCommentById` | Fetches a comment by id |
| `findAllCommentIds` | Returns all the comment ids |
| `findAllComments` | Returns all the comments |
| `saveShaderComments` | Saves a list of shader comments |
| `deleteCommentById` | Deletes a comment by id |
| `savePlaylist` | Saves a playlist |
| `savePlaylistShaders` | Associates a list of shader ids to a playlist |
| `deletePlaylistById` | Deletes a playlist by id |
| `findAllPlaylistIds` | Returns all the playlist ids |
| `findAllPlaylists` | Returns all the playlists |


## Model

![Shadertoy Model](https://github.com/ivoleitao/shadertoy/blob/develop/packages/shadertoy/model.svg?raw=true)

## Contributing

This is a unofficial [Shadertoy](https://www.shadertoy.com) client API. It is developed by best effort, in the motto of "Scratch your own itch!", meaning APIs that are meaningful for the author use cases.

If you would like to contribute with other parts of the API, feel free to make a Github [pull request](https://github.com/ivoleitao/shadertoy/pulls) as I'm always looking for contributions for:
* Tests
* Documentation
* New APIs

See [CONTRIBUTING.md](https://github.com/ivoleitao/shadertoy/blob/develop/CONTRIBUTING.md) for ways to get started.

## Features and Bugs

Please file feature requests and bugs at the [issue tracker][tracker].

[tracker]: https://github.com/ivoleitao/shadertoy/issues/new

## License

This project is licensed under the MIT License - see the [LICENSE](https://github.com/ivoleitao/shadertoy/blob/develop/packages/shadertoy/LICENSE) file for details
