# shadertoy
A Shadertoy client and storage API for Dart

[![Pub Package](https://img.shields.io/pub/v/shadertoy.svg?style=flat-square)](https://pub.dartlang.org/packages/shadertoy)
[![Build Status](https://github.com/ivoleitao/shadertoy/workflows/build/badge.svg)](https://github.com/ivoleitao/shadertoy/actions)
[![Coverage Status](https://codecov.io/gh/ivoleitao/shadertoy/graph/badge.svg)](https://codecov.io/gh/ivoleitao/shadertoy)
[![Package Documentation](https://img.shields.io/badge/doc-shadertoy-blue.svg)](https://www.dartdocs.org/documentation/shadertoy/latest)
[![GitHub License](https://img.shields.io/badge/license-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

## Introduction

Provides a definition of the contracts and entities needed to create implementations of the shadertoy site and REST API's and storage model.

Three main types of contracts are defined in this library:
* A **Client API**, for the REST interfaces defined in the Shadertoy [howto](https://www.shadertoy.com/howto#q2) that allow the user to browse shaders available with `public+api` privacy settings. Note that the number of operations available with this API are limited albeit enough for simple browsing usage. To start using this type of client a API key should be obtained for a properly registered user on the [apps](https://www.shadertoy.com/myapps) page and the client implementation should support providing it at the time of the construction
* **Extended Client API**, provides access to the same methods as the previous API but adds methods namely users, playlists, shader comments and website media. Note that the shaders returned by this API should not be constrained by the `public+api` privacy settings.
* **Store API**, defines contracts supporting the creation of data stores thus providing a way to work offline with the downloaded shaders instead of hitting the client or extended client APIs. It supports all the methods as the previous API plus the storage primitives.

## Capabilities

This package provides a number of operations through two types of clients:

**Client API**

* `Find shader` by id
* `Find shaders` by a list of id's
* `Query shaders` by term, tags and sort them by *name*, *likes*, *views*, *newness* and by *hotness* (proportional to popularity and inversely proportional to lifetime). All the query results are paginated through the `from` and `num` parameters
* `Find all shader ids`
* `Query shader ids` by term, tags and sort them by *name*, *likes*, *views*, *newness* and by *hotness* (proportional to popularity and inversely proportional to lifetime). All the query results are paginated through the `from` and `num` parameters

**Extended Client API**

All the client API features plus the following available on a extended API:
* `Find user` by id
* `Query shaders by user id`, tags and sort them by *name*, *likes*, *views*, *newness* and by *hotness* (proportional to popularity and inversely proportional to lifetime). All the query results are paginated through the `from` and `num` parameters
* `Query shaders by user id`, tags and sort them by *name*, *likes*, *views*, *newness* and by *hotness* (proportional to popularity and inversely proportional to lifetime). All the query results are paginated through the `from` and `num` parameters
* `Find all shader ids by user id`
* `Find comments` by shader id
* `Find playlist` by id.
* `Query shaders by playlist id`. All the query results are paginated through the `from` and `num` parameters
* `Query shader ids by playlist id`. All the query results are paginated through the `from` and `num` parameters 

**Store API**

All the base and extended client API features plus the following:
* `Find all user ids`
* `Find all users`
* `Save user`
* `Save users`
* `Delete user by id`
* `Find all shaders`
* `Save shader`
* `Save shaders`
* `Delete shader by id`
* `Find comment by id`
* `Find all comment ids`
* `Find all comments`
* `Save shader comments`
* `Find all playlist ids`
* `Find all playlists`
* `Save playlist`
* `Save playlist shaders`
* `Delete playlist by id`

## Getting Started

Add this to your `pubspec.yaml` (or create it):

```dart
dependencies:
    shadertoy: ^1.0.22
```

Run the following command to install dependencies:

```dart
pub get
```

Finally, to start developing import the library:

```dart
import 'package:shadertoy/shadertoy.dart';
```

The following client and storage API implementations are available

| Plugins                                                    | Status                                                       | Description                                                  |
| ---------------------------------------------------------- | ------------------------------------------------------------ | ------------------------------------------------------------ |
| [shadertoy_client](https://github.com/ivoleitao/shadertoy_client) | [![Pub](https://img.shields.io/pub/v/shadertoy_client.svg?style=flat-square)](https://pub.dartlang.org/packages/shadertoy_client) | HTTP client to the Shadertoy REST and Site API                                      |
| [shadertoy_sqlite](https://github.com/ivoleitao/shadertoy_sqlite) | [![Pub](https://img.shields.io/pub/v/shadertoy_sqlite.svg?style=flat-square)](https://pub.dartlang.org/packages/shadertoy_sqlite) | A Moor storage implementation using the [moor](https://pub.dev/packages/moor) package                                     |

## Usage

Instantiate a `ShadertoyClient` implementation, for example the one provided by the package [shadertoy_client](https://pub.dev/packages/shadertoy_client), to access the client API:

```dart
final ws = newShadertoyWSClient('xx');
```
and execute one of the methods provided, for example to obtain a shader by id execute `findShaderById` providing the id of the shader as parameter:

```dart
var fsr = await ws.findShaderById('...');
if (fsr.ok) {
    print(fsr?.shader);
} else {
    print('Error: ${fsr.error.message}')
}
```
In alternative instantiate a `ShadertoyExtendedClient` implementation, for example the one provided by the package [shadertoy_client](https://pub.dev/packages/shadertoy_client), to access the Site API:
```dart
final site = newShadertoySiteClient();
```
and execute one of the methods provided, for example to obtain the shader comments by shader id execute `findCommentsByShaderId` providing the id of the shader as parameter:

```dart
final fsr = await site.findCommentsByShaderId('...');
if (fsr.ok) {
    fsr.comments.forEach((c)=> print(c.text));
} else {
    print('Error: ${fsr.error.message}')
}
```

To create a database providing the same set of read operations as the previous contracts but also the ability to save shaders as well as other entities a `ShadertoyStore` contract is also provided. The user should instantiate a `ShadertoyStore` providing the appropriate configurations for the implementation:

```dart
ShadertoyStore store = ...
```

and execute persistent operations, for example storing the definition of a shader in the store with:

```dart
var shader = Shader(...);
var ssr = await store.saveShader(shader);
if (ssr.ok) {
    print('Shader stored');
} else {
    print('Error: ${response.error.message}')
}
```

## Model

![Shadertoy API Model](model.svg?raw=true)

## Contributing

This a unofficial [Shadertoy](https://www.shadertoy.com) client library API. It is developed by best effort, in the motto of "Scratch your own itch!", meaning APIs that are meaningful for the author use cases.

If you would like to contribute with other parts of the API, feel free to make a [Github pull request](https://github.com/ivoleitao/shadertoy/pulls) as I'm always looking for contributions for:
* Tests
* Documentation
* New APIs

## Features and Bugs

Please file feature requests and bugs at the [issue tracker][tracker].

[tracker]: https://github.com/ivoleitao/shadertoy/issues/new

## License

This project is licensed under the MIT License - see the [LICENSE](https://github.com/ivoleitao/shadertoy/LICENSE) file for details
