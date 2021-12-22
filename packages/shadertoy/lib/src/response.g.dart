// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoginResponse _$LoginResponseFromJson(Map<String, dynamic> json) =>
    LoginResponse(
      error: const ResponseErrorConverter().fromJson(json['Error'] as String?),
    );

Map<String, dynamic> _$LoginResponseToJson(LoginResponse instance) =>
    <String, dynamic>{
      'Error': const ResponseErrorConverter().toJson(instance.error),
    };

LogoutResponse _$LogoutResponseFromJson(Map<String, dynamic> json) =>
    LogoutResponse(
      error: const ResponseErrorConverter().fromJson(json['Error'] as String?),
    );

Map<String, dynamic> _$LogoutResponseToJson(LogoutResponse instance) =>
    <String, dynamic>{
      'Error': const ResponseErrorConverter().toJson(instance.error),
    };

FindUserResponse _$FindUserResponseFromJson(Map<String, dynamic> json) =>
    FindUserResponse(
      user: json['User'] == null
          ? null
          : User.fromJson(json['User'] as Map<String, dynamic>),
      error: const ResponseErrorConverter().fromJson(json['Error'] as String?),
    );

Map<String, dynamic> _$FindUserResponseToJson(FindUserResponse instance) =>
    <String, dynamic>{
      'Error': const ResponseErrorConverter().toJson(instance.error),
      'User': instance.user?.toJson(),
    };

FindUsersResponse _$FindUsersResponseFromJson(Map<String, dynamic> json) =>
    FindUsersResponse(
      total: json['Users'] as int?,
      users: (json['Results'] as List<dynamic>?)
          ?.map((e) => FindUserResponse.fromJson(e as Map<String, dynamic>))
          .toList(),
      error: const ResponseErrorConverter().fromJson(json['Error'] as String?),
    );

Map<String, dynamic> _$FindUsersResponseToJson(FindUsersResponse instance) =>
    <String, dynamic>{
      'Error': const ResponseErrorConverter().toJson(instance.error),
      'Users': instance.total,
      'Results': instance.users?.map((e) => e.toJson()).toList(),
    };

FindUserIdsResponse _$FindUserIdsResponseFromJson(Map<String, dynamic> json) =>
    FindUserIdsResponse(
      ids:
          (json['Results'] as List<dynamic>?)?.map((e) => e as String).toList(),
      error: const ResponseErrorConverter().fromJson(json['Error'] as String?),
    );

Map<String, dynamic> _$FindUserIdsResponseToJson(
        FindUserIdsResponse instance) =>
    <String, dynamic>{
      'Error': const ResponseErrorConverter().toJson(instance.error),
      'Results': instance.ids,
    };

FindShaderResponse _$FindShaderResponseFromJson(Map<String, dynamic> json) =>
    FindShaderResponse(
      shader: json['Shader'] == null
          ? null
          : Shader.fromJson(json['Shader'] as Map<String, dynamic>),
      error: const ResponseErrorConverter().fromJson(json['Error'] as String?),
    );

Map<String, dynamic> _$FindShaderResponseToJson(FindShaderResponse instance) =>
    <String, dynamic>{
      'Error': const ResponseErrorConverter().toJson(instance.error),
      'Shader': instance.shader?.toJson(),
    };

FindShaderIdsResponse _$FindShaderIdsResponseFromJson(
        Map<String, dynamic> json) =>
    FindShaderIdsResponse(
      ids:
          (json['Results'] as List<dynamic>?)?.map((e) => e as String).toList(),
      error: const ResponseErrorConverter().fromJson(json['Error'] as String?),
    );

Map<String, dynamic> _$FindShaderIdsResponseToJson(
        FindShaderIdsResponse instance) =>
    <String, dynamic>{
      'Error': const ResponseErrorConverter().toJson(instance.error),
      'Results': instance.ids,
    };

FindShadersResponse _$FindShadersResponseFromJson(Map<String, dynamic> json) =>
    FindShadersResponse(
      total: json['Shaders'] as int?,
      shaders: (json['Results'] as List<dynamic>?)
          ?.map((e) => FindShaderResponse.fromJson(e as Map<String, dynamic>))
          .toList(),
      error: const ResponseErrorConverter().fromJson(json['Error'] as String?),
    );

Map<String, dynamic> _$FindShadersResponseToJson(
        FindShadersResponse instance) =>
    <String, dynamic>{
      'Error': const ResponseErrorConverter().toJson(instance.error),
      'Shaders': instance.total,
      'Results': instance.shaders?.map((e) => e.toJson()).toList(),
    };

