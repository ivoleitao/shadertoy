import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'playlist.g.dart';

@JsonSerializable()
class Playlist extends Equatable {
  @JsonKey(name: 'id')

  /// The playlist id
  final String id;

  @JsonKey(name: 'userId')

  /// The user id
  final String userId;

  @JsonKey(name: 'name')

  /// The playlist name
  final String name;

  @JsonKey(name: 'description')

  /// The playlist description
  final String description;

  @JsonKey(name: 'published')

  /// Builds a [Playlist]
  ///
  /// * [id]: The playlist id
  /// * [userId]: The user id
  /// * [name]: The playlist name
  /// * [description]: The playlist description
  const Playlist(
      {required this.id,
      required this.userId,
      required this.name,
      required this.description});

  @override
  List<Object> get props => [id, userId, name, description];

  /// Creates a [Playlist] from json map
  factory Playlist.fromJson(Map<String, dynamic> json) =>
      _$PlaylistFromJson(json);

  /// Creates a json map from a [Playlist]
  Map<String, dynamic> toJson() => _$PlaylistToJson(this);

  /// Builds a copy of a [Playlist]
  ///
  /// * [id]: The playlist id
  /// * [userId]: The user id
  /// * [name]: The playlist name
  /// * [description]: The playlist description
  Playlist copyWith(
      {String? id,
      String? userId,
      String? name,
      String? description,
      int? shaders,
      List<String>? shaderIds}) {
    return Playlist(
        id: id ?? this.id,
        userId: userId ?? this.userId,
        name: name ?? this.name,
        description: description ?? this.description);
  }
}
