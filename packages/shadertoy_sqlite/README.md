# shadertoy_sqlite
A [Shadertoy API](https://github.com/ivoleitao/shadertoy_api) storage implementation with [moor](https://pub.dev/packages/moor)

[![Pub Package](https://img.shields.io/pub/v/shadertoy_sqlite.svg?style=flat-square)](https://pub.dartlang.org/packages/shadertoy_sqlite)
[![Build Status](https://github.com/ivoleitao/shadertoy_sqlite/workflows/build/badge.svg)](https://github.com/ivoleitao/shadertoy_sqlite/actions)
[![Coverage Status](https://codecov.io/gh/ivoleitao/shadertoy_sqlite/graph/badge.svg)](https://codecov.io/gh/ivoleitao/shadertoy_sqlite)
[![Package Documentation](https://img.shields.io/badge/doc-shadertoy_sqlite-blue.svg)](https://www.dartdocs.org/documentation/shadertoy_sqlite/latest)
[![GitHub License](https://img.shields.io/badge/license-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

## Introduction

This package implements the storage APIs defined in the [shadertoy_api](https://pub.dev/packages/shadertoy_api) package providing a [moor](https://pub.dev/packages/moor) backed implementation

## Capabilities

The following methods are implemented:

* `Find all user ids`
* `Save user`
* `Save users`
* `Delete user by id`
* `Save shader`
* `Save shaders`
* `Delete shader by id`
* `Save shader comments`
* `Save playlist`
* `Save playlist shaders`
* `Delete playlist by id`

## Getting Started

Add this to your `pubspec.yaml` (or create it):

```dart
dependencies:
    shadertoy_sqlite: ^1.0.5
```

Run the following command to install dependencies:

```dart
pub get
```

Finally, to start developing import the library:

```dart
import 'package:shadertoy_sqlite/shadertoy_sqlite.dart';
```

## Usage

To create a new store the `ShadertoyStore` implementation needs to be instanciated. The example bellow creates a new `moor` store with an in memory implementation (mostly used for test purposes)

```dart
import 'package:moor/ffi.dart';
import 'package:moor/moor.dart';
import 'package:shadertoy_sqlite/shadertoy_sqlite.dart';

QueryExecutor memoryExecutor({bool logStatements = false}) {
  return VmDatabase.memory(logStatements: logStatements);
}

final store = newShadertoyMoorStore(memoryExecutor())
```

A more real example would entail de creation of a database backed by a file like so:

```dart
import 'dart:io';

import 'package:moor/ffi.dart';
import 'package:moor/moor.dart';
import 'package:shadertoy_api/shadertoy_api.dart';
import 'package:shadertoy_sqlite/shadertoy_sqlite.dart';

QueryExecutor diskExecutor(File file, {bool logStatements = false}) {
  return VmDatabase(file, logStatements: logStatements);
}

final store = newShadertoyMoorStore(diskExecutor(File('shadertoy.db')))
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
## Model

![Shadertoy Storage Model](model.svg?raw=true)
## Contributing

This a unofficial [Shadertoy](https://www.shadertoy.com) storage library. It is developed by best effort, in the motto of "Scratch your own itch!", meaning APIs that are meaningful for the author use cases.

If you would like to contribute with other parts of the API, feel free to make a [Github pull request](https://github.com/ivoleitao/shadertoy_sqlite/pulls) as I'm always looking for contributions for:
* Tests
* Documentation
* New APIs

## Features and Bugs

Please file feature requests and bugs at the [issue tracker][tracker].

[tracker]: https://github.com/ivoleitao/shadertoy_sqlite/issues/new

## License

This project is licensed under the MIT License - see the [LICENSE](https://github.com/ivoleitao/shadertoy_sqlite/LICENSE) file for details