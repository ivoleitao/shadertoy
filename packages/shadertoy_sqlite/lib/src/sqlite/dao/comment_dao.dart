import 'package:moor/moor.dart';
import 'package:shadertoy/shadertoy_api.dart';
import 'package:shadertoy_sqlite/src/sqlite/store.dart';
import 'package:shadertoy_sqlite/src/sqlite/table/comment_table.dart';

part 'comment_dao.g.dart';

@UseDao(
    tables: [CommentTable], queries: {'commentId': 'SELECT id FROM Comment'})

/// Comment data access object
class CommentDao extends DatabaseAccessor<MoorStore> with _$CommentDaoMixin {
  /// Creates a [CommentDao]
  ///
  /// * [store]: A pre-initialized [MoorStore] store
  CommentDao(MoorStore store) : super(store);

  /// Checks if a shader has comments
  ///
  /// * [shaderId]: The shader id to check for comments
  ///
  /// Returns `true` if the shader has comments
  Future<bool> exists(String shaderId) {
    return (select(commentTable)
          ..where((entry) => entry.shaderId.equals(shaderId)))
        .get()
        .then((comments) => comments.isNotEmpty);
  }

  /// Converts a [CommentEntry] into a [Comment]
  ///
  /// * [entry]: The entry to convert
  Comment _toCommentEntity(CommentEntry entry) => Comment(
      id: entry.id,
      shaderId: entry.shaderId,
      userId: entry.userId,
      picture: entry.picture,
      date: entry.date,
      text: entry.comment,
      hidden: entry.hidden);

  /// Converts a [CommentEntry] into a [Comment] or returns null of [entry] is null
  ///
  /// * [entry]: The entry to convert
  Comment? _toCommentEntityOrNull(CommentEntry? entry) =>
      entry != null ? _toCommentEntity(entry) : null;

  /// Converts a list of [CommentEntry] into a list of [Comment]
  ///
  /// * [entries]: The list of entries to convert
  List<Comment> _toCommentEntities(List<CommentEntry> entries) {
    return entries.map(_toCommentEntity).toList();
  }

  /// Returns a [Comment] with id [commentId]
  ///
  /// * [commentId]: The id of the comment
  Future<Comment?> findById(String commentId) {
    return (select(commentTable)..where((entry) => entry.id.equals(commentId)))
        .getSingleOrNull()
        .then(_toCommentEntityOrNull);
  }

  /// Get's the comments of shader by [shaderId]
  ///
  /// * [shaderId]: The id of the shader
  Future<List<Comment>> findByShaderId(String shaderId) {
    return (select(commentTable)
          ..where((entry) => entry.shaderId.equals(shaderId)))
        .get()
        .then(_toCommentEntities);
  }

  /// Returns all the comment ids
  Future<List<String>> findAllIds() {
    return commentId().get();
  }

  /// Returns all the comments
  Future<List<Comment>> findAll() {
    return select(commentTable).get().then(_toCommentEntities);
  }

  /// Converts a list of [Comment] into a list of [CommentEntry]
  ///
  /// * [comments]: The list of [Comment] to convert
  List<CommentEntry> _toCommentEntries(List<Comment> comments) {
    return comments
        .map((comment) => CommentEntry(
            id: comment.id,
            userId: comment.userId,
            picture: comment.picture,
            shaderId: comment.shaderId,
            date: comment.date,
            comment: comment.text,
            hidden: comment.hidden))
        .toList();
  }

  /// Saves the comments of a shader
  ///
  /// * [comments]: The list of comments to save
  Future<void> save(List<Comment> comments) {
    return batch((b) => b.insertAll(commentTable, _toCommentEntries(comments),
        mode: InsertMode.insertOrReplace));
  }

  /// Deletes a [Comment] by [commentId]
  ///
  /// * [commentId]: The id of the [Comment]
  Future<void> deleteById(String commentId) {
    return (delete(commentTable)
          ..where((comment) => comment.id.equals(commentId)))
        .go();
  }
}
