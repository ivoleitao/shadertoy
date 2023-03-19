import 'package:dio/dio.dart';
import 'package:shadertoy/shadertoy_api.dart';
import 'package:shadertoy_client/shadertoy_client.dart';
import 'package:test/test.dart';

import '../fixtures/fixtures.dart';
import '../mock_adapter.dart';
import 'ws_mock_adapter.dart';

void main() {
  ShadertoyWSOptions newOptions([ShadertoyWSOptions? options]) {
    return options != null
        ? options.copyWith(baseUrl: MockAdapter.mockBase)
        : ShadertoyWSOptions(apiKey: 'xx', baseUrl: MockAdapter.mockBase);
  }

  ShadertoyWSClient newClient(
      ShadertoyWSOptions options, HttpClientAdapter adapter) {
    final client = Dio(BaseOptions(baseUrl: MockAdapter.mockBase))
      ..httpClientAdapter = adapter;

    return ShadertoyWSClient(options, client: client);
  }

  group('Shaders', () {
    MockAdapter newAdapter(ShadertoyWSOptions options) {
      return MockAdapter(basePath: options.apiPath);
    }

    test('Find shader by id', () async {
      // prepare
      final options = newOptions();
      final fs = await findShaderResponseFixture('shaders/seascape.json');
      final adapter = newAdapter(options)..addFindShaderRoute(fs, options);
      final api = newClient(options, adapter);
      // act
      final sr = await api.findShaderById('Ms2SD1');
      // assert
      expect(sr, isNotNull);
      expect(sr.error, isNull);
      expect(sr.shader, isNotNull);
      expect(sr, fs);
    });

    test('Find shader by id with empty response', () async {
      // prepare
      final options = newOptions();
      final shaderId = 'tllBzj';
      final adapter = newAdapter(options)
        ..addEmptyResponseRoute('shaders/$shaderId', options);
      final api = newClient(options, adapter);
      // act
      final sr = await api.findShaderById(shaderId);
      // assert
      expect(sr, isNotNull);
      expect(sr.error, isNotNull);
      expect(sr.shader, isNull);
      expect(
          sr.error,
          ResponseError.unknown(
              message: 'Empty response body',
              context: contextShader,
              target: shaderId));
    });

    test('Find shader by id with unexpected plain text return', () async {
      // prepare
      final options = newOptions();
      final shaderId = 'WlXfW7';
      final text = 'Database connect error';
      final adapter = newAdapter(options)
          .addTextResponseRoute('shaders/$shaderId', text, options);
      final api = newClient(options, adapter);
      // act
      final sr = await api.findShaderById(shaderId);
      // assert
      expect(sr, isNotNull);
      expect(sr.error, isNotNull);
      expect(sr.shader, isNull);
      expect(
          sr.error,
          ResponseError.unknown(
              message: 'Unexpected response: $text',
              context: contextShader,
              target: shaderId));
    });

    test('Find shader by id with Dio error', () async {
      // prepare
      final options = newOptions();
      final message = 'Failed host lookup: \'www.shadertoy.com\'';
      final fs = await findShaderResponseFixture('shaders/seascape.json');
      final adapter = newAdapter(options)
        ..addFindShaderSocketErrorRoute(fs, options, message);
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
      final fsl = await findShaderResponseFixtures(shaders);
      final adapter = newAdapter(options)..addFindShadersRoute(fsl, options);
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
      final fsl = await findShaderResponseFixtures(shaders);
      final adapter = newAdapter(options)..addFindShadersRoute(fsl, options);
      final api = newClient(options, adapter);
      // act
      final sr = await api.findShadersByIdSet({'Ms2SD1', '3lsSzf'});
      // assert
      expect(sr, isNotNull);
      expect(sr.error, isNull);
      expect(sr, await findShadersResponseFixture(shaders));
    });

    test('Find shaders by id set with a unexpected plain text return',
        () async {
      // prepare
      final options = newOptions();
      final shaderId = 'WlXfW7';
      final text = 'Database connect error';
      final adapter = newAdapter(options)
          .addTextResponseRoute('shaders/$shaderId', text, options);
      final api = newClient(options, adapter);
      // act
      final sr = await api.findShadersByIdSet({shaderId});
      // assert
      expect(sr, isNotNull);
      expect(sr.error, isNull);
      expect(sr.shaders, isNotNull);
      expect(sr.shaders?.length, 1);
      expect(sr.shaders?[0].shader, isNull);
      expect(sr.shaders?[0].error, isNotNull);
      expect(
          sr.shaders?[0].error,
          ResponseError.unknown(
              message: 'Unexpected response: $text',
              context: contextShader,
              target: shaderId));
    });

    test('Find shaders by id set with Dio error', () async {
      // prepare
      final options = newOptions();
      final shaders = ['shaders/seascape.json', 'shaders/happy_jumping.json'];
      final fsl = await findShaderResponseFixtures(shaders);
      final message = 'Failed host lookup: \'www.shadertoy.com\'';
      final adapter = newAdapter(options)
        ..addFindShadersSocketErrorRoute(fsl, options, message);
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

    test('Find shaders with term with 3 results', () async {
      // prepare
      final options = newOptions();
      final term = 'prince';
      final shaders = [
        'shaders/lovely_stars.json',
        'shaders/scaleable_homeworlds.json',
        'shaders/prince_necklace.json'
      ];
      final fsi = await findShaderIdsResponseFixture(shaders);
      final fsl = await findShaderResponseFixtures(shaders);
      final adapter = newAdapter(options)
        ..addFindShaderIdsRoute(fsi, options, term: term)
        ..addFindShadersRoute(fsl, options);
      final api = newClient(options, adapter);
      // act
      final sr = await api.findShaders(term: term);
      // assert
      expect(sr, isNotNull);
      expect(sr.error, isNull);
      expect(sr, await findShadersResponseFixture(shaders));
    });

    test('Find shaders with Dio error', () async {
      // prepare
      final options = newOptions();
      final term = 'prince';
      final message = 'Failed host lookup: \'www.shadertoy.com\'';
      final adapter = newAdapter(options)
        ..addFindShaderIdsSocketErrorRoute(options, message, term: term);
      final api = newClient(options, adapter);
      // act
      final sr = await api.findShaders(term: term);
      // assert
      expect(sr, isNotNull);
      expect(sr.error, isNotNull);
      expect(sr.shaders, isNull);
      expect(
          sr.error,
          ResponseError.unknown(
              message: 'SocketException: $message', context: contextShader));
    });

    test('Find all shader ids', () async {
      // prepare
      final options = newOptions();
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
      final adapter = newAdapter(options)
        ..addFindAllShaderIdsRoute(fsi, options);

      final api = newClient(options, adapter);
      // act
      final sr = await api.findAllShaderIds();
      // assert
      expect(sr, isNotNull);
      expect(sr.error, isNull);
      expect(sr, fsi);
    });

    test('Find all shader ids, with unexpected plain text return', () async {
      // prepare
      final options = newOptions();
      final text = 'Database connect error';
      final adapter =
          newAdapter(options).addTextResponseRoute('shaders', text, options);
      final api = newClient(options, adapter);
      // act
      final sr = await api.findAllShaderIds();
      // assert
      expect(sr, isNotNull);
      expect(sr.error, isNotNull);
      expect(sr.ids, isNull);
      expect(
          sr.error,
          ResponseError.unknown(
              message: 'Unexpected response: $text', context: contextShader));
    });

    test('Find shader ids with term', () async {
      // prepare
      final options = newOptions();
      final term = 'prince';
      final shaders = [
        'shaders/lovely_stars.json',
        'shaders/scaleable_homeworlds.json',
        'shaders/prince_necklace.json'
      ];
      final fsi = await findShaderIdsResponseFixture(shaders);
      final adapter = newAdapter(options)
        ..addFindShaderIdsRoute(fsi, options, term: term);

      final api = newClient(options, adapter);
      // act
      final sr = await api.findShaderIds(term: term);
      // assert
      expect(sr, isNotNull);
      expect(sr.error, isNull);
      expect(sr, fsi);
    });

    test('Find shader ids with query', () async {
      // prepare
      final options = newOptions();
      final term = 'raymarching';
      final filters = {'multipass', 'soundoutput'};
      final sort = Sort.hot;
      final from = 0;
      final num = 2;
      final shaders = ['shaders/homeward.json', 'shaders/after.json'];
      final fsi = await findShaderIdsResponseFixture(shaders);
      final adapter = newAdapter(options)
        ..addFindShaderIdsRoute(fsi, options,
            term: term, filters: filters, sort: sort, from: from, num: num);

      final api = newClient(options, adapter);
      // act
      final sr = await api.findShaderIds(
          term: term, filters: filters, sort: sort, from: from, num: num);
      // assert
      expect(sr, isNotNull);
      expect(sr.error, isNull);
      expect(sr, fsi);
    });

    test('Find shader ids with unexpected plain text return', () async {
      // prepare
      final options = newOptions();
      final term = 'raymarching';
      final filters = {'multipass', 'soundoutput'};
      final sort = Sort.hot;
      final from = 0;
      final num = 2;
      final text = 'Database connect error';
      final adapter = newAdapter(options)
          .addTextResponseRoute('shaders/query/$term', text, options, {
        'filter': filters.toList(),
        'sort': [sort.name],
        'from': [from.toString()],
        'num': [num.toString()],
      });
      final api = newClient(options, adapter);
      // act
      final sr = await api.findShaderIds(
          term: term, filters: filters, sort: sort, from: from, num: num);
      // assert
      expect(sr, isNotNull);
      expect(sr.error, isNotNull);
      expect(sr.ids, isNull);
      expect(
          sr.error,
          ResponseError.unknown(
              message: 'Unexpected response: $text', context: contextShader));
    });
  });
}
