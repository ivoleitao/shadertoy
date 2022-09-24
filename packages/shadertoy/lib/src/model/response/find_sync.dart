import 'package:json_annotation/json_annotation.dart';
import 'package:shadertoy/src/converter/error_converter.dart';
import 'package:shadertoy/src/model/sync.dart';

import 'error.dart';
import 'response.dart';

part 'find_sync.g.dart';

@JsonSerializable()

/// Find sync API response
///
/// The response returned upon the execution of a find sync API call
/// When [FindSyncResponse.error] is *not null* there was an error in the find sync call
/// When [FindSyncResponse.error] is *null* the [FindSyncResponse.sync] has the returned sync
class FindSyncResponse extends APIResponse {
  @JsonKey(name: 'Sync')

  /// The sync returned, null when there is an error
  final Sync? sync;

  /// Builds an [FindSyncResponse]
  ///
  /// * [sync]: The sync
  /// * [error]: An error
  ///
  /// Upon construction either [sync] or [error] should be provided, not both
  FindSyncResponse({this.sync, ResponseError? error}) : super(error: error);

  /// Creates a [FindSyncResponse] from json map
  factory FindSyncResponse.fromJson(Map<String, dynamic> json) =>
      _$FindSyncResponseFromJson(json);

  /// Creates a json map from a [FindSyncResponse]
  Map<String, dynamic> toJson() => _$FindSyncResponseToJson(this);
}
