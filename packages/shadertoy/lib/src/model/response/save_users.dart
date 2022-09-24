import 'response.dart';

/// Save users API response
///
/// The response returned upon the execution of the save users API call
/// When [SaveUsersResponse.error] is *not null* there was an error in the save shader call
/// When [SaveUsersResponse.error] is *null* the save was sucessful
class SaveUsersResponse extends APIResponse {
  /// Builds a [SaveUsersResponse]
  ///
  /// [error]: An error if there was error while saving the user
  SaveUsersResponse({super.error});
}
