# shadertoy_alfred

![GitHub release](https://img.shields.io/github/release/ivoleitao/shadertoy-alfred.svg)
![GitHub All Releases](https://img.shields.io/github/downloads/ivoleitao/shadertoy-alfred/total.svg)
[![GitHub License](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

## Overview

Search for shaders in [Shadertoy](https://www.shadertoy.com/) using [Alfred](https://www.alfredapp.com/).

![demo](demo.gif)

## Getting Started

1. [Download the latest version](https://github.com/ivoleitao/shadertoy-alfred/releases/latest)
2. Install the workflow by double-clicking the `.alfredworkflow` file
3. You can add the workflow to a category, then click "Import" to finish importing. You'll now see the workflow listed in the left sidebar of your Workflows preferences pane.

## Usage

| Command          | Description                                               |
|------------------|---------------------------------------------------------- |
| `sts {term}`     | Searches for a shader by {term}                           |
| `stb {sort}`     | Browse shaders by {sort} order (hot,newness,love,popular) |
| `stp {playlist}` | Browse {playlist} shaders                                 |
| `stu`            | Updates workflow                                          | 


Either press `⌘Y` to Quick Look the result, or press `<enter>` copy it to your clipboard.


## Contributing

This is a unofficial [Shadertoy](https://www.shadertoy.com) alfred workflow. It is developed by best effort, in the motto of "Scratch your own itch!", meaning APIs that are meaningful for the author use cases.

If you would like to contribute with other parts of the API, feel free to make a Github [pull request](https://github.com/ivoleitao/shadertoy/pulls) as I'm always looking for contributions for:
* Tests
* Documentation
* New APIs

See [CONTRIBUTING.md](https://github.com/ivoleitao/shadertoy/blob/develop/CONTRIBUTING.md) for ways to get started.

## Features and Bugs

Please file feature requests and bugs at the [issue tracker][tracker].

[tracker]: https://github.com/ivoleitao/shadertoy/issues/new

## License

This project is licensed under the MIT License - see the [LICENSE](https://github.com/ivoleitao/shadertoy/blob/develop/packages/shadertoy_alfred/LICENSE) file for details