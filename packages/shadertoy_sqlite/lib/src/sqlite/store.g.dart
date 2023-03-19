// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'store.dart';

// ignore_for_file: type=lint
class $UserTableTable extends UserTable
    with TableInfo<$UserTableTable, UserEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UserTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _pictureMeta =
      const VerificationMeta('picture');
  @override
  late final GeneratedColumn<String> picture = GeneratedColumn<String>(
      'picture', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _memberSinceMeta =
      const VerificationMeta('memberSince');
  @override
  late final GeneratedColumn<DateTime> memberSince = GeneratedColumn<DateTime>(
      'member_since', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _followingMeta =
      const VerificationMeta('following');
  @override
  late final GeneratedColumn<int> following = GeneratedColumn<int>(
      'following', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: Constant(0));
  static const VerificationMeta _followersMeta =
      const VerificationMeta('followers');
  @override
  late final GeneratedColumn<int> followers = GeneratedColumn<int>(
      'followers', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: Constant(0));
  static const VerificationMeta _aboutMeta = const VerificationMeta('about');
  @override
  late final GeneratedColumn<String> about = GeneratedColumn<String>(
      'about', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
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
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UserEntry(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      picture: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}picture']),
      memberSince: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}member_since'])!,
      following: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}following'])!,
      followers: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}followers'])!,
      about: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}about']),
    );
  }

  @override
  $UserTableTable createAlias(String alias) {
    return $UserTableTable(attachedDatabase, alias);
  }
}

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
  const UserEntry(
      {required this.id,
      this.picture,
      required this.memberSince,
      required this.following,
      required this.followers,
      this.about});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || picture != null) {
      map['picture'] = Variable<String>(picture);
    }
    map['member_since'] = Variable<DateTime>(memberSince);
    map['following'] = Variable<int>(following);
    map['followers'] = Variable<int>(followers);
    if (!nullToAbsent || about != null) {
      map['about'] = Variable<String>(about);
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
    serializer ??= driftRuntimeOptions.defaultSerializer;
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
    serializer ??= driftRuntimeOptions.defaultSerializer;
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
          Value<String?> picture = const Value.absent(),
          DateTime? memberSince,
          int? following,
          int? followers,
          Value<String?> about = const Value.absent()}) =>
      UserEntry(
        id: id ?? this.id,
        picture: picture.present ? picture.value : this.picture,
        memberSince: memberSince ?? this.memberSince,
        following: following ?? this.following,
        followers: followers ?? this.followers,
        about: about.present ? about.value : this.about,
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
  int get hashCode =>
      Object.hash(id, picture, memberSince, following, followers, about);
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
    Expression<String>? picture,
    Expression<DateTime>? memberSince,
    Expression<int>? following,
    Expression<int>? followers,
    Expression<String>? about,
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
      map['picture'] = Variable<String>(picture.value);
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
      map['about'] = Variable<String>(about.value);
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

class $ShaderTableTable extends ShaderTable
    with TableInfo<$ShaderTableTable, ShaderEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ShaderTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
      'user_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _versionMeta =
      const VerificationMeta('version');
  @override
  late final GeneratedColumn<String> version = GeneratedColumn<String>(
      'version', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
      'date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _viewsMeta = const VerificationMeta('views');
  @override
  late final GeneratedColumn<int> views = GeneratedColumn<int>(
      'views', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: Constant(0));
  static const VerificationMeta _likesMeta = const VerificationMeta('likes');
  @override
  late final GeneratedColumn<int> likes = GeneratedColumn<int>(
      'likes', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: Constant(0));
  static const VerificationMeta _privacyMeta =
      const VerificationMeta('privacy');
  @override
  late final GeneratedColumn<String> privacy = GeneratedColumn<String>(
      'privacy', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _flagsMeta = const VerificationMeta('flags');
  @override
  late final GeneratedColumn<int> flags = GeneratedColumn<int>(
      'flags', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: Constant(0));
  static const VerificationMeta _tagsJsonMeta =
      const VerificationMeta('tagsJson');
  @override
  late final GeneratedColumn<String> tagsJson = GeneratedColumn<String>(
      'tags_json', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: Constant('[]'));
  static const VerificationMeta _renderPassesJsonMeta =
      const VerificationMeta('renderPassesJson');
  @override
  late final GeneratedColumn<String> renderPassesJson = GeneratedColumn<String>(
      'render_passes_json', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
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
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ShaderEntry(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      userId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}user_id'])!,
      version: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}version'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      date: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}date'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description']),
      views: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}views'])!,
      likes: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}likes'])!,
      privacy: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}privacy'])!,
      flags: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}flags'])!,
      tagsJson: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}tags_json'])!,
      renderPassesJson: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}render_passes_json'])!,
    );
  }

  @override
  $ShaderTableTable createAlias(String alias) {
    return $ShaderTableTable(attachedDatabase, alias);
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
  const ShaderEntry(
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
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['user_id'] = Variable<String>(userId);
    map['version'] = Variable<String>(version);
    map['name'] = Variable<String>(name);
    map['date'] = Variable<DateTime>(date);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
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
    serializer ??= driftRuntimeOptions.defaultSerializer;
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
    serializer ??= driftRuntimeOptions.defaultSerializer;
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
          Value<String?> description = const Value.absent(),
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
        description: description.present ? description.value : this.description,
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
  int get hashCode => Object.hash(id, userId, version, name, date, description,
      views, likes, privacy, flags, tagsJson, renderPassesJson);
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
    Expression<String>? description,
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
      map['description'] = Variable<String>(description.value);
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

class $CommentTableTable extends CommentTable
    with TableInfo<$CommentTableTable, CommentEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CommentTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _shaderIdMeta =
      const VerificationMeta('shaderId');
  @override
  late final GeneratedColumn<String> shaderId = GeneratedColumn<String>(
      'shader_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES Shader (id) ON DELETE CASCADE'));
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
      'user_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _pictureMeta =
      const VerificationMeta('picture');
  @override
  late final GeneratedColumn<String> picture = GeneratedColumn<String>(
      'picture', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
      'date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _commentMeta =
      const VerificationMeta('comment');
  @override
  late final GeneratedColumn<String> comment = GeneratedColumn<String>(
      'comment', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _hiddenMeta = const VerificationMeta('hidden');
  @override
  late final GeneratedColumn<bool> hidden =
      GeneratedColumn<bool>('hidden', aliasedName, false,
          type: DriftSqlType.bool,
          requiredDuringInsert: false,
          defaultConstraints: GeneratedColumn.constraintsDependsOnDialect({
            SqlDialect.sqlite: 'CHECK ("hidden" IN (0, 1))',
            SqlDialect.mysql: '',
            SqlDialect.postgres: '',
          }),
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
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CommentEntry(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      shaderId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}shader_id'])!,
      userId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}user_id'])!,
      picture: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}picture']),
      date: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}date'])!,
      comment: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}comment'])!,
      hidden: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}hidden'])!,
    );
  }

  @override
  $CommentTableTable createAlias(String alias) {
    return $CommentTableTable(attachedDatabase, alias);
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
  const CommentEntry(
      {required this.id,
      required this.shaderId,
      required this.userId,
      this.picture,
      required this.date,
      required this.comment,
      required this.hidden});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['shader_id'] = Variable<String>(shaderId);
    map['user_id'] = Variable<String>(userId);
    if (!nullToAbsent || picture != null) {
      map['picture'] = Variable<String>(picture);
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
    serializer ??= driftRuntimeOptions.defaultSerializer;
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
    serializer ??= driftRuntimeOptions.defaultSerializer;
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
          Value<String?> picture = const Value.absent(),
          DateTime? date,
          String? comment,
          bool? hidden}) =>
      CommentEntry(
        id: id ?? this.id,
        shaderId: shaderId ?? this.shaderId,
        userId: userId ?? this.userId,
        picture: picture.present ? picture.value : this.picture,
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
  int get hashCode =>
      Object.hash(id, shaderId, userId, picture, date, comment, hidden);
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
    Expression<String>? picture,
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
      map['picture'] = Variable<String>(picture.value);
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

class $PlaylistTableTable extends PlaylistTable
    with TableInfo<$PlaylistTableTable, PlaylistEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PlaylistTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
      'user_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
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
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PlaylistEntry(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      userId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}user_id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description'])!,
    );
  }

  @override
  $PlaylistTableTable createAlias(String alias) {
    return $PlaylistTableTable(attachedDatabase, alias);
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
  const PlaylistEntry(
      {required this.id,
      required this.userId,
      required this.name,
      required this.description});
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
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PlaylistEntry(
      id: serializer.fromJson<String>(json['id']),
      userId: serializer.fromJson<String>(json['userId']),
      name: serializer.fromJson<String>(json['name']),
      description: serializer.fromJson<String>(json['description']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
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
  int get hashCode => Object.hash(id, userId, name, description);
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

class $PlaylistShaderTableTable extends PlaylistShaderTable
    with TableInfo<$PlaylistShaderTableTable, PlaylistShaderEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PlaylistShaderTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _playlistIdMeta =
      const VerificationMeta('playlistId');
  @override
  late final GeneratedColumn<String> playlistId = GeneratedColumn<String>(
      'playlist_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES Playlist (id) ON DELETE CASCADE'));
  static const VerificationMeta _shaderIdMeta =
      const VerificationMeta('shaderId');
  @override
  late final GeneratedColumn<String> shaderId = GeneratedColumn<String>(
      'shader_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES Shader (id) ON DELETE CASCADE'));
  static const VerificationMeta _orderMeta = const VerificationMeta('order');
  @override
  late final GeneratedColumn<int> order = GeneratedColumn<int>(
      'order', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
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
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PlaylistShaderEntry(
      playlistId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}playlist_id'])!,
      shaderId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}shader_id'])!,
      order: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}order'])!,
    );
  }

  @override
  $PlaylistShaderTableTable createAlias(String alias) {
    return $PlaylistShaderTableTable(attachedDatabase, alias);
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
  const PlaylistShaderEntry(
      {required this.playlistId, required this.shaderId, required this.order});
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
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PlaylistShaderEntry(
      playlistId: serializer.fromJson<String>(json['playlistId']),
      shaderId: serializer.fromJson<String>(json['shaderId']),
      order: serializer.fromJson<int>(json['order']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
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
  int get hashCode => Object.hash(playlistId, shaderId, order);
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

class $SyncTableTable extends SyncTable
    with TableInfo<$SyncTableTable, SyncEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SyncTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
      'type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _targetMeta = const VerificationMeta('target');
  @override
  late final GeneratedColumn<String> target = GeneratedColumn<String>(
      'target', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _messageMeta =
      const VerificationMeta('message');
  @override
  late final GeneratedColumn<String> message = GeneratedColumn<String>(
      'message', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _creationTimeMeta =
      const VerificationMeta('creationTime');
  @override
  late final GeneratedColumn<DateTime> creationTime = GeneratedColumn<DateTime>(
      'creation_time', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _updateTimeMeta =
      const VerificationMeta('updateTime');
  @override
  late final GeneratedColumn<DateTime> updateTime = GeneratedColumn<DateTime>(
      'update_time', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [type, target, status, message, creationTime, updateTime];
  @override
  String get aliasedName => _alias ?? 'Sync';
  @override
  String get actualTableName => 'Sync';
  @override
  VerificationContext validateIntegrity(Insertable<SyncEntry> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('type')) {
      context.handle(
          _typeMeta, type.isAcceptableOrUnknown(data['type']!, _typeMeta));
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('target')) {
      context.handle(_targetMeta,
          target.isAcceptableOrUnknown(data['target']!, _targetMeta));
    } else if (isInserting) {
      context.missing(_targetMeta);
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('message')) {
      context.handle(_messageMeta,
          message.isAcceptableOrUnknown(data['message']!, _messageMeta));
    }
    if (data.containsKey('creation_time')) {
      context.handle(
          _creationTimeMeta,
          creationTime.isAcceptableOrUnknown(
              data['creation_time']!, _creationTimeMeta));
    } else if (isInserting) {
      context.missing(_creationTimeMeta);
    }
    if (data.containsKey('update_time')) {
      context.handle(
          _updateTimeMeta,
          updateTime.isAcceptableOrUnknown(
              data['update_time']!, _updateTimeMeta));
    } else if (isInserting) {
      context.missing(_updateTimeMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {type, target};
  @override
  SyncEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SyncEntry(
      type: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}type'])!,
      target: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}target'])!,
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      message: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}message']),
      creationTime: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}creation_time'])!,
      updateTime: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}update_time'])!,
    );
  }

  @override
  $SyncTableTable createAlias(String alias) {
    return $SyncTableTable(attachedDatabase, alias);
  }
}

class SyncEntry extends DataClass implements Insertable<SyncEntry> {
  /// The type
  final String type;

  /// The target
  final String target;

  /// The status.
  final String status;

  /// The message.
  final String? message;

  /// The creation time
  final DateTime creationTime;

  /// The update time
  final DateTime updateTime;
  const SyncEntry(
      {required this.type,
      required this.target,
      required this.status,
      this.message,
      required this.creationTime,
      required this.updateTime});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['type'] = Variable<String>(type);
    map['target'] = Variable<String>(target);
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || message != null) {
      map['message'] = Variable<String>(message);
    }
    map['creation_time'] = Variable<DateTime>(creationTime);
    map['update_time'] = Variable<DateTime>(updateTime);
    return map;
  }

  SyncTableCompanion toCompanion(bool nullToAbsent) {
    return SyncTableCompanion(
      type: Value(type),
      target: Value(target),
      status: Value(status),
      message: message == null && nullToAbsent
          ? const Value.absent()
          : Value(message),
      creationTime: Value(creationTime),
      updateTime: Value(updateTime),
    );
  }

  factory SyncEntry.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SyncEntry(
      type: serializer.fromJson<String>(json['type']),
      target: serializer.fromJson<String>(json['target']),
      status: serializer.fromJson<String>(json['status']),
      message: serializer.fromJson<String?>(json['message']),
      creationTime: serializer.fromJson<DateTime>(json['creationTime']),
      updateTime: serializer.fromJson<DateTime>(json['updateTime']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'type': serializer.toJson<String>(type),
      'target': serializer.toJson<String>(target),
      'status': serializer.toJson<String>(status),
      'message': serializer.toJson<String?>(message),
      'creationTime': serializer.toJson<DateTime>(creationTime),
      'updateTime': serializer.toJson<DateTime>(updateTime),
    };
  }

  SyncEntry copyWith(
          {String? type,
          String? target,
          String? status,
          Value<String?> message = const Value.absent(),
          DateTime? creationTime,
          DateTime? updateTime}) =>
      SyncEntry(
        type: type ?? this.type,
        target: target ?? this.target,
        status: status ?? this.status,
        message: message.present ? message.value : this.message,
        creationTime: creationTime ?? this.creationTime,
        updateTime: updateTime ?? this.updateTime,
      );
  @override
  String toString() {
    return (StringBuffer('SyncEntry(')
          ..write('type: $type, ')
          ..write('target: $target, ')
          ..write('status: $status, ')
          ..write('message: $message, ')
          ..write('creationTime: $creationTime, ')
          ..write('updateTime: $updateTime')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(type, target, status, message, creationTime, updateTime);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SyncEntry &&
          other.type == this.type &&
          other.target == this.target &&
          other.status == this.status &&
          other.message == this.message &&
          other.creationTime == this.creationTime &&
          other.updateTime == this.updateTime);
}

class SyncTableCompanion extends UpdateCompanion<SyncEntry> {
  final Value<String> type;
  final Value<String> target;
  final Value<String> status;
  final Value<String?> message;
  final Value<DateTime> creationTime;
  final Value<DateTime> updateTime;
  const SyncTableCompanion({
    this.type = const Value.absent(),
    this.target = const Value.absent(),
    this.status = const Value.absent(),
    this.message = const Value.absent(),
    this.creationTime = const Value.absent(),
    this.updateTime = const Value.absent(),
  });
  SyncTableCompanion.insert({
    required String type,
    required String target,
    required String status,
    this.message = const Value.absent(),
    required DateTime creationTime,
    required DateTime updateTime,
  })  : type = Value(type),
        target = Value(target),
        status = Value(status),
        creationTime = Value(creationTime),
        updateTime = Value(updateTime);
  static Insertable<SyncEntry> custom({
    Expression<String>? type,
    Expression<String>? target,
    Expression<String>? status,
    Expression<String>? message,
    Expression<DateTime>? creationTime,
    Expression<DateTime>? updateTime,
  }) {
    return RawValuesInsertable({
      if (type != null) 'type': type,
      if (target != null) 'target': target,
      if (status != null) 'status': status,
      if (message != null) 'message': message,
      if (creationTime != null) 'creation_time': creationTime,
      if (updateTime != null) 'update_time': updateTime,
    });
  }

  SyncTableCompanion copyWith(
      {Value<String>? type,
      Value<String>? target,
      Value<String>? status,
      Value<String?>? message,
      Value<DateTime>? creationTime,
      Value<DateTime>? updateTime}) {
    return SyncTableCompanion(
      type: type ?? this.type,
      target: target ?? this.target,
      status: status ?? this.status,
      message: message ?? this.message,
      creationTime: creationTime ?? this.creationTime,
      updateTime: updateTime ?? this.updateTime,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (target.present) {
      map['target'] = Variable<String>(target.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (message.present) {
      map['message'] = Variable<String>(message.value);
    }
    if (creationTime.present) {
      map['creation_time'] = Variable<DateTime>(creationTime.value);
    }
    if (updateTime.present) {
      map['update_time'] = Variable<DateTime>(updateTime.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SyncTableCompanion(')
          ..write('type: $type, ')
          ..write('target: $target, ')
          ..write('status: $status, ')
          ..write('message: $message, ')
          ..write('creationTime: $creationTime, ')
          ..write('updateTime: $updateTime')
          ..write(')'))
        .toString();
  }
}

abstract class _$DriftStore extends GeneratedDatabase {
  _$DriftStore(QueryExecutor e) : super(e);
  late final $UserTableTable userTable = $UserTableTable(this);
  late final $ShaderTableTable shaderTable = $ShaderTableTable(this);
  late final $CommentTableTable commentTable = $CommentTableTable(this);
  late final $PlaylistTableTable playlistTable = $PlaylistTableTable(this);
  late final $PlaylistShaderTableTable playlistShaderTable =
      $PlaylistShaderTableTable(this);
  late final $SyncTableTable syncTable = $SyncTableTable(this);
  late final UserDao userDao = UserDao(this as DriftStore);
  late final ShaderDao shaderDao = ShaderDao(this as DriftStore);
  late final CommentDao commentDao = CommentDao(this as DriftStore);
  late final PlaylistDao playlistDao = PlaylistDao(this as DriftStore);
  late final SyncDao syncDao = SyncDao(this as DriftStore);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        userTable,
        shaderTable,
        commentTable,
        playlistTable,
        playlistShaderTable,
        syncTable
      ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules(
        [
          WritePropagation(
            on: TableUpdateQuery.onTableName('Shader',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('Comment', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('Playlist',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('PlaylistShader', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('Shader',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('PlaylistShader', kind: UpdateKind.delete),
            ],
          ),
        ],
      );
}
