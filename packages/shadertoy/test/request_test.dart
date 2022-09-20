import 'package:shadertoy/src/model/request/find_shaders.dart';
import 'package:test/test.dart';

void main() {
  var ids = {'MsGczV', 'wtd3zs'};
  var request1 = FindShadersRequest(ids = ids);

  test('Test a request', () {
    expect(request1.ids, ids);
  });

  test('Convert a request to a JSON serializable map and back', () {
    var json = request1.toJson();
    var request2 = FindShadersRequest.fromJson(json);
    expect(request1, equals(request2));
  });
}
