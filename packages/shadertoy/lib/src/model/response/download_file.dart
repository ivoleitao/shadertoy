import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import 'error.dart';
import 'response.dart';

part 'download_file.g.dart';

@JsonSerializable()

/// Download file API response
///
/// The response returned upon the execution of the download file API call
/// When [DownloadFileResponse.error] is *not null* there was an error in the donwload file call
/// When [DownloadFileResponse.error] is *null* the [DownloadFileResponse.bytes] has the bytes of the file
class DownloadFileResponse extends APIResponse with EquatableMixin {
  @JsonKey(name: 'Bytes')

  /// File bytes
  final List<int>? bytes;

  @override
  List get props {
    return [bytes, error];
  }

  /// Builds a [DownloadFileResponse]
  ///
  /// [bytes]: The bytes of the file
  /// [error]: An error if there was error while fetching the file
  DownloadFileResponse({this.bytes, ResponseError? error})
      : super(error: error);
}
