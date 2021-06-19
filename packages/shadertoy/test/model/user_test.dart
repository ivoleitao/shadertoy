import 'package:shadertoy/src/model/user.dart';
import 'package:test/test.dart';

void main() {
  var memberSince = DateTime(2000, 1, 1, 0, 0, 0);
  var user1 = User(
      id: 'id1',
      picture: 'picture1',
      memberSince: memberSince,
      following: 1,
      followers: 1,
      about: 'about1');

  test('Test a user', () {
    expect(user1.id, 'id1');
    expect(user1.picture, 'picture1');
    expect(user1.memberSince, memberSince);
    expect(user1.following, 1);
    expect(user1.followers, 1);
    expect(user1.about, 'about1');
  });

  test('Convert a user to a JSON serializable map and back', () {
    var json = user1.toJson();
    var user2 = User.fromJson(json);
    expect(user1, equals(user2));
  });
}
