import 'package:json_annotation/json_annotation.dart';
import 'package:shadertoy/src/converter/error_converter.dart';

import 'response.dart';

part 'download_file.g.dart';

@JsonSerializable()

/// Download file API response
///
/// The response returned upon the execution of the download file API call
/// When [DownloadFileResponse.error] is *not null* there was an error in the donwload file call
/// When [DownloadFileResponse.error] is *null* the [DownloadFileResponse.bytes] has the bytes of the file
class DownloadFileResponse extends APIResponse {
  @JsonKey(name: 'Bytes')

  /// File bytes
  final List<int>? bytes;

  /// Builds a [DownloadFileResponse]
  ///
  /// [bytes]: The bytes of the file
  /// [error]: An error if there was error while fetching the file
  DownloadFileResponse({this.bytes, super.error});

  @override
  List<Object?> get props => [...super.props, bytes];
}
