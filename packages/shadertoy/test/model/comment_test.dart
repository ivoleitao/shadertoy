import 'package:shadertoy/src/model/comment.dart';
import 'package:test/test.dart';

void main() {
  test('Test a comment', () {
    var now = DateTime.now();
    var comment = Comment(
        id: 'commentId1',
        shaderId: 'shaderId1',
        userId: 'userId1',
        picture: '/img/profile.jpg',
        date: now,
        text: 'text1');
    expect(comment.id, 'commentId1');
    expect(comment.shaderId, 'shaderId1');
    expect(comment.userId, 'userId1');
    expect(comment.picture, '/img/profile.jpg');
    expect(comment.date, now);
    expect(comment.text, 'text1');
  });

  test('Test the comment to a JSON serializable map and back', () {
    var now = DateTime.now();
    var comment1 = Comment(
        id: 'commentId1',
        shaderId: 'shaderId1',
        userId: 'userId1',
        picture: '/img/profile.jpg',
        date: now,
        text: 'text1',
        hidden: true);
    var json = comment1.toJson();
    var comment2 = Comment.fromJson(json);
    expect(comment1, equals(comment2));
  });
}
