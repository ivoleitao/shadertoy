import 'package:json_annotation/json_annotation.dart';
import 'package:shadertoy/src/converter/error_converter.dart';
import 'package:shadertoy/src/model/response/find_sync.dart';

import 'error.dart';
import 'response.dart';

part 'find_syncs.g.dart';

@JsonSerializable()

/// Find syncs API response
///
/// The response returned upon the execution of a find syncs API call
/// When [FindSyncsResponse.error] is *not null* there was an error in the find syncs call
/// When [FindSyncsResponse.error] is *null* the [FindSyncsResponse.syncs] has the returned syncs
class FindSyncsResponse extends APIResponse {
  @JsonKey(name: 'Syncs')

  /// The total number of syncs
  final int total;

  @JsonKey(name: 'Results')

  /// The list of the syncs returned
  final List<FindSyncResponse>? syncs;

  /// Builds a [FindSyncsResponse]
  ///
  /// [total]: The total number of syncs returned
  /// [syncs]: The list of syncs
  /// [error]: An error if there was error while fetching the syncs
  FindSyncsResponse({int? total, this.syncs, ResponseError? error})
      : total = total ?? syncs?.length ?? 0,
        super(error: error);

  /// Creates a [FindSyncsResponse] from json map
  factory FindSyncsResponse.fromJson(Map<String, dynamic> json) =>
      _$FindSyncsResponseFromJson(json);

  /// Creates a json map from a [FindSyncsResponse]
  Map<String, dynamic> toJson() => _$FindSyncsResponseToJson(this);
}
