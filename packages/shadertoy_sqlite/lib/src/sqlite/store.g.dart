// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'store.dart';

// **************************************************************************
// MoorGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps, unnecessary_this
class UserEntry extends DataClass implements Insertable<UserEntry> {
  /// The user id
  final String id;

  /// The user picture.
  final String? picture;

  /// The registration date of the user
  final DateTime memberSince;

  /// The number of followed users
  final int following;

  /// The number of followers
  final int followers;

  /// Abouth this user
  final String? about;
  UserEntry(
      {required this.id,
      this.picture,
      required this.memberSince,
      required this.following,
      required this.followers,
      this.about});
  factory UserEntry.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return UserEntry(
      id: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}id'])!,
      picture: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}picture']),
      memberSince: const DateTimeType()
          .mapFromDatabaseResponse(data['${effectivePrefix}member_since'])!,
      following: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}following'])!,
      followers: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}followers'])!,
      about: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}about']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || picture != null) {
      map['picture'] = Variable<String?>(picture);
    }
    map['member_since'] = Variable<DateTime>(memberSince);
    map['following'] = Variable<int>(following);
    map['followers'] = Variable<int>(followers);
    if (!nullToAbsent || about != null) {
      map['about'] = Variable<String?>(about);
    }
    return map;
  }

  UserTableCompanion toCompanion(bool nullToAbsent) {
    return UserTableCompanion(
      id: Value(id),
      picture: picture == null && nullToAbsent
          ? const Value.absent()
          : Value(picture),
      memberSince: Value(memberSince),
      following: Value(following),
      followers: Value(followers),
      about:
          about == null && nullToAbsent ? const Value.absent() : Value(about),
    );
  }

  factory UserEntry.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return UserEntry(
      id: serializer.fromJson<String>(json['id']),
      picture: serializer.fromJson<String?>(json['picture']),
      memberSince: serializer.fromJson<DateTime>(json['memberSince']),
      following: serializer.fromJson<int>(json['following']),
      followers: serializer.fromJson<int>(json['followers']),
      about: serializer.fromJson<String?>(json['about']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'picture': serializer.toJson<String?>(picture),
      'memberSince': serializer.toJson<DateTime>(memberSince),
      'following': serializer.toJson<int>(following),
      'followers': serializer.toJson<int>(followers),
      'about': serializer.toJson<String?>(about),
    };
  }

  UserEntry copyWith(
          {String? id,
          String? picture,
          DateTime? memberSince,
          int? following,
          int? followers,
          String? about}) =>
      UserEntry(
        id: id ?? this.id,
        picture: picture ?? this.picture,
        memberSince: memberSince ?? this.memberSince,
        following: following ?? this.following,
        followers: followers ?? this.followers,
        about: about ?? this.about,
      );
  @override
  String toString() {
    return (StringBuffer('UserEntry(')
          ..write('id: $id, ')
          ..write('picture: $picture, ')
          ..write('memberSince: $memberSince, ')
          ..write('following: $following, ')
          ..write('followers: $followers, ')
          ..write('about: $about')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(
      id.hashCode,
      $mrjc(
          picture.hashCode,
          $mrjc(
              memberSince.hashCode,
              $mrjc(following.hashCode,
                  $mrjc(followers.hashCode, about.hashCode))))));
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserEntry &&
          other.id == this.id &&
          other.picture == this.picture &&
          other.memberSince == this.memberSince &&
          other.following == this.following &&
          other.followers == this.followers &&
          other.about == this.about);
}

