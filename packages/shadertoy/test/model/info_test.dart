import 'package:shadertoy/src/model/info.dart';
import 'package:test/test.dart';

void main() {
  var date = DateTime(2000, 1, 1, 0, 0, 0);
  var info1 = Info(
      id: 'id1',
      date: date,
      views: 1,
      name: 'name1',
      userId: 'userId1',
      description: 'description1',
      likes: 1,
      privacy: ShaderPrivacy.public_api,
      flags: 1,
      tags: ['test1'],
      hasLiked: true);

  test('Test a info', () {
    expect(info1.id, 'id1');
    expect(info1.date, date);
    expect(info1.views, 1);
    expect(info1.name, 'name1');
    expect(info1.userId, 'userId1');
    expect(info1.description, 'description1');
    expect(info1.likes, 1);
    expect(info1.privacy, ShaderPrivacy.public_api);
    expect(info1.flags, 1);
    expect(info1.tags, ['test1']);
    expect(info1.hasLiked, true);
  });

  test('Convert a info to a JSON serializable map and back', () {
    var json = info1.toJson();
    var info2 = Info.fromJson(json);
    expect(info1, equals(info2));
  });

  test('Create a info from a json map', () {
    var json = {
      'id': 'id1',
      'date': '123123123',
      'viewed': 1,
      'name': 'name1',
      'username': 'userId1',
      'description': 'description1',
      'likes': 1,
      'published': 2,
      'flags': 1,
      'tags': ['test1'],
      'hasliked': 1
    };

    expect(() => Info.fromJson(json), returnsNormally);
  });

  test('Create a info from a json map with a invalid type', () {
    var json = {
      'id': 'id1',
      'date': '123123123',
      'viewed': 1,
      'name': 'name1',
      'username': 'userId1',
      'description': 'description1',
      'likes': 1,
      'published': 4,
      'flags': 1,
      'tags': ['test1'],
      'hasliked': 1
    };

    expect(() => Info.fromJson(json), throwsArgumentError);
  });
}
