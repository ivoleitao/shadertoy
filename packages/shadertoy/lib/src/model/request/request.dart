import 'package:equatable/equatable.dart';

/// Base API request class
///
/// It should be used as the base class for every API request.
abstract class APIRequest extends Equatable {
  @override
  List<Object?> get props => [];
}