class UserTableCompanion extends UpdateCompanion<UserEntry> {
  final Value<String> id;
  final Value<String?> picture;
  final Value<DateTime> memberSince;
  final Value<int> following;
  final Value<int> followers;
  final Value<String?> about;
  const UserTableCompanion({
    this.id = const Value.absent(),
    this.picture = const Value.absent(),
    this.memberSince = const Value.absent(),
    this.following = const Value.absent(),
    this.followers = const Value.absent(),
    this.about = const Value.absent(),
  });
  UserTableCompanion.insert({
    required String id,
    this.picture = const Value.absent(),
    required DateTime memberSince,
    this.following = const Value.absent(),
    this.followers = const Value.absent(),
    this.about = const Value.absent(),
  })  : id = Value(id),
        memberSince = Value(memberSince);
  static Insertable<UserEntry> custom({
    Expression<String>? id,
    Expression<String?>? picture,
    Expression<DateTime>? memberSince,
    Expression<int>? following,
    Expression<int>? followers,
    Expression<String?>? about,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (picture != null) 'picture': picture,
      if (memberSince != null) 'member_since': memberSince,
      if (following != null) 'following': following,
      if (followers != null) 'followers': followers,
      if (about != null) 'about': about,
    });
  }

  UserTableCompanion copyWith(
      {Value<String>? id,
      Value<String?>? picture,
      Value<DateTime>? memberSince,
      Value<int>? following,
      Value<int>? followers,
      Value<String?>? about}) {
    return UserTableCompanion(
      id: id ?? this.id,
      picture: picture ?? this.picture,
      memberSince: memberSince ?? this.memberSince,
      following: following ?? this.following,
      followers: followers ?? this.followers,
      about: about ?? this.about,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (picture.present) {
      map['picture'] = Variable<String?>(picture.value);
    }
    if (memberSince.present) {
      map['member_since'] = Variable<DateTime>(memberSince.value);
    }
    if (following.present) {
      map['following'] = Variable<int>(following.value);
    }
    if (followers.present) {
      map['followers'] = Variable<int>(followers.value);
    }
    if (about.present) {
      map['about'] = Variable<String?>(about.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UserTableCompanion(')
          ..write('id: $id, ')
          ..write('picture: $picture, ')
          ..write('memberSince: $memberSince, ')
          ..write('following: $following, ')
          ..write('followers: $followers, ')
          ..write('about: $about')
          ..write(')'))
        .toString();
  }
}

class $UserTableTable extends UserTable
    with TableInfo<$UserTableTable, UserEntry> {
  final GeneratedDatabase _db;
  final String? _alias;
  $UserTableTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumn<String?> id = GeneratedColumn<String?>(
      'id', aliasedName, false,
      typeName: 'TEXT', requiredDuringInsert: true);
  final VerificationMeta _pictureMeta = const VerificationMeta('picture');
  late final GeneratedColumn<String?> picture = GeneratedColumn<String?>(
      'picture', aliasedName, true,
      typeName: 'TEXT', requiredDuringInsert: false);
  final VerificationMeta _memberSinceMeta =
      const VerificationMeta('memberSince');
  late final GeneratedColumn<DateTime?> memberSince =
      GeneratedColumn<DateTime?>('member_since', aliasedName, false,
          typeName: 'INTEGER', requiredDuringInsert: true);
  final VerificationMeta _followingMeta = const VerificationMeta('following');
  late final GeneratedColumn<int?> following = GeneratedColumn<int?>(
      'following', aliasedName, false,
      typeName: 'INTEGER',
      requiredDuringInsert: false,
      defaultValue: Constant(0));
  final VerificationMeta _followersMeta = const VerificationMeta('followers');
  late final GeneratedColumn<int?> followers = GeneratedColumn<int?>(
      'followers', aliasedName, false,
      typeName: 'INTEGER',
      requiredDuringInsert: false,
      defaultValue: Constant(0));
  final VerificationMeta _aboutMeta = const VerificationMeta('about');
  late final GeneratedColumn<String?> about = GeneratedColumn<String?>(
      'about', aliasedName, true,
      typeName: 'TEXT', requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [id, picture, memberSince, following, followers, about];
  @override
  String get aliasedName => _alias ?? 'User';
  @override
  String get actualTableName => 'User';
  @override
  VerificationContext validateIntegrity(Insertable<UserEntry> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('picture')) {
      context.handle(_pictureMeta,
          picture.isAcceptableOrUnknown(data['picture']!, _pictureMeta));
    }
    if (data.containsKey('member_since')) {
      context.handle(
          _memberSinceMeta,
          memberSince.isAcceptableOrUnknown(
              data['member_since']!, _memberSinceMeta));
    } else if (isInserting) {
      context.missing(_memberSinceMeta);
    }
    if (data.containsKey('following')) {
      context.handle(_followingMeta,
          following.isAcceptableOrUnknown(data['following']!, _followingMeta));
    }
    if (data.containsKey('followers')) {
      context.handle(_followersMeta,
          followers.isAcceptableOrUnknown(data['followers']!, _followersMeta));
    }
    if (data.containsKey('about')) {
      context.handle(
          _aboutMeta, about.isAcceptableOrUnknown(data['about']!, _aboutMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  UserEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    return UserEntry.fromData(data, _db,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $UserTableTable createAlias(String alias) {
    return $UserTableTable(_db, alias);
  }
}

class ShaderEntry extends DataClass implements Insertable<ShaderEntry> {
  /// The id of the shader
  final String id;

  /// The id of the user that created this shader
  final String userId;

  /// The version of this shader
  final String version;

  /// The name of the shader
  final String name;

  /// The date this shader was published
  final DateTime date;

  /// A description of the shader
  final String? description;

  /// The number of views this shader had
  final int views;

  /// The number of likes this shader had
  final int likes;

  /// The privacy of this shader
  final String privacy;

  /// The flags of this shader
  final int flags;

  /// A json list of the tags of this shader
  final String tagsJson;

  /// The render passses in json
  final String renderPassesJson;
  ShaderEntry(
      {required this.id,
      required this.userId,
      required this.version,
      required this.name,
      required this.date,
      this.description,
      required this.views,
      required this.likes,
      required this.privacy,
      required this.flags,
      required this.tagsJson,
      required this.renderPassesJson});
  factory ShaderEntry.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return ShaderEntry(
      id: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}id'])!,
      userId: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}user_id'])!,
      version: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}version'])!,
      name: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}name'])!,
      date: const DateTimeType()
          .mapFromDatabaseResponse(data['${effectivePrefix}date'])!,
      description: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}description']),
      views: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}views'])!,
      likes: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}likes'])!,
      privacy: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}privacy'])!,
      flags: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}flags'])!,
      tagsJson: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}tags_json'])!,
      renderPassesJson: const StringType().mapFromDatabaseResponse(
          data['${effectivePrefix}render_passes_json'])!,
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['user_id'] = Variable<String>(userId);
    map['version'] = Variable<String>(version);
    map['name'] = Variable<String>(name);
    map['date'] = Variable<DateTime>(date);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String?>(description);
    }
    map['views'] = Variable<int>(views);
    map['likes'] = Variable<int>(likes);
    map['privacy'] = Variable<String>(privacy);
    map['flags'] = Variable<int>(flags);
    map['tags_json'] = Variable<String>(tagsJson);
    map['render_passes_json'] = Variable<String>(renderPassesJson);
    return map;
  }

  ShaderTableCompanion toCompanion(bool nullToAbsent) {
    return ShaderTableCompanion(
      id: Value(id),
      userId: Value(userId),
      version: Value(version),
      name: Value(name),
      date: Value(date),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      views: Value(views),
      likes: Value(likes),
      privacy: Value(privacy),
      flags: Value(flags),
      tagsJson: Value(tagsJson),
      renderPassesJson: Value(renderPassesJson),
    );
  }

  factory ShaderEntry.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return ShaderEntry(
      id: serializer.fromJson<String>(json['id']),
      userId: serializer.fromJson<String>(json['userId']),
      version: serializer.fromJson<String>(json['version']),
      name: serializer.fromJson<String>(json['name']),
      date: serializer.fromJson<DateTime>(json['date']),
      description: serializer.fromJson<String?>(json['description']),
      views: serializer.fromJson<int>(json['views']),
      likes: serializer.fromJson<int>(json['likes']),
      privacy: serializer.fromJson<String>(json['privacy']),
      flags: serializer.fromJson<int>(json['flags']),
      tagsJson: serializer.fromJson<String>(json['tagsJson']),
      renderPassesJson: serializer.fromJson<String>(json['renderPassesJson']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'userId': serializer.toJson<String>(userId),
      'version': serializer.toJson<String>(version),
      'name': serializer.toJson<String>(name),
      'date': serializer.toJson<DateTime>(date),
      'description': serializer.toJson<String?>(description),
      'views': serializer.toJson<int>(views),
      'likes': serializer.toJson<int>(likes),
      'privacy': serializer.toJson<String>(privacy),
      'flags': serializer.toJson<int>(flags),
      'tagsJson': serializer.toJson<String>(tagsJson),
      'renderPassesJson': serializer.toJson<String>(renderPassesJson),
    };
  }

  ShaderEntry copyWith(
          {String? id,
          String? userId,
          String? version,
          String? name,
          DateTime? date,
          String? description,
          int? views,
          int? likes,
          String? privacy,
          int? flags,
          String? tagsJson,
          String? renderPassesJson}) =>
      ShaderEntry(
        id: id ?? this.id,
        userId: userId ?? this.userId,
        version: version ?? this.version,
        name: name ?? this.name,
        date: date ?? this.date,
        description: description ?? this.description,
        views: views ?? this.views,
        likes: likes ?? this.likes,
        privacy: privacy ?? this.privacy,
        flags: flags ?? this.flags,
        tagsJson: tagsJson ?? this.tagsJson,
        renderPassesJson: renderPassesJson ?? this.renderPassesJson,
      );
  @override
  String toString() {
    return (StringBuffer('ShaderEntry(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('version: $version, ')
          ..write('name: $name, ')
          ..write('date: $date, ')
          ..write('description: $description, ')
          ..write('views: $views, ')
          ..write('likes: $likes, ')
          ..write('privacy: $privacy, ')
          ..write('flags: $flags, ')
          ..write('tagsJson: $tagsJson, ')
          ..write('renderPassesJson: $renderPassesJson')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(
      id.hashCode,
      $mrjc(
          userId.hashCode,
          $mrjc(
              version.hashCode,
              $mrjc(
                  name.hashCode,
                  $mrjc(
                      date.hashCode,
                      $mrjc(
                          description.hashCode,
                          $mrjc(
                              views.hashCode,
                              $mrjc(
                                  likes.hashCode,
                                  $mrjc(
                                      privacy.hashCode,
                                      $mrjc(
                                          flags.hashCode,
                                          $mrjc(
                                              tagsJson.hashCode,
                                              renderPassesJson
                                                  .hashCode))))))))))));
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ShaderEntry &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.version == this.version &&
          other.name == this.name &&
          other.date == this.date &&
          other.description == this.description &&
          other.views == this.views &&
          other.likes == this.likes &&
          other.privacy == this.privacy &&
          other.flags == this.flags &&
          other.tagsJson == this.tagsJson &&
          other.renderPassesJson == this.renderPassesJson);
}

