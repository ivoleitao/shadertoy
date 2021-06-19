## 1.0.22

- TODO

## 1.0.21

- savePlaylist now optionally saves the shaderIds of the playlist as well

## 1.0.20

- Corrected the response of the FindPlaylistsResponse

## 1.0.19

- Updated derry with test action
- Added find all users method
- Added find all shaders method
- Added find all comment ids method
- Added find all comments method
- Added find all playlist ids method
- Added find all playlists method 

## 1.0.18

- Added new unit tests
- Added find comment by id

## 1.0.17

- Removed grinder
- Simplified derry script

## 1.0.16

- Added grinder support

## 1.0.15

- Updated dart sdk
- Improved derry script

## 1.0.14

- Removed some leftover traces of account support
- Added support for deleting shaders, users, playlist and comments by id
- Start using dart format instead of dartfmt which was deprecated
- Started using dart analize instead of dartanalyzer which was deprecated
- Now using the new setup-dart github action from the dart team introducing multi os tests
- Removed a comment inside a extension method as it was causing errors on dartdoc

## 1.0.13

- `catchError` is not an extension of the ShadertoyClient 

## 1.0.12

- The `catchError` method as a static method on ShadertoyClient was triggering analyser errors in shadertoy_client moving to a base class

## 1.0.11

- Corrected some lint errors

## 1.0.10

- Added filePath and previewFilePath in the Input object

## 1.0.9

- Fixed the return type of find all user ids

## 1.0.8

- Added find all user ids to the ShadertoyStore API

## 1.0.7

- Added derry support
## 1.0.6

- Added the generated files again. There's no way to publish a package without adding them to source control. See https://github.com/dart-lang/pub/issues/2222

## 1.0.5

- Upgrade sdk to 2.10.0
- Improved coverage
- Updated dependencies
- Added run all tests configuration
- Removed Account as it will be used differently
- Removed shaderId and added id, userPicture and hidden on the comment model
- Removed context from ShadertoyContext
- Removed ShadertoyWS and ShadertoySite
- Added copyWith in the main models
- Added missing documentation on Playlist
- Added following and followers on User
- Added plantuml generation
- Improved documentation removing all warnings/errors

## 1.0.4

- Downgraded to the pub sdk 2.8.1

## 1.0.3

- Updated dependencies
- Corrected insecure link in the README
- Increased coverage
- Removed generated files from coverage report using remove_from_coverage tool

## 1.0.2

- Removed meta dependency

## 1.0.1

- Updated dependencies

## 1.0.0

- Released 1.0.0 version

## 1.0.0-dev.8

- Updated sdk to 2.8
- Updated dependencies 

## 1.0.0-dev.7

- Updated documentation
- Improved test coverage
- Pluralized CommentsResponse field names
- Added embedded URLs construction method in the Context class

## 1.0.0-dev.6

- Updated documentation

## 1.0.0-dev.5

- Updated badges
- Update minimum sdk to 2.7
- Added model tests
- Updated dependencies

## 1.0.0-dev.4

- Finished the CI process

## 1.0.0-dev.3

- Several changes in the github repo configuration
- Github actions for this repo now publish the file to pub
- README.md now has again the model image since the plantuml proxy does not support https

## 1.0.0-dev.2

- Added generated files to github
- Added missing documentation

## 1.0.0-dev.1

- Initial version
