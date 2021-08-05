# shadertoy_cli
A [shadertoy](https://github.com/ivoleitao/shadertoy) command line tool

[![Pub Package](https://img.shields.io/pub/v/shadertoy_cli.svg?style=flat-square)](https://pub.dartlang.org/packages/shadertoy_cli)
[![Coverage Status](https://codecov.io/gh/ivoleitao/shadertoy/graph/badge.svg?flag=shadertoy_cli)](https://codecov.io/gh/ivoleitao/shadertoy)
[![Package Documentation](https://img.shields.io/badge/doc-shadertoy_cli-blue.svg)](https://www.dartdocs.org/documentation/shadertoy_cli/latest)
[![GitHub License](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

## Overview

A command line tool to interact with the shadertoy rest and site apis

## Installing

```sh
$ dart pub global activate shadertoy
```

## Commands

```sh
$ shadertoy help
```

```sh
Command line shadertoy client

Usage: shadertoy <command> [arguments]

Global options:
-h, --help    Print this usage information.

Available commands:
  search     Search shaders
  shader     Gets one or more shaders by id
  comments   Gets shader comments by id
  user       Gets one or more users by id
  playlist   Gets one or more playlists by id

Run "shadertoy help <command>" for more information about a command.
```

### search

```sh
$ shadertoy help search
```
```sh
Search shaders

Usage: shadertoy search [arguments]
-h, --help                   Print this usage information.
-v, --[no-]verbose           Verbose logging
-u, --user=<user>            The user
-p, --password=<password>    The password
-k, --apiKey=<apiKey>        The api key
-f, --file=<file>            The database location
-t, --term=<term>            The search term
-i, --tag=<filter>           Search filter
-s, --sort=<sort>            Search sort

          [hot]              Hotness
          [love]             Love
          [name]             Name
          [newest]           Newness
          [popular]          Popularity

    --from=<from>            Start from
                             (defaults to "0")
    --num=<num>              Number of results
                             (defaults to "12")

Run "shadertoy help" to see global options.
```

### shader

```sh
$ shadertoy help shader
```
```sh
Gets one or more shaders by id

Usage: shadertoy shader [arguments]
-h, --help                   Print this usage information.
-v, --[no-]verbose           Verbose logging
-u, --user=<user>            The user
-p, --password=<password>    The password
-k, --apiKey=<apiKey>        The api key
-f, --file=<file>            The database location
-i, --ids=<ids>              The id(s) of the shader(s)

Run "shadertoy help" to see global options.
```

### comments

```sh
$ shadertoy help comments
```
```sh
Gets shader comments by id

Usage: shadertoy comments [arguments]
-h, --help                   Print this usage information.
-v, --[no-]verbose           Verbose logging
-u, --user=<user>            The user
-p, --password=<password>    The password
-k, --apiKey=<apiKey>        The api key
-f, --file=<file>            The database location
-i, --id=<id>                The id of the shader

Run "shadertoy help" to see global options.
```

### user

```sh
$ shadertoy help user
```
```sh
Gets one or more users by id

Usage: shadertoy user [arguments]
-h, --help                   Print this usage information.
-v, --[no-]verbose           Verbose logging
-u, --user=<user>            The user
-p, --password=<password>    The password
-k, --apiKey=<apiKey>        The api key
-f, --file=<file>            The database location
-i, --ids=<ids>              The id(s) of the user(s)

Run "shadertoy help" to see global options.
```

### playlist

```sh
$ shadertoy help playlist
```
```sh
Gets one or more playlists by id

Usage: shadertoy playlist [arguments]
-h, --help                   Print this usage information.
-v, --[no-]verbose           Verbose logging
-u, --user=<user>            The user
-p, --password=<password>    The password
-k, --apiKey=<apiKey>        The api key
-f, --file=<file>            The database location
-i, --ids=<ids>              The id(s) of the playlist

Run "shadertoy help" to see global options.
```

## Contributing

This is the unofficial [Shadertoy](https://www.shadertoy.com) command line tool. It is developed by best effort, in the motto of "Scratch your own itch!", meaning APIs that are meaningful for the author use cases.

If you would like to contribute with new features, feel free to make a Github [pull request](https://github.com/ivoleitao/shadertoy/pulls) as I'm always looking for contributions for:
* Tests
* Documentation
* New commands

See [CONTRIBUTING.md](https://github.com/ivoleitao/shadertoy/blob/develop/CONTRIBUTING.md) for ways to get started.

## Features and Bugs

Please file feature requests and bugs at the [issue tracker][tracker].

[tracker]: https://github.com/ivoleitao/shadertoy/issues/new

## License

This project is licensed under the MIT License - see the [LICENSE](https://github.com/ivoleitao/shadertoy/blob/develop/packages/shadertoy_cli/LICENSE) file for details