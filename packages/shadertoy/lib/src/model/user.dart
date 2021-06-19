import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()

/// A shadertoy site user
class User extends Equatable {
  @JsonKey(name: 'id')

  /// The id of the user
  final String id;

  @JsonKey(name: 'picture')

  /// A link to the user picture
  final String? picture;

  @JsonKey(name: 'memberSince')

  /// Join date of the user
  final DateTime memberSince;

  @JsonKey(name: 'following')

  /// How many users this user follows
  final int following;

  @JsonKey(name: 'followers')

  /// How many users follow this user
  final int followers;

  @JsonKey(name: 'about')

  /// More about the user
  final String? about;

  /// Builds a user
  ///
  /// * [id]: The id of the user
  /// * [picture]: A link to the user picture
  /// * [memberSince]: The user join date
  /// * [following]: The number of users this user is following
  /// * [followers]: The number of followers this user has
  /// * [about]: More about the user
  const User(
      {required this.id,
      this.picture,
      required this.memberSince,
      this.following = 0,
      this.followers = 0,
      this.about});

  @override
  List<Object?> get props =>
      [id, picture, memberSince, following, followers, about];

  /// Creates a [User] from json map
  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  /// Creates a json map from a [User]
  Map<String, dynamic> toJson() => _$UserToJson(this);

  /// Builds a copy of a [User]
  ///
  /// * [id]: The id of the user
  /// * [picture]: A link to the user picture
  /// * [memberSince]: The user join date
  /// * [following]: The number of users this user is following
  /// * [followers]: The number of followers this user has
  /// * [about]: More about the user
  User copyWith(
      {String? id,
      String? picture,
      DateTime? memberSince,
      int? following,
      int? followers,
      String? about}) {
    return User(
        id: id ?? this.id,
        picture: picture ?? this.picture,
        memberSince: memberSince ?? this.memberSince,
        following: following ?? this.following,
        followers: followers ?? this.followers,
        about: about ?? this.about);
  }
}