class ShaderTableCompanion extends UpdateCompanion<ShaderEntry> {
  final Value<String> id;
  final Value<String> userId;
  final Value<String> version;
  final Value<String> name;
  final Value<DateTime> date;
  final Value<String?> description;
  final Value<int> views;
  final Value<int> likes;
  final Value<String> privacy;
  final Value<int> flags;
  final Value<String> tagsJson;
  final Value<String> renderPassesJson;
  const ShaderTableCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.version = const Value.absent(),
    this.name = const Value.absent(),
    this.date = const Value.absent(),
    this.description = const Value.absent(),
    this.views = const Value.absent(),
    this.likes = const Value.absent(),
    this.privacy = const Value.absent(),
    this.flags = const Value.absent(),
    this.tagsJson = const Value.absent(),
    this.renderPassesJson = const Value.absent(),
  });
  ShaderTableCompanion.insert({
    required String id,
    required String userId,
    required String version,
    required String name,
    required DateTime date,
    this.description = const Value.absent(),
    this.views = const Value.absent(),
    this.likes = const Value.absent(),
    required String privacy,
    this.flags = const Value.absent(),
    this.tagsJson = const Value.absent(),
    required String renderPassesJson,
  })  : id = Value(id),
        userId = Value(userId),
        version = Value(version),
        name = Value(name),
        date = Value(date),
        privacy = Value(privacy),
        renderPassesJson = Value(renderPassesJson);
  static Insertable<ShaderEntry> custom({
    Expression<String>? id,
    Expression<String>? userId,
    Expression<String>? version,
    Expression<String>? name,
    Expression<DateTime>? date,
    Expression<String?>? description,
    Expression<int>? views,
    Expression<int>? likes,
    Expression<String>? privacy,
    Expression<int>? flags,
    Expression<String>? tagsJson,
    Expression<String>? renderPassesJson,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (version != null) 'version': version,
      if (name != null) 'name': name,
      if (date != null) 'date': date,
      if (description != null) 'description': description,
      if (views != null) 'views': views,
      if (likes != null) 'likes': likes,
      if (privacy != null) 'privacy': privacy,
      if (flags != null) 'flags': flags,
      if (tagsJson != null) 'tags_json': tagsJson,
      if (renderPassesJson != null) 'render_passes_json': renderPassesJson,
    });
  }

  ShaderTableCompanion copyWith(
      {Value<String>? id,
      Value<String>? userId,
      Value<String>? version,
      Value<String>? name,
      Value<DateTime>? date,
      Value<String?>? description,
      Value<int>? views,
      Value<int>? likes,
      Value<String>? privacy,
      Value<int>? flags,
      Value<String>? tagsJson,
      Value<String>? renderPassesJson}) {
    return ShaderTableCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      version: version ?? this.version,
      name: name ?? this.name,
      date: date ?? this.date,
      description: description ?? this.description,
      views: views ?? this.views,
      likes: likes ?? this.likes,
      privacy: privacy ?? this.privacy,
      flags: flags ?? this.flags,
      tagsJson: tagsJson ?? this.tagsJson,
      renderPassesJson: renderPassesJson ?? this.renderPassesJson,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (version.present) {
      map['version'] = Variable<String>(version.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (description.present) {
      map['description'] = Variable<String?>(description.value);
    }
    if (views.present) {
      map['views'] = Variable<int>(views.value);
    }
    if (likes.present) {
      map['likes'] = Variable<int>(likes.value);
    }
    if (privacy.present) {
      map['privacy'] = Variable<String>(privacy.value);
    }
    if (flags.present) {
      map['flags'] = Variable<int>(flags.value);
    }
    if (tagsJson.present) {
      map['tags_json'] = Variable<String>(tagsJson.value);
    }
    if (renderPassesJson.present) {
      map['render_passes_json'] = Variable<String>(renderPassesJson.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ShaderTableCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('version: $version, ')
          ..write('name: $name, ')
          ..write('date: $date, ')
          ..write('description: $description, ')
          ..write('views: $views, ')
          ..write('likes: $likes, ')
          ..write('privacy: $privacy, ')
          ..write('flags: $flags, ')
          ..write('tagsJson: $tagsJson, ')
          ..write('renderPassesJson: $renderPassesJson')
          ..write(')'))
        .toString();
  }
}

class $ShaderTableTable extends ShaderTable
    with TableInfo<$ShaderTableTable, ShaderEntry> {
  final GeneratedDatabase _db;
  final String? _alias;
  $ShaderTableTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumn<String?> id = GeneratedColumn<String?>(
      'id', aliasedName, false,
      typeName: 'TEXT', requiredDuringInsert: true);
  final VerificationMeta _userIdMeta = const VerificationMeta('userId');
  late final GeneratedColumn<String?> userId = GeneratedColumn<String?>(
      'user_id', aliasedName, false,
      typeName: 'TEXT', requiredDuringInsert: true);
  final VerificationMeta _versionMeta = const VerificationMeta('version');
  late final GeneratedColumn<String?> version = GeneratedColumn<String?>(
      'version', aliasedName, false,
      typeName: 'TEXT', requiredDuringInsert: true);
  final VerificationMeta _nameMeta = const VerificationMeta('name');
  late final GeneratedColumn<String?> name = GeneratedColumn<String?>(
      'name', aliasedName, false,
      typeName: 'TEXT', requiredDuringInsert: true);
  final VerificationMeta _dateMeta = const VerificationMeta('date');
  late final GeneratedColumn<DateTime?> date = GeneratedColumn<DateTime?>(
      'date', aliasedName, false,
      typeName: 'INTEGER', requiredDuringInsert: true);
  final VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  late final GeneratedColumn<String?> description = GeneratedColumn<String?>(
      'description', aliasedName, true,
      typeName: 'TEXT', requiredDuringInsert: false);
  final VerificationMeta _viewsMeta = const VerificationMeta('views');
  late final GeneratedColumn<int?> views = GeneratedColumn<int?>(
      'views', aliasedName, false,
      typeName: 'INTEGER',
      requiredDuringInsert: false,
      defaultValue: Constant(0));
  final VerificationMeta _likesMeta = const VerificationMeta('likes');
  late final GeneratedColumn<int?> likes = GeneratedColumn<int?>(
      'likes', aliasedName, false,
      typeName: 'INTEGER',
      requiredDuringInsert: false,
      defaultValue: Constant(0));
  final VerificationMeta _privacyMeta = const VerificationMeta('privacy');
  late final GeneratedColumn<String?> privacy = GeneratedColumn<String?>(
      'privacy', aliasedName, false,
      typeName: 'TEXT', requiredDuringInsert: true);
  final VerificationMeta _flagsMeta = const VerificationMeta('flags');
  late final GeneratedColumn<int?> flags = GeneratedColumn<int?>(
      'flags', aliasedName, false,
      typeName: 'INTEGER',
      requiredDuringInsert: false,
      defaultValue: Constant(0));
  final VerificationMeta _tagsJsonMeta = const VerificationMeta('tagsJson');
  late final GeneratedColumn<String?> tagsJson = GeneratedColumn<String?>(
      'tags_json', aliasedName, false,
      typeName: 'TEXT',
      requiredDuringInsert: false,
      defaultValue: Constant('[]'));
  final VerificationMeta _renderPassesJsonMeta =
      const VerificationMeta('renderPassesJson');
  late final GeneratedColumn<String?> renderPassesJson =
      GeneratedColumn<String?>('render_passes_json', aliasedName, false,
          typeName: 'TEXT', requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        userId,
        version,
        name,
        date,
        description,
        views,
        likes,
        privacy,
        flags,
        tagsJson,
        renderPassesJson
      ];
  @override
  String get aliasedName => _alias ?? 'Shader';
  @override
  String get actualTableName => 'Shader';
  @override
  VerificationContext validateIntegrity(Insertable<ShaderEntry> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta,
          userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta));
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('version')) {
      context.handle(_versionMeta,
          version.isAcceptableOrUnknown(data['version']!, _versionMeta));
    } else if (isInserting) {
      context.missing(_versionMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
          _dateMeta, date.isAcceptableOrUnknown(data['date']!, _dateMeta));
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    }
    if (data.containsKey('views')) {
      context.handle(
          _viewsMeta, views.isAcceptableOrUnknown(data['views']!, _viewsMeta));
    }
    if (data.containsKey('likes')) {
      context.handle(
          _likesMeta, likes.isAcceptableOrUnknown(data['likes']!, _likesMeta));
    }
    if (data.containsKey('privacy')) {
      context.handle(_privacyMeta,
          privacy.isAcceptableOrUnknown(data['privacy']!, _privacyMeta));
    } else if (isInserting) {
      context.missing(_privacyMeta);
    }
    if (data.containsKey('flags')) {
      context.handle(
          _flagsMeta, flags.isAcceptableOrUnknown(data['flags']!, _flagsMeta));
    }
    if (data.containsKey('tags_json')) {
      context.handle(_tagsJsonMeta,
          tagsJson.isAcceptableOrUnknown(data['tags_json']!, _tagsJsonMeta));
    }
    if (data.containsKey('render_passes_json')) {
      context.handle(
          _renderPassesJsonMeta,
          renderPassesJson.isAcceptableOrUnknown(
              data['render_passes_json']!, _renderPassesJsonMeta));
    } else if (isInserting) {
      context.missing(_renderPassesJsonMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ShaderEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    return ShaderEntry.fromData(data, _db,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $ShaderTableTable createAlias(String alias) {
    return $ShaderTableTable(_db, alias);
  }
}

class CommentEntry extends DataClass implements Insertable<CommentEntry> {
  /// The comment id
  final String id;

  /// The shader id
  final String shaderId;

  /// The user id
  final String userId;

  /// An optional user picture
  final String? picture;

  /// The date/time of the comment
  final DateTime date;

  /// The comment
  final String comment;

  /// If this comment should be not appear
  final bool hidden;
  CommentEntry(
      {required this.id,
      required this.shaderId,
      required this.userId,
      this.picture,
      required this.date,
      required this.comment,
      required this.hidden});
  factory CommentEntry.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return CommentEntry(
      id: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}id'])!,
      shaderId: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}shader_id'])!,
      userId: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}user_id'])!,
      picture: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}picture']),
      date: const DateTimeType()
          .mapFromDatabaseResponse(data['${effectivePrefix}date'])!,
      comment: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}comment'])!,
      hidden: const BoolType()
          .mapFromDatabaseResponse(data['${effectivePrefix}hidden'])!,
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['shader_id'] = Variable<String>(shaderId);
    map['user_id'] = Variable<String>(userId);
    if (!nullToAbsent || picture != null) {
      map['picture'] = Variable<String?>(picture);
    }
    map['date'] = Variable<DateTime>(date);
    map['comment'] = Variable<String>(comment);
    map['hidden'] = Variable<bool>(hidden);
    return map;
  }

  CommentTableCompanion toCompanion(bool nullToAbsent) {
    return CommentTableCompanion(
      id: Value(id),
      shaderId: Value(shaderId),
      userId: Value(userId),
      picture: picture == null && nullToAbsent
          ? const Value.absent()
          : Value(picture),
      date: Value(date),
      comment: Value(comment),
      hidden: Value(hidden),
    );
  }

  factory CommentEntry.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return CommentEntry(
      id: serializer.fromJson<String>(json['id']),
      shaderId: serializer.fromJson<String>(json['shaderId']),
      userId: serializer.fromJson<String>(json['userId']),
      picture: serializer.fromJson<String?>(json['picture']),
      date: serializer.fromJson<DateTime>(json['date']),
      comment: serializer.fromJson<String>(json['comment']),
      hidden: serializer.fromJson<bool>(json['hidden']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'shaderId': serializer.toJson<String>(shaderId),
      'userId': serializer.toJson<String>(userId),
      'picture': serializer.toJson<String?>(picture),
      'date': serializer.toJson<DateTime>(date),
      'comment': serializer.toJson<String>(comment),
      'hidden': serializer.toJson<bool>(hidden),
    };
  }

  CommentEntry copyWith(
          {String? id,
          String? shaderId,
          String? userId,
          String? picture,
          DateTime? date,
          String? comment,
          bool? hidden}) =>
      CommentEntry(
        id: id ?? this.id,
        shaderId: shaderId ?? this.shaderId,
        userId: userId ?? this.userId,
        picture: picture ?? this.picture,
        date: date ?? this.date,
        comment: comment ?? this.comment,
        hidden: hidden ?? this.hidden,
      );
  @override
  String toString() {
    return (StringBuffer('CommentEntry(')
          ..write('id: $id, ')
          ..write('shaderId: $shaderId, ')
          ..write('userId: $userId, ')
          ..write('picture: $picture, ')
          ..write('date: $date, ')
          ..write('comment: $comment, ')
          ..write('hidden: $hidden')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(
      id.hashCode,
      $mrjc(
          shaderId.hashCode,
          $mrjc(
              userId.hashCode,
              $mrjc(
                  picture.hashCode,
                  $mrjc(date.hashCode,
                      $mrjc(comment.hashCode, hidden.hashCode)))))));
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CommentEntry &&
          other.id == this.id &&
          other.shaderId == this.shaderId &&
          other.userId == this.userId &&
          other.picture == this.picture &&
          other.date == this.date &&
          other.comment == this.comment &&
          other.hidden == this.hidden);
}

