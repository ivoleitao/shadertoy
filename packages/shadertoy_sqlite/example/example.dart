import 'package:moor/ffi.dart';
import 'package:moor/moor.dart';
import 'package:shadertoy/shadertoy_api.dart';
import 'package:shadertoy_sqlite/shadertoy_sqlite.dart';

QueryExecutor memoryExecutor({bool logStatements = false}) {
  return VmDatabase.memory(logStatements: logStatements);
}

void main(List<String> arguments) async {
  // Creates a new store with an in-memory executor
  final store = newShadertoySqliteStore(memoryExecutor());

  // Creates user 1
  final userId1 = 'UzZ0Z1';
  final user1 =
      User(id: userId1, about: 'About user 1', memberSince: DateTime.now());
  await store.saveUser(user1);

  // Retrieves user 1
  await store.findUserById(userId1);

  // Creates user 2
  final userId2 = 'UzZ0Z2';
  final user2 =
      User(id: userId2, about: 'About user 2', memberSince: DateTime.now());
  await store.saveUser(user2);

  // Retrieves user 2
  await store.findUserById(userId2);

  // Creates a shader with two render passes
  final shaderId1 = 'SzZ0Zz';
  final shader1 = Shader(
      version: '0.1',
      info: Info(
          id: shaderId1,
          date: DateTime.fromMillisecondsSinceEpoch(1360495251),
          views: 131083,
          name: 'Example',
          userId: userId1,
          description: 'A shader example',
          likes: 570,
          privacy: ShaderPrivacy.publicApi,
          flags: 32,
          tags: [
            'procedural',
            '3d',
            'raymarching',
            'distancefield',
            'terrain',
            'motionblur',
            'vr'
          ],
          hasLiked: false),
      renderPasses: [
        RenderPass(
            name: 'Image',
            type: RenderPassType.image,
            description: '',
            code: 'code 0',
            inputs: [
              Input(
                  id: '257',
                  src: '/media/previz/buffer00.png',
                  type: InputType.texture,
                  channel: 0,
                  sampler: Sampler(
                      filter: FilterType.linear,
                      wrap: WrapType.clamp,
                      vflip: true,
                      srgb: true,
                      internal: 'byte'),
                  published: 1)
            ],
            outputs: [
              Output(id: '37', channel: 0)
            ]),
        RenderPass(
            name: 'Buffer A',
            type: RenderPassType.buffer,
            description: '',
            code: 'code 1',
            inputs: [
              Input(
                  id: '17',
                  src: '/media/a/zs098rere0323u85534ukj4.png',
                  type: InputType.texture,
                  channel: 0,
                  sampler: Sampler(
                      filter: FilterType.mipmap,
                      wrap: WrapType.repeat,
                      vflip: false,
                      srgb: false,
                      internal: 'byte'),
                  published: 1)
            ],
            outputs: [
              Output(id: '257', channel: 0)
            ])
      ]);

  // Saves the shader
  await store.saveShader(shader1);

  // Retrieves the saved shader
  await store.findShaderById(shaderId1);

  // Creates the first comment
  final comment1 = Comment(
      id: 'CaA0A1',
      shaderId: shaderId1,
      userId: userId2,
      picture: '/img/profile.jpg',
      date: DateTime.now(),
      text: 'Great shader!');

  // Creates the second comment
  final comment2 = Comment(
      id: 'CaA0A2',
      shaderId: shaderId1,
      userId: userId1,
      picture: '/img/profile.jpg',
      date: DateTime.now(),
      text: 'Thanks');

  // Save shader comments
  await store.saveShaderComments([comment1, comment2]);

  // Retrieves the shader comments
  await store.findCommentsByShaderId(shaderId1);

  // Creates a playlist
  final playlistId1 = 'week';
  final playlist1 = Playlist(
      id: playlistId1,
      userId: 'shadertoy',
      name: 'Shaders of the Week',
      description: 'Playlist with every single shader of the week ever.');

  // Save the playlist
  await store.savePlaylist(playlist1);

  // Retrieves the playlist
  await store.findPlaylistById(playlistId1);

  // Stores the shader on the playlist
  await store.savePlaylistShaders(playlistId1, [shaderId1]);

  // Retrieves the playlist shader ids
  await store.findShaderIdsByPlaylistId(playlistId1);
}
