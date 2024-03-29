import 'package:drift/drift.dart' show driftRuntimeOptions;
import 'package:shadertoy/shadertoy_api.dart';
import 'package:shadertoy_sqlite/shadertoy_sqlite.dart';
import 'package:test/test.dart';

import 'fixtures/fixtures.dart';

void main() {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;

  Future<List<FindShaderResponse>> getNameSort(List<String> shaderPaths) async {
    nameSort(FindShaderResponse fsr) => fsr.shader?.info.name ?? '';
    final response = await findShadersResponseFixture(shaderPaths);
    final shaders = response.shaders ?? [];
    final result = List<FindShaderResponse>.from(shaders);
    result.sort((shader1, shader2) {
      final name1 = nameSort(shader1);
      final name2 = nameSort(shader2);
      return name1.compareTo(name2);
    });

    return result;
  }

  Future<List<FindShaderResponse>> getDateSort(List<String> shaderPaths) async {
    dateSort(FindShaderResponse fsr) =>
        fsr.shader?.info.date ?? DateTime(2013, 1, 2);
    final response = await findShadersResponseFixture(shaderPaths);
    final shaders = response.shaders ?? [];
    final result = List<FindShaderResponse>.from(shaders);
    result.sort((shader1, shader2) {
      final date1 = dateSort(shader1);
      final date2 = dateSort(shader2);
      return -1 * date1.compareTo(date2);
    });

    return result;
  }

  Future<List<FindShaderResponse>> getPopularitySort(
      List<String> shaderPaths) async {
    popularitySort(FindShaderResponse fsr) => fsr.shader?.info.views ?? 1;
    final response = await findShadersResponseFixture(shaderPaths);
    final shaders = response.shaders ?? [];
    final result = List<FindShaderResponse>.from(shaders);
    result.sort((shader1, shader2) {
      final popularity1 = popularitySort(shader1);
      final popularity2 = popularitySort(shader2);
      if (popularity1 < popularity2) {
        return 1;
      } else if (popularity1 > popularity2) {
        return -1;
      }

      return 0;
    });

    return result;
  }

  Future<List<FindShaderResponse>> getLoveSort(List<String> shaderPaths) async {
    loveSort(FindShaderResponse fsr) => fsr.shader?.info.likes ?? 1;
    final response = await findShadersResponseFixture(shaderPaths);
    final shaders = response.shaders ?? [];
    final result = List<FindShaderResponse>.from(shaders);
    result.sort((shader1, shader2) {
      final love1 = loveSort(shader1);
      final love2 = loveSort(shader2);
      if (love1 < love2) {
        return 1;
      } else if (love1 > love2) {
        return -1;
      }

      return 0;
    });

    return result;
  }

  Future<List<FindShaderResponse>> getHotSort(List<String> shaderPaths) async {
    hotSort(FindShaderResponse fsr) {
      final info = fsr.shader?.info;
      final views = info?.views ?? 1;
      final milisNow = DateTime.now().millisecondsSinceEpoch;
      final milisDate = info?.date.millisecondsSinceEpoch ?? 1;

      return views / (milisNow ~/ 1000 - (milisDate) ~/ 1000);
    }

    final response = await findShadersResponseFixture(shaderPaths);
    final shaders = response.shaders ?? [];
    final result = List<FindShaderResponse>.from(shaders);

    result.sort((shader1, shader2) {
      final hot1 = hotSort(shader1);
      final hot2 = hotSort(shader2);
      if (hot1 < hot2) {
        return 1;
      } else if (hot1 > hot2) {
        return -1;
      }

      return 0;
    });

    return result;
  }

  group('Shader', () {
    test('Save shader', () async {
      // prepare
      final store = await newShadertoySqliteMemoryStore();
      final shader = await shaderFixture('shaders/happy_jumping.json');
      // act
      final response = await store.saveShader(shader);
      // assert
      expect(response, isNotNull);
      expect(response.error, isNull);
    });

    test('Save shaders', () async {
      // prepare
      final store = await newShadertoySqliteMemoryStore();
      final shaders = await shadersFixture(
          ['shaders/seascape.json', 'shaders/happy_jumping.json']);
      // act
      final response = await store.saveShaders(shaders);
      // assert
      expect(response, isNotNull);
      expect(response.error, isNull);
    });

    test('Save shader twice', () async {
      // prepare
      final store = await newShadertoySqliteMemoryStore();
      final originalShader = await shaderFixture('shaders/happy_jumping.json');
      final updatedShader = originalShader.copyWith(version: 'a');
      // act
      await store.saveShader(originalShader);
      final savedShader1 = await store.findShaderById(originalShader.info.id);
      await store.saveShader(updatedShader);
      final savedShader2 = await store.findShaderById(originalShader.info.id);
      // assert
      expect(savedShader1.shader, originalShader);
      expect(savedShader2.shader, updatedShader);
    });

    test('Find shader by id', () async {
      // prepare
      final store = await newShadertoySqliteMemoryStore();
      final shader = await shaderFixture('shaders/happy_jumping.json');
      await store.saveShader(shader);
      // act
      final response = await store.findShaderById(shader.info.id);
      // assert
      expect(response, isNotNull);
      expect(response.error, isNull);
      expect(response.shader, shader);
    });

    test('Find shader by id with not found response', () async {
      // prepare
      final store = await newShadertoySqliteMemoryStore();
      final shaderId = 'xxxx';
      // act
      final response = await store.findShaderById(shaderId);
      // assert
      expect(response, isNotNull);
      expect(response.error, isNotNull);
      expect(
          response.error,
          ResponseError.notFound(
              message: 'Shader $shaderId not found',
              context: contextShader,
              target: shaderId));
    });

    test('Find shaders by id set', () async {
      // prepare
      final store = await newShadertoySqliteMemoryStore();
      final shaderPaths = [
        'shaders/seascape.json',
        'shaders/happy_jumping.json'
      ];
      final shaders = await shadersFixture(shaderPaths);
      await store.saveShaders(shaders);
      // act
      final response = await store
          .findShadersByIdSet({shaders[0].info.id, shaders[1].info.id});
      // assert
      expect(response, await findShadersResponseFixture(shaderPaths));
    });

    test('Find shader ids by query', () async {
      // prepare
      final store = await newShadertoySqliteMemoryStore();
      final shaderPaths = [
        'shaders/clouds.json',
        'shaders/elevated.json',
        'shaders/rainforest.json',
        'shaders/raymarching_part_1.json',
        'shaders/raymarching_part_2.json',
        'shaders/raymarching_part_3.json',
        'shaders/raymarching_part_4.json',
        'shaders/raymarching_part_6.json',
        'shaders/raymarching_primitives.json',
        'shaders/volcanic.json',
      ];
      final shaders = await shadersFixture(shaderPaths);
      await store.saveShaders(shaders);
      // act
      final response = await store
          .findShaderIds(term: 'Elevated', filters: {'procedural', '3d'});
      // assert
      final actualIds = response.ids ?? [];
      final expected =
          await findShaderIdsResponseFixture(['shaders/elevated.json']);
      final expectedIds = expected.ids ?? [];
      expect(actualIds, containsAllInOrder(expectedIds));
    });

    test('Find all shader ids', () async {
      // prepare
      final store = await newShadertoySqliteMemoryStore();
      final shaderPaths = [
        'shaders/seascape.json',
        'shaders/happy_jumping.json'
      ];
      final shaders = await shadersFixture(shaderPaths);
      await store.saveShaders(shaders);
      // act
      final response = await store.findAllShaderIds();
      // assert
      expect(response, isNotNull);
      expect(response.error, isNull);
      final actualIds = response.ids ?? [];
      final expected = await findShaderIdsResponseFixture(shaderPaths);
      final expectedIds = expected.ids ?? [];
      expect(actualIds, containsAll(expectedIds));
    });

    test('Find shaders', () async {
      // prepare
      final store = await newShadertoySqliteMemoryStore();
      final shaderPaths = [
        'shaders/clouds.json',
        'shaders/creation.json',
        'shaders/elevated.json',
        'shaders/rainforest.json',
        'shaders/raymarching_part_1.json',
        'shaders/raymarching_part_2.json',
        'shaders/raymarching_part_3.json',
        'shaders/raymarching_part_4.json',
        'shaders/raymarching_part_6.json',
        'shaders/raymarching_primitives.json',
        'shaders/seascape.json',
        'shaders/volcanic.json',
        'shaders/snail.json',
        'shaders/selfie_girl.json',
      ];
      final shaders = await shadersFixture(shaderPaths);
      await store.saveShaders(shaders);
      // act
      final response = await store.findShaders();
      // assert
      final actual = response.shaders ?? [];
      final expected = (await getHotSort(shaderPaths))
          .take(ShadertoySqliteOptions.defaultShaderCount);

      expect(actual.length, ShadertoySqliteOptions.defaultShaderCount);
      expect(actual, containsAllInOrder(expected));
    });

    test('Find shaders, sort by name asc', () async {
      // prepare
      final store = await newShadertoySqliteMemoryStore();
      final shaderPaths = [
        'shaders/clouds.json',
        'shaders/creation.json',
        'shaders/elevated.json',
        'shaders/rainforest.json',
        'shaders/raymarching_part_1.json',
        'shaders/raymarching_part_2.json',
        'shaders/raymarching_part_3.json',
        'shaders/raymarching_part_4.json',
        'shaders/raymarching_part_6.json',
        'shaders/raymarching_primitives.json',
        'shaders/seascape.json',
        'shaders/volcanic.json',
      ];
      final shaders = await shadersFixture(shaderPaths);
      await store.saveShaders(shaders);
      // act
      final response = await store.findShaders(sort: Sort.name);
      // assert
      final actual = response.shaders;
      final expected = (await getNameSort(shaderPaths))
          .take(ShadertoySqliteOptions.defaultShaderCount);

      expect(actual, containsAllInOrder(expected));
    });

    test('Find shaders, sort by popularity (views)', () async {
      // prepare
      final store = await newShadertoySqliteMemoryStore();
      final shaderPaths = [
        'shaders/clouds.json',
        'shaders/creation.json',
        'shaders/elevated.json',
        'shaders/rainforest.json',
        'shaders/raymarching_part_1.json',
        'shaders/raymarching_part_2.json',
        'shaders/raymarching_part_3.json',
        'shaders/raymarching_part_4.json',
        'shaders/raymarching_part_6.json',
        'shaders/raymarching_primitives.json',
        'shaders/seascape.json',
        'shaders/volcanic.json',
      ];
      final shaders = await shadersFixture(shaderPaths);
      await store.saveShaders(shaders);
      // act
      final response = await store.findShaders(sort: Sort.popular);
      // assert
      final actual = response.shaders;
      final expected = (await getPopularitySort(shaderPaths))
          .take(ShadertoySqliteOptions.defaultShaderCount);

      expect(actual, containsAllInOrder(expected));
    });

    test('Find shaders, sort by date desc', () async {
      // prepare
      final store = await newShadertoySqliteMemoryStore();
      final shaderPaths = [
        'shaders/clouds.json',
        'shaders/creation.json',
        'shaders/elevated.json',
        'shaders/rainforest.json',
        'shaders/raymarching_part_1.json',
        'shaders/raymarching_part_2.json',
        'shaders/raymarching_part_3.json',
        'shaders/raymarching_part_4.json',
        'shaders/raymarching_part_6.json',
        'shaders/raymarching_primitives.json',
        'shaders/seascape.json',
        'shaders/volcanic.json',
      ];
      final shaders = await shadersFixture(shaderPaths);
      await store.saveShaders(shaders);
      // act
      final response = await store.findShaders(sort: Sort.newest);
      // assert
      final actual = response.shaders;
      final expected = (await getDateSort(shaderPaths))
          .take(ShadertoySqliteOptions.defaultShaderCount);

      expect(actual, containsAllInOrder(expected));
    });

    test('Find shaders, sort by love (likes) desc', () async {
      // prepare
      final store = await newShadertoySqliteMemoryStore();
      final shaderPaths = [
        'shaders/clouds.json',
        'shaders/creation.json',
        'shaders/elevated.json',
        'shaders/expansive_reaction_diffusion.json',
        'shaders/flame.json',
        'shaders/fractal_land.json',
        'shaders/protean_clouds.json',
        'shaders/rainforest.json',
        'shaders/raymarching_primitives.json',
        'shaders/seascape.json',
        'shaders/star_nest.json',
        'shaders/voxel_edges.json',
      ];
      final shaders = await shadersFixture(shaderPaths);
      await store.saveShaders(shaders);
      // act
      final response = await store.findShaders(sort: Sort.love);
      // assert
      final actual = response.shaders;
      final expected = (await getLoveSort(shaderPaths))
          .take(ShadertoySqliteOptions.defaultShaderCount);

      expect(actual, containsAllInOrder(expected));
    });

    test('Find shaders, sort by hot desc', () async {
      // prepare
      final store = await newShadertoySqliteMemoryStore();

      final shaderPaths = [
        'shaders/day_at_the_lake.json',
        'shaders/ed_209.json',
        'shaders/happy_jumping.json',
        'shaders/joe_gardner_soul_pixar.json',
        'shaders/m_o_from_wall_e.json',
        'shaders/normalized_blinn_phong.json',
        'shaders/normalized_blinn_phong_test.json',
        'shaders/raymarching_primitives.json',
        'shaders/seascape.json',
        'shaders/second_order_pixel_sorter.json',
        'shaders/selfie_girl.json',
        'shaders/truchet_grid_inversion.json',
      ];
      final shaders = await shadersFixture(shaderPaths);

      await store.saveShaders(shaders);
      // act
      final response = await store.findShaders(sort: Sort.hot);
      // assert
      final actual = response.shaders;
      final expected = (await getHotSort(shaderPaths))
          .take(ShadertoySqliteOptions.defaultShaderCount);

      expect(actual, containsAllInOrder(expected));
    });

    test('Find shaders by term', () async {
      // prepare
      final store = await newShadertoySqliteMemoryStore();
      final shaderPaths = [
        'shaders/clouds.json',
        'shaders/creation.json',
        'shaders/elevated.json',
        'shaders/rainforest.json',
        'shaders/raymarching_part_1.json',
        'shaders/raymarching_part_2.json',
        'shaders/raymarching_part_3.json',
        'shaders/raymarching_part_4.json',
        'shaders/raymarching_part_6.json',
        'shaders/raymarching_primitives.json',
        'shaders/seascape.json',
        'shaders/volcanic.json',
      ];
      final shaders = await shadersFixture(shaderPaths);
      await store.saveShaders(shaders);
      // act
      final response = await store.findShaders(term: 'volcanic');
      // assert
      final actualShaders = response.shaders ?? [];
      final expected =
          await findShadersResponseFixture(['shaders/volcanic.json']);
      final expectedShaders = expected.shaders ?? [];

      expect(actualShaders, containsAllInOrder(expectedShaders));
    });

    test('Find shaders by tag', () async {
      // prepare
      final store = await newShadertoySqliteMemoryStore();
      final shaderPaths = [
        'shaders/clouds.json',
        'shaders/creation.json',
        'shaders/elevated.json',
        'shaders/rainforest.json',
        'shaders/raymarching_part_1.json',
        'shaders/raymarching_part_2.json',
        'shaders/raymarching_part_3.json',
        'shaders/raymarching_part_4.json',
        'shaders/raymarching_part_6.json',
        'shaders/raymarching_primitives.json',
        'shaders/seascape.json',
        'shaders/volcanic.json',
      ];
      final shaders = await shadersFixture(shaderPaths);
      await store.saveShaders(shaders);
      // act
      final response = await store.findShaders(filters: {'waves', 'sea'});
      // assert
      final actualShaders = response.shaders;
      final expected =
          await findShadersResponseFixture(['shaders/seascape.json']);
      final expectedShaders = expected.shaders ?? [];

      expect(actualShaders, containsAllInOrder(expectedShaders));
    });

    test('Find shaders by query', () async {
      // prepare
      final store = await newShadertoySqliteMemoryStore();
      final shaderPaths = [
        'shaders/clouds.json',
        'shaders/creation.json',
        'shaders/elevated.json',
        'shaders/rainforest.json',
        'shaders/raymarching_part_1.json',
        'shaders/raymarching_part_2.json',
        'shaders/raymarching_part_3.json',
        'shaders/raymarching_part_4.json',
        'shaders/raymarching_part_6.json',
        'shaders/raymarching_primitives.json',
        'shaders/seascape.json',
        'shaders/volcanic.json',
      ];
      final shaders = await shadersFixture(shaderPaths);
      await store.saveShaders(shaders);
      // act
      final response = await store
          .findShaders(term: 'Elevated', filters: {'procedural', '3d'});
      // assert
      final actualShaders = response.shaders;
      final expected =
          await findShadersResponseFixture(['shaders/elevated.json']);
      final expectedShaders = expected.shaders ?? [];

      expect(actualShaders, containsAllInOrder(expectedShaders));
    });

    /*
    test('Find shaders with from and limit', () async {
      // prepare
      final store = await newShadertoySqliteMemoryStore();
      final shaderPaths = [
        'shaders/clouds.json',
        'shaders/creation.json',
        'shaders/elevated.json',
        'shaders/rainforest.json',
        'shaders/raymarching_part_1.json',
        'shaders/raymarching_part_2.json',
        'shaders/raymarching_part_3.json',
        'shaders/raymarching_part_4.json',
        'shaders/raymarching_part_6.json',
        'shaders/raymarching_primitives.json',
        'shaders/seascape.json',
        'shaders/volcanic.json',
      ];
      final shaders = shadersFixture(shaderPaths);
      await store.saveShaders(shaders);
      // act
      final response = await store.findShaders(from: 6, num: 5);
      // assert
      final actual = response.shaders;
      final expected = _hotSort(shaderPaths).sublist(6, 11);

      expect(actual, containsAllInOrder(expected));
    });
    */

    test('Find all shaders', () async {
      // prepare
      final store = await newShadertoySqliteMemoryStore();
      final shaderPaths = [
        'shaders/seascape.json',
        'shaders/happy_jumping.json'
      ];
      final shaders = await shadersFixture(shaderPaths);
      await store.saveShaders(shaders);
      // act
      final response = await store.findAllShaders();
      // assert
      expect(response, isNotNull);
      expect(response.error, isNull);

      final actualShaders = response.shaders;
      final expected = await findShadersResponseFixture(shaderPaths);
      final expectedShaders = expected.shaders ?? [];
      expect(actualShaders, expectedShaders);
    });

    test('Delete shader by id', () async {
      // prepare
      final store = await newShadertoySqliteMemoryStore();
      final shader = await shaderFixture('shaders/happy_jumping.json');
      await store.saveShader(shader);
      final fsr1 = await store.findShaderById(shader.info.id);
      // act
      final dsr = await store.deleteShaderById(shader.info.id);
      final fsr2 = await store.findShaderById(shader.info.id);
      // assert
      expect(fsr1.shader, isNotNull);
      expect(dsr, isNotNull);
      expect(dsr.error, isNull);
      expect(fsr2.shader, isNull);
    });

    test('Delete shader by id with comments', () async {
      // prepare
      final store = await newShadertoySqliteMemoryStore();
      final shader = await shaderFixture('shaders/elevated.json');
      final shaderId = shader.info.id;
      await store.saveShader(shader);
      final comments = await commentsFixture('comment/$shaderId.json');
      await store.saveShaderComments(shaderId, comments);
      final fcr1 = await store.findCommentsByShaderId(shaderId);
      // act
      final dsr = await store.deleteShaderById(shaderId);
      final fcr2 = await store.findCommentsByShaderId(shaderId);
      // assert
      expect(fcr1.comments, isNotEmpty);
      expect(dsr, isNotNull);
      expect(dsr.error, isNull);
      expect(fcr2.comments, isEmpty);
    });

    test('Delete shader by id with playlist reference', () async {
      // prepare
      final store = await newShadertoySqliteMemoryStore();
      final playlistId = 'week';
      final shaderPaths = [
        'shaders/seascape.json',
        'shaders/happy_jumping.json'
      ];
      final shaders = await shadersFixture(shaderPaths);
      await store.saveShaders(shaders);
      final playlist = await playlistFixture('playlist/$playlistId.json');
      await store.savePlaylist(playlist);
      await store.savePlaylistShaders(
          playlistId, shaders.map((shader) => shader.info.id).toList());
      final fspr1 = await store.findShadersByPlaylistId(playlistId);
      // act
      final dsr = await store.deleteShaderById(shaders[0].info.id);
      final fspr2 = await store.findShadersByPlaylistId(playlistId);
      // assert
      expect(fspr1.shaders, contains(FindShaderResponse(shader: shaders[0])));
      expect(dsr, isNotNull);
      expect(dsr.error, isNull);
      expect(fspr2.shaders,
          isNot(contains(FindShaderResponse(shader: shaders[0]))));
    });
  });

  group('User', () {
    test('Save user', () async {
      // prepare
      final store = await newShadertoySqliteMemoryStore();
      final userId = 'iq';
      final user = await userFixture('users/$userId.json');
      // act
      final response = await store.saveUser(user);
      // assert
      expect(response, isNotNull);
      expect(response.error, isNull);
    });

    test('Save users', () async {
      // prepare
      final store = await newShadertoySqliteMemoryStore();
      final users =
          await usersFixture(['users/iq.json', 'users/shaderflix.json']);
      // act
      final response = await store.saveUsers(users);
      // assert
      expect(response, isNotNull);
      expect(response.error, isNull);
    });

    test('Save user twice', () async {
      // prepare
      final store = await newShadertoySqliteMemoryStore();
      final userId = 'iq';
      final originalUser = await userFixture('users/$userId.json');
      final updatedUser = originalUser.copyWith(followers: 1);
      // act
      await store.saveUser(originalUser);
      final savedUser1 = await store.findUserById(userId);
      await store.saveUser(updatedUser);
      final savedUser2 = await store.findUserById(userId);
      // assert
      expect(savedUser1.user, originalUser);
      expect(savedUser2.user, updatedUser);
    });

    test('Find user by id', () async {
      // prepare
      final store = await newShadertoySqliteMemoryStore();
      final user = await userFixture('users/iq.json');
      await store.saveUser(user);
      // act
      final response = await store.findUserById(user.id);
      // assert
      expect(response, isNotNull);
      expect(response.error, isNull);
      expect(response.user, user);
    });

    test('Find user by id with not found response', () async {
      // prepare
      final userId = 'xxx';
      final store = await newShadertoySqliteMemoryStore();
      // act
      final response = await store.findUserById(userId);
      // assert
      expect(response, isNotNull);
      expect(response.error, isNotNull);
      expect(
          response.error,
          ResponseError.notFound(
              message: 'User $userId not found',
              context: contextUser,
              target: userId));
    });

    test('Find shaders by user id', () async {
      final store = await newShadertoySqliteMemoryStore();
      final userId = 'iq';
      final user = await userFixture('users/$userId.json');
      await store.saveUser(user);
      final shaderPaths = [
        'shaders/clouds.json',
        'shaders/creation.json',
        'shaders/elevated.json',
        'shaders/rainforest.json',
        'shaders/raymarching_part_1.json',
        'shaders/raymarching_part_2.json',
        'shaders/raymarching_part_3.json',
        'shaders/raymarching_part_4.json',
        'shaders/raymarching_part_6.json',
        'shaders/raymarching_primitives.json',
        'shaders/seascape.json',
        'shaders/selfie_girl.json',
        'shaders/snail.json',
        'shaders/volcanic.json',
      ];
      final shaders = await shadersFixture(shaderPaths);
      await store.saveShaders(shaders);
      // act
      final response = await store.findShadersByUserId(userId);
      // assert
      final actualShaders = response.shaders;
      final expected = await getPopularitySort(shaderPaths);
      final expectedShaders = expected
          .where((element) => element.shader?.info.userId == userId)
          .take(ShadertoySqliteOptions.defaultUserShaderCount);

      expect(actualShaders, containsAllInOrder(expectedShaders));
    });

    test('Find shader ids by user id', () async {
      final store = await newShadertoySqliteMemoryStore();
      final userId = 'iq';
      final user = await userFixture('users/$userId.json');
      await store.saveUser(user);
      final shaderPaths = [
        'shaders/clouds.json',
        'shaders/creation.json',
        'shaders/elevated.json',
        'shaders/rainforest.json',
        'shaders/raymarching_part_1.json',
        'shaders/raymarching_part_2.json',
        'shaders/raymarching_part_3.json',
        'shaders/raymarching_part_4.json',
        'shaders/raymarching_part_6.json',
        'shaders/raymarching_primitives.json',
        'shaders/seascape.json',
        'shaders/selfie_girl.json',
        'shaders/snail.json',
        'shaders/volcanic.json',
      ];
      final shaders = await shadersFixture(shaderPaths);
      await store.saveShaders(shaders);
      // act
      final response = await store.findShaderIdsByUserId(userId);
      // assert
      final actualShaders = response.ids;
      final expected = await getPopularitySort(shaderPaths);
      final expectedShaders = expected
          .where((element) => element.shader?.info.userId == userId)
          .take(ShadertoySqliteOptions.defaultShaderCount)
          .map((e) => e.shader?.info.id)
          .toList();

      expect(actualShaders, containsAllInOrder(expectedShaders));
    });

    test('Find all shader ids by user id', () async {
      // prepare
      final store = await newShadertoySqliteMemoryStore();
      final user = await userFixture('users/iq.json');
      await store.saveUser(user);
      final shaderPaths = [
        'shaders/seascape.json',
        'shaders/happy_jumping.json',
        'shaders/ladybug.json'
      ];
      final shaders = await shadersFixture(shaderPaths);
      await store.saveShaders(shaders);
      // act
      final response = await store.findAllShaderIdsByUserId(user.id);
      // assert
      expect(response, isNotNull);
      expect(response.error, isNull);
      final actualIds = response.ids ?? [];
      final expected =
          await findShaderIdsResponseFixture(shaderPaths.sublist(1));
      final expectedIds = expected.ids ?? [];
      expect(actualIds, expectedIds);
    });

    test('Find all user ids', () async {
      // prepare
      final store = await newShadertoySqliteMemoryStore();
      final userPaths = ['users/iq.json', 'users/shaderflix.json'];
      final users = await usersFixture(userPaths);
      await store.saveUsers(users);
      // act
      final response = await store.findAllUserIds();
      // assert
      expect(response, isNotNull);
      expect(response.error, isNull);
      final actualIds = response.ids ?? [];
      final expected = await findUserIdsResponseFixture(userPaths);
      final expectedIds = expected.ids ?? [];
      expect(actualIds, containsAll(expectedIds));
    });

    test('Find all users', () async {
      // prepare
      final store = await newShadertoySqliteMemoryStore();
      final userPaths = ['users/iq.json', 'users/shaderflix.json'];
      final users = await usersFixture(userPaths);
      await store.saveUsers(users);
      // act
      final response = await store.findAllUsers();
      // assert
      expect(response, isNotNull);
      expect(response.error, isNull);
      final actualUsers = response.users ?? [];
      final expected = await findUsersResponseFixture(userPaths);
      final expectedUsers = expected.users ?? [];
      expect(actualUsers, containsAll(expectedUsers));
    });

    test('Delete user by id', () async {
      // prepare
      final store = await newShadertoySqliteMemoryStore();
      final userId = 'iq';
      final user = await userFixture('users/$userId.json');
      await store.saveUser(user);
      final fur1 = await store.findUserById(user.id);
      // act
      final dur = await store.deleteUserById(user.id);
      final fur2 = await store.findUserById(user.id);
      // assert
      expect(fur1.user, isNotNull);
      expect(dur, isNotNull);
      expect(dur.error, isNull);
      expect(fur2.user, isNull);
    });
  });

  group('Comment', () {
    test('Save comment', () async {
      // prepare
      final store = await newShadertoySqliteMemoryStore();
      final shader = await shaderFixture('shaders/elevated.json');
      final shaderId = shader.info.id;
      await store.saveShader(shader);
      final comments = await commentsFixture('comment/$shaderId.json');
      // act
      final response = await store.saveShaderComments(shaderId, comments);
      // assert
      expect(response, isNotNull);
      expect(response.error, isNull);
    });

    test('Save comments twice', () async {
      // prepare
      final store = await newShadertoySqliteMemoryStore();
      final shader = await shaderFixture('shaders/elevated.json');
      final shaderId = shader.info.id;
      await store.saveShader(shader);
      final originalComments = await commentsFixture('comment/$shaderId.json');
      final updatedComments = originalComments
          .map((comment) => comment.copyWith(text: 'test'))
          .toList();
      // act
      await store.saveShaderComments(shaderId, originalComments);
      final savedComments1 = await store.findCommentsByShaderId(shaderId);
      await store.saveShaderComments(shaderId, updatedComments);
      final savedComments2 = await store.findCommentsByShaderId(shaderId);
      // assert
      expect(savedComments1.comments, originalComments);
      expect(savedComments2.comments, updatedComments);
    });

    test('Find comment by id', () async {
      // prepare
      final store = await newShadertoySqliteMemoryStore();
      final shader = await shaderFixture('shaders/elevated.json');
      final shaderId = shader.info.id;
      await store.saveShader(shader);
      final comments = await commentsFixture('comment/$shaderId.json');
      await store.saveShaderComments(shaderId, comments);
      // act
      final response = await store.findCommentById(comments[0].id);
      // assert
      expect(response, isNotNull);
      expect(response.error, isNull);
      expect(response.comment, comments[0]);
    });

    test('Find all comment ids', () async {
      // prepare
      final store = await newShadertoySqliteMemoryStore();
      final shader = await shaderFixture('shaders/elevated.json');
      final shaderId = shader.info.id;
      await store.saveShader(shader);
      final commentPath = 'comment/$shaderId.json';
      final comments = await commentsFixture(commentPath);
      await store.saveShaderComments(shaderId, comments);
      // act
      final response = await store.findAllCommentIds();
      // assert
      expect(response, isNotNull);
      expect(response.error, isNull);
      final actualIds = response.ids ?? [];
      final expected = await findCommentIdsResponseFixture(commentPath);
      final expectedIds = expected.ids ?? [];
      expect(actualIds, containsAll(expectedIds));
    });

    test('Find all comments', () async {
      // prepare
      final store = await newShadertoySqliteMemoryStore();
      final shader = await shaderFixture('shaders/elevated.json');
      final shaderId = shader.info.id;
      await store.saveShader(shader);
      final commentPath = 'comment/$shaderId.json';
      final comments = await commentsFixture(commentPath);
      await store.saveShaderComments(shaderId, comments);
      // act
      final response = await store.findAllComments();
      // assert
      expect(response, isNotNull);
      expect(response.error, isNull);
      final actualComments = response.comments ?? [];
      final expected = await findCommentsResponseFixture(commentPath);
      final expectedComments = expected.comments ?? [];
      expect(actualComments, containsAll(expectedComments));
    });

    test('Delete comment by id', () async {
      // prepare
      final store = await newShadertoySqliteMemoryStore();
      final shader = await shaderFixture('shaders/elevated.json');
      final shaderId = shader.info.id;
      await store.saveShader(shader);
      final comments = await commentsFixture('comment/$shaderId.json');
      await store.saveShaderComments(shaderId, comments);
      final fcr1 = await store.findCommentsByShaderId(shaderId);
      // act
      final dcr = await store.deleteShaderComments(shaderId);
      final fcr2 = await store.findCommentsByShaderId(shaderId);
      // assert
      expect(fcr1.comments, isNotNull);
      expect(dcr, isNotNull);
      expect(dcr.error, isNull);
      expect(fcr2.comments, isNot(contains(comments[0].id)));
    });
  });

  group('Playlist', () {
    test('Save playlist', () async {
      // prepare
      final store = await newShadertoySqliteMemoryStore();
      final playlistId = 'week';
      final playlist = await playlistFixture('playlist/$playlistId.json');
      // act
      final response = await store.savePlaylist(playlist);
      // assert
      expect(response, isNotNull);
      expect(response.error, isNull);
    });

    test('Save playlist twice', () async {
      // prepare
      final store = await newShadertoySqliteMemoryStore();
      final playlistId = 'week';
      final originalPlaylist =
          await playlistFixture('playlist/$playlistId.json');
      final updatedPlaylist = originalPlaylist.copyWith(name: 'weekly');
      // act
      await store.savePlaylist(originalPlaylist);
      final savedPlaylist1 = await store.findPlaylistById(playlistId);
      await store.savePlaylist(updatedPlaylist);
      final savedPlaylist2 = await store.findPlaylistById(playlistId);
      // assert
      expect(savedPlaylist1.playlist, originalPlaylist);
      expect(savedPlaylist2.playlist, updatedPlaylist);
    });

    test('Save playlist with shader ids', () async {
      // prepare
      final store = await newShadertoySqliteMemoryStore();
      final playlistId = 'week';
      final shaderPaths = [
        'shaders/seascape.json',
        'shaders/happy_jumping.json'
      ];
      final shaders = await shadersFixture(shaderPaths);
      await store.saveShaders(shaders);
      final playlist = await playlistFixture('playlist/$playlistId.json');
      // act
      final response = await store.savePlaylist(playlist,
          shaderIds: shaders.map((shader) => shader.info.id).toList());
      // assert
      expect(response, isNotNull);
      expect(response.error, isNull);
    });

    test('Find playlist by id with not found response', () async {
      // prepare
      final playlistId = 'xxx';
      final store = await newShadertoySqliteMemoryStore();
      // act
      final response = await store.findPlaylistById(playlistId);
      // assert
      expect(response, isNotNull);
      expect(response.error, isNotNull);
      expect(
          response.error,
          ResponseError.notFound(
              message: 'Playlist $playlistId not found',
              context: contextPlaylist,
              target: playlistId));
    });

    test('Find all playlist ids', () async {
      // prepare
      final store = await newShadertoySqliteMemoryStore();
      final playlistId1 = 'week';
      final playlist1Path = 'playlist/$playlistId1.json';
      final playlist1 = await playlistFixture(playlist1Path);
      await store.savePlaylist(playlist1);

      final playlistId2 = 'featured';
      final playlist2Path = 'playlist/$playlistId2.json';
      final playlist2 = await playlistFixture(playlist2Path);
      await store.savePlaylist(playlist2);
      final playlistPaths = [playlist1Path, playlist2Path];
      // act
      final response = await store.findAllPlaylistIds();
      // assert
      expect(response, isNotNull);
      expect(response.error, isNull);
      final actualIds = response.ids ?? [];
      final expected = await findPlaylistIdsResponseFixture(playlistPaths);
      final expectedIds = expected.ids ?? [];
      expect(actualIds, containsAll(expectedIds));
    });

    test('Find all playlists', () async {
      // prepare
      final store = await newShadertoySqliteMemoryStore();
      final playlistId1 = 'week';
      final playlist1Path = 'playlist/$playlistId1.json';
      final playlist1 = await playlistFixture(playlist1Path);
      await store.savePlaylist(playlist1);

      final playlistId2 = 'featured';
      final playlist2Path = 'playlist/$playlistId2.json';
      final playlist2 = await playlistFixture(playlist2Path);
      await store.savePlaylist(playlist2);
      final playlistPaths = [playlist1Path, playlist2Path];
      // act
      final response = await store.findAllPlaylists();
      // assert
      expect(response, isNotNull);
      expect(response.error, isNull);
      final actualPlaylists = response.playlists ?? [];
      final expected = await findPlaylistsResponseFixture(playlistPaths);
      final expectedPlaylists = expected.playlists ?? [];
      expect(actualPlaylists, containsAll(expectedPlaylists));
    });

    test('Save playlist shaders', () async {
      // prepare
      final store = await newShadertoySqliteMemoryStore();
      final playlistId = 'week';
      final shaderPaths = [
        'shaders/seascape.json',
        'shaders/happy_jumping.json'
      ];
      final shaders = await shadersFixture(shaderPaths);
      await store.saveShaders(shaders);
      final playlist = await playlistFixture('playlist/$playlistId.json');
      await store.savePlaylist(playlist);
      // act
      final response = await store.savePlaylistShaders(
          playlistId, shaders.map((shader) => shader.info.id).toList());
      // assert
      expect(response, isNotNull);
      expect(response.error, isNull);
    });

    test('Save playlist shader ids with FOREIGN KEY constraint', () async {
      // prepare
      final store = await newShadertoySqliteMemoryStore();
      final playlistId = 'week';
      final shaderPaths = [
        'shaders/seascape.json',
        'shaders/happy_jumping.json'
      ];
      final shaders = await shadersFixture(shaderPaths);
      final playlist = await playlistFixture('playlist/$playlistId.json');
      await store.savePlaylist(playlist);
      // act
      final response = await store.savePlaylistShaders(
          playlistId, shaders.map((shader) => shader.info.id).toList());
      // assert
      expect(response, isNotNull);
      expect(response.error, isNotNull);
      expect(
          response.error,
          ResponseError.unprocessableEntity(
              message: 'FOREIGN KEY constraint failed',
              context: contextPlaylist,
              target: playlistId));
    }, onPlatform: {'chrome': Skip('Foreign keys are not working on chrome')});

    test('Save playlist shader ids', () async {
      // prepare
      final store = await newShadertoySqliteMemoryStore();
      final playlistId = 'week';
      final shaderPaths = [
        'shaders/seascape.json',
        'shaders/happy_jumping.json'
      ];
      final shaders = await shadersFixture(shaderPaths);
      await store.saveShaders(shaders);
      final playlist = await playlistFixture('playlist/$playlistId.json');
      await store.savePlaylist(playlist);
      // act
      final response = await store.savePlaylistShaders(
          playlistId, shaders.map((shader) => shader.info.id).toList());
      // assert
      expect(response, isNotNull);
      expect(response.error, isNull);
    });

    test('Find shaders by playlist id', () async {
      // prepare
      final store = await newShadertoySqliteMemoryStore();
      final playlistId = 'week';
      final shaderPaths = [
        'shaders/clouds.json',
        'shaders/creation.json',
        'shaders/elevated.json',
        'shaders/rainforest.json',
        'shaders/raymarching_part_1.json',
        'shaders/raymarching_part_2.json',
        'shaders/raymarching_part_3.json',
        'shaders/raymarching_part_4.json',
        'shaders/raymarching_part_6.json',
        'shaders/raymarching_primitives.json',
        'shaders/seascape.json',
        'shaders/volcanic.json',
      ];
      final shaders = await shadersFixture(shaderPaths);
      await store.saveShaders(shaders);
      final playlist = await playlistFixture('playlist/$playlistId.json');
      await store.savePlaylist(playlist);
      await store.savePlaylistShaders(
          playlistId, shaders.map((shader) => shader.info.id).toList());
      // act
      final response = await store.findShadersByPlaylistId(playlistId);
      // assert
      final actualShaders = response.shaders ?? [];
      final expected = await findShadersResponseFixture(shaderPaths);
      final expectedShaders = expected.shaders ?? [];
      expect(actualShaders, containsAllInOrder(expectedShaders));
    });

    test('Find shader ids by playlist id', () async {
      // prepare
      final store = await newShadertoySqliteMemoryStore();
      final playlistId = 'week';
      final shaderPaths = [
        'shaders/clouds.json',
        'shaders/creation.json',
        'shaders/elevated.json',
        'shaders/rainforest.json',
        'shaders/raymarching_part_1.json',
        'shaders/raymarching_part_2.json',
        'shaders/raymarching_part_3.json',
        'shaders/raymarching_part_4.json',
        'shaders/raymarching_part_6.json',
        'shaders/raymarching_primitives.json',
        'shaders/seascape.json',
        'shaders/volcanic.json',
      ];
      final shaders = await shadersFixture(shaderPaths);
      await store.saveShaders(shaders);
      final playlist = await playlistFixture('playlist/$playlistId.json');
      await store.savePlaylist(playlist);
      await store.savePlaylistShaders(
          playlistId, shaders.map((shader) => shader.info.id).toList());
      // act
      final response = await store.findShaderIdsByPlaylistId(playlistId);
      // assert
      final actualIds = response.ids ?? [];
      final expected = await findShaderIdsResponseFixture(shaderPaths);
      final expectedIds = expected.ids ?? [];
      expect(actualIds, containsAllInOrder(expectedIds));
    });

    test('Find all shader ids by playlist id', () async {
      // prepare
      final store = await newShadertoySqliteMemoryStore();
      final playlistId = 'week';
      final shaderPaths = [
        'shaders/clouds.json',
        'shaders/creation.json',
        'shaders/elevated.json',
        'shaders/rainforest.json',
        'shaders/raymarching_part_1.json',
        'shaders/raymarching_part_2.json',
        'shaders/raymarching_part_3.json',
        'shaders/raymarching_part_4.json',
        'shaders/raymarching_part_6.json',
        'shaders/raymarching_primitives.json',
        'shaders/seascape.json',
        'shaders/volcanic.json',
      ];
      final shaders = await shadersFixture(shaderPaths);
      await store.saveShaders(shaders);
      final playlist = await playlistFixture('playlist/$playlistId.json');
      await store.savePlaylist(playlist);
      await store.savePlaylistShaders(
          playlistId, shaders.map((shader) => shader.info.id).toList());
      // act
      final response = await store.findAllShaderIdsByPlaylistId(playlistId);
      // assert
      final actual = response.ids ?? [];
      final expected = await findShaderIdsResponseFixture(shaderPaths);
      final expectedIds = expected.ids ?? [];
      expect(actual, containsAllInOrder(expectedIds));
    });

    test('Delete playlist by id', () async {
      // prepare
      final store = await newShadertoySqliteMemoryStore();
      final playlistId = 'week';
      final playlist = await playlistFixture('playlist/$playlistId.json');
      await store.savePlaylist(playlist);
      final fpr1 = await store.findPlaylistById(playlist.id);
      // act
      final dpr = await store.deletePlaylistById(playlist.id);
      final fpr2 = await store.findPlaylistById(playlist.id);
      // assert
      expect(fpr1.playlist, isNotNull);
      expect(dpr, isNotNull);
      expect(dpr.error, isNull);
      expect(fpr2.playlist, isNull);
    });

    test('Delete playlist by id with playlist reference', () async {
      // prepare
      final store = await newShadertoySqliteMemoryStore();
      final playlistId = 'week';
      final shaderPaths = [
        'shaders/seascape.json',
        'shaders/happy_jumping.json'
      ];
      final shaders = await shadersFixture(shaderPaths);
      await store.saveShaders(shaders);
      final playlist = await playlistFixture('playlist/$playlistId.json');
      await store.savePlaylist(playlist);
      await store.savePlaylistShaders(
          playlistId, shaders.map((shader) => shader.info.id).toList());
      final fspr1 = await store.findShadersByPlaylistId(playlistId);
      // act
      final dsr = await store.deletePlaylistById(playlistId);
      final fspr2 = await store.findShadersByPlaylistId(playlistId);
      // assert
      expect(fspr1.shaders, contains(FindShaderResponse(shader: shaders[0])));
      expect(dsr, isNotNull);
      expect(dsr.error, isNull);
      expect(fspr2.shaders, isEmpty);
    });
  });

  group('Sync', () {
    test('Save sync', () async {
      // prepare
      final store = await newShadertoySqliteMemoryStore();
      final sync = Sync(
          type: SyncType.shader,
          target: '3sBGRt',
          status: SyncStatus.ok,
          creationTime: DateTime.now());
      // act
      final response = await store.saveSync(sync);
      // assert
      expect(response, isNotNull);
      expect(response.error, isNull);
    });

    test('Save syncs', () async {
      // prepare
      final store = await newShadertoySqliteMemoryStore();
      final syncs = [
        Sync(
            type: SyncType.shader,
            target: '3sBGRt',
            status: SyncStatus.ok,
            creationTime: DateTime.now()),
        Sync(
            type: SyncType.user,
            target: 'XdcfDf',
            status: SyncStatus.error,
            message: 'Error',
            creationTime: DateTime.now(),
            updateTime: DateTime.now())
      ];
      // act
      final response = await store.saveSyncs(syncs);
      // assert
      expect(response, isNotNull);
      expect(response.error, isNull);
    });

    test('Save sync twice', () async {
      // prepare
      final store = await newShadertoySqliteMemoryStore();
      final creationTime = DateTime(2000, 1, 1, 0, 0, 0);
      final originalSync = Sync(
          type: SyncType.shader,
          target: '3sBGRt',
          status: SyncStatus.ok,
          creationTime: creationTime);
      final updatedSync = originalSync.copyWith(
          updateTime: creationTime.add(Duration(days: 1)));
      // act
      await store.saveSync(originalSync);
      final savedSync1 =
          await store.findSyncById(originalSync.type, originalSync.target);
      await store.saveSync(updatedSync);
      final savedSync2 =
          await store.findSyncById(originalSync.type, originalSync.target);
      // assert
      expect(savedSync1.sync, originalSync);
      expect(savedSync2.sync, updatedSync);
    });

    test('Find sync by id', () async {
      // prepare
      final store = await newShadertoySqliteMemoryStore();
      final creationTime = DateTime(2000, 1, 1, 0, 0, 0);
      final sync = Sync(
          type: SyncType.shader,
          target: '3sBGRt',
          status: SyncStatus.ok,
          creationTime: creationTime);
      await store.saveSync(sync);
      // act
      final response = await store.findSyncById(sync.type, sync.target);
      // assert
      expect(response, isNotNull);
      expect(response.error, isNull);
      expect(response.sync, sync);
    });

    test('Find sync by id with not found response', () async {
      // prepare
      final store = await newShadertoySqliteMemoryStore();
      final type = SyncType.shader;
      final target = '3sBGRt';
      // act
      final response = await store.findSyncById(type, target);
      // assert
      expect(response, isNotNull);
      expect(response.error, isNotNull);
      expect(
          response.error,
          ResponseError.notFound(
              message: 'Sync $target not found',
              context: contextSync,
              target: target));
    });

    test('Find syncs', () async {
      // prepare
      final store = await newShadertoySqliteMemoryStore();
      final creationTime = DateTime(2000, 1, 1, 0, 0, 0);
      final syncs = [
        Sync(
            type: SyncType.shader,
            target: '3sBGRt',
            status: SyncStatus.ok,
            creationTime: creationTime),
        Sync(
            type: SyncType.user,
            target: 'XdcfDf',
            status: SyncStatus.error,
            message: 'Error',
            creationTime: creationTime,
            updateTime: creationTime)
      ];
      await store.saveSyncs(syncs);
      // act
      final response = await store.findSyncs();
      // assert
      final actual = response.syncs ?? [];
      final expected =
          syncs.map((sync) => FindSyncResponse(sync: sync)).toList();

      expect(actual.length, syncs.length);
      expect(actual, containsAllInOrder(expected));
    });

    test('Find syncs by query', () async {
      // prepare
      final store = await newShadertoySqliteMemoryStore();
      final syncs = [
        Sync(
            type: SyncType.shader,
            target: '3sBGRa',
            status: SyncStatus.ok,
            creationTime: DateTime(2000, 1, 1, 0, 0, 0),
            updateTime: DateTime(2010, 1, 1, 0, 0, 0)),
        Sync(
            type: SyncType.shader,
            target: '3sBGRt',
            status: SyncStatus.error,
            creationTime: DateTime(2001, 1, 1, 0, 0, 0),
            updateTime: DateTime(2011, 1, 1, 0, 0, 0)),
        Sync(
            type: SyncType.user,
            target: 'XdcfDf',
            status: SyncStatus.error,
            message: 'Error',
            creationTime: DateTime(2002, 1, 1, 0, 0, 0),
            updateTime: DateTime(2012, 1, 1, 0, 0, 0))
      ];
      await store.saveSyncs(syncs);
      // act
      final response = await store.findSyncs(
          type: SyncType.shader,
          target: '3sBGRt',
          status: {SyncStatus.error},
          createdBefore: DateTime(2002, 1, 1, 0, 0, 0),
          updatedBefore: DateTime(2012, 1, 1, 0, 0, 0));
      // assert
      final actualSyncs = response.syncs;
      final expectedSyncs = [FindSyncResponse(sync: syncs[1])];

      expect(actualSyncs, containsAllInOrder(expectedSyncs));
    });

    test('Find all syncs', () async {
      // prepare
      final store = await newShadertoySqliteMemoryStore();
      final creationTime = DateTime(2000, 1, 1, 0, 0, 0);
      final syncs = [
        Sync(
            type: SyncType.shader,
            target: '3sBGRt',
            status: SyncStatus.ok,
            creationTime: creationTime),
        Sync(
            type: SyncType.user,
            target: 'XdcfDf',
            status: SyncStatus.error,
            message: 'Error',
            creationTime: creationTime,
            updateTime: creationTime)
      ];
      await store.saveSyncs(syncs);
      // act
      final response = await store.findAllSyncs();
      // assert
      expect(response, isNotNull);
      expect(response.error, isNull);

      final actualSyncs = response.syncs;
      final expected = FindSyncsResponse(
          syncs: syncs.map((sync) => FindSyncResponse(sync: sync)).toList());
      final expectedSyncs = expected.syncs ?? [];
      expect(actualSyncs, expectedSyncs);
    });

    test('Delete sync by id', () async {
      // prepare
      final store = await newShadertoySqliteMemoryStore();
      final syncType = SyncType.shader;
      final target = '3sBGRt';
      final creationTime = DateTime(2000, 1, 1, 0, 0, 0);
      final sync = Sync(
          type: syncType,
          target: target,
          status: SyncStatus.ok,
          creationTime: creationTime);
      await store.saveSync(sync);
      final fsr1 = await store.findSyncById(syncType, target);
      // act
      final dsr = await store.deleteSyncById(syncType, target);
      final fsr2 = await store.findSyncById(syncType, target);
      // assert
      expect(fsr1.sync, isNotNull);
      expect(dsr, isNotNull);
      expect(dsr.error, isNull);
      expect(fsr2.sync, isNull);
    });
  });
}