CommentsResponse _$CommentsResponseFromJson(Map<String, dynamic> json) =>
    CommentsResponse(
      texts: (json['text'] as List<dynamic>?)?.map((e) => e as String).toList(),
      dates: (json['date'] as List<dynamic>?)?.map((e) => e as String).toList(),
      userIds: (json['username'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      userPictures: (json['userpicture'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      ids: (json['id'] as List<dynamic>?)?.map((e) => e as String).toList(),
      hidden: (json['hidden'] as List<dynamic>?)?.map((e) => e as int).toList(),
      error: const ResponseErrorConverter().fromJson(json['Error'] as String?),
    );

Map<String, dynamic> _$CommentsResponseToJson(CommentsResponse instance) =>
    <String, dynamic>{
      'Error': const ResponseErrorConverter().toJson(instance.error),
      'text': instance.texts,
      'date': instance.dates,
      'username': instance.userIds,
      'userpicture': instance.userPictures,
      'id': instance.ids,
      'hidden': instance.hidden,
    };

FindCommentResponse _$FindCommentResponseFromJson(Map<String, dynamic> json) =>
    FindCommentResponse(
      comment: json['Comment'] == null
          ? null
          : Comment.fromJson(json['Comment'] as Map<String, dynamic>),
      error: const ResponseErrorConverter().fromJson(json['Error'] as String?),
    );

Map<String, dynamic> _$FindCommentResponseToJson(
        FindCommentResponse instance) =>
    <String, dynamic>{
      'Error': const ResponseErrorConverter().toJson(instance.error),
      'Comment': instance.comment?.toJson(),
    };

FindCommentIdsResponse _$FindCommentIdsResponseFromJson(
        Map<String, dynamic> json) =>
    FindCommentIdsResponse(
      ids:
          (json['Results'] as List<dynamic>?)?.map((e) => e as String).toList(),
      error: const ResponseErrorConverter().fromJson(json['Error'] as String?),
    );

Map<String, dynamic> _$FindCommentIdsResponseToJson(
        FindCommentIdsResponse instance) =>
    <String, dynamic>{
      'Error': const ResponseErrorConverter().toJson(instance.error),
      'Results': instance.ids,
    };

FindCommentsResponse _$FindCommentsResponseFromJson(
        Map<String, dynamic> json) =>
    FindCommentsResponse(
      total: json['Comments'] as int?,
      comments: (json['Results'] as List<dynamic>?)
          ?.map((e) => Comment.fromJson(e as Map<String, dynamic>))
          .toList(),
      error: const ResponseErrorConverter().fromJson(json['Error'] as String?),
    );

Map<String, dynamic> _$FindCommentsResponseToJson(
        FindCommentsResponse instance) =>
    <String, dynamic>{
      'Error': const ResponseErrorConverter().toJson(instance.error),
      'Comments': instance.total,
      'Results': instance.comments?.map((e) => e.toJson()).toList(),
    };

FindPlaylistResponse _$FindPlaylistResponseFromJson(
        Map<String, dynamic> json) =>
    FindPlaylistResponse(
      playlist: json['Playlist'] == null
          ? null
          : Playlist.fromJson(json['Playlist'] as Map<String, dynamic>),
      error: const ResponseErrorConverter().fromJson(json['Error'] as String?),
    );

Map<String, dynamic> _$FindPlaylistResponseToJson(
        FindPlaylistResponse instance) =>
    <String, dynamic>{
      'Error': const ResponseErrorConverter().toJson(instance.error),
      'Playlist': instance.playlist?.toJson(),
    };

FindPlaylistIdsResponse _$FindPlaylistIdsResponseFromJson(
        Map<String, dynamic> json) =>
    FindPlaylistIdsResponse(
      ids:
          (json['Results'] as List<dynamic>?)?.map((e) => e as String).toList(),
      error: const ResponseErrorConverter().fromJson(json['Error'] as String?),
    );

Map<String, dynamic> _$FindPlaylistIdsResponseToJson(
        FindPlaylistIdsResponse instance) =>
    <String, dynamic>{
      'Error': const ResponseErrorConverter().toJson(instance.error),
      'Results': instance.ids,
    };

FindPlaylistsResponse _$FindPlaylistsResponseFromJson(
        Map<String, dynamic> json) =>
    FindPlaylistsResponse(
      total: json['Playlists'] as int?,
      playlists: (json['Results'] as List<dynamic>?)
          ?.map((e) => FindPlaylistResponse.fromJson(e as Map<String, dynamic>))
          .toList(),
      error: const ResponseErrorConverter().fromJson(json['Error'] as String?),
    );

Map<String, dynamic> _$FindPlaylistsResponseToJson(
        FindPlaylistsResponse instance) =>
    <String, dynamic>{
      'Error': const ResponseErrorConverter().toJson(instance.error),
      'Playlists': instance.total,
      'Results': instance.playlists?.map((e) => e.toJson()).toList(),
    };

FindSyncResponse _$FindSyncResponseFromJson(Map<String, dynamic> json) =>
    FindSyncResponse(
      sync: json['Sync'] == null
          ? null
          : Sync.fromJson(json['Sync'] as Map<String, dynamic>),
      error: const ResponseErrorConverter().fromJson(json['Error'] as String?),
    );

Map<String, dynamic> _$FindSyncResponseToJson(FindSyncResponse instance) =>
    <String, dynamic>{
      'Error': const ResponseErrorConverter().toJson(instance.error),
      'Sync': instance.sync?.toJson(),
    };

FindSyncsResponse _$FindSyncsResponseFromJson(Map<String, dynamic> json) =>
    FindSyncsResponse(
      total: json['Syncs'] as int?,
      syncs: (json['Results'] as List<dynamic>?)
          ?.map((e) => FindSyncResponse.fromJson(e as Map<String, dynamic>))
          .toList(),
      error: const ResponseErrorConverter().fromJson(json['Error'] as String?),
    );

Map<String, dynamic> _$FindSyncsResponseToJson(FindSyncsResponse instance) =>
    <String, dynamic>{
      'Error': const ResponseErrorConverter().toJson(instance.error),
      'Syncs': instance.total,
      'Results': instance.syncs?.map((e) => e.toJson()).toList(),
    };
