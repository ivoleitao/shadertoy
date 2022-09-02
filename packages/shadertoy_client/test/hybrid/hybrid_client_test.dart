import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as p;
import 'package:shadertoy/shadertoy_api.dart';
import 'package:shadertoy_client/shadertoy_client.dart';
import 'package:shadertoy_client/src/site/site_parser.dart';
import 'package:shadertoy_sqlite/shadertoy_sqlite.dart';
import 'package:stash/stash_api.dart';
import 'package:stash_memory/stash_memory.dart';
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
      final sl = await shaderFixtures(shaders);
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
      final sl = await shaderFixtures(shaders);
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
      final response = await textFixture('results/results_0_12.html');
      final sl = await shaderListFixture('results/results_0_12.json');
      final adapter = newAdapter()
        ..addResultsRoute(response, siteOptions,
            query: query, sort: sort, filters: filters, from: from);
      final api = newClient(adapter, siteOptions: siteOptions);
      // act
      final sr = await api.findShaders(
          term: query, sort: sort, filters: filters, from: from);
      // assert
      expect(sr, isNotNull);
      expect(sr.error, isNull);
      expect(sr, sl.toFindShadersResponse(total: 36));
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
      final response1 = await textFixture('results/results_0_12.html');
      final response2 = await textFixture('results/results_12_12.html');
      final response3 = await textFixture('results/results_24_12.html');
      final sl = await shaderIdListFixtures([
        'results/results_0_12.json',
        'results/results_12_12.json',
        'results/results_24_12.json'
      ]);
      final adapter = newAdapter()
        ..addResultsRoute(response1, siteOptions)
        ..addResultsRoute(response2, siteOptions,
            from: siteOptions.pageResultsShaderCount,
            num: siteOptions.pageResultsShaderCount)
        ..addResultsRoute(response3, siteOptions,
            from: siteOptions.pageResultsShaderCount * 2,
            num: siteOptions.pageResultsShaderCount);
      final api = newClient(adapter, siteOptions: siteOptions);
      // act
      final sr = await api.findAllShaderIds();
      // assert
      expect(sr, isNotNull);
      expect(sr.error, isNull);
      expect(sr, FindShaderIdsResponse(count: 36, ids: sl));
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
      final response = await textFixture('results/results.html');
      final sl = await shaderIdListFixture('results/results.json');
      final adapter = newAdapter()..addResultsRoute(response, siteOptions);
      final api = newClient(adapter, siteOptions: siteOptions);
      // act
      final sr = await api.findShaderIds();
      // assert
      expect(sr, isNotNull);
      expect(sr.error, isNull);
      expect(sr, FindShaderIdsResponse(count: 63918, ids: sl));
    });

    test('Find new shader ids with WS client', () async {
      // prepare
      final options = newWSOptions();
      final num = options.shaderCount;
      final shaders1 = [
        'shaders/voxel_game_evolution.json', // wsByWV 1587452922
        'shaders/kleinian_variations.json', // ldSyRd 1493419573
        'shaders/rhodium_fractalscape.json', // ltKGzc 1476023128
        'shaders/rapping_fractal.json', // 4sKSzt 1466044200
        'shaders/fight_them_all_fractal.json', // XsGXzK 1465452238
        'shaders/rave_fractal.json', // MsKXDw 1464836517
        'shaders/simplex_noise_fire_milkdrop_beat.json', // XsKGzc 1455834915
        'shaders/smashing_fractals.json', // wsfXRn 1550436200
        'shaders/fractal_explorer_multi_res.json', // MdV3Wz 1454184710
        'shaders/fractal_explorer_dof.json', // MdyGRW 1453409227
        'shaders/trilobyte_bipolar_daisy_complex.json', // Xs3fDS 1526469729
        'shaders/trilobyte_julia_fractal_smasher.json' // ls3fD7 1525386682
      ];
      final shaders2 = [
        'shaders/trilobyte_multi_turing_pattern.json', // tsfSz4 1550782157
        'shaders/surfer_boy.json', // ldd3DX 1542803894
        'shaders/turn_burn.json', // MlscWX 1509015241
        'shaders/alien_corridor.json', // 4slyRs 1490564246
        'shaders/blueprint_of_architekt.json', // 4tySDW 1485002916
        'shaders/crossy_penguin.json', // 4dKXDG 1466337141
        'shaders/gargantua_with_hdr_bloom.json', // lstSRS 1460054893
        'shaders/multiple_transparency.json', // XtyGWD 1474559035
        'shaders/ice_primitives.json', // MscXzn 1457308502
        'shaders/elephant.json', // 4dKGWm 1454853751
        'shaders/three_pass_dof.json', // MsG3Dz 1453999525
        'shaders/full_scene_radial_blur.json' // XsKGRW 1453904549
      ];
      final shaders3 = [
        'shaders/basic_montecarlo.json', // MsdGzl, 1451942717
        'shaders/volcanic.json', // XsX3RB 1372830991
        'shaders/elevated.json' // MdX3Rr 1360495251
      ];
      final fsi1 = await findShaderIdsResponseFixture(shaders1);
      final fsi2 = await findShaderIdsResponseFixture(shaders2);
      final fsi3 = await findShaderIdsResponseFixture(shaders3);
      final storeShaderIds = {'XsX3RB', 'MdX3Rr'};
      final adapter = newAdapter(options)
        ..addFindShaderIdsRoute(fsi1, options,
            sort: Sort.newest, from: 0, num: num)
        ..addFindShaderIdsRoute(fsi2, options,
            sort: Sort.newest, from: num, num: num)
        ..addFindShaderIdsRoute(fsi3, options,
            sort: Sort.newest, from: num * 2, num: num);

      final api = newClient(adapter, wsOptions: options);
      // act
      final sr = await api.findNewShaderIds(storeShaderIds);
      // assert
      expect(sr, isNotNull);
      expect(sr.error, isNull);
      expect(
          sr,
          FindShaderIdsResponse(ids: [
            ...?fsi1.ids,
            ...?fsi2.ids,
            ...['MsdGzl']
          ]));
    });

    test('Find new shader ids with site client', () async {
      // prepare
      final options = newSiteOptions();
      final response1 = await textFixture('results/results_newest_0_12.html');
      final response2 = await textFixture('results/results_newest_12_12.html');
      final response3 = await textFixture('results/results_newest_24_12.html');
      final sl = await shaderIdListFixtures([
        'results/results_newest_0_12.json',
        'results/results_newest_12_12.json',
        'results/results_newest_24_12.json'
      ]);
      final storeShaderIds = {'ftGcRm', 'ftyyzw'};
      final adapter = newAdapter()
        ..addResultsRoute(sort: Sort.newest, response1, options)
        ..addResultsRoute(
            sort: Sort.newest,
            response2,
            options,
            from: options.pageResultsShaderCount,
            num: options.pageResultsShaderCount)
        ..addResultsRoute(
            sort: Sort.newest,
            response3,
            options,
            from: options.pageResultsShaderCount * 2,
            num: options.pageResultsShaderCount);
      final api = newClient(adapter, siteOptions: options);
      // act
      final sr = await api.findNewShaderIds(storeShaderIds);
      // assert
      expect(sr, isNotNull);
      expect(sr.error, isNull);
      expect(sr, FindShaderIdsResponse(count: 34, ids: sl.sublist(0, 34)));
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
                  following: 67,
                  followers: 1176,
                  about:
                      '\n\n*[url]http://www.iquilezles.org[/url]\n*[url]https://www.patreon.com/inigoquilez[/url]\n*[url]https://www.youtube.com/c/InigoQuilez[/url]\n*[url]https://www.facebook.com/inigo.quilez.art[/url]\n*[url]https://twitter.com/iquilezles[/url]')));
    });

    test('Find shaders by user id', () async {
      // prepare
      final siteOptions = newSiteOptions();
      final userId = 'iq';
      final response = await textFixture('user/iq_0_8.html');
      final sl = await shaderListFixture('user/iq_0_8.json');
      final adapter = newAdapter()
        ..addUserShadersRoute(response, userId, siteOptions);
      final api = newClient(adapter, siteOptions: siteOptions);
      // act
      final sr = await api.findShadersByUserId(userId);
      // assert
      expect(sr, isNotNull);
      expect(sr.error, isNull);
      expect(sr, sl.toFindShadersResponse(total: 24));
    });

    test('Find shader ids by user id, first page', () async {
      // prepare
      final siteOptions = newSiteOptions();
      final userId = 'iq';
      final response = await textFixture('user/iq_0_8.html');
      final sl = await shaderIdListFixture('user/iq_0_8.json');
      final adapter = newAdapter()
        ..addUserShadersRoute(response, userId, siteOptions);
      final api = newClient(adapter, siteOptions: siteOptions);
      // act
      final sr = await api.findShaderIdsByUserId(userId);
      // assert
      expect(sr, isNotNull);
      expect(sr.error, isNull);
      expect(sr, FindShaderIdsResponse(count: 24, ids: sl));
    });
  }, timeout: Timeout(Duration(seconds: 60)));

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
        'shaders/kitties.json',
        'shaders/fire_fire.json',
        'shaders/giant_ventifacts_of_calientis_v.json',
        'shaders/controllable_machinery.json',
        'shaders/battleships.json',
        'shaders/soul_creature.json',
        'shaders/hex_marching.json',
        'shaders/saturday_torus.json',
        'shaders/jeweled_vortex.json',
        'shaders/fluffballs.json',
        'shaders/coastal_landscape.json',
        'shaders/night_circuit.json'
      ];
      final sl = await shaderFixtures(shaders);
      final response = await textFixture('playlist/week_0_12.html');
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
        'shaders/kitties.json',
        'shaders/fire_fire.json',
        'shaders/giant_ventifacts_of_calientis_v.json',
        'shaders/controllable_machinery.json',
        'shaders/battleships.json',
        'shaders/soul_creature.json',
        'shaders/hex_marching.json',
        'shaders/saturday_torus.json',
        'shaders/jeweled_vortex.json',
        'shaders/fluffballs.json',
        'shaders/coastal_landscape.json',
        'shaders/night_circuit.json'
      ];
      final sl = await shaderFixtures(shaders);
      final response = await textFixture('playlist/week_0_12.html');
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
  }, timeout: Timeout(Duration(seconds: 60)));

  group('Downloads', () {
    test('Download shader picture', () async {
      // prepare
      final siteOptions = newSiteOptions();
      final shaderId = 'XsX3RB';
      final fixturePath = 'media/shaders/$shaderId.jpg';
      final response = await binaryFixture(fixturePath);
      final adapter = newAdapter()
        ..addDownloadShaderPicture(shaderId, response, siteOptions);
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

  group('Sync', () {
    test('Full Mode', () async {
      // prepare
      final siteOptions = ShadertoySiteOptions();

      final shaders = await shaderListFixtures([
        'results/results_0_12.json',
        'results/results_12_12.json',
        'results/results_24_12.json'
      ]);
      final shaderCommentMap = {
        for (var shader in shaders)
          shader.info.id:
              await commentsResponseFixture('comment/${shader.info.id}.json')
      };
      final shaderMediaMap = {
        for (var shader in shaders)
          for (var path in shader.picturePaths())
            path: await binaryFixture(path)
      };

      final userIds = {...shaders.map((s) => s.info.userId)};
      final userHtmlMap = {
        for (var userId in userIds)
          userId: await textFixture('user/$userId.html')
      };

      final userList = [
        for (var userEntry in userHtmlMap.entries)
          parseUser(userEntry.key, parseDocument(userEntry.value)).user
      ];

      final userMediaMap = {
        for (var picture
            in userList.map((user) => user?.picture).whereType<String>())
          p.relative(picture, from: '/'): await binaryFixture(picture)
      };

      final results1 = await textFixture('results/results_0_12.html');
      final results2 = await textFixture('results/results_12_12.html');
      final results3 = await textFixture('results/results_24_12.html');

      final playlistId = 'week';
      final playlist1 = await textFixture('playlist/${playlistId}_0_12.html');
      final playlist2 = await textFixture('playlist/${playlistId}_12_12.html');
      final playlist3 = await textFixture('playlist/${playlistId}_24_12.html');

      final playlistShaderPaths = [
        // 1
        'shaders/kitties.json',
        'shaders/fire_fire.json',
        'shaders/giant_ventifacts_of_calientis_v.json',
        'shaders/controllable_machinery.json',
        'shaders/battleships.json',
        'shaders/soul_creature.json',
        'shaders/hex_marching.json',
        'shaders/saturday_torus.json',
        'shaders/jeweled_vortex.json',
        'shaders/fluffballs.json',
        'shaders/coastal_landscape.json',
        'shaders/night_circuit.json',
        // 2
        'shaders/pig_squad_9_year_anniversary.json',
        'shaders/cubic_dispersal.json',
        'shaders/color_processing.json',
        'shaders/space_ship.json',
        'shaders/space_ship.json',
        'shaders/danger_noodle.json',
        'shaders/stars_and_galaxy.json',
        'shaders/desperate_distraction.json',
        'shaders/party_concert_visuals.json',
        'shaders/omzg_shader_royale.json',
        'shaders/morning_commute.json',
        'shaders/quartz_wip.json',
        // 3
        'shaders/synthwave_song.json',
        'shaders/a_paper_heart_for_my_valentine.json',
        'shaders/terraform.json',
        'shaders/star_gazing_hippo.json',
        'shaders/undulating_columns.json',
        'shaders/trippy_triangle.json',
        'shaders/exit_the_matrix.json',
        'shaders/on_the_salt_lake.json',
        'shaders/recursive_donut.json',
        'shaders/truchet_kaleidoscope_ftw.json',
        'shaders/paper_plane.json',
        'shaders/hyper_dough.json'
      ];
      final playlistShaders = await shaderFixtures(playlistShaderPaths);

      final adapter = newAdapter()
        ..addResultsRoute(results1, siteOptions)
        ..addResultsRoute(results2, siteOptions,
            from: siteOptions.pageResultsShaderCount,
            num: siteOptions.pageResultsShaderCount)
        ..addResultsRoute(results3, siteOptions,
            from: siteOptions.pageResultsShaderCount * 2,
            num: siteOptions.pageResultsShaderCount)
        ..addShaderRouteList(shaders, siteOptions)
        ..addCommentsRouteMap(shaderCommentMap, siteOptions)
        ..addDownloadMediaMap(shaderMediaMap, siteOptions)
        ..addUserRouteMap(userHtmlMap, siteOptions)
        ..addDownloadMediaMap(userMediaMap, siteOptions)
        ..addPlaylistRoute(playlist1, playlistId, siteOptions)
        ..addPlaylistShadersRoute(playlist1, playlistId, siteOptions)
        ..addPlaylistShadersRoute(playlist2, playlistId, siteOptions,
            from: siteOptions.pagePlaylistShaderCount,
            num: siteOptions.pagePlaylistShaderCount)
        ..addPlaylistShadersRoute(playlist3, playlistId, siteOptions,
            from: siteOptions.pagePlaylistShaderCount * 2,
            num: siteOptions.pagePlaylistShaderCount)
        ..addShadersRoute(playlistShaders, siteOptions);

      final metadataStore = newShadertoySqliteStore();
      final assetStore =
          await newMemoryVaultStore().then((store) => store.vault<Uint8List>());
      final api = newClient(adapter, siteOptions: siteOptions);

      // act
      await api.rsync(metadataStore, assetStore, HybridSyncMode.full,
          playlistIds: [playlistId]);
      // assert
      final allSyncs = await metadataStore.findAllSyncs();
      expect(allSyncs, isNotNull);
      expect(allSyncs.error, isNull);

      final syncs = allSyncs.syncs ?? [];

      final shaderSyncs = syncs.where((fsr) =>
          fsr.sync?.status == SyncStatus.ok &&
          fsr.sync?.type == SyncType.shader);
      expect(shaderSyncs.length, 36);
      final shaderPictureSyncs = syncs.where((fsr) =>
          fsr.sync?.status == SyncStatus.ok &&
          fsr.sync?.type == SyncType.shaderAsset);
      expect(shaderPictureSyncs.length, shaderMediaMap.length);

      final userSyncs = syncs.where((fsr) =>
          fsr.sync?.status == SyncStatus.ok && fsr.sync?.type == SyncType.user);
      expect(userSyncs.length, 22);
      final userPictureSyncs = syncs.where((fsr) =>
          fsr.sync?.status == SyncStatus.ok &&
          fsr.sync?.type == SyncType.userAsset);
      expect(userPictureSyncs.length, userMediaMap.length);

      /*
      final shaderPaths = {
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
      };

      final shaders = [
        for (var shader in shaderPaths) await shaderFixture(shader)
      ];
      final commentsReponseMap = {
        for (var shader in shaders)
          shader.info.id:
              await commentsResponseFixture('comment/${shader.info.id}.json')
      };
      final shaderMedia = {
        for (var shader in shaders)
          for (var path in shader.picturePaths())
            path: await binaryFixture(path)
      };

      final userIds = {...shaders.map((s) => s.info.userId)};
      final userResponseMap = {
        for (var userId in userIds)
          userId: await textFixture('user/$userId.html')
      };
      final userMedia = {
        for (var userId in userIds)
          'media/users/$userId/profile.png':
              await binaryFixture('media/users/$userId/profile.png')
      };

      final results1 = await textFixture('results/sync_step_1.html');
      final results2 = await textFixture('results/sync_step_2.html');
      final playlist = await textFixture('playlist/week_by_mu6k.html');
      final playlist1 = await textFixture('playlist/week_24_page_1.html');
      final playlist2 = await textFixture('playlist/week_24_page_2.html');
      final adapter = newAdapter()
        ..addResultsRoute(results1, siteOptions)
        ..addResultsRoute(results2, siteOptions, from: 12, num: 12)
        ..addPlaylistRoute(playlist, playlistId, siteOptions)
        ..addPlaylistShadersRoute(playlist1, playlistId, siteOptions,
            from: 0, num: playlistNum)
        ..addPlaylistShadersRoute(playlist2, playlistId, siteOptions,
            from: siteOptions.pagePlaylistShaderCount, num: playlistNum)
        ..addShaderRouteList(shaders, siteOptions)
        ..addCommentsRouteMap(commentsReponseMap, siteOptions)
        ..addDownloadMediaMap(shaderMedia, siteOptions)
        ..addUserRouteMap(userResponseMap, siteOptions)
        ..addDownloadMediaMap(userMedia, siteOptions);
      final api = newClient(adapter, siteOptions: siteOptions);
      final store = newShadertoySqliteStore();
      final vault =
          await newMemoryVaultStore().then((store) => store.vault<Uint8List>());
      // act
      await api
          .rsync(store, vault, HybridSyncMode.full, playlistIds: [playlistId]);
      // assert
      */
    }, timeout: Timeout(Duration(days: 1)));
  });

  test('Latest Mode', () async {});
}
