import 'dart:io';

import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'package:shadertoy/shadertoy_api.dart';
import 'package:shadertoy_client/shadertoy_client.dart';
import 'package:test/test.dart';

import '../fixtures/fixtures.dart';
import '../mock_adapter.dart';
import '../site/site_mock_adapter.dart';
import '../ws/ws_mock_adapter.dart';

void main() {
  MockAdapter newAdapter([ShadertoyWSOptions? options]) {
    return MockAdapter(basePath: options?.apiPath);
  }

  ShadertoyWSOptions newWSOptions([ShadertoyWSOptions? options]) {
    return options != null
        ? options.copyWith(baseUrl: MockAdapter.mockBase)
        : ShadertoyWSOptions(apiKey: 'xx', baseUrl: MockAdapter.mockBase);
  }

  ShadertoySiteOptions newSiteOptions([ShadertoySiteOptions? options]) {
    return options != null
        ? options.copyWith(baseUrl: MockAdapter.mockBase)
        : ShadertoySiteOptions(baseUrl: MockAdapter.mockBase);
  }

  ShadertoyHybrid newClient(HttpClientAdapter adapter,
      {ShadertoySiteOptions? siteOptions, ShadertoyWSOptions? wsOptions}) {
    final client = Dio(BaseOptions(baseUrl: MockAdapter.mockBase))
      ..httpClientAdapter = adapter;

    return ShadertoyHybridClient(siteOptions ?? ShadertoySiteOptions(),
        wsOptions: wsOptions, client: client);
  }

  group('Authentication', () {
    test('Login with correct credentials', () async {
      // prepare
      final user = 'user';
      final password = 'password';
      final siteOptions =
          newSiteOptions(ShadertoySiteOptions(user: user, password: password));
      final nowPlusOneDay = DateTime.now().add(Duration(days: 1));
      final formatter = DateFormat('EEE, dd-MMM-yyyy HH:mm:ss');
      final expires = formatter.format(nowPlusOneDay);
      final adapter = newAdapter()
        ..addLoginRoute(siteOptions, 302, {
          HttpHeaders.setCookieHeader: [
            'sdtd=4e9dcd95663b58540ac7aa1dc3f0b914; expires=$expires GMT; Max-Age=1209600; path=/; secure; HttpOnly',
          ],
          HttpHeaders.locationHeader: ['/']
        });
      final api = newClient(adapter, siteOptions: siteOptions);
      // act
      final sr = await api.login();
      final loggedIn = await api.loggedIn;
      // assert
      expect(sr, isNotNull);
      expect(sr.error, isNull);
      expect(loggedIn, isTrue);
    });

    test('Logout without login', () async {
      // prepare
      final siteOptions = newSiteOptions();
      final adapter = newAdapter();
      final api = newClient(adapter, siteOptions: siteOptions);
      // act
      final sr = await api.logout();
      final loggedIn = await api.loggedIn;
      // assert
      expect(sr, isNotNull);
      expect(sr.error, isNull);
      expect(loggedIn, isFalse);
    });

    test('Logout with login', () async {
      // prepare
      final user = 'user';
      final password = 'password';
      final siteOptions =
          newSiteOptions(ShadertoySiteOptions(user: user, password: password));
      final nowPlusOneDay = DateTime.now().add(Duration(days: 1));
      final formatter = DateFormat('EEE, dd-MMM-yyyy HH:mm:ss');
      final expires = formatter.format(nowPlusOneDay);
      final adapter = newAdapter()
        ..addLoginRoute(siteOptions, 302, {
          HttpHeaders.setCookieHeader: [
            'sdtd=4e9dcd95663b58540ac7aa1dc3f0b914; expires=$expires GMT; Max-Age=1209600; path=/; secure; HttpOnly',
          ],
          HttpHeaders.locationHeader: ['/']
        })
        ..addLogoutRoute(siteOptions, 302, {
          HttpHeaders.setCookieHeader: [
            'sdtd=deleted; expires=Thu, 01-Jan-1970 00:00:01 GMT; Max-Age=0; path=/; secure; httponly',
          ],
          HttpHeaders.locationHeader: ['/']
        });
      final api = newClient(adapter, siteOptions: siteOptions);
      // act
      final lir = await api.login();
      final loggedIn = await api.loggedIn;
      // assert
      expect(lir, isNotNull);
      expect(lir.error, isNull);
      expect(loggedIn, isTrue);
      // act
      final lor = await api.logout();
      final loggedOut = !await api.loggedIn;
      // assert
      expect(lor, isNotNull);
      expect(lor.error, isNull);
      expect(loggedOut, isTrue);
    });
  });

  group('Shaders', () {
    test('Find shader by id with WS client', () async {
      // prepare
      final wsOptions = newWSOptions();
      final fs = await findShaderResponseFixture('shaders/seascape.json');
      final adapter = newAdapter(wsOptions)..addFindShaderRoute(fs, wsOptions);
      final api = newClient(adapter, wsOptions: wsOptions);
      // act
      final sr = await api.findShaderById('Ms2SD1');
      // assert
      expect(sr, isNotNull);
      expect(sr.error, isNull);
      expect(sr.shader, isNotNull);
      expect(sr, fs);
    });

    test('Find shader by id with site client', () async {
      // prepare
      final siteOptions = ShadertoySiteOptions();
      final shaders = ['shaders/seascape.json'];
      final sl = await shadersFixture(shaders);
      final adapter = newAdapter()..addShadersRoute(sl, siteOptions);
      final api = newClient(adapter, siteOptions: siteOptions);
      // act
      final sr = await api.findShaderById('Ms2SD1');
      // assert
      expect(sr, isNotNull);
      expect(sr.error, isNull);
      expect(sr.shader, isNotNull);
      expect(sr, await findShaderResponseFixture('shaders/seascape.json'));
    });

    test('Find shaders by id set with WS client', () async {
      // prepare
      final wsOptions = newWSOptions();
      final shaders = ['shaders/seascape.json', 'shaders/happy_jumping.json'];
      final fsl = await findShaderResponseFixtures(shaders);
      final adapter = newAdapter(wsOptions)
        ..addFindShadersRoute(fsl, wsOptions);
      final api = newClient(adapter, wsOptions: wsOptions);
      // act
      final sr = await api.findShadersByIdSet({'Ms2SD1', '3lsSzf'});
      // assert
      expect(sr, isNotNull);
      expect(sr.error, isNull);
      expect(sr, await findShadersResponseFixture(shaders));
    });

    test('Find shaders by id set with site client', () async {
      // prepare
      final siteOptions = newSiteOptions();
      final shaders = ['shaders/seascape.json', 'shaders/happy_jumping.json'];
      final sl = await shadersFixture(shaders);
      final adapter = newAdapter()..addShadersRoute(sl, siteOptions);
      final api = newClient(adapter, siteOptions: siteOptions);
      // act
      final sr = await api.findShadersByIdSet({'Ms2SD1', '3lsSzf'});
      // assert
      expect(sr, isNotNull);
      expect(sr.error, isNull);
      expect(sr, await findShadersResponseFixture(shaders));
    });

    test('Find shaders with site WS client', () async {
      // prepare
      final wsOptions = newWSOptions();
      final term = 'prince';
      final shaders = [
        'shaders/lovely_stars.json',
        'shaders/scaleable_homeworlds.json',
        'shaders/prince_necklace.json'
      ];
      final fsi = await findShaderIdsResponseFixture(shaders);
      final fsl = await findShaderResponseFixtures(shaders);
      final adapter = newAdapter(wsOptions)
        ..addFindShaderIdsRoute(fsi, wsOptions, term: term)
        ..addFindShadersRoute(fsl, wsOptions);
      final api = newClient(adapter, wsOptions: wsOptions);
      // act
      final sr = await api.findShaders(term: term);
      // assert
      expect(sr, isNotNull);
      expect(sr.error, isNull);
      expect(sr, await findShadersResponseFixture(shaders));
    });

    test('Find shaders with site client', () async {
      // prepare
      final siteOptions = newSiteOptions();
      final query = 'raymarch';
      final sort = Sort.love;
      final filters = {'multipass'};
      final from = 0;
      final shaders = [
        'shaders/elevated.json',
        'shaders/rainforest.json',
        'shaders/volcanic.json',
        'shaders/sirenian_dawn.json',
        'shaders/goo.json',
        'shaders/cloudy_terrain.json',
        'shaders/raymarching_tutorial.json',
        'shaders/greek_temple.json',
        'shaders/gargantua_with_hdr_bloom.json',
        'shaders/selfie_girl.json',
        'shaders/ladybug.json',
        'shaders/precalculated_voronoi_heightmap.json',
      ];
      final sl = await shadersFixture(shaders);
      final response = await textFixture('results/filtered_page_1.html');
      final adapter = newAdapter()
        ..addResultsRoute(response, siteOptions,
            query: query, sort: sort, filters: filters, from: from)
        ..addShadersRoute(sl, siteOptions);
      final api = newClient(adapter, siteOptions: siteOptions);
      // act
      final sr = await api.findShaders(
          term: query, sort: sort, filters: filters, from: from);
      // assert
      expect(sr, isNotNull);
      expect(sr.error, isNull);
      expect(sr, await findShadersResponseFixture(shaders));
    });

    test('Find all shader ids with WS client', () async {
      // prepare
      final wsOptions = newWSOptions();
      final shaders = [
        'shaders/after.json',
        'shaders/happy_jumping.json',
        'shaders/homeward.json',
        'shaders/lovely_stars.json',
        'shaders/prince_necklace.json',
        'shaders/scaleable_homeworlds.json',
        'shaders/seascape.json'
      ];
      final fsi = await findShaderIdsResponseFixture(shaders);
      final adapter = newAdapter(wsOptions)
        ..addFindAllShaderIdsRoute(fsi, wsOptions);
      final api = newClient(adapter, wsOptions: wsOptions);
      // act
      final sr = await api.findAllShaderIds();
      // assert
      expect(sr, isNotNull);
      expect(sr.error, isNull);
      expect(sr, fsi);
    });

    test('Find all shader ids with site client', () async {
      // prepare
      final siteOptions = newSiteOptions();
      final shaders = [
        'shaders/fractal_explorer_multi_res.json',
        'shaders/rave_fractal.json',
        'shaders/rhodium_fractalscape.json',
        'shaders/fractal_explorer_dof.json',
        'shaders/kleinian_variations.json',
        'shaders/simplex_noise_fire_milkdrop_beat.json',
        'shaders/fight_them_all_fractal.json',
        'shaders/trilobyte_julia_fractal_smasher.json',
        'shaders/rapping_fractal.json',
        'shaders/trilobyte_bipolar_daisy_complex.json',
        'shaders/smashing_fractals.json',
        'shaders/trilobyte_multi_turing_pattern.json',
        'shaders/surfer_boy.json',
        'shaders/alien_corridor.json',
        'shaders/turn_burn.json',
        'shaders/ice_primitives.json',
        'shaders/basic_montecarlo.json',
        'shaders/crossy_penguin.json',
        'shaders/full_scene_radial_blur.json',
        'shaders/gargantua_with_hdr_bloom.json',
        'shaders/blueprint_of_architekt.json',
        'shaders/three_pass_dof.json',
        'shaders/elephant.json',
        'shaders/multiple_transparency.json'
      ];
      final response1 = await textFixture('results/24_page_1.html');
      final response2 = await textFixture('results/24_page_2.html');
      final adapter = newAdapter()
        ..addResultsRoute(response1, siteOptions)
        ..addResultsRoute(response2, siteOptions, from: 12, num: 12);
      final api = newClient(adapter, siteOptions: siteOptions);
      // act
      final sr = await api.findAllShaderIds();
      // assert
      expect(sr, isNotNull);
      expect(sr.error, isNull);
      expect(sr, await findShaderIdsResponseFixture(shaders, count: 24));
    });

    test('Find shader ids with WS client', () async {
      // prepare
      final wsOptions = newWSOptions();
      final term = 'prince';
      final shaders = [
        'shaders/lovely_stars.json',
        'shaders/scaleable_homeworlds.json',
        'shaders/prince_necklace.json'
      ];
      final fsi = await findShaderIdsResponseFixture(shaders);
      final adapter = newAdapter(wsOptions)
        ..addFindShaderIdsRoute(fsi, wsOptions, term: term);

      final api = newClient(adapter, wsOptions: wsOptions);
      // act
      final sr = await api.findShaderIds(term: term);
      // assert
      expect(sr, isNotNull);
      expect(sr.error, isNull);
      expect(sr, fsi);
    });

    test('Find shader ids with site client', () async {
      // prepare
      final siteOptions = newSiteOptions();
      final shaders = [
        'shaders/seascape.json',
        'shaders/raymarching_primitives.json',
        'shaders/creation.json',
        'shaders/clouds.json',
        'shaders/raymarching_part_6.json',
        'shaders/elevated.json',
        'shaders/volcanic.json',
        'shaders/raymarching_part_1.json',
        'shaders/rainforest.json',
        'shaders/raymarching_part_2.json',
        'shaders/raymarching_part_3.json',
        'shaders/very_fast_procedural_ocean.json',
      ];
      final response = await textFixture('results/normal.html');
      final adapter = newAdapter()..addResultsRoute(response, siteOptions);
      final api = newClient(adapter, siteOptions: siteOptions);
      // act
      final sr = await api.findShaderIds();
      // assert
      expect(sr, isNotNull);
      expect(sr.error, isNull);
      expect(sr, await findShaderIdsResponseFixture(shaders, count: 43698));
    });
  });

  group('Users', () {
    test('Find user by id', () async {
      // prepare
      final siteOptions = newSiteOptions();
      final userId = 'iq';
      final response = await textFixture('user/$userId.html');
      final adapter = newAdapter()..addUserRoute(response, userId, siteOptions);
      final api = newClient(adapter, siteOptions: siteOptions);
      // act
      final sr = await api.findUserById(userId);
      // assert
      expect(sr, isNotNull);
      expect(sr.error, isNull);
      expect(sr.user, isNotNull);
      expect(
          sr,
          FindUserResponse(
              user: User(
                  id: userId,
                  picture: '/media/users/$userId/profile.png',
                  memberSince: DateTime(2013, 1, 11),
                  following: 53,
                  followers: 353,
                  about:
                      '\n\n*[url]http://www.iquilezles.org[/url]\n*[url]https://www.patreon.com/inigoquilez[/url]\n*[url]https://www.youtube.com/c/InigoQuilez[/url]\n*[url]https://www.facebook.com/inigo.quilez.art[/url]\n*[url]https://twitter.com/iquilezles[/url]')));
    });

    test('Find shaders by user id', () async {
      // prepare
      final siteOptions = newSiteOptions();
      final userId = 'iq';
      final shaders = [
        'shaders/raymarching_primitives.json',
        'shaders/clouds.json',
        'shaders/elevated.json',
        'shaders/volcanic.json',
        'shaders/rainforest.json',
        'shaders/snail.json',
        'shaders/voxel_edges.json',
        'shaders/mike.json'
      ];
      final response = await textFixture('user/iq_page_1.html');
      final sl = await shadersFixture(shaders);
      final adapter = newAdapter()
        ..addUserShadersRoute(response, userId, siteOptions)
        ..addShadersRoute(sl, siteOptions);
      final api = newClient(adapter, siteOptions: siteOptions);
      // act
      final sr = await api.findShadersByUserId(userId);
      // assert
      expect(sr, isNotNull);
      expect(sr.error, isNull);
      expect(sr, await findShadersResponseFixture(shaders));
    });

    test('Find shader ids by user id, first page', () async {
      // prepare
      final siteOptions = newSiteOptions();
      final userId = 'iq';
      final shaders = [
        'shaders/raymarching_primitives.json',
        'shaders/clouds.json',
        'shaders/elevated.json',
        'shaders/volcanic.json',
        'shaders/rainforest.json',
        'shaders/snail.json',
        'shaders/voxel_edges.json',
        'shaders/mike.json'
      ];
      final response = await textFixture('user/iq_page_1.html');
      final sl = await shadersFixture(shaders);
      final adapter = newAdapter()
        ..addUserShadersRoute(response, userId, siteOptions)
        ..addShadersRoute(sl, siteOptions);
      final api = newClient(adapter, siteOptions: siteOptions);
      // act
      final sr = await api.findShaderIdsByUserId(userId);
      // assert
      expect(sr, isNotNull);
      expect(sr.error, isNull);
      expect(
          sr,
          await findShaderIdsResponseFixture(shaders,
              count: siteOptions.pageUserShaderCount));
    });
  });

  group('Comments', () {
    test('Find comments by shader id', () async {
      // prepare
      final siteOptions = newSiteOptions();
      final shaderId = 'ldB3Dt';
      final response = await commentsResponseFixture('comment/$shaderId.json');
      final adapter = newAdapter()
        ..addCommentRoute(response, shaderId, siteOptions);
      final api = newClient(adapter, siteOptions: siteOptions);
      // act
      final sr = await api.findCommentsByShaderId(shaderId);
      // assert
      expect(sr, isNotNull);
      expect(sr.error, isNull);
      expect(sr.comments, isNotNull);
      expect(sr.comments, isNotEmpty);
      expect(
          sr,
          FindCommentsResponse(comments: [
            Comment(
                id: 'XlGcRK',
                shaderId: shaderId,
                userId: 'wosztal15',
                picture: '/media/users/wosztal15/profile.jpeg',
                date: DateTime.fromMillisecondsSinceEpoch(1599820652 * 1000),
                text: '\nI have to admit that it makes an amazing impression!',
                hidden: false),
            Comment(
                id: '4lGyzG',
                shaderId: shaderId,
                userId: 'Cubex',
                picture: '/media/users/Cubex/profile.png',
                date: DateTime.fromMillisecondsSinceEpoch(1599493658 * 1000),
                text: 'Woobly moobly, it\'s amazing!',
                hidden: false),
            Comment(
                id: 'Xd2GW1',
                shaderId: shaderId,
                userId: 'iq',
                picture: '/media/users/iq/profile.png',
                date: DateTime.fromMillisecondsSinceEpoch(1395074155 * 1000),
                text: 'Oh, I love it!',
                hidden: false),
          ]));
    });
  });

  group('Playlist', () {
    test('Find playlist by id', () async {
      // prepare
      final siteOptions = newSiteOptions();
      final playlistId = 'week';
      final response = await textFixture('playlist/$playlistId.html');
      final adapter = newAdapter()
        ..addPlaylistRoute(response, playlistId, siteOptions);
      final api = newClient(adapter, siteOptions: siteOptions);
      // act
      final sr = await api.findPlaylistById(playlistId);
      // assert
      expect(sr, isNotNull);
      expect(sr.error, isNull);
      expect(sr.playlist, isNotNull);
      expect(
          sr,
          FindPlaylistResponse(
              playlist: Playlist(
                  id: playlistId,
                  userId: 'shadertoy',
                  name: 'Shaders of the Week',
                  description:
                      'Playlist with every single shader of the week ever.')));
    });

    test('Find shaders by playlist id', () async {
      // prepare
      final siteOptions = newSiteOptions();
      final playlistId = 'week';
      final shaders = [
        'shaders/cables2.json',
        'shaders/ray_marching_experiment_43.json',
        'shaders/impulse_glass.json',
        'shaders/3d_cellular_tiling.json',
        'shaders/phyllotaxes.json',
        'shaders/geometric_cellular_surfaces.json',
        'shaders/ed_209.json',
        'shaders/hexpacked_sphere_bass_shader.json',
        'shaders/puma_clyde_concept.json',
        'shaders/asymmetric_hexagon_landscape.json',
        'shaders/worms.json',
        'shaders/primitive_portrait.json'
      ];
      final sl = await shadersFixture(shaders);
      final response = await textFixture('playlist/week_page_1.html');
      final adapter = newAdapter()
        ..addPlaylistShadersRoute(response, playlistId, siteOptions)
        ..addShadersRoute(sl, siteOptions);
      final api = newClient(adapter, siteOptions: siteOptions);
      // act
      final sr = await api.findShadersByPlaylistId(playlistId);
      // assert
      expect(sr, isNotNull);
      expect(sr.error, isNull);
      expect(sr, await findShadersResponseFixture(shaders));
    });

    test('Find shader ids by playlist id', () async {
      // prepare
      final siteOptions = newSiteOptions();
      final playlistId = 'week';
      final shaders = [
        'shaders/cables2.json',
        'shaders/ray_marching_experiment_43.json',
        'shaders/impulse_glass.json',
        'shaders/3d_cellular_tiling.json',
        'shaders/phyllotaxes.json',
        'shaders/geometric_cellular_surfaces.json',
        'shaders/ed_209.json',
        'shaders/hexpacked_sphere_bass_shader.json',
        'shaders/puma_clyde_concept.json',
        'shaders/asymmetric_hexagon_landscape.json',
        'shaders/worms.json',
        'shaders/primitive_portrait.json'
      ];
      final sl = await shadersFixture(shaders);
      final response = await textFixture('playlist/week_page_1.html');
      final adapter = newAdapter()
        ..addPlaylistShadersRoute(response, playlistId, siteOptions)
        ..addShadersRoute(sl, siteOptions);
      final api = newClient(adapter, siteOptions: siteOptions);
      // act
      final sr = await api.findShaderIdsByPlaylistId(playlistId);
      // assert
      expect(sr, isNotNull);
      expect(sr.error, isNull);
      expect(
          sr,
          await findShaderIdsResponseFixture(shaders,
              count: siteOptions.pagePlaylistShaderCount));
    });
  });

  group('Downloads', () {
    test('Download shader picture', () async {
      // prepare
      final siteOptions = newSiteOptions();
      final shaderId = 'XsX3RB';
      final fixturePath = 'media/shaders/$shaderId.jpg';
      final response = await binaryFixture(fixturePath);
      final adapter = newAdapter()
        ..addDownloadShaderMedia(response, shaderId, siteOptions);
      final api = newClient(adapter, siteOptions: siteOptions);
      // act
      final sr = await api.downloadShaderPicture(shaderId);
      // assert
      expect(sr, isNotNull);
      expect(sr.error, isNull);
      expect(sr.bytes, isNotNull);
      expect(sr, await downloadFileResponseFixture(fixturePath));
    });

    test('Download media', () async {
      // prepare
      final siteOptions = newSiteOptions();
      final fixturePath = 'img/profile.jpg';
      final response = await binaryFixture(fixturePath);
      final adapter = newAdapter()
        ..addDownloadFile(fixturePath, response, siteOptions);
      final api = newClient(adapter, siteOptions: siteOptions);
      // act
      final sr = await api.downloadMedia('/$fixturePath');
      // assert
      expect(sr, isNotNull);
      expect(sr.error, isNull);
      expect(sr.bytes, isNotNull);
      expect(sr, await downloadFileResponseFixture(fixturePath));
    });
  });
}
