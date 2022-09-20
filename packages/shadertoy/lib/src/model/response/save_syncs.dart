import 'package:equatable/equatable.dart';
import 'package:shadertoy/src/model/response/error.dart';

import 'response.dart';

/// Save syncs API response
///
/// The response returned upon the execution of the save syncs API call
/// When [SaveSyncsResponse.error] is *null* the save was sucessful
class SaveSyncsResponse extends APIResponse with EquatableMixin {
  /// Builds a [SaveSyncsResponse]
  ///
  /// [error]: An error if there was error while saving the sync
  SaveSyncsResponse({ResponseError? error}) : super(error: error);
}
