import 'package:equatable/equatable.dart';

import 'error.dart';
import 'response.dart';

/// Delete user API response
///
/// The response returned upon the execution of the delete user API call
/// When [DeleteUserResponse.error] is *not null* there was an error in the delete user call
/// When [DeleteUserResponse.error] is *null* the delete was sucessful
class DeleteUserResponse extends APIResponse with EquatableMixin {
  /// Builds a [DeleteUserResponse]
  ///
  /// [error]: An error if there was error while deleting the user
  DeleteUserResponse({ResponseError? error}) : super(error: error);
}
