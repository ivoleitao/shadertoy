import 'response.dart';

/// Save user API response
///
/// The response returned upon the execution of the save user API call
/// When [SaveUserResponse.fail] is *not null* there was an error in the save user call
/// When [SaveUserResponse.fail] is *null* the save was sucessful
class SaveUserResponse extends APIResponse {
  /// Builds a [SaveUserResponse]
  ///
  /// [error]: An error if there was error while saving the user
  SaveUserResponse({super.error});
}
