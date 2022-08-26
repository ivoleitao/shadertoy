import 'dart:io';

import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'package:shadertoy/shadertoy_api.dart';
import 'package:shadertoy_client/src/site/site_client.dart';
import 'package:shadertoy_client/src/site/site_options.dart';
import 'package:test/test.dart';

import '../fixtures/fixtures.dart';
import '../mock_adapter.dart';
import 'site_mock_adapter.dart';

void main() {
  MockAdapter newAdapter(ShadertoySiteOptions options) {
    return MockAdapter();
  }

  ShadertoySiteOptions newOptions([ShadertoySiteOptions? options]) {
    return options != null
        ? options.copyWith(baseUrl: MockAdapter.mockBase)
        : ShadertoySiteOptions(baseUrl: MockAdapter.mockBase);
  }

  ShadertoySiteClient newClient(
      ShadertoySiteOptions options, HttpClientAdapter adapter) {
    final client = Dio(BaseOptions(baseUrl: MockAdapter.mockBase))
      ..httpClientAdapter = adapter;

    return ShadertoySiteClient(options, client: client);
  }

  group('Authentication', () {
    test('Login with correct credentials', () async {
      // prepare
      final user = 'user';
      final password = 'password';
      final options =
          newOptions(ShadertoySiteOptions(user: user, password: password));
      final nowPlusOneDay = DateTime.now().add(Duration(days: 1));
      final formatter = DateFormat('EEE, dd-MMM-yyyy HH:mm:ss');
      final expires = formatter.format(nowPlusOneDay);
      final adapter = newAdapter(options)
        ..addLoginRoute(options, 302, {
          HttpHeaders.setCookieHeader: [
            'sdtd=4e9dcd95663b58540ac7aa1dc3f0b914; expires=$expires GMT; Max-Age=1209600; path=/; secure; HttpOnly',
          ],
          HttpHeaders.locationHeader: ['/']
        });
      final api = newClient(options, adapter);
      // act
      final sr = await api.login();
      final loggedIn = await api.loggedIn;
      // assert
      expect(sr, isNotNull);
      expect(sr.error, isNull);
      expect(loggedIn, isTrue);
    });

    test('Login with wrong credentials', () async {
      // prepare
      final user = 'user';
      final password = 'password';
      final options =
          newOptions(ShadertoySiteOptions(user: user, password: password));
      final adapter = newAdapter(options)
        ..addLoginRoute(options, 302, {
          HttpHeaders.locationHeader: [
            '/${ShadertoyContext.signInPath}?error=1'
          ]
        });
      final api = newClient(options, adapter);
      // act
      final sr = await api.login();
      final loggedIn = await api.loggedIn;
      // assert
      expect(sr, isNotNull);
      expect(sr.error, isNotNull);
      expect(loggedIn, isFalse);
      expect(
          sr.error,
          ResponseError.authentication(
              message: 'Login error',
              context: contextUser,
              target: options.user));
    });

    test('Login with missing location header', () async {
      // prepare
      final user = 'user';
      final password = 'password';
      final options =
          newOptions(ShadertoySiteOptions(user: user, password: password));
      final adapter = newAdapter(options)..addLoginRoute(options, 302, {});
      final api = newClient(options, adapter);
      // act
      final sr = await api.login();
      final loggedIn = await api.loggedIn;
      // assert
      expect(sr, isNotNull);
      expect(sr.error, isNotNull);
      expect(loggedIn, isFalse);
      expect(
          sr.error,
          ResponseError.unknown(
              message: 'Invalid location header',
              context: contextUser,
              target: options.user));
    });

    test('Login with Dio error', () async {
      // prepare
      final user = 'user';
      final password = 'password';
      final options =
          newOptions(ShadertoySiteOptions(user: user, password: password));
      final message = 'Failed host lookup: \'www.shadertoy.com\'';
      final adapter = newAdapter(options)
        ..addLoginSocketErrorRoute(options, message);
      final api = newClient(options, adapter);
      // act
      var lr = await api.login();
      // assert
      expect(lr, isNotNull);
      expect(lr.error, isNotNull);
      expect(
          lr.error,
          ResponseError.unknown(
              message: 'SocketException: $message',
              context: contextUser,
              target: user));
    });

    test('Logout without login', () async {
      // prepare
      final options = newOptions(ShadertoySiteOptions());
      final adapter = newAdapter(options);
      final api = newClient(options, adapter);
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
      final options =
          newOptions(ShadertoySiteOptions(user: user, password: password));
      final nowPlusOneDay = DateTime.now().add(Duration(days: 1));
      final formatter = DateFormat('EEE, dd-MMM-yyyy HH:mm:ss');
      final expires = formatter.format(nowPlusOneDay);
      final adapter = newAdapter(options)
        ..addLoginRoute(options, 302, {
          HttpHeaders.setCookieHeader: [
            'sdtd=4e9dcd95663b58540ac7aa1dc3f0b914; expires=$expires GMT; Max-Age=1209600; path=/; secure; HttpOnly',
          ],
          HttpHeaders.locationHeader: ['/']
        })
        ..addLogoutRoute(options, 302, {
          HttpHeaders.setCookieHeader: [
            'sdtd=deleted; expires=Thu, 01-Jan-1970 00:00:01 GMT; Max-Age=0; path=/; secure; httponly',
          ],
          HttpHeaders.locationHeader: ['/']
        });
      final api = newClient(options, adapter);
      // act
      final lir = await api.login();
      final loggedIn1 = await api.loggedIn;
      // assert
      expect(lir, isNotNull);
      expect(lir.error, isNull);
      expect(loggedIn1, isTrue);
      // act
      final lor = await api.logout();
      final loggedIn2 = await api.loggedIn;
      // assert
      expect(lor, isNotNull);
      expect(lor.error, isNull);
      expect(loggedIn2, isFalse);
    });

    test('Dio logout error with login', () async {
      // prepare
      final user = 'user';
      final password = 'password';
      final options =
          newOptions(ShadertoySiteOptions(user: user, password: password));
      final message = 'Failed host lookup: \'www.shadertoy.com\'';
      final nowPlusOneDay = DateTime.now().add(Duration(days: 1));
      final formatter = DateFormat('EEE, dd-MMM-yyyy HH:mm:ss');
      final expires = formatter.format(nowPlusOneDay);
      final adapter = newAdapter(options)
        ..addLoginRoute(options, 302, {
          HttpHeaders.setCookieHeader: [
            'sdtd=4e9dcd95663b58540ac7aa1dc3f0b914; expires=$expires GMT; Max-Age=1209600; path=/; secure; HttpOnly',
          ],
          HttpHeaders.locationHeader: ['/']
        })
        ..addLogoutSocketErrorRoute(options, message);
      final api = newClient(options, adapter);
      // act
      var lir = await api.login();
      final loggedIn = await api.loggedIn;
      // assert
      expect(lir, isNotNull);
      expect(lir.error, isNull);
      expect(loggedIn, isTrue);
      // act
      var lor = await api.logout();
      // assert
      expect(lor, isNotNull);
      expect(lor.error, isNotNull);
      expect(
          lor.error,
          ResponseError.unknown(
              message: 'SocketException: $message',
              context: contextUser,
              target: user));
    });
  });

  group('Shaders', () {
    test('Find shader by id', () async {
      // prepare
      final options = ShadertoySiteOptions();
      final shaders = ['shaders/seascape.json'];
      final sl = await shaderFixtures(shaders);
      final adapter = newAdapter(options)..addShadersRoute(sl, options);
      final api = newClient(options, adapter);
      // act
      final sr = await api.findShaderById('Ms2SD1');
      // assert
      expect(sr, isNotNull);
      expect(sr.error, isNull);
      expect(sr.shader, isNotNull);
      expect(sr, await findShaderResponseFixture('shaders/seascape.json'));
    });

    test('Find shader by id with not found response', () async {
      // prepare
      final options = newOptions();
      final shaders = ['shaders/seascape.json'];
      final sl = await shaderFixtures(shaders);
      final adapter = newAdapter(options)
        ..addShadersRoute(sl, options, responseShaders: <Shader>[]);
      final api = newClient(options, adapter);
      // act
      final sr = await api.findShaderById('Ms2SD1');
      // assert
      expect(sr, isNotNull);
      expect(sr.error, isNotNull);
      expect(sr.shader, isNull);
      expect(
          sr.error,
          ResponseError.notFound(
              message: 'Shader not found',
              context: contextShader,
              target: 'Ms2SD1'));
    });

    test('Find shader by id with Dio error', () async {
      // prepare
      final options = newOptions();
      final shaders = ['shaders/seascape.json'];
      final message = 'Failed host lookup: \'www.shadertoy.com\'';
      final fs = await findShadersRequestFixture(shaders);
      final adapter = newAdapter(options)
        ..addShadersSocketErrorRoute(fs, options, message);
      final api = newClient(options, adapter);
      // act
      final sr = await api.findShaderById('Ms2SD1');
      // assert
      expect(sr, isNotNull);
      expect(sr.error, isNotNull);
      expect(sr.shader, isNull);
      expect(
          sr.error,
          ResponseError.unknown(
              message: 'SocketException: $message',
              context: contextShader,
              target: 'Ms2SD1'));
    });

    test('Find shaders by id set with one result', () async {
      // prepare
      final options = newOptions();
      final shaders = ['shaders/seascape.json'];
      final sl = await shaderFixtures(shaders);
      final adapter = newAdapter(options)..addShadersRoute(sl, options);
      final api = newClient(options, adapter);
      // act
      final sr = await api.findShadersByIdSet({'Ms2SD1'});
      // assert
      expect(sr, isNotNull);
      expect(sr.error, isNull);
      expect(sr, await findShadersResponseFixture(shaders));
    });

    test('Find shaders by id set with two results', () async {
      // prepare
      final options = newOptions();
      final shaders = ['shaders/seascape.json', 'shaders/happy_jumping.json'];
      final sl = await shaderFixtures(shaders);
      final adapter = newAdapter(options)..addShadersRoute(sl, options);
      final api = newClient(options, adapter);
      // act
      final sr = await api.findShadersByIdSet({'Ms2SD1', '3lsSzf'});
      // assert
      expect(sr, isNotNull);
      expect(sr.error, isNull);
      expect(sr, await findShadersResponseFixture(shaders));
    });

    test('Find shaders by id set with Dio error', () async {
      // prepare
      final options = newOptions();
      final shaders = ['shaders/seascape.json', 'shaders/happy_jumping.json'];
      final message = 'Failed host lookup: \'www.shadertoy.com\'';
      final fs = await findShadersRequestFixture(shaders);
      final adapter = newAdapter(options)
        ..addShadersSocketErrorRoute(fs, options, message);
      final api = newClient(options, adapter);
      // act
      final sr = await api.findShadersByIdSet({'Ms2SD1', '3lsSzf'});
      // assert
      expect(sr, isNotNull);
      expect(sr.shaders, isNull);
      expect(sr.error, isNotNull);
      expect(
          sr.error,
          ResponseError.unknown(
              message: 'SocketException: $message', context: contextShader));
    });

    test('Find shaders', () async {
      // prepare
      final options = newOptions();
      final response = await textFixture('results/results.html');
      final sl = await shaderListFixture('results/results.json');
      final adapter = newAdapter(options)..addResultsRoute(response, options);
      final api = newClient(options, adapter);
      // act
      final sr = await api.findShaders();
      // assert
      expect(sr, isNotNull);
      expect(sr.error, isNull);
      expect(sr, sl.toFindShadersResponse(total: 63918));
    });

    test('Find shaders with no html body', () async {
      // prepare
      final options = newOptions();
      final response = await textFixture('error/no_body.html');
      final adapter = newAdapter(options)..addResultsRoute(response, options);
      final api = newClient(options, adapter);
      // act
      final sr = await api.findShaders();
      // assert
      expect(sr, isNotNull);
      expect(sr.error, isNotNull);
      expect(
          sr.error,
          ResponseError.backendResponse(
              message: 'Unexpected HTML response body: '));
    });

    test('Find shaders with an unparsable number of results', () async {
      // prepare
      final options = newOptions();
      final response =
          await textFixture('results/unparsable_number_of_results.html');
      final adapter = newAdapter(options)..addResultsRoute(response, options);
      final api = newClient(options, adapter);
      // act
      final sr = await api.findShaders();
      // assert
      expect(sr, isNotNull);
      expect(sr.error, isNotNull);
      expect(
          sr.error,
          ResponseError.backendResponse(
              message: 'Unable to parse the number of results'));
    });

    test('Find shaders with an invalid number of results', () async {
      // prepare
      final options = newOptions();
      final response =
          await textFixture('results/invalid_number_of_results.html');
      final adapter = newAdapter(options)..addResultsRoute(response, options);
      final api = newClient(options, adapter);
      // act
      final sr = await api.findShaders();
      // assert
      expect(sr, isNotNull);
      expect(sr.error, isNotNull);
      expect(
          sr.error,
          ResponseError.backendResponse(
              message: 'Obtained an invalid number of results: -1'));
    });

    test('Find shaders with no script blocks', () async {
      // prepare
      final options = newOptions();
      final response = await textFixture('results/no_script_blocks.html');
      final adapter = newAdapter(options)..addResultsRoute(response, options);
      final api = newClient(options, adapter);
      // act
      final sr = await api.findShaders();
      // assert
      expect(sr, isNotNull);
      expect(sr.error, isNotNull);
      expect(
          sr.error,
          ResponseError.backendResponse(
              message: 'Unable to get the script blocks from the document'));
    });

    test('Find shaders with no script block match', () async {
      // prepare
      final options = newOptions();
      final response = await textFixture('results/no_script_block_match.html');
      final adapter = newAdapter(options)..addResultsRoute(response, options);
      final api = newClient(options, adapter);
      // act
      final sr = await api.findShaders();
      // assert
      expect(sr, isNotNull);
      expect(sr.error, isNotNull);
      expect(
          sr.error,
          ResponseError.backendResponse(
              message: 'No script block matches with the pattern'));
    });

    test('Find shaders with Dio error', () async {
      // prepare
      final options = newOptions();
      final message = 'Failed host lookup: \'www.shadertoy.com\'';
      final adapter = newAdapter(options)
        ..addResultsSocketErrorRoute(options, message);
      final api = newClient(options, adapter);
      // act
      final sr = await api.findShaders();
      // assert
      expect(sr, isNotNull);
      expect(sr.shaders, isNull);
      expect(sr.error, isNotNull);
      expect(
          sr.error,
          ResponseError.unknown(
              message: 'SocketException: $message', context: contextShader));
    });

    test('Find shaders with query, one result', () async {
      // prepare
      final options = newOptions();
      final query = 'raymarch';
      final sort = Sort.love;
      final filters = {'vr', 'soundoutput', 'multipass'};

      final response = await textFixture('results/results_1.html');
      final sl = await shaderListFixture('results/results_1.json');
      final adapter = newAdapter(options)
        ..addResultsRoute(response, options,
            query: query, sort: sort, filters: filters)
        ..addShadersRoute(sl, options);
      final api = newClient(options, adapter);
      // act
      final sr =
          await api.findShaders(term: query, sort: sort, filters: filters);
      // assert
      expect(sr, isNotNull);
      expect(sr.error, isNull);
      expect(sr, sl.toFindShadersResponse(total: 1));
    });

    test('Find shaders with query, first page', () async {
      // prepare
      final options = newOptions();
      final query = 'raymarch';
      final sort = Sort.love;
      final filters = {'multipass'};
      final from = 0;
      final response = await textFixture('results/results_0_12.html');
      final sl = await shaderListFixture('results/results_0_12.json');
      final adapter = newAdapter(options)
        ..addResultsRoute(response, options,
            query: query, sort: sort, filters: filters, from: from);
      final api = newClient(options, adapter);
      // act
      final sr = await api.findShaders(
          term: query, sort: sort, filters: filters, from: from);
      // assert
      expect(sr, isNotNull);
      expect(sr.error, isNull);
      expect(sr, sl.toFindShadersResponse(total: 36));
    });

    test('Find shaders with query, second page', () async {
      // prepare
      final options = newOptions();
      final query = 'raymarch';
      final sort = Sort.love;
      final filters = {'multipass'};
      final from = options.pageResultsShaderCount;
      final num = options.pageResultsShaderCount;
      final response = await textFixture('results/results_12_12.html');
      final sl = await shaderListFixture('results/results_12_12.json');
      final adapter = newAdapter(options)
        ..addResultsRoute(response, options,
            query: query, sort: sort, filters: filters, from: from, num: num)
        ..addShadersRoute(sl, options);
      final api = newClient(options, adapter);
      // act
      final sr = await api.findShaders(
          term: query, sort: sort, filters: filters, from: from);
      // assert
      expect(sr, isNotNull);
      expect(sr.error, isNull);
      expect(sr, sl.toFindShadersResponse(total: 36));
    });

    test('Find shaders with query, second and third page', () async {
      // prepare
      final options = newOptions();
      final query = 'raymarch';
      final sort = Sort.love;
      final filters = {'multipass'};
      final from = options.pageResultsShaderCount;
      final num = options.pageResultsShaderCount;
      final response1 = await textFixture('results/results_12_12.html');
      final response2 = await textFixture('results/results_24_12.html');
      final sl = await shaderListFixtures(
          ['results/results_12_12.json', 'results/results_24_12.json']);
      final adapter = newAdapter(options)
        ..addResultsRoute(response1, options,
            query: query, sort: sort, filters: filters, from: from, num: num)
        ..addResultsRoute(response2, options,
            query: query,
            sort: sort,
            filters: filters,
            from: from * 2,
            num: num)
        ..addShadersRoute(sl, options);
      final api = newClient(options, adapter);
      // act
      final sr = await api.findShaders(
          term: query, sort: sort, filters: filters, from: from, num: num * 2);
      // assert
      expect(sr, isNotNull);
      expect(sr.error, isNull);
      expect(sr, sl.toFindShadersResponse(total: 36));
    });

    test('Find all shader ids', () async {
      // prepare
      final options = newOptions();
      final response1 = await textFixture('results/results_0_12.html');
      final response2 = await textFixture('results/results_12_12.html');
      final response3 = await textFixture('results/results_24_12.html');
      final sl = await shaderIdListFixtures([
        'results/results_0_12.json',
        'results/results_12_12.json',
        'results/results_24_12.json'
      ]);
      final adapter = newAdapter(options)
        ..addResultsRoute(response1, options)
        ..addResultsRoute(response2, options,
            from: options.pageResultsShaderCount,
            num: options.pageResultsShaderCount)
        ..addResultsRoute(response3, options,
            from: options.pageResultsShaderCount * 2,
            num: options.pageResultsShaderCount);
      final api = newClient(options, adapter);
      // act
      final sr = await api.findAllShaderIds();
      // assert
      expect(sr, isNotNull);
      expect(sr.error, isNull);
      expect(sr, FindShaderIdsResponse(count: 36, ids: sl));
    });

    test('Find all shader ids with Dio error on the first page', () async {
      // prepare
      final options = newOptions();
      final message = 'Failed host lookup: \'www.shadertoy.com\'';
      final response = await textFixture('results/results.html');
      final adapter = newAdapter(options)
        ..addResultsSocketErrorRoute(options, message)
        ..addResultsRoute(response, options, from: 12, num: 12);
      final api = newClient(options, adapter);
      // act
      final sr = await api.findAllShaderIds();
      // assert
      expect(sr, isNotNull);
      expect(sr.error, isNotNull);
      expect(
          sr.error,
          ResponseError.unknown(
              message: 'SocketException: $message', context: contextShader));
    });

    test('Find all shader ids with Dio error on the second page', () async {
      // prepare
      final options = newOptions();
      final message = 'Failed host lookup: \'www.shadertoy.com\'';
      final response1 = await textFixture('results/results_0_12.html');
      final response3 = await textFixture('results/results_24_12.html');
      final adapter = newAdapter(options)
        ..addResultsRoute(response1, options)
        ..addResultsSocketErrorRoute(options, message, from: 12, num: 12)
        ..addResultsRoute(response3, options,
            from: options.pageResultsShaderCount * 2,
            num: options.pageResultsShaderCount);
      final api = newClient(options, adapter);
      // act
      final sr = await api.findAllShaderIds();
      // assert
      expect(sr, isNotNull);
      expect(sr.error, isNotNull);
      expect(
          sr.error,
          ResponseError.unknown(
              message: 'SocketException: $message', context: contextShader));
    });

    test(
        'Find all shader ids with an unparsable number of results on the second page',
        () async {
      // prepare
      final options = newOptions();
      final response1 = await textFixture('results/results_0_12.html');
      final response2 = await textFixture(
          'results/results_12_12_invalid_number_of_results.html');
      final response3 = await textFixture('results/results_24_12.html');

      final adapter = newAdapter(options)
        ..addResultsRoute(response1, options)
        ..addResultsRoute(response2, options,
            from: options.pageResultsShaderCount,
            num: options.pageResultsShaderCount)
        ..addResultsRoute(response3, options,
            from: options.pageResultsShaderCount * 2,
            num: options.pageResultsShaderCount);
      final api = newClient(options, adapter);
      // act
      final sr = await api.findAllShaderIds();
      // assert
      expect(sr, isNotNull);
      expect(sr.error, isNotNull);
      expect(
          sr.error,
          ResponseError.backendResponse(
              message:
                  'Page 2 of 3 page(s) was not successfully fetched: Obtained an invalid number of results: -1'));
    });

    test('Find shader ids', () async {
      // prepare
      final options = newOptions();
      final response = await textFixture('results/results.html');
      final sl = await shaderIdListFixture('results/results.json');
      final adapter = newAdapter(options)..addResultsRoute(response, options);
      final api = newClient(options, adapter);
      // act
      final sr = await api.findShaderIds();
      // assert
      expect(sr, isNotNull);
      expect(sr.error, isNull);
      expect(sr, FindShaderIdsResponse(count: 63918, ids: sl));
    });

    test('Find shader ids with Dio error', () async {
      // prepare
      final options = newOptions();
      final message = 'Failed host lookup: \'www.shadertoy.com\'';
      final adapter = newAdapter(options)
        ..addResultsSocketErrorRoute(options, message);
      final api = newClient(options, adapter);
      // act
      final sr = await api.findShaderIds();
      // assert
      expect(sr, isNotNull);
      expect(sr.error, isNotNull);
      expect(
          sr.error,
          ResponseError.unknown(
              message: 'SocketException: $message', context: contextShader));
    });
  }, timeout: Timeout(Duration(seconds: 60)));

  group('Users', () {
    test('Find user iq by id', () async {
      // prepare
      final options = newOptions();
      final userId = 'iq';
      final response = await textFixture('user/$userId.html');
      final adapter = newAdapter(options)
        ..addUserRoute(response, userId, options);
      final api = newClient(options, adapter);
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

    test('Find user shaderflix by id', () async {
      // prepare
      final options = newOptions();
      final userId = 'shaderflix';
      final response = await textFixture('user/$userId.html');
      final adapter = newAdapter(options)
        ..addUserRoute(response, userId, options);
      final api = newClient(options, adapter);
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
                  memberSince: DateTime(2019, 7, 20),
                  following: 0,
                  followers: 0,
                  about:
                      '\n\n[b]b[/b]\n[i]i[/i]\n[url]http://www.url.com[/url]\n[url=http://www.url.com]My Url[/url]\n[code]c[/code]\n:)\n:(\n:D\n:love:\n:octopus:\n:octopusballoon:\n:alpha:\n:beta:\n:delta\n:epsilon:\n:nabla:\n:square:\n:limit:\nplain')));
    });

    test('Find user by id with not found response', () async {
      // prepare
      final options = newOptions();
      final userId = 'XXXX';
      final user = 'user/$userId';
      final error = 'Http status error [404]';
      final adapter = newAdapter(options)
        ..addResponseErrorRoute(user, error, options);
      final api = newClient(options, adapter);
      // act
      final sr = await api.findUserById(userId);
      // assert
      expect(sr, isNotNull);
      expect(sr.error, isNotNull);
      expect(sr.user, isNull);
      expect(
          sr.error,
          ResponseError.notFound(
              message: error, context: contextUser, target: userId));
    });

    test('Find user by id with empty response', () async {
      // prepare
      final options = newOptions();
      final userId = 'XXXX';
      final response = await textFixture('error/no_body.html');
      final adapter = newAdapter(options)
        ..addUserRoute(response, userId, options);
      final api = newClient(options, adapter);
      // act
      final sr = await api.findUserById(userId);
      // assert
      expect(sr, isNotNull);
      expect(sr.error, isNotNull);
      expect(sr.user, isNull);
      expect(
          sr.error,
          ResponseError.backendResponse(
              message: 'Unexpected HTML response body: ',
              context: contextUser,
              target: userId));
    });

    test('Find user by id with an invalid number of sections', () async {
      // prepare
      final options = newOptions();
      final userId = 'XXXX';
      final response = await textFixture('user/invalid_no_sections.html');
      final adapter = newAdapter(options)
        ..addUserRoute(response, userId, options);
      final api = newClient(options, adapter);
      // act
      final sr = await api.findUserById(userId);
      // assert
      expect(sr, isNotNull);
      expect(sr.error, isNotNull);
      expect(sr.user, isNull);
      expect(
          sr.error,
          ResponseError.backendResponse(
              message: 'Obtained an invalid number of user sections: 2',
              context: contextUser,
              target: userId));
    });

    test('Find user by id with Dio error', () async {
      // prepare
      final options = newOptions();
      final userId = 'shaderflix';
      final message = 'Failed host lookup: \'www.shadertoy.com\'';
      final adapter = newAdapter(options)
        ..addUserSocketErrorRoute(userId, options, message);
      final api = newClient(options, adapter);
      // act
      final sr = await api.findUserById(userId);
      // assert
      expect(sr, isNotNull);
      expect(sr.error, isNotNull);
      expect(
          sr.error,
          ResponseError.unknown(
              message: 'SocketException: $message',
              context: contextUser,
              target: userId));
    });

    test('Find shaders by user id with Dio error', () async {
      // prepare
      final options = newOptions();
      final userId = 'shaderflix';
      final message = 'Failed host lookup: \'www.shadertoy.com\'';
      final adapter = newAdapter(options)
        ..addUserShadersSocketErrorRoute(userId, options, message);
      final api = newClient(options, adapter);
      // act
      final sr = await api.findShadersByUserId(userId);
      // assert
      expect(sr, isNotNull);
      expect(sr.error, isNotNull);
      expect(
          sr.error,
          ResponseError.unknown(
              message: 'SocketException: $message',
              context: contextUser,
              target: userId));
    });

    test('Find shaders by user id with no body', () async {
      // prepare
      final options = newOptions();
      final userId = 'shaderflix';
      final response = await textFixture('error/no_body.html');
      final adapter = newAdapter(options)
        ..addUserShadersRoute(response, userId, options);
      final api = newClient(options, adapter);
      // act
      final sr = await api.findShadersByUserId(userId);
      // assert
      expect(sr, isNotNull);
      expect(sr.error, isNotNull);
      expect(sr.shaders, isNull);
      expect(
          sr.error,
          ResponseError.backendResponse(
              message: 'Unexpected HTML response body: ',
              context: contextUser,
              target: userId));
    });

    test('Find shaders by user id with no results', () async {
      // prepare
      final options = newOptions();
      final userId = 'shaderflix';
      final response = await textFixture('user/no_shaders.html');
      final adapter = newAdapter(options)
        ..addUserShadersRoute(response, userId, options);
      final api = newClient(options, adapter);
      // act
      final sr = await api.findShadersByUserId(userId);
      // assert
      expect(sr, isNotNull);
      expect(sr.error, isNull);
      expect(sr, await findShadersResponseFixture([]));
    });

    test('Find shaders by user id with one result', () async {
      // prepare
      final options = newOptions();
      final userId = 'bonzaj';

      final response = await textFixture('user/bonzaj_1.html');
      final sl = await shaderListFixture('user/bonzaj_1.json');
      final adapter = newAdapter(options)
        ..addUserShadersRoute(response, userId, options)
        ..addShadersRoute(sl, options);
      final api = newClient(options, adapter);
      // act
      final sr = await api.findShadersByUserId(userId);
      // assert
      expect(sr, isNotNull);
      expect(sr.error, isNull);
      expect(sr, sl.toFindShadersResponse());
    });

    test('Find shaders by user id with query, one result', () async {
      // prepare
      final options = newOptions();
      final userId = 'iq';
      final sort = Sort.popular;
      final filters = {'multipass', 'musicstream'};

      final response = await textFixture('user/iq_1.html');
      final sl = await shaderListFixture('user/iq_1.json');
      final adapter = newAdapter(options)
        ..addUserShadersRoute(response, userId, options,
            sort: sort, filters: filters)
        ..addShadersRoute(sl, options);
      final api = newClient(options, adapter);
      // act
      final sr =
          await api.findShadersByUserId(userId, sort: sort, filters: filters);
      // assert
      expect(sr, isNotNull);
      expect(sr.error, isNull);
      expect(sr, sl.toFindShadersResponse());
    });

    test('Find shaders by user id, first page', () async {
      // prepare
      final options = newOptions();
      final userId = 'iq';
      final response = await textFixture('user/iq_0_8.html');
      final sl = await shaderListFixture('user/iq_0_8.json');
      final adapter = newAdapter(options)
        ..addUserShadersRoute(response, userId, options);
      final api = newClient(options, adapter);
      // act
      final sr = await api.findShadersByUserId(userId);
      // assert
      expect(sr, isNotNull);
      expect(sr.error, isNull);
      expect(sr, sl.toFindShadersResponse(total: 24));
    });

    test('Find shaders by user id, second page', () async {
      // prepare
      final options = newOptions();
      final userId = 'iq';
      final from = 8;
      final num = options.pageUserShaderCount;
      final response = await textFixture('user/iq_8_8.html');
      final sl = await shaderListFixture('user/iq_8_8.json');
      final adapter = newAdapter(options)
        ..addUserShadersRoute(response, userId, options, from: from, num: num)
        ..addShadersRoute(sl, options);
      final api = newClient(options, adapter);
      // act
      final sr = await api.findShadersByUserId(userId, from: from, num: num);
      // assert
      expect(sr, isNotNull);
      expect(sr.error, isNull);
      expect(sr, sl.toFindShadersResponse(total: 24));
    });

    test('Find shaders by user id, first and second page', () async {
      // prepare
      final options = newOptions();
      final userId = 'iq';
      final from = 0;
      final num = options.pageUserShaderCount;
      final response1 = await textFixture('user/iq_0_8.html');
      final response2 = await textFixture('user/iq_8_8.html');
      final sl =
          await shaderListFixtures(['user/iq_0_8.json', 'user/iq_8_8.json']);

      final adapter = newAdapter(options)
        ..addUserShadersRoute(response1, userId, options, from: from, num: num)
        ..addUserShadersRoute(response2, userId, options,
            from: options.pageUserShaderCount, num: num)
        ..addShadersRoute(sl, options);
      final api = newClient(options, adapter);
      // act
      final sr =
          await api.findShadersByUserId(userId, from: from, num: num * 2);
      // assert
      expect(sr, isNotNull);
      expect(sr.error, isNull);
      expect(sr, sl.toFindShadersResponse(total: 24));
    });

    test(
        'Find shaders by user id with an unparsable number of results on the second page',
        () async {
      // prepare
      final options = newOptions();
      final userId = 'iq';
      final from = 0;
      final num = options.pageUserShaderCount;
      final response1 = await textFixture('user/iq_0_8.html');
      final response2 =
          await textFixture('user/iq_8_8_invalid_number_of_results.html');

      final adapter = newAdapter(options)
        ..addUserShadersRoute(response1, userId, options, from: from, num: num)
        ..addUserShadersRoute(response2, userId, options,
            from: options.pageUserShaderCount, num: num);
      final api = newClient(options, adapter);
      // act
      final sr =
          await api.findShadersByUserId(userId, from: from, num: num * 2);
      // assert
      expect(sr, isNotNull);
      expect(sr.error, isNotNull);
      expect(
          sr.error,
          ResponseError.backendResponse(
              message:
                  'Page 2 of 2 page(s) was not successfully fetched: Obtained an invalid number of results: -1',
              context: contextUser,
              target: userId));
    });

    test('Find shaders by user id, second and third page', () async {
      // prepare
      final options = newOptions();
      final userId = 'iq';
      final from = 8;
      final num = options.pageUserShaderCount;
      final response2 = await textFixture('user/iq_8_8.html');
      final response3 = await textFixture('user/iq_16_8.html');
      final sl =
          await shaderListFixtures(['user/iq_8_8.json', 'user/iq_16_8.json']);

      final adapter = newAdapter(options)
        ..addUserShadersRoute(response2, userId, options, from: from, num: num)
        ..addUserShadersRoute(response3, userId, options,
            from: from * 2, num: num)
        ..addShadersRoute(sl, options);
      final api = newClient(options, adapter);
      // act
      final sr =
          await api.findShadersByUserId(userId, from: from, num: num * 2);
      // assert
      expect(sr, isNotNull);
      expect(sr.error, isNull);
      expect(sr, sl.toFindShadersResponse(total: 24));
    });

    test('Find shader ids by user id, first page', () async {
      // prepare
      final options = newOptions();
      final userId = 'iq';
      final response = await textFixture('user/iq_0_8.html');
      final sl = await shaderIdListFixture('user/iq_0_8.json');
      final adapter = newAdapter(options)
        ..addUserShadersRoute(response, userId, options);
      final api = newClient(options, adapter);
      // act
      final sr = await api.findShaderIdsByUserId(userId);
      // assert
      expect(sr, isNotNull);
      expect(sr.error, isNull);
      expect(sr, FindShaderIdsResponse(count: 24, ids: sl));
    });

    test('Find shader ids by user id with Dio error', () async {
      // prepare
      final options = newOptions();
      final userId = 'iq';
      final message = 'Failed host lookup: \'www.shadertoy.com\'';
      final adapter = newAdapter(options)
        ..addUserShadersSocketErrorRoute(userId, options, message);
      final api = newClient(options, adapter);
      // act
      final sr = await api.findShaderIdsByUserId(userId);
      // assert
      expect(sr, isNotNull);
      expect(sr.error, isNotNull);
      expect(
          sr.error,
          ResponseError.unknown(
              message: 'SocketException: $message',
              context: contextUser,
              target: userId));
    });

    test('Find all shader ids by user id', () async {
      // prepare
      final options = newOptions();
      final userId = 'iq';
      final from = 8;
      final num = options.pageUserShaderCount;
      final response1 = await textFixture('user/iq_0_8.html');
      final response2 = await textFixture('user/iq_8_8.html');
      final response3 = await textFixture('user/iq_16_8.html');
      final sl = await shaderIdListFixtures(
          ['user/iq_0_8.json', 'user/iq_8_8.json', 'user/iq_16_8.json']);

      final adapter = newAdapter(options)
        ..addUserShadersRoute(response1, userId, options)
        ..addUserShadersRoute(response2, userId, options, from: from, num: num)
        ..addUserShadersRoute(response3, userId, options,
            from: from * 2, num: num);
      final api = newClient(options, adapter);
      // act
      final sr = await api.findAllShaderIdsByUserId(userId);
      // assert
      expect(sr, isNotNull);
      expect(sr.error, isNull);
      expect(sr, FindShaderIdsResponse(count: 24, ids: sl));
    });

    test('Find all shader ids by user id with Dio error', () async {
      // prepare
      final options = newOptions();
      final userId = 'iq';
      final message = 'Failed host lookup: \'www.shadertoy.com\'';
      final adapter = newAdapter(options)
        ..addUserShadersSocketErrorRoute(userId, options, message);
      final api = newClient(options, adapter);
      // act
      final sr = await api.findAllShaderIdsByUserId(userId);
      // assert
      expect(sr, isNotNull);
      expect(sr.error, isNotNull);
      expect(
          sr.error,
          ResponseError.unknown(
              message: 'SocketException: $message',
              context: contextUser,
              target: userId));
    });
  }, timeout: Timeout(Duration(seconds: 60)));

  group('Comments', () {
    test('Find comments by shader id', () async {
      // prepare
      final options = newOptions();
      final shaderId = 'ldB3Dt';
      final response = await commentsResponseFixture('comment/$shaderId.json');
      final adapter = newAdapter(options)
        ..addCommentRoute(response, shaderId, options);
      final api = newClient(options, adapter);
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
                userId: 'iq',
                shaderId: shaderId,
                picture: '/media/users/iq/profile.png',
                date: DateTime.fromMillisecondsSinceEpoch(1395074155 * 1000),
                text: 'Oh, I love it!',
                hidden: false),
          ]));
    });

    test('Find comments by shader id with Dio error', () async {
      // prepare
      final options = newOptions();
      final shaderId = 'ldB3Dt';
      final message = 'Failed host lookup: \'www.shadertoy.com\'';
      final adapter = newAdapter(options)
        ..addCommentSocketErrorRoute(shaderId, options, message);
      final api = newClient(options, adapter);
      // act
      final sr = await api.findCommentsByShaderId(shaderId);
      // assert
      expect(sr, isNotNull);
      expect(sr.error, isNotNull);
      expect(sr.comments, isNull);
      expect(
          sr.error,
          ResponseError.unknown(
              message: 'SocketException: $message',
              context: contextShader,
              target: shaderId));
    });
  });

  group('Playlist', () {
    test('Find playlist by id', () async {
      // prepare
      final options = newOptions();
      final playlistId = 'week';
      final response = await textFixture('playlist/$playlistId.html');
      final adapter = newAdapter(options)
        ..addPlaylistRoute(response, playlistId, options);
      final api = newClient(options, adapter);
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

    test('Find playlist by id with not found response', () async {
      // prepare
      final options = newOptions();
      final playlistId = 'XXXX';
      final playlist = 'playlist/$playlistId';
      final error = 'Http status error [404]';
      final adapter = newAdapter(options)
        ..addResponseErrorRoute(playlist, error, options);
      final api = newClient(options, adapter);
      // act
      final sr = await api.findPlaylistById(playlistId);
      // assert
      expect(sr, isNotNull);
      expect(sr.error, isNotNull);
      expect(sr.playlist, isNull);
      expect(
          sr.error,
          ResponseError.notFound(
              message: error, context: contextPlaylist, target: playlistId));
    });

    test('Find playlist by id with empty response', () async {
      // prepare
      final options = newOptions();
      final playlistId = 'XXXX';
      final response = await textFixture('error/no_body.html');
      final adapter = newAdapter(options)
        ..addPlaylistRoute(response, playlistId, options);
      final api = newClient(options, adapter);
      // act
      final sr = await api.findPlaylistById(playlistId);
      // assert
      expect(sr, isNotNull);
      expect(sr.error, isNotNull);
      expect(sr.playlist, isNull);
      expect(
          sr.error,
          ResponseError.backendResponse(
              message: 'Unexpected HTML response body: ',
              context: contextPlaylist,
              target: playlistId));
    });

    test('Find playlist by id with Dio error', () async {
      // prepare
      final options = newOptions();
      final playlistId = 'week';
      final message = 'Failed host lookup: \'www.shadertoy.com\'';
      final adapter = newAdapter(options)
        ..addPlaylistSocketErrorRoute(playlistId, options, message);
      final api = newClient(options, adapter);
      // act
      final sr = await api.findPlaylistById(playlistId);
      // assert
      expect(sr, isNotNull);
      expect(sr.error, isNotNull);
      expect(
          sr.error,
          ResponseError.unknown(
              message: 'SocketException: $message',
              context: contextPlaylist,
              target: playlistId));
    });

    test('Find playlist by id with an invalid name', () async {
      // prepare
      final options = newOptions();
      final playlistId = 'XXXX';
      final response = await textFixture('playlist/invalid_name.html');
      final adapter = newAdapter(options)
        ..addPlaylistRoute(response, playlistId, options);
      final api = newClient(options, adapter);
      // act
      final sr = await api.findPlaylistById(playlistId);
      // assert
      expect(sr, isNotNull);
      expect(sr.error, isNotNull);
      expect(sr.playlist, isNull);
      expect(
          sr.error,
          ResponseError.backendResponse(
              message: 'Unable to get the playlist name from the document',
              context: contextPlaylist,
              target: playlistId));
    });

    test('Find playlist by id with an invalid description', () async {
      // prepare
      final options = newOptions();
      final playlistId = 'XXXX';
      final response = await textFixture('playlist/invalid_description.html');
      final adapter = newAdapter(options)
        ..addPlaylistRoute(response, playlistId, options);
      final api = newClient(options, adapter);
      // act
      final sr = await api.findPlaylistById(playlistId);
      // assert
      expect(sr, isNotNull);
      expect(sr.error, isNotNull);
      expect(sr.playlist, isNull);
      expect(
          sr.error,
          ResponseError.backendResponse(
              message:
                  'Unable to get the playlist description from the document',
              context: contextPlaylist,
              target: playlistId));
    });

    test('Find playlist by id with an invalid user id', () async {
      // prepare
      final options = newOptions();
      final playlistId = 'XXXX';
      final response = await textFixture('playlist/invalid_user_id.html');
      final adapter = newAdapter(options)
        ..addPlaylistRoute(response, playlistId, options);
      final api = newClient(options, adapter);
      // act
      final sr = await api.findPlaylistById(playlistId);
      // assert
      expect(sr, isNotNull);
      expect(sr.error, isNotNull);
      expect(sr.playlist, isNull);
      expect(
          sr.error,
          ResponseError.backendResponse(
              message: 'Unable to get the playlist user id from the document',
              context: contextPlaylist,
              target: playlistId));
    });

    test('Find shaders by playlist id, first page', () async {
      // prepare
      final options = newOptions();
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
      final adapter = newAdapter(options)
        ..addPlaylistShadersRoute(response, playlistId, options)
        ..addShadersRoute(sl, options);
      final api = newClient(options, adapter);
      // act
      final sr = await api.findShadersByPlaylistId(playlistId);
      // assert
      expect(sr, isNotNull);
      expect(sr.error, isNull);
      expect(sr, await findShadersResponseFixture(shaders));
    });

    test('Find shaders by playlist id, second page', () async {
      // prepare
      final options = newOptions();
      final playlistId = 'week';
      final from = options.pagePlaylistShaderCount;
      final num = options.pagePlaylistShaderCount;
      final shaders = [
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
        'shaders/quartz_wip.json'
      ];
      final sl = await shaderFixtures(shaders);
      final response = await textFixture('playlist/week_12_12.html');
      final adapter = newAdapter(options)
        ..addPlaylistShadersRoute(response, playlistId, options,
            from: from, num: num)
        ..addShadersRoute(sl, options);
      final api = newClient(options, adapter);
      // act
      final sr =
          await api.findShadersByPlaylistId(playlistId, from: from, num: num);
      // assert
      expect(sr, isNotNull);
      expect(sr.error, isNull);
      expect(sr, await findShadersResponseFixture(shaders));
    });

    test('Find shaders by playlist id, first and second page', () async {
      // prepare
      final options = newOptions();
      final playlistId = 'week';
      final from = 0;
      final num = options.pagePlaylistShaderCount;
      final shaders = [
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
        'shaders/quartz_wip.json'
      ];
      final sl = await shaderFixtures(shaders);
      final response1 = await textFixture('playlist/week_0_12.html');
      final response2 = await textFixture('playlist/week_12_12.html');
      final adapter = newAdapter(options)
        ..addPlaylistShadersRoute(response1, playlistId, options,
            from: from, num: num)
        ..addPlaylistShadersRoute(response2, playlistId, options,
            from: options.pagePlaylistShaderCount, num: num)
        ..addShadersRoute(sl, options);
      final api = newClient(options, adapter);
      // act
      final sr = await api.findShadersByPlaylistId(playlistId,
          from: from, num: num * 2);
      // assert
      expect(sr, isNotNull);
      expect(sr.error, isNull);
      expect(sr, await findShadersResponseFixture(shaders));
    });

    test(
        'Find shaders by playlist id with an unparsable number of results on the first page',
        () async {
      // prepare
      final options = newOptions();
      final playlistId = 'week';
      final from = 0;
      final num = options.pagePlaylistShaderCount;
      final response = await textFixture(
          'playlist/week_0_12_invalid_number_of_results.html');
      final adapter = newAdapter(options)
        ..addPlaylistShadersRoute(response, playlistId, options,
            from: from, num: num);
      final api = newClient(options, adapter);
      // act
      final sr =
          await api.findShadersByPlaylistId(playlistId, from: from, num: num);
      // assert
      expect(sr, isNotNull);
      expect(sr.error, isNotNull);
      expect(
          sr.error,
          ResponseError.backendResponse(
              message: 'Obtained an invalid number of results: -1',
              context: contextPlaylist,
              target: playlistId));
    });

    test(
        'Find shaders by playlist id with an unparsable number of results on the second page',
        () async {
      // prepare
      final options = newOptions();
      final playlistId = 'week';
      final from = 0;
      final num = options.pagePlaylistShaderCount;
      final response1 = await textFixture('playlist/week_0_12.html');
      final response2 = await textFixture(
          'playlist/week_12_12_invalid_number_of_results.html');
      final adapter = newAdapter(options)
        ..addPlaylistShadersRoute(response1, playlistId, options,
            from: from, num: num)
        ..addPlaylistShadersRoute(response2, playlistId, options,
            from: options.pagePlaylistShaderCount, num: num);
      final api = newClient(options, adapter);
      // act
      final sr = await api.findShadersByPlaylistId(playlistId,
          from: from, num: num * 2);
      // assert
      expect(sr, isNotNull);
      expect(sr.error, isNotNull);
      expect(
          sr.error,
          ResponseError.backendResponse(
              message:
                  'Page 2 of 2 page(s) was not successfully fetched: Obtained an invalid number of results: -1',
              context: contextPlaylist,
              target: playlistId));
    });

    test('Find shaders by playlist id, second and third page', () async {
      // prepare
      final options = newOptions();
      final playlistId = 'week';
      final from = options.pagePlaylistShaderCount;
      final num = options.pagePlaylistShaderCount;
      final shaders = [
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
        'shaders/hyper_dough.json',
      ];
      final sl = await shaderFixtures(shaders);
      final response2 = await textFixture('playlist/week_12_12.html');
      final response3 = await textFixture('playlist/week_24_12.html');
      final adapter = newAdapter(options)
        ..addPlaylistShadersRoute(response2, playlistId, options,
            from: from, num: num)
        ..addPlaylistShadersRoute(response3, playlistId, options,
            from: from * 2, num: num)
        ..addShadersRoute(sl, options);
      final api = newClient(options, adapter);
      // act
      final sr = await api.findShadersByPlaylistId(playlistId,
          from: from, num: num * 2);
      // assert
      expect(sr, isNotNull);
      expect(sr.error, isNull);
      expect(sr, await findShadersResponseFixture(shaders));
    });

    test('Find shaders by playlist id with Dio error', () async {
      // prepare
      final options = newOptions();
      final playlistId = 'week';
      final message = 'Failed host lookup: \'www.shadertoy.com\'';
      final adapter = newAdapter(options)
        ..addPlaylistShadersSocketErrorRoute(playlistId, options, message);
      final api = newClient(options, adapter);
      // act
      final sr = await api.findShadersByPlaylistId(playlistId);
      // assert
      expect(sr, isNotNull);
      expect(sr.error, isNotNull);
      expect(
          sr.error,
          ResponseError.unknown(
              message: 'SocketException: $message',
              context: contextPlaylist,
              target: playlistId));
    });

    test('Find shader ids by playlist id, first page', () async {
      // prepare
      final options = newOptions();
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
      final adapter = newAdapter(options)
        ..addPlaylistShadersRoute(response, playlistId, options)
        ..addShadersRoute(sl, options);
      final api = newClient(options, adapter);
      // act
      final sr = await api.findShaderIdsByPlaylistId(playlistId);
      // assert
      expect(sr, isNotNull);
      expect(sr.error, isNull);
      expect(
          sr,
          await findShaderIdsResponseFixture(shaders,
              count: options.pagePlaylistShaderCount));
    });

    test('Find shader ids by playlist id with Dio error', () async {
      // prepare
      final options = newOptions();
      final playlistId = 'week';
      final message = 'Failed host lookup: \'www.shadertoy.com\'';
      final adapter = newAdapter(options)
        ..addPlaylistShadersSocketErrorRoute(playlistId, options, message);
      final api = newClient(options, adapter);
      // act
      final sr = await api.findShaderIdsByPlaylistId(playlistId);
      // assert
      expect(sr, isNotNull);
      expect(sr.error, isNotNull);
      expect(
          sr.error,
          ResponseError.unknown(
              message: 'SocketException: $message',
              context: contextPlaylist,
              target: playlistId));
    });

    test('Find all shader ids by playlist id', () async {
      // prepare
      final options = newOptions();
      final playlistId = 'week';
      final from = options.pagePlaylistShaderCount;
      final num = options.pagePlaylistShaderCount;
      final shaders = [
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
      final sl = await shaderFixtures(shaders);

      final response1 = await textFixture('playlist/week_0_12.html');
      final response2 = await textFixture('playlist/week_12_12.html');
      final response3 = await textFixture('playlist/week_24_12.html');
      final adapter = newAdapter(options)
        ..addPlaylistShadersRoute(response1, playlistId, options)
        ..addPlaylistShadersRoute(response2, playlistId, options,
            from: from, num: num)
        ..addPlaylistShadersRoute(response3, playlistId, options,
            from: from * 2, num: num)
        ..addShadersRoute(sl, options);
      final api = newClient(options, adapter);
      // act
      final sr = await api.findAllShaderIdsByPlaylistId(playlistId);
      // assert
      expect(sr, isNotNull);
      expect(sr.error, isNull);
      expect(sr, await findShaderIdsResponseFixture(shaders, count: 36));
    });

    test('Find all shader ids by playlist id with Dio error', () async {
      // prepare
      final options = newOptions();
      final playlistId = 'week';
      final message = 'Failed host lookup: \'www.shadertoy.com\'';
      final adapter = newAdapter(options)
        ..addPlaylistShadersSocketErrorRoute(playlistId, options, message);
      final api = newClient(options, adapter);
      // act
      final sr = await api.findAllShaderIdsByPlaylistId(playlistId);
      // assert
      expect(sr, isNotNull);
      expect(sr.error, isNotNull);
      expect(
          sr.error,
          ResponseError.unknown(
              message: 'SocketException: $message',
              context: contextPlaylist,
              target: playlistId));
    });
  }, timeout: Timeout(Duration(seconds: 60)));

  group('Downloads', () {
    test('Download shader picture', () async {
      // prepare
      final options = newOptions();
      final shaderId = 'XsX3RB';
      final fixturePath = 'media/shaders/$shaderId.jpg';
      final response = await binaryFixture(fixturePath);
      final adapter = newAdapter(options)
        ..addDownloadShaderPicture(shaderId, response, options);
      final api = newClient(options, adapter);
      // act
      final sr = await api.downloadShaderPicture(shaderId);
      // assert
      expect(sr, isNotNull);
      expect(sr.error, isNull);
      expect(sr.bytes, isNotNull);
      expect(sr, await downloadFileResponseFixture(fixturePath));
    });

    test('Download non existing shader picture', () async {
      // prepare
      final options = newOptions();
      final shaderId = 'XsXxXxX';
      final media = 'media/shaders/$shaderId.jpg';
      final error = 'Http status error [404]';
      final adapter = newAdapter(options)
        ..addResponseErrorRoute(media, error, options);
      final api = newClient(options, adapter);
      // act
      final sr = await api.downloadShaderPicture(shaderId);
      // assert
      expect(sr, isNotNull);
      expect(sr.error, isNotNull);
      expect(
          sr.error,
          ResponseError.notFound(
              message: error, context: contextShader, target: shaderId));
    });

    test('Download media', () async {
      // prepare
      final options = newOptions();
      final fixturePath = 'img/profile.jpg';
      final response = await binaryFixture(fixturePath);
      final adapter = newAdapter(options)
        ..addDownloadFile(fixturePath, response, options);
      final api = newClient(options, adapter);
      // act
      final sr = await api.downloadMedia('/$fixturePath');
      // assert
      expect(sr, isNotNull);
      expect(sr.error, isNull);
      expect(sr.bytes, isNotNull);
      expect(sr, await downloadFileResponseFixture(fixturePath));
    });

    test('Download non existing media', () async {
      // prepare
      final options = newOptions();
      final media = 'img/profile.jpg';
      final error = 'Http status error [404]';
      final adapter = newAdapter(options)
        ..addResponseErrorRoute(media, error, options);
      final api = newClient(options, adapter);
      // act
      final sr = await api.downloadMedia('/$media');
      // assert
      expect(sr, isNotNull);
      expect(sr.error, isNotNull);
      expect(
          sr.error, ResponseError.notFound(message: error, target: '/$media'));
    });
  });
}