class CommentTableCompanion extends UpdateCompanion<CommentEntry> {
  final Value<String> id;
  final Value<String> shaderId;
  final Value<String> userId;
  final Value<String?> picture;
  final Value<DateTime> date;
  final Value<String> comment;
  final Value<bool> hidden;
  const CommentTableCompanion({
    this.id = const Value.absent(),
    this.shaderId = const Value.absent(),
    this.userId = const Value.absent(),
    this.picture = const Value.absent(),
    this.date = const Value.absent(),
    this.comment = const Value.absent(),
    this.hidden = const Value.absent(),
  });
  CommentTableCompanion.insert({
    required String id,
    required String shaderId,
    required String userId,
    this.picture = const Value.absent(),
    required DateTime date,
    required String comment,
    this.hidden = const Value.absent(),
  })  : id = Value(id),
        shaderId = Value(shaderId),
        userId = Value(userId),
        date = Value(date),
        comment = Value(comment);
  static Insertable<CommentEntry> custom({
    Expression<String>? id,
    Expression<String>? shaderId,
    Expression<String>? userId,
    Expression<String?>? picture,
    Expression<DateTime>? date,
    Expression<String>? comment,
    Expression<bool>? hidden,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (shaderId != null) 'shader_id': shaderId,
      if (userId != null) 'user_id': userId,
      if (picture != null) 'picture': picture,
      if (date != null) 'date': date,
      if (comment != null) 'comment': comment,
      if (hidden != null) 'hidden': hidden,
    });
  }

  CommentTableCompanion copyWith(
      {Value<String>? id,
      Value<String>? shaderId,
      Value<String>? userId,
      Value<String?>? picture,
      Value<DateTime>? date,
      Value<String>? comment,
      Value<bool>? hidden}) {
    return CommentTableCompanion(
      id: id ?? this.id,
      shaderId: shaderId ?? this.shaderId,
      userId: userId ?? this.userId,
      picture: picture ?? this.picture,
      date: date ?? this.date,
      comment: comment ?? this.comment,
      hidden: hidden ?? this.hidden,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (shaderId.present) {
      map['shader_id'] = Variable<String>(shaderId.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (picture.present) {
      map['picture'] = Variable<String?>(picture.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (comment.present) {
      map['comment'] = Variable<String>(comment.value);
    }
    if (hidden.present) {
      map['hidden'] = Variable<bool>(hidden.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CommentTableCompanion(')
          ..write('id: $id, ')
          ..write('shaderId: $shaderId, ')
          ..write('userId: $userId, ')
          ..write('picture: $picture, ')
          ..write('date: $date, ')
          ..write('comment: $comment, ')
          ..write('hidden: $hidden')
          ..write(')'))
        .toString();
  }
}

class $CommentTableTable extends CommentTable
    with TableInfo<$CommentTableTable, CommentEntry> {
  final GeneratedDatabase _db;
  final String? _alias;
  $CommentTableTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumn<String?> id = GeneratedColumn<String?>(
      'id', aliasedName, false,
      typeName: 'TEXT', requiredDuringInsert: true);
  final VerificationMeta _shaderIdMeta = const VerificationMeta('shaderId');
  late final GeneratedColumn<String?> shaderId = GeneratedColumn<String?>(
      'shader_id', aliasedName, false,
      typeName: 'TEXT',
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL REFERENCES Shader(id) ON DELETE CASCADE');
  final VerificationMeta _userIdMeta = const VerificationMeta('userId');
  late final GeneratedColumn<String?> userId = GeneratedColumn<String?>(
      'user_id', aliasedName, false,
      typeName: 'TEXT', requiredDuringInsert: true);
  final VerificationMeta _pictureMeta = const VerificationMeta('picture');
  late final GeneratedColumn<String?> picture = GeneratedColumn<String?>(
      'picture', aliasedName, true,
      typeName: 'TEXT', requiredDuringInsert: false);
  final VerificationMeta _dateMeta = const VerificationMeta('date');
  late final GeneratedColumn<DateTime?> date = GeneratedColumn<DateTime?>(
      'date', aliasedName, false,
      typeName: 'INTEGER', requiredDuringInsert: true);
  final VerificationMeta _commentMeta = const VerificationMeta('comment');
  late final GeneratedColumn<String?> comment = GeneratedColumn<String?>(
      'comment', aliasedName, false,
      typeName: 'TEXT', requiredDuringInsert: true);
  final VerificationMeta _hiddenMeta = const VerificationMeta('hidden');
  late final GeneratedColumn<bool?> hidden = GeneratedColumn<bool?>(
      'hidden', aliasedName, false,
      typeName: 'INTEGER',
      requiredDuringInsert: false,
      defaultConstraints: 'CHECK (hidden IN (0, 1))',
      defaultValue: const Constant(false));
  @override
  List<GeneratedColumn> get $columns =>
      [id, shaderId, userId, picture, date, comment, hidden];
  @override
  String get aliasedName => _alias ?? 'Comment';
  @override
  String get actualTableName => 'Comment';
  @override
  VerificationContext validateIntegrity(Insertable<CommentEntry> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('shader_id')) {
      context.handle(_shaderIdMeta,
          shaderId.isAcceptableOrUnknown(data['shader_id']!, _shaderIdMeta));
    } else if (isInserting) {
      context.missing(_shaderIdMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta,
          userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta));
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('picture')) {
      context.handle(_pictureMeta,
          picture.isAcceptableOrUnknown(data['picture']!, _pictureMeta));
    }
    if (data.containsKey('date')) {
      context.handle(
          _dateMeta, date.isAcceptableOrUnknown(data['date']!, _dateMeta));
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('comment')) {
      context.handle(_commentMeta,
          comment.isAcceptableOrUnknown(data['comment']!, _commentMeta));
    } else if (isInserting) {
      context.missing(_commentMeta);
    }
    if (data.containsKey('hidden')) {
      context.handle(_hiddenMeta,
          hidden.isAcceptableOrUnknown(data['hidden']!, _hiddenMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CommentEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    return CommentEntry.fromData(data, _db,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $CommentTableTable createAlias(String alias) {
    return $CommentTableTable(_db, alias);
  }
}

class PlaylistEntry extends DataClass implements Insertable<PlaylistEntry> {
  /// The id of the playlist
  final String id;

  /// The id of the user that created the playlist
  final String userId;

  /// The name of the playlist
  final String name;

  /// The description of the playlist
  final String description;
  PlaylistEntry(
      {required this.id,
      required this.userId,
      required this.name,
      required this.description});
  factory PlaylistEntry.fromData(
      Map<String, dynamic> data, GeneratedDatabase db,
      {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return PlaylistEntry(
      id: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}id'])!,
      userId: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}user_id'])!,
      name: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}name'])!,
      description: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}description'])!,
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['user_id'] = Variable<String>(userId);
    map['name'] = Variable<String>(name);
    map['description'] = Variable<String>(description);
    return map;
  }

  PlaylistTableCompanion toCompanion(bool nullToAbsent) {
    return PlaylistTableCompanion(
      id: Value(id),
      userId: Value(userId),
      name: Value(name),
      description: Value(description),
    );
  }

  factory PlaylistEntry.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return PlaylistEntry(
      id: serializer.fromJson<String>(json['id']),
      userId: serializer.fromJson<String>(json['userId']),
      name: serializer.fromJson<String>(json['name']),
      description: serializer.fromJson<String>(json['description']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'userId': serializer.toJson<String>(userId),
      'name': serializer.toJson<String>(name),
      'description': serializer.toJson<String>(description),
    };
  }

  PlaylistEntry copyWith(
          {String? id, String? userId, String? name, String? description}) =>
      PlaylistEntry(
        id: id ?? this.id,
        userId: userId ?? this.userId,
        name: name ?? this.name,
        description: description ?? this.description,
      );
  @override
  String toString() {
    return (StringBuffer('PlaylistEntry(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('name: $name, ')
          ..write('description: $description')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(id.hashCode,
      $mrjc(userId.hashCode, $mrjc(name.hashCode, description.hashCode))));
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PlaylistEntry &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.name == this.name &&
          other.description == this.description);
}

class PlaylistTableCompanion extends UpdateCompanion<PlaylistEntry> {
  final Value<String> id;
  final Value<String> userId;
  final Value<String> name;
  final Value<String> description;
  const PlaylistTableCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.name = const Value.absent(),
    this.description = const Value.absent(),
  });
  PlaylistTableCompanion.insert({
    required String id,
    required String userId,
    required String name,
    required String description,
  })  : id = Value(id),
        userId = Value(userId),
        name = Value(name),
        description = Value(description);
  static Insertable<PlaylistEntry> custom({
    Expression<String>? id,
    Expression<String>? userId,
    Expression<String>? name,
    Expression<String>? description,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
    });
  }

  PlaylistTableCompanion copyWith(
      {Value<String>? id,
      Value<String>? userId,
      Value<String>? name,
      Value<String>? description}) {
    return PlaylistTableCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      description: description ?? this.description,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PlaylistTableCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('name: $name, ')
          ..write('description: $description')
          ..write(')'))
        .toString();
  }
}

class $PlaylistTableTable extends PlaylistTable
    with TableInfo<$PlaylistTableTable, PlaylistEntry> {
  final GeneratedDatabase _db;
  final String? _alias;
  $PlaylistTableTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumn<String?> id = GeneratedColumn<String?>(
      'id', aliasedName, false,
      typeName: 'TEXT', requiredDuringInsert: true);
  final VerificationMeta _userIdMeta = const VerificationMeta('userId');
  late final GeneratedColumn<String?> userId = GeneratedColumn<String?>(
      'user_id', aliasedName, false,
      typeName: 'TEXT', requiredDuringInsert: true);
  final VerificationMeta _nameMeta = const VerificationMeta('name');
  late final GeneratedColumn<String?> name = GeneratedColumn<String?>(
      'name', aliasedName, false,
      typeName: 'TEXT', requiredDuringInsert: true);
  final VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  late final GeneratedColumn<String?> description = GeneratedColumn<String?>(
      'description', aliasedName, false,
      typeName: 'TEXT', requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, userId, name, description];
  @override
  String get aliasedName => _alias ?? 'Playlist';
  @override
  String get actualTableName => 'Playlist';
  @override
  VerificationContext validateIntegrity(Insertable<PlaylistEntry> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta,
          userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta));
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    } else if (isInserting) {
      context.missing(_descriptionMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PlaylistEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    return PlaylistEntry.fromData(data, _db,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $PlaylistTableTable createAlias(String alias) {
    return $PlaylistTableTable(_db, alias);
  }
}

class PlaylistShaderEntry extends DataClass
    implements Insertable<PlaylistShaderEntry> {
  /// The playlist id
  final String playlistId;

  /// The shader id
  final String shaderId;

  /// The order of the shader on the playlist
  final int order;
  PlaylistShaderEntry(
      {required this.playlistId, required this.shaderId, required this.order});
  factory PlaylistShaderEntry.fromData(
      Map<String, dynamic> data, GeneratedDatabase db,
      {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return PlaylistShaderEntry(
      playlistId: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}playlist_id'])!,
      shaderId: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}shader_id'])!,
      order: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}order'])!,
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['playlist_id'] = Variable<String>(playlistId);
    map['shader_id'] = Variable<String>(shaderId);
    map['order'] = Variable<int>(order);
    return map;
  }

  PlaylistShaderTableCompanion toCompanion(bool nullToAbsent) {
    return PlaylistShaderTableCompanion(
      playlistId: Value(playlistId),
      shaderId: Value(shaderId),
      order: Value(order),
    );
  }

  factory PlaylistShaderEntry.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return PlaylistShaderEntry(
      playlistId: serializer.fromJson<String>(json['playlistId']),
      shaderId: serializer.fromJson<String>(json['shaderId']),
      order: serializer.fromJson<int>(json['order']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'playlistId': serializer.toJson<String>(playlistId),
      'shaderId': serializer.toJson<String>(shaderId),
      'order': serializer.toJson<int>(order),
    };
  }

  PlaylistShaderEntry copyWith(
          {String? playlistId, String? shaderId, int? order}) =>
      PlaylistShaderEntry(
        playlistId: playlistId ?? this.playlistId,
        shaderId: shaderId ?? this.shaderId,
        order: order ?? this.order,
      );
  @override
  String toString() {
    return (StringBuffer('PlaylistShaderEntry(')
          ..write('playlistId: $playlistId, ')
          ..write('shaderId: $shaderId, ')
          ..write('order: $order')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf(
      $mrjc(playlistId.hashCode, $mrjc(shaderId.hashCode, order.hashCode)));
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PlaylistShaderEntry &&
          other.playlistId == this.playlistId &&
          other.shaderId == this.shaderId &&
          other.order == this.order);
}

class PlaylistShaderTableCompanion
    extends UpdateCompanion<PlaylistShaderEntry> {
  final Value<String> playlistId;
  final Value<String> shaderId;
  final Value<int> order;
  const PlaylistShaderTableCompanion({
    this.playlistId = const Value.absent(),
    this.shaderId = const Value.absent(),
    this.order = const Value.absent(),
  });
  PlaylistShaderTableCompanion.insert({
    required String playlistId,
    required String shaderId,
    required int order,
  })  : playlistId = Value(playlistId),
        shaderId = Value(shaderId),
        order = Value(order);
  static Insertable<PlaylistShaderEntry> custom({
    Expression<String>? playlistId,
    Expression<String>? shaderId,
    Expression<int>? order,
  }) {
    return RawValuesInsertable({
      if (playlistId != null) 'playlist_id': playlistId,
      if (shaderId != null) 'shader_id': shaderId,
      if (order != null) 'order': order,
    });
  }

  PlaylistShaderTableCompanion copyWith(
      {Value<String>? playlistId, Value<String>? shaderId, Value<int>? order}) {
    return PlaylistShaderTableCompanion(
      playlistId: playlistId ?? this.playlistId,
      shaderId: shaderId ?? this.shaderId,
      order: order ?? this.order,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (playlistId.present) {
      map['playlist_id'] = Variable<String>(playlistId.value);
    }
    if (shaderId.present) {
      map['shader_id'] = Variable<String>(shaderId.value);
    }
    if (order.present) {
      map['order'] = Variable<int>(order.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PlaylistShaderTableCompanion(')
          ..write('playlistId: $playlistId, ')
          ..write('shaderId: $shaderId, ')
          ..write('order: $order')
          ..write(')'))
        .toString();
  }
}

class $PlaylistShaderTableTable extends PlaylistShaderTable
    with TableInfo<$PlaylistShaderTableTable, PlaylistShaderEntry> {
  final GeneratedDatabase _db;
  final String? _alias;
  $PlaylistShaderTableTable(this._db, [this._alias]);
  final VerificationMeta _playlistIdMeta = const VerificationMeta('playlistId');
  late final GeneratedColumn<String?> playlistId = GeneratedColumn<String?>(
      'playlist_id', aliasedName, false,
      typeName: 'TEXT',
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL REFERENCES Playlist(id) ON DELETE CASCADE');
  final VerificationMeta _shaderIdMeta = const VerificationMeta('shaderId');
  late final GeneratedColumn<String?> shaderId = GeneratedColumn<String?>(
      'shader_id', aliasedName, false,
      typeName: 'TEXT',
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL REFERENCES Shader(id) ON DELETE CASCADE');
  final VerificationMeta _orderMeta = const VerificationMeta('order');
  late final GeneratedColumn<int?> order = GeneratedColumn<int?>(
      'order', aliasedName, false,
      typeName: 'INTEGER', requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [playlistId, shaderId, order];
  @override
  String get aliasedName => _alias ?? 'PlaylistShader';
  @override
  String get actualTableName => 'PlaylistShader';
  @override
  VerificationContext validateIntegrity(
      Insertable<PlaylistShaderEntry> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('playlist_id')) {
      context.handle(
          _playlistIdMeta,
          playlistId.isAcceptableOrUnknown(
              data['playlist_id']!, _playlistIdMeta));
    } else if (isInserting) {
      context.missing(_playlistIdMeta);
    }
    if (data.containsKey('shader_id')) {
      context.handle(_shaderIdMeta,
          shaderId.isAcceptableOrUnknown(data['shader_id']!, _shaderIdMeta));
    } else if (isInserting) {
      context.missing(_shaderIdMeta);
    }
    if (data.containsKey('order')) {
      context.handle(
          _orderMeta, order.isAcceptableOrUnknown(data['order']!, _orderMeta));
    } else if (isInserting) {
      context.missing(_orderMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {playlistId, shaderId};
  @override
  PlaylistShaderEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    return PlaylistShaderEntry.fromData(data, _db,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $PlaylistShaderTableTable createAlias(String alias) {
    return $PlaylistShaderTableTable(_db, alias);
  }
}

abstract class _$MoorStore extends GeneratedDatabase {
  _$MoorStore(QueryExecutor e) : super(SqlTypeSystem.defaultInstance, e);
  late final $UserTableTable userTable = $UserTableTable(this);
  late final $ShaderTableTable shaderTable = $ShaderTableTable(this);
  late final $CommentTableTable commentTable = $CommentTableTable(this);
  late final $PlaylistTableTable playlistTable = $PlaylistTableTable(this);
  late final $PlaylistShaderTableTable playlistShaderTable =
      $PlaylistShaderTableTable(this);
  late final UserDao userDao = UserDao(this as MoorStore);
  late final ShaderDao shaderDao = ShaderDao(this as MoorStore);
  late final CommentDao commentDao = CommentDao(this as MoorStore);
  late final PlaylistDao playlistDao = PlaylistDao(this as MoorStore);
  @override
  Iterable<TableInfo> get allTables => allSchemaEntities.whereType<TableInfo>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        userTable,
        shaderTable,
        commentTable,
        playlistTable,
        playlistShaderTable
      ];
}
